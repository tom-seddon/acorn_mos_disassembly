Rebuildable version of (most of) Acorn's MOS 3.20 for the Master 128.

The starting point was JGH's MOS 3.20 disassembly here:
http://mdfs.net/Info/Comp/Acorn/Source/MOS.htm

This required only some minor tweaks to get it to build as-was with
BeebAsm, producing an exact replica of the corresponding parts of the
original ROM.

I then converted this to 64tass syntax, that being my preferred 6502
assembler.

Looks like there's ~1.5 KB of MOS code in the end of the View ROM
that's not included here yet.

# symbol names

The Master Reference Manual (part 1) mentions a few names, presumably
from the original source. I've used those where appropriate.

The policy for names otherwise is to copy from
https://tobylobster.github.io/mos/index.html where there's an obvious
match.

It's possible https://github.com/stardot/AcornOS120 would be a more
authentic source, but I must admit I'm not a huge fan of the short,
abbreviated names.

# prerequisites

Mandatory:

* [`64tass`](http://tass64.sourceforge.net/)
* a Unix-type system with the usual Unix-type stuff (on Windows, you
  should be good with WSL, cygwin, Git Bash, etc.)

Optional:

* [`vbindiff`](https://www.cjmweb.net/vbindiff/)

# build

Type `make`.

The output file is `build/mos320.rom`.

The build process prints SHA1 hashes for the output and for the
original rom, so you can see if the output is the same. (The expected
SHA1 for the original is `aa8e3cf42b414344069de23fdce6f913bf1ec501`.)

I've found `vbindiff` helpful for figuring out discrepancies. If you
have this installed, type `make diff` to run it, comparing the built
MOS 3.20 with the original.

## regarding the build output ##

The build output isn't (yet?) terribly useful as-is. You do get an
exact replica of the key 32 KB of the MOS ROM, but you still need the
other 96 KB (ADFS, BASIC, DFS, Edit, View, ViewSheet), that's not
dealt with here, if you want to create a full 128 KB MegaROM image.

I don't currently plan on doing a full disassembly of the entire
MegaROM, but I do plan to at least improve the build process so that
the output is a bit-identical 128 KB MOS 3.20 MegaROM image.
