Rebuildable, partially-commented version of Acorn's MOS 3.20 for the
Master 128.

The starting point was JGH's MOS 3.20 disassembly here:
http://mdfs.net/Info/Comp/Acorn/Source/MOS.htm

https://tobylobster.github.io/mos/ has proven very helpful for
understanding the bits that haven't changed much since OS 1.20.

**This is extremely WIP.** 

# project goals

Initial goals are to produce a useful listing file from the assembler,
that's got all addresses and bytes listed, and enough comments and
labels to give you a clue about what each bit of code might be doing
(even if the algorithm isn't fully described). This is intended to
simplify following along when looking at an unadorned disassembly
(e.g., on the Master itself), looking at MOS ROM addresses, and so on.

My longer term goal is to produce a decent-quality modifiable source
file, with all label references located and all current assumptions
(page alignment, routines that share pages, variables that must be
together, etc.) checked. Then, in theory, code can be added or removed
fairly freely.

# code notes

## symbol names ##

The Master Reference Manual (part 1) mentions a few names, presumably
from the original source. I've used those where appropriate.
https://github.com/stardot/AcornOS120 has also provided some symbols -
mostly for ZP addresses. The 6 character limit is a bit limiting for
code.

Initially, I used some names from
https://tobylobster.github.io/mos/index.html, as there are some bits
of code that are obviously reused from MOS 1.20. I ended up finding
the cross-referencing a bit time-consuming in the end, though, so I
didn't keep up with this.

## notation ##

### entry/exit/preserves ###

Register names are of course `A`, `X`, `Y`, and `N`, `V`, `B`, `D`,
`I`, `Z`, `C` refer to the status register bits.

I've not been super consistent about this, but I've sometimes noted if
C is preserved, as that's useful to know. N, V, Z and C are often
outputs so I've noted when required.

### Stack contents ###

Where relevant, stack contents are noted as `S=[A; B...]`, where `A`
is the item at S+1, `B` is the item at S+2, and so on.

Registers are referred to using their names. `RL` and `RH` are the low
and high bytes of the return address. Other things get an English
description.

# build

## prerequisites ##

Mandatory:

* [`64tass`](http://tass64.sourceforge.net/) (I use r2625)
* a Unix-type system with the usual Unix-type stuff (on Windows, you
  should be good with WSL, cygwin, Git Bash, etc.)

Optional:

* [`vbindiff`](https://www.cjmweb.net/vbindiff/)

## build steps ##

Type `make`.

## build output

The output file is `build/mos320.rom`, which is 33.5 KBytes as
follows:

- 1.5 KB, "ext" ROM (end of sideways bank 14)
- 16 KB, Terminal ROM (sideways bank 15)
- 16 KB, MOS ROM ($c000)

The build process prints SHA1 hashes for the output and for the
original rom, so you can see if the output is the same. (The expected
SHA1 for the original is `684b1ee65441609e1703ee2a3caf07043e40e1c0`.)

I've found `vbindiff` helpful for figuring out discrepancies. If you
have this installed, type `make diff` to run it, comparing the built
MOS 3.20 with the original.

## regarding the build output ##

The build output isn't (yet?) terribly useful as-is. You do get an
exact replica of the key 33.5 KB of the MOS ROM, but you still need
the other 94.5 KB (ADFS, BASIC, DFS, Edit, View, ViewSheet), that's
not dealt with here, if you want to create a full 128 KB MegaROM
image.

I don't currently plan on doing a full disassembly of the entire
MegaROM, but I do plan to at least improve the build process so that
the output is a bit-identical 128 KB MOS 3.20 MegaROM image.

# the other MOS 3.20 parts

## BASIC

Original code: https://github.com/stardot/AcornCmosBasic

Commented disassembly: http://8bs.com/basic/basic4.htm

## ADFS

https://github.com/hoglet67/ADFS/blob/master/src/adfs150.asm

## DFS

Nobody appears to have disassembled this version of DFS.

## Edit

https://github.com/SteveFosdick/edit4/blob/master/edit110.asm

## View

Nobody appears to have disassembled View.

There's 1.5 KB of MOS code at the end, which is included in this repo.

## ViewSheet

Nobody appears to have disassembled ViewSheet.
