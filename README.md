Rebuildable, partially-commented version of Acorn MOS for Acorn's
8-bit BBC Master series and derivatives. The objective is to produce a
useful listing file that you can use for reference when debugging or
writing code.

**This project is a work in progress.**

The code covers 6 released versions for Acorn systems, 3 released
versions for non-Acorn systems, and 1 unreleased version for Acorn
systems. For more details, see
[the versions list](./docs/versions.md).

Prebuilt listing files are available from the latest release page:
https://github.com/tom-seddon/acorn_mos_disassembly/releases/latest -
download the -lst zip. 

Alternatively, you can create them yourself, following
[the building instructions](./docs/build.md).

[Some notes about the listing files](./docs/lst.md).

# goals

1. Produce a useful listing file from the assembler, that's got all
   addresses and bytes listed, and enough comments that you can follow
   along
   
2. Rationalize the (currently numerous) version checks in the code;
   initially added as needed to make all the versions build from the
   same source, ultimately they should be mostly replaced by feature
   flags, each version then choosing its own set
   
3. Produce a decent-quality modifiable source file, with all label
   references and data-dependent constants located, and current
   assumptions documented with error or warning directives,
   facilitating addition or removal of code

Goals 2 and 3 are intended to enable the possible creation of new
versions of the MOS, but actually creating those versions is not a
goal of this project.

# new versions of the MOS

Even though producing new versions of the MOS is not a goal of this
project, there some **experimental** new versions of the MOS available
anyway, for use at your own risk. These can be used in an emulator, or
programmed into a EPROM (or similar) and used in real hardware.

**All new versions of the MOS are experimental.** Should you actually
use your 8-bit 1980s Acorn computer for anything important, please
proceed with appropriate caution.

[MOS 3.20(NT) and MOS 3.50(NT)](./docs/NT.md), for Master 128 only,
have had the Terminal ROM taken out. All existing OS behaviour is
(hopefully) maintained, but creation of new MegaROM images is much
simplified.

[Refresh versions of MOS 3.20, MOS 3.50 and MOS 5.10](./docs/refresh.md),
cover Master 128, Master Compact and Olivetti PC128S, using the
existing OS code as a starting point for new versions with additional
fixes and features.

# history

The starting point was JGH's MOS 3.20 disassembly here:
http://mdfs.net/Info/Comp/Acorn/Source/MOS.htm - this provided
comments for several sections, identified many of the tables, and
convinced me that this sort of project might actually be feasible.

https://tobylobster.github.io/mos/ has provided most comments and
symbol names for the bits that haven't changed (or haven't changed
much) since OS 1.20.

https://tobylobster.github.io/GXR-pages/index.html has provided symbol
names for some of the bits similar to the the GXR ROM.

# the other MOS parts?

As well as the MOS code, the Master series ROMs usually included some
additional software. [Disassemblies or source code available for some
versions of some of these](./docs/other-parts.md).
