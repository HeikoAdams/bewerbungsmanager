#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking bewerbungen
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf32-i386 -m elf_i386  --build-id --dynamic-linker=/lib/ld-linux.so.2    -L. -o bewerbungen link.res
if [ $? != 0 ]; then DoExitLink bewerbungen; fi
IFS=$OFS
echo Linking bewerbungen
OFS=$IFS
IFS="
"
/usr/bin/objcopy --only-keep-debug bewerbungen bewerbungen.dbg
if [ $? != 0 ]; then DoExitLink bewerbungen; fi
IFS=$OFS
echo Linking bewerbungen
OFS=$IFS
IFS="
"
/usr/bin/objcopy --add-gnu-debuglink=bewerbungen.dbg bewerbungen
if [ $? != 0 ]; then DoExitLink bewerbungen; fi
IFS=$OFS
echo Linking bewerbungen
OFS=$IFS
IFS="
"
/usr/bin/strip --strip-unneeded bewerbungen
if [ $? != 0 ]; then DoExitLink bewerbungen; fi
IFS=$OFS
