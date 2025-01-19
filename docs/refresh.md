**The refreshed MOS versions are experimental**

The refreshed versions of the MOS use the original Acorn code as a
starting point for new builds with bug fixes, performance improvements
and perhaps the odd new feature.

Goals for the refreshed versions, roughly in priority order:

1. fix any obvious MOS bugs: crash, hang, behaviour not matching
   documentation, stuff fixed in a later version, that sort of thing
2. retain compatibility with existing MOS versions
3. improve performance where possible
4. maybe add the occasional useful new user-facing quality-of-life
   feature

There are no plans to add new APIs.

# variants available

The following refreshed variants of the MOS are available,
distinguished from the official versions with an alphabetic suffix,
here indicated by `r`:

* MOS 3.20r - for Master 128, based on MOS 3.20 with Terminal removed
* MOS 3.50r - for Master 128, based on MOS 3.50 with Terminal removed
* MOS 5.10r - for Master Compact (or Olivetti PC128S), based on MOS
  5.10

The actual suffix for the first released refresh version is `A`,
followed by `B`, `D`, `E` - and so on. (To avoid confusion with MOS
I5.10C, there will be no refresh version `C`.)

For Master 128, you can use either MOS 3.20r or MOS 3.50r.

For Master Compact (or Olivetti PC128S), you need to use MOS 5.10r.

# download

See the releases page for the refreshed versions:
https://github.com/tom-seddon/acorn_mos_refreshed/releases

The latest version is at the top.

# how to use

Version E and later come with prebuilt ROM images in the zip, that you
can program and use straight away, and use as a base for further
modification. For more details about what's included, see [the
prebuilt versions notes](./prebuilt.md).

You can also assemble your own ROM image starting from `mos.rom` (the
MOS region code) and `utils.rom` (sideways ROM bank 15) and going from
there. (Please bear in mind [the MOS 3.50 notes](./MOS3.50.md) if
using MOS 3.50r and hoping to use the standard MOS 3.50 ROMs for DFS,
BASIC, EDIT or ADFS. I have some notes on putting together a [MOS 3.50
DIY build](./MOS3.50.DIY.md).)

# other notes

- The new version number can be seen in response to `*FX0` or `*HELP`
- [OSBYTE &81 machine detection](https://beebwiki.mdfs.net/OSBYTE_%2681)
  results are deliberately unchanged
- There will be no updates to MOS 4.00 for the Master ET
- There are no refreshed versions of MOS 5.11 or the Olivetti PC128S
  MOS planned, but any useful changes may make their way into MOS
  5.10r

# feedback

If you have any problems or find any bugs, please post in the StarDot
thread or open a GitHub issue.

StarDot thread for this project:
https://www.stardot.org.uk/forums/viewtopic.php?t=28879

GitHub issues for this project:
https://github.com/tom-seddon/acorn_mos_disassembly/issues

# version history

Version history is as follows, including the version currently in
development (which is not available from the releases page, but can be
built from the code in the repo if you want to try it).

All 3 variants are built from the same code, and are released
together, so the version numbers for all 3 variants stay in sync. 

## E (under development)

## D

* All: print version number in startup banner instead of `Acorn MOS`
* All: improve OSWRCH speed when printing text at text cursor
* 3.20D: bring in some of the MOS 3.50 code shuffling to free up space
  for future improvements 
* 3.50D: further improve relocated language ROM Tube transfer speed
* 3.50D: fix text printing speed in modes 1/5, which was previously
  needlessly a bit slower than in MOS 3.20

## C

There is no version C.

## B

* 3.20B, 3.50B: RTC year is assumed to be 20xx not 19xx
* 3.20B, 3.50B: remove built-in `*X` command
* 3.50B: fix handling of missing language ROM Tube relocation bitmaps
* 3.50B: improve language ROM Tube transfer speed

## A

* 3.20A, 5.10A: fix OSBYTE &6B behaviour
