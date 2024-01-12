**The NT builds are experimental.**

The NT builds of the MOS strip out the Terminal ROM, and replace it
with the MOS code previously hidden in one of the other sideways ROM
banks. (NT = No Terminal.) Now the MOS code is confined entirely to
the MOS ROM and sideways ROM 15, and you can put anything you like in
the other banks. This is intended to simplify producing new MegaROM
images with alternative utility or language ROMs.

You can get a build from the latest release page:
https://github.com/tom-seddon/acorn_mos_disassembly/releases/latest -
download the `acorn-mos-320nt-350nt` zip. Use `mos.rom` and
`utils.rom` corresponding to the version of interest.

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

In all other respects this is (supposed to be) identical to MOS 3.50.

Note that the non-MOS stuff in MOS 3.50 is annoyingly interdependent.
The MOS is careful to confine itself to to specific regions, but the
other built-in ROMs aren't. So please note the following restrictions:

1. If wanting to use the MOS 3.50 DFS (DFS 2.45) and/or MOS 3.50 ADFS
   (ADFS 2.03), you'll need both, as they depend on one another, and
   you'll need to put them in their default banks (DFS in bank 9, ADFS
   in bank 13)
   
2. MOS 3.50 BASIC (BASIC 4r32) or MOS 3.50 EDIT (EDIT 1.50r) can go in
   any bank, but to use them with a 6502 co-processor they need to be
   in their default banks (EDIT in bank 11, BASIC in bank 12) and the
   original View ROM will also need to be in bank 14. This is due to a
   bug in MOS 3.50 relating to relocating ROMs when copying over the
   Tube
   
As a workaround for issue 2, modified versions of BASIC and EDIT are
supplied in the `350nt` folder in the distribution zip. These are
non-relocatable, so you'll get less extra memory in the 2nd processor
than you should... but, they will actually work.
