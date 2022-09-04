#!/usr/bin/env bash

rules='
# Black Magic Probe
# there are two connections, one for GDB and one for UART debugging
# copy this to /etc/udev/rules.d/99-blackmagic.rules
# and run sudo udevadm control -R
ACTION!="add|change", GOTO="blackmagic_rules_end"
SUBSYSTEM=="tty", ACTION=="add", ATTRS{interface}=="Black Magic GDB Server", SYMLINK+="ttyBmpGdb"
SUBSYSTEM=="tty", ACTION=="add", ATTRS{interface}=="Black Magic UART Port", SYMLINK+="ttyBmpTarg"
SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6017", MODE="0666", GROUP="plugdev", TAG+="uaccess"
SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6018", MODE="0666", GROUP="plugdev", TAG+="uaccess"
LABEL="blackmagic_rules_end"
'

dst='/etc/udev/rules.d/99-blackmagic.rules'

printf > "$dst" '%s' "$rules"
chown root:root "$dst"
chmod 644 "$dst"
udevadm control --reload-rules
