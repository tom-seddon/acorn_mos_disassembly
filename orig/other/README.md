It's stretching the term "orig" a bit in a couple of places - but here
are some other ROMs, not part of the original MOS.

The prebuilt versions use these.

# `Acorn ADFS 153 (IDE).rom`; `Acorn ADFS 205 (IDE).rom`

ADFS, patched to work with modern IDE interfaces. Stardot thread here:
https://stardot.org.uk/forums/viewtopic.php?t=29533

153 is a patched version of 1.50 from MOS 3.20.

205 is a patched version of 2.03 from MOS 3.50.

I don't have relevant hardware, but I'm sure it's fine. What could
possibly go wrong???

# `basic.4r33.rom`

BASIC 4r32 patched as per description here:
https://github.com/hoglet67/BBCBasic4r32

I took the liberty of changing the version string. 4r33 has seen
previous use for this version:
https://stardot.org.uk/forums/viewtopic.php?t=28393

The patch doesn't affect the relocation bitmap.

# `dfs.2.29.rom`

Bug-fixed version of DFS 2.24 supplied on the Master 128 Welcome disk.

Can't find much info about this? [JGH's DFS versions
page](https://mdfs.net/System/ROMs/Filing/Disk/Acorn/versions) says
this:

    OSGBPB Tube problem introduced at 2.26
    fixed. *CONFIGURE FDRIVE 2 has software
    delay added to hardware delay. This
    allows for support of slow step rate
    drives with 1772 fitted, ie
    *CONFIGURE FDRIVE  0   1   2   3
    for 1770           6  12  50  30 ms
    for 1772           6  12  32   3 ms
    Bugs:
    OSWORD &7F double-density select in
    drive.b3 does not work.
	
# `dfs.2.45.no_mos.rom`

MOS 3.50's DFS 2.45, but with the MOS ROM parts replaced with 0s.

# `blank.rom`

Not actually a valid ROM: just a 16 KB file consisting entirely of 0s.
	
# `basiced.1.46.rom`; `rbasiced.1.46.rom`; `rbasiced.1.46.relocation.dat`

The BASIC Editor 1.46, my updated version of The BASIC Editor. See
https://github.com/tom-seddon/basic_editor/

This is included because it's one of very few ROMs that has a
relocatable version. The relocation bitmaps are annoying to set up, so
might as well provide a prebuilt version for anybody that wants it.
