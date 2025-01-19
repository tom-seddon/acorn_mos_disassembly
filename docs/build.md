# build prerequisites

Mandatory:

* Python 3.x

On Unix:

* [`64tass`](http://tass64.sourceforge.net/) (I use r3120)
* GNU Make

(Prebuilt Windows EXEs for 64tass and make are included in the repo.)

# git clone

This repo has submodules. Clone it with `--recursive`:

    git clone --recursive https://github.com/tom-seddon/acorn_mos_disassembly
	
Alternatively, if you already cloned it non-recursively, you can do
the following from inside the working copy:

    git submodule init
	git submodule update

(The code won't build without fiddling around if you download one of
the archive files from GitHub - a GitHub limitation. It's easiest to
clone it as above.)

# build steps

Type `make` from the root of the working copy.

The build process is supposed to be silent when there are no errors
and when the output matches the original ROMs. Some versions of make
might print a load of stuff about entering and leaving the directory.

# build output

The build output is assembler listing files that you can use for
reference. Released versions:

- `build/mos320.lst` - MOS 3.20
- `build/mos350.lst` - MOS 3.50
- `build/mos400.lst` - MOS 4.00
- `build/mos500.lst` - MOS 5.00
- `build/mos510.lst` - MOS 5.10
- `build/mos511.lst` - MOS 5.11

Unreleased versions:

- `build/mos329.lst` - MOS 3.29

Versions for non-Acorn hardware:

- `build/mosPC128S.lst` - MOS I5.10C
- `build/mosCFA3000.lst` - MOS 3.5a
- `build/mosautocue.lst` - MOS 5.10i
