Rebuildable, partially-commented version of Acorn MOS for the Master
series. The following versions are covered, as they all seem to be
quite closely related:

- MOS 3.20 (Master 128, UK)
- MOS 4.00 (Master ET, UK)
- MOS 5.00, MOS 5.10 (Master Compact, UK)
- MOS 5.11 (Master Compact, International)
- PC128S MOS (Olivetti PC128S)

The starting point was JGH's MOS 3.20 disassembly here:
http://mdfs.net/Info/Comp/Acorn/Source/MOS.htm - this provided
comments for several sections, identified many of the tables, and
convinced me that this sort of project might actually be feasible.

https://tobylobster.github.io/mos/ has provided most comments and
symbol names for the bits that haven't changed (or haven't changed
much) since OS 1.20.

**This project is extremely WIP.** A lot of it isn't actually
commented, and many of the label names fail to meet even the low bar
of "not actively misleading". But I think I've found all the bits that
are code, and all the bits that are data, and many of the
data-dependent constants.

# project goals

Initial goals are to produce a useful listing file from the assembler,
that's got all addresses and bytes listed, and enough comments and
labels to give you a clue about what each bit of code might be doing
(even if the algorithm isn't fully described). This is intended to
simplify following along when looking at an unadorned disassembly
(e.g., on the Master itself), looking at MOS ROM addresses, and so on.
That's the sort of situation where I've personally most missed having
an annotated disassembly.

The 64tass listing file is relatively easy to read, but not ideal. I
intend to add a postprocessing step to transform it into something a
bit tidier.

My longer term goal is to produce a decent-quality modifiable source
file, with all label references located, all data-dependent constants
identified, and all current assumptions (page alignment, routines that
share pages, variables that must be together, etc.) checked. Then, in
theory, code can be added or removed fairly freely.

# build

## prerequisites ##

Mandatory:

* [`64tass`](http://tass64.sourceforge.net/) (I use r3120)
* a Unix-type system with the usual Unix-type stuff (on Windows, you
  should be good with WSL, cygwin, Git Bash, etc.)

Optional:

* [`vbindiff`](https://www.cjmweb.net/vbindiff/)

## build steps ##

Type `make`.

## build output

The build output is assembler listing files that you can use for
reference:

- `build/mos320.lst` - MOS 3.20
- `build/mos400.lst` - MOS 4.00
- `build/mos500.lst` - MOS 5.00
- `build/mos510.lst` - MOS 5.10
- `build/mos511.lst` - MOS 5.11
- `build/mosPC128S.lst` - PC128S MOS

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

### BASIC-style notation

`?M` means the byte at address `M`. `M?N` means the byte at address
`M+N`.

`!M` and `M!N` are the same, but for 32-bit dwords.

`;` means the quantity is a 16-bit word, as per the BASIC `VDU`
statement. This doesn't really have any strict syntax. I've mainly
used it when commented the VDU driver code.

### 64tass-style notation

`<M` is the LSB of `M`, and `>M` is the MSB of M.

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

# the other MOS 3.20 parts

## BASIC

Original code: https://github.com/stardot/AcornCmosBasic

Commented disassembly: http://8bs.com/basic/basic4.htm

## ADFS

https://github.com/hoglet67/ADFS/blob/master/src/adfs150.asm

## DFS

http://regregex.bbcmicro.net/dfs224.asm.txt

## Edit

https://github.com/SteveFosdick/edit4/blob/master/edit110.asm

## View

Nobody appears to have disassembled View.

There's 1.5 KB of MOS code at the end, which is included in this repo.

## ViewSheet

Nobody appears to have disassembled ViewSheet.

# the other MOS versions

I haven't done MOS 3.50 yet - it looked rather different from the
others.
