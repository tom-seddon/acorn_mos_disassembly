Rebuildable version of Acorn's MOS 3.20 for the Master 128.

The starting point was JGH's MOS 3.20 disassembly here: http://mdfs.net/Info/Comp/Acorn/Source/MOS.htm

This required only some minor tweaks to get it to build as-was with
BeebAsm, producing an exact replica of the corresponding parts of the
original ROM.

I then converted this to 64tass syntax, that being my preferred 6502
assembler.

Current policy for names is to copy from
https://tobylobster.github.io/mos/index.html where there's an obvious
match. It's possible https://github.com/stardot/AcornOS120 would be a
better source.

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
