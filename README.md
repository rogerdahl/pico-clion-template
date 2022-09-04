# Raspberry Pico + CLion + Black Magic Probe

Project template for development with the Raspberry Pico SDK, JetBrains CLion and a Black Magic Probe.

- This sets up a full development environment with all the code assistance and debugging features available in CLion.
- Flashing and on-chip debugging is done via SWD by the Black Magic Probe
- This method of flashing does not require any manual steps, such as reconnecting USB or pressing the button on the Pico. It is also more reliable since it does not depend on the USB port on the Pico being correctly set up


## Black Magic Probe (BMP)

BMP implements a GDB Server that exposes SWD debugger on connected devices. Pico is an officially supported target. OpenOCD is built into the BMP, so does not need to be run on the local machine. 

I used an STM32 "blue pill" board and followed these instructions: https://github.com/koendv/blackmagic-bluepill

More information about BMP: https://black-magic.org/
And in this book: https://github.com/compuphase/Black-Magic-Probe-Book/blob/master/BlackMagicProbe.pdf

Automatically create udev rules for BMP: `sudo ./create-blackmagic-udev-rules.sh`

After flashing the BMP firmware, the serial adapter is no longer needed. Make sure to at least disconnect the 5V supply from it.

## CLion setup

/home/dahl/dev/pico/blink/rp2040-tools/pqt-gcc/1.4.0-c-0196c06/bin/arm-none-eabi-gdb

Run/Debug Configuration:

```
Target: blink
Executable: blink
GDB: arm-none-eabi-gdb (from 'RD ARM' toolchain)
Download executable: Updated Only
'target remote' args: /dev/ttyBmpGdb 0 
GDB Server: /usr/bin/gdb
Advanced GDB Server Options
Working directory: /home/dahl/dev/pico/blink
Reset command: monitor reset (After Download: Checked)
```

## GDB setup

CLion does not allow configuring the commands that is sends to GDB on startup. It sends a "target remote", while we want "target extended-remote". The following is workaround that redefines `target remote` to `target extended-remote`. 

```bash
cat > ~/.gdbinit << EOF
set history save on

# redefine "target remote" as "target extended-remote"
define target remote
target extended-remote $arg0
# using 2nd additional "'remote target' args" parameter to define .elf file
add-inferior -exec $arg2
inferior 2
# using 1st additional "'remote target' args" parameter to select the core
attach $arg1
end
EOF
```

More info: https://youtrack.jetbrains.com/issue/CPP-7322

To pass the .elf file and select the core, we can now pass them in the `'target remote' args` in the Run/Debug Configuration.

## Building

https://www.jetbrains.com/help/clion/embedded-overview.html

### cmake

It's important to use the correct pico_sdk_import.cmake. The one in this project is copied from
<PICO_SDK_PATH>/external/pico_sdk_import.cmake.

```
PICO_SDK_PATH is /home/dahl/sdk/pico/pico-sdk
PICO platform is rp2040.
Build type is Release
PICO target board is pico_w.
Using CMake board configuration from /home/dahl/sdk/pico/pico-sdk/src/boards/pico_w.cmake
Using board configuration from /home/dahl/sdk/pico/pico-sdk/src/boards/include/boards/pico_w.h
TinyUSB available at /home/dahl/sdk/pico/pico-sdk/lib/tinyusb/src/portable/raspberrypi/rp2040; enabling build support for USB.
cyw43-driver available at /home/dahl/sdk/pico/pico-sdk-master/lib/cyw43-driver
lwIP available at /home/dahl/sdk/pico/pico-sdk/lib/lwip
Enabling build support for Pico W wireless.
Using PICO_EXAMPLES_PATH from environment ('/home/dahl/pico/pico-examples')
-- Configuring done
-- Generating done
-- Build files have been written to: /home/dahl/sdk/pico/pico-sdk

Submodule 'lib/cyw43-driver' (https://github.com/georgerobotics/cyw43-driver.git) registered for path 'lib/cyw43-driver'
Submodule 'lib/lwip' (https://github.com/lwip-tcpip/lwip.git) registered for path 'lib/lwip'
Submodule 'tinyusb' (https://github.com/hathach/tinyusb.git) registered for path 'lib/tinyusb'
Cloning into '/home/dahl/dev/pico/SDK/1/pico-sdk/lib/cyw43-driver'...
Cloning into '/home/dahl/dev/pico/SDK/1/pico-sdk/lib/lwip'...
Cloning into '/home/dahl/dev/pico/SDK/1/pico-sdk/lib/tinyusb'...
```

## Flash and debug connections

| Blue Pill Black Magic Probe  | Target | Comment                                 |
| ---------------------------- | ------ | --------------------------------------- |
| GND 	                       | GND 	|                                         | 
| PB14 	                       | SWDIO 	| Serial Wire Debugging Data              |
| PA5 	                       | SWCLK 	| Serial Wire Debugging Clock             |
| PA10 	                       | SWO 	| Serial Wire Output                      |
| PA3 	                       | RXD 	| Optional serial port                    |
| PA2 	                       | TXD 	| Optional serial port                    |
| 3V3 	                       | 3V3 	| Careful! Only connect one power source  |

Note that the SWD pins on the blue pill are not used.


## Flash and debug

!!!! For this to work, the `gdb-upload.sh` script must be left running in the background !!!!

I have no idea why.


## Troubleshooting

- Get things working on the command line first, then in CLion



### GDB commands

| Command| Description |
| --- | --- |
| target extended remote [ serial port ] | Connecting to BMP |
| monitor swdp_scan | Scanning for targets using SWD |
| attach 1 | Attaching to the detected target |
| load | Loading the project binary |
| start | Starting the firmware with a breakpoint set to the start of the main function |
| next,[enter,...] | Stepping over the main function |
| Continuing execution | continue |
| CTRL-C, CTRL-D | Breaking and detaching from the target |
| set pagination off | |
| set logging file gdb.txt | |
| set logging on | |
| end | |
| info breakpoints | |
| r | |
| set logging off | |
| quit | |
| load | |
| monitor option erase | |
| monitor erase_mass | |
