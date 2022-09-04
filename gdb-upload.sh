#!/usr/bin/env bash

gdb_path="$(realpath "./rp2040-tools/pqt-gcc/1.4.0-c-0196c06/bin/arm-none-eabi-gdb")"
elf_path="$(realpath "./cmake-build-debug-rd-arm/blink.elf")"
tmp_path="/tmp/gdb-script"

gdb_upload="
target extended-remote /dev/ttyBmpGdb
file $elf_path
monitor swdp_scan
attach 1
"
# load
# quit
# run

cat <<< "$gdb_upload" > "$tmp_path"

"$gdb_path" --command="$tmp_path"
