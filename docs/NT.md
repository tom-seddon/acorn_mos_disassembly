**The NT builds are experimental.**

The NT builds of the MOS strip out the Terminal ROM, and replace it
with the MOS code previously hidden in one of the other sideways ROM
banks. (NT = No Terminal.) Now the MOS code is confined entirely to
the MOS ROM and sideways ROM 15, and you can put anything you like in
the other banks. This is intended to simplify producing new MegaROM
images with alternative utility or language ROMs.

You can get a build from the latest release page:
https://github.com/tom-seddon/acorn_mos_disassembly/releases/latest -
download the -NT zip. Use `mos.rom` and `utils.rom` corresponding to
the version of interest.

Alternatively, you can build it yourself, following
[the building instructions](./build.md). Find the output in the build
folder: `mos.rom` and `utils.rom` in `build/320nt` or `build/350nt`.

(`mos.rom` and `utils.rom` are closely related, and cannot be mixed
and matched. Both ROMs must come from the exact same build!)

When putting together the new MegaROM image, `mos.rom` goes in the MOS
ROM area, and `utils.rom` goes in sideways ROM bank 15.

# MOS 3.20(NT)

The MOS no longer relies on finding code in the View ROM. You can put
anything you like in banks 9-14.

In all other respects this is (supposed to be) identical to MOS 3.20,
warts and all. In particular, there are still no sideways RAM
utilities built in the MOS.

# MOS 3.50(NT)

The MOS no longer relies on finding code in the DFS ROM. You can put
anything you like in banks 9-14.

(If wanting to use the MOS 3.50 DFS and ADFS, note that they depend on
one another, and can't be put in just any old banks. For more info,
see here: https://mdfs.net/Info/Comp/BBC/SROMs/MegaROM.htm)

In all other respects this is (supposed to be) identical to MOS 3.50.
