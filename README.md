Rebuildable, partially-commented version of Acorn MOS for Acorn's
8-bit BBC Master series and derivatives. The following released
versions for Acorn systems are covered (version numbers as reported by
`*FX0`). Click each .lst link to get a reasonably recent assembler
listing file, including assembled code, labels and comments.

- MOS 3.20 (Master 128, UK): [./dist/mos320.lst](./dist/mos320.lst)
- MOS 3.50 (Master 128, UK): [./dist/mos350.lst](./dist/mos350.lst)
- MOS 4.00 (Master ET, UK): [./dist/mos400.lst](./dist/mos400.lst)
- MOS 5.00 (Master Compact, UK): [./dist/mos500.lst](./dist/mos500.lst)
- MOS 5.10 (Master Compact, UK): [./dist/mos510.lst](./dist/mos510.lst)
- MOS 5.11 (Master Compact, International):  [./dist/mos511.lst](./dist/mos511.lst)

The following unreleased versions for Acorn systems are covered:

- MOS 3.29 (looks to be a pre-release version of MOS 3.50):  [./dist/mos329.lst](./dist/mos329.lst)

The following non-Acorn systems are also covered:

- MOS I5.10C (variant of MOS 5.10) ([Olivetti PC128S](https://it.wikipedia.org/wiki/Olivetti_Prodest_PC_128_S)):  [./dist/mosPC128S.lst](./dist/mosPC128S.lst)
- MOS 3.5a (variant of MOS 3.50) ([Henson CFA3000](https://stardot.org.uk/forums/viewtopic.php?t=20676)):  [./dist/mosCFA3000.lst](./dist/mosCFA3000.lst)
- MOS 5.10i (variant of MOS 5.11) ([Autocue 1500 teleprompter](https://stardot.org.uk/forums/viewtopic.php?t=7179)):  [./dist/mosautocue.lst](./dist/mosautocue.lst)

**This project is a work in progress.** A lot of it isn't actually
commented, some of the OS workspace references haven't been turned
into labels, and many of the label names fail to meet even the low bar
of "not actively misleading". I've concentrated so far on finding the
bits that are code, the bits that are data, any obfuscated references
to addresses in the ROM, and any obvious data-dependent constants.

The starting point was JGH's MOS 3.20 disassembly here:
http://mdfs.net/Info/Comp/Acorn/Source/MOS.htm - this provided
comments for several sections, identified many of the tables, and
convinced me that this sort of project might actually be feasible.

https://tobylobster.github.io/mos/ has provided most comments and
symbol names for the bits that haven't changed (or haven't changed
much) since OS 1.20.

# project goals

Initial goals are to produce a useful listing file from the assembler,
that's got all addresses and bytes listed, and enough comments and
labels to give you a clue about what each bit of code might be doing
(even if the algorithm isn't fully described). This is intended to
simplify following along when looking at an unadorned disassembly
(e.g., on the Master itself), looking at MOS ROM addresses, and so on.
That's the sort of situation where I've personally most missed having
an annotated disassembly.

(Readable source code is not an initial goal. Sorry! )

For these purposes, the 64tass listing files are relatively easy to
follow along, but not ideal. I intend to add a postprocessing step to
transform it into something a bit tidier.

My longer term goal is to produce a decent-quality modifiable source
file, with all label references located, all data-dependent constants
identified, and all current assumptions (page alignment, routines that
share pages, variables that must be together, etc.) checked. Then, in
theory, code can be added or removed fairly freely.

## patches

This project only covers MOS builds that look like they were created
from the original source. I've found some versions that have been
patched with the following binary patches:

* Y2K fixes: http://www.adsb.co.uk/bbc/bbc_master.html
* Fix for OSBYTE &6B never selecting the external 2 MHz bus: https://github.com/tom-seddon/acorn_mos_disassembly/blob/ac672c5201fc65644731a07c9c2065abcefd1e24/dist/mos320.lst#L27565 

# build

This repo has submodules. Clone it with `--recursive`:

    git clone --recursive https://github.com/tom-seddon/mos320
	
Alternatively, if you already cloned it non-recursively, you can do
the following from inside the working copy:

    git submodule init
	git submodule update

## prerequisites ##

Mandatory:

* Python 3.x

On Unix:

* [`64tass`](http://tass64.sourceforge.net/) (I use r3120)
* GNU Make

(Prebuilt Windows EXEs for 64tass and make are included in the repo.)

## build steps ##

Type `make` from the root of the working copy.

The build process is supposed to be silent when there are no errors
and when the output matches the original ROMs. Some versions of make
might print a load of stuff about entering and leaving the directory.

## build output

The build output is assembler listing files that you can use for
reference. Released versions:

- `build/mos320.lst` - MOS 3.20
- `build/mos350.lst` - MOS 3.50
- `build/mos400.lst` - MOS 4.00
- `build/mos500.lst` - MOS 5.00
- `build/mos510.lst` - MOS 5.10
- `build/mos511.lst` - MOS 5.11

Modified versions:

- `build/mos320multios.lst` - MOS 3.20 + Y2K fix

Unreleased versions:

- `build/mos329.lst` - MOS 3.29

Versions for non-Acorn hardware:

- `build/mosPC128S.lst` - MOS I5.10C
- `build/mosCFA3000.lst` - MOS 3.5a
- `build/mosautocue.lst` - MOS 5.10i

## **experimental** new MOS builds

There are also experimental new builds of the OS that may be of
interest.

### MOS 3.20(NT)

A build of MOS 3.20 with Terminal stripped out and all MOS code
confined to the MOS ROM (`build/320nt/mos.rom`) and sideways bank 15
(`build/320nt/utils.rom`). You can put anything you like in the other
6 sideways banks.

In all other respects this is (supposed to be) identical to MOS 3.20,
warts and all.

# code notes

## code layout ##

The listing file includes up to 3 parts of the MOS, in this order:

- ext part - any code squeezed into an additional sideways ROM bank
  (the `extROM` constant indicates which bank it is, and the listing
  file indicates which addresses it occupies)
- utils/terminal part - the MOS code in sideways ROM bank 15
- mos part - the MOS code in the OS area

For some versions, the utils/terminal part includes the Terminal
application, the disassembly for which is pretty sparse. I've done
little more than simply identify which bits of the ROM are specific to
it.

(Because I started with one of those versions, there are lots of
references to `terminal` in the code. Sorry. These will get tidied
up.)

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

# the other MOS parts

There are disassemblies or source code available for Some versions of
some of the non-MOS parts of the various iterations of the Master
ROMs.

## BASIC

https://github.com/stardot/AcornCmosBasic

https://github.com/stardot/AcornDmosBasic

https://github.com/hoglet67/BBCBasic4r32

http://8bs.com/basic/basic4.htm

## ADFS

https://github.com/hoglet67/ADFS/blob/master/src/adfs150.asm

## DFS

http://regregex.bbcmicro.net/dfs224.asm.txt

## Edit

https://github.com/SteveFosdick/edit4/blob/master/edit110.asm

## View

Nobody appears to have disassembled View.

## ViewSheet

Nobody appears to have disassembled ViewSheet.

