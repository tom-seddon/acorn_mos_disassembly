# MOS 3.50r/3.50(NT) DIY builds

Putting together a DIY build of MOS 3.50r or MOS 3.50(NT) is a bit
more annoying than MOS 3.20, because the ROMs depend on one another.
But it can be done (and it's easier than with Acorn's MOS 3.50!).

Here are some notes about a DIY ROM I put together, containing the
following ROMs, which might serve as an example of doing this sort of
thing:

| ROM | What |
| --- | --- |
| MOS | MOS 3.50r |
| 15 | MOS 3.50r utils |
| 14 | DFS 2.45 + relocation bitmaps + extra ADFS code |
| 13 | The BASIC Editor (relocatable) |
| 12 | BASIC 4r32 (relocatable) |
| 11 | EDIT 1.50r (relocatable) |
| 10 | ADFS 2.03 |
| 9 | EXMON II |

# Prerequisites

You'll need to be set up to build the ROMs locally, as per
[the build instructions](./build.md).

# ADFS 2.03 needs DFS 2.45

If using ADFS 2.03, you also need DFS 2.45, and they need to be 4
banks apart. (This is surely fixable, but it isn't obviously a big
problem so I just haven't investigated.)

The actual banks don't matter, and it doesn't matter which is higher
priority. So this gives two options: banks 9 and 13, or banks 10 and
14.

I wanted DFS in the higher-priority ROM, as the filing system I
normally use can fail to initialise, and when this happens I would
rather get DFS than ADFS.

I decided to use 10+14 as this makes it slightly easier for me to test
in the emulator (as the `*CONFIGURE FILE 9` setting, which usually
makes sense, won't keep selecting ADFS).

# Finding additional images

ADFS 2.03 is part of the MegaROM, and there's a 16 KB ROM image in
this repo in the `orig/mos350` folder.

EXMON II is widely available. The newest version released by Beebug
seems to be 2.02. A very slightly updated version 2.03 is available
here: https://github.com/tom-seddon/exmon2_disassembly

For The BASIC Editor, I use my updated version 1.46 from here:
https://github.com/tom-seddon/basic_editor - 1.46 comes as a
relocatable version with a Tube relocation bitmap.

# Setting up the relocation bitmaps

I have a script for looking after MOS 3.50 relocation bitmaps:
https://github.com/tom-seddon/beeb/tree/master/bin#tube_relocation

It's also in a submodule of this repo:
`submodules/beeb/bin/tube_relocation.py`.

The ideal place for the relocation bitmaps is the DFS ROM, between
$af00 and $b800 - the region containing MOS code that's unnecessary in
MOS 3.50(NT) or MOS 3.50r. This region is 2,304 bytes.

Relocation bitmaps for BASIC 4r32 and EDIT 1.50r are produced during
the build process: see `build/basic.4r32.relocation.dat` and
`build/edit.1.50r.relocation.dat`. 609+444=1,053 bytes total.

The BASIC Editor's relocation bitmap is another 600-odd bytes. It all
fits!

The `tube_relocation.py set-multi` command will insert the relocation
bitmaps into an unused region of a ROM, and fix up the relocatable
ROMs to refer to it. You need to supply the ROM the bitmaps will be
inserted into (the DFS ROM) and the bank it will occupy (14 in this
case), the region to use for the bitmaps (0xaf00 - 0xb800 here), and
then each relocatable ROM and its relocation bitmap.

All the ROM images mentioned will be modified.

The command line for this gets a bit unwieldy, even in this simplified
summary form that doesn't spell out the full paths:

    python3 submodules/beeb/bin/tube_relocation.py set-multi --bitmap-rom dfs.2.45.rom 14 --begin 0xaf00 --end 0xb800 --rom basic.4r32.rom basic.4r32.relocation.dat --rom edit.1.50r.rom edit.1.50r.relocation.dat --rom rbasiced.rom rbasiced.relocation.dat --set-multi

# Test in emulator

I used b2: https://github.com/tom-seddon/b2/

It doesn't support 128 KByte MegaROM images, but the 16 KByte ROM
images can be loaded individually.

# Create 128 KByte MegaROM image

See https://mdfs.net/Info/Comp/BBC/SROMs/MegaROM.htm - the files need
to be concatenated, in the following order:

1. `mos.rom`
2. ROM 9 - EXMON II
3. ROM 10 - ADFS 2.03
4. ROM 11 - EDIT 1.50r (as modified by tube_relocation.py)
5. ROM 12 - BASIC 4r32 (as modified by tube_relocation.py)
6. ROM 13 - The BASIC Editor (as modified by tube_relocation.py)
7. ROM 14 - DFS 2.45 (as modified by tube_relocation.py)
8. ROM 15 - `utils.rom`

Each file must be 16,384 bytes, padded if required, so that the full
image is 131,072 bytes.

# Create 512 KByte multi-OS ROM image

I've got one of these: https://www.ebay.co.uk/itm/265960074487

The image is 512 KBytes, 4 x 128 KByte MegaROM images in the following
order:

1. OS 1.20
2. OS 2.00
3. OS 3.20
4. OS 3.50

I replaced the 128 KBytes corresponding to OS 2.00 with the 128 KByte
MegaROM image.

# Program ROM and test in Master

I used an Xgecu T48 with a PLCC32-to-DIP32 adapter.

# Example Makefile target

See the `tom_example` target in the Makefile, which does all of the
above. This is just an example, but it does run on my PC, and it might
even run on yours too.

Needs https://github.com/tom-seddon/basic_editor and
https://github.com/tom-seddon/exmon2_disassembly working copies
available - note paths in the Makefile. Please see the respective
repos for building instructions.
