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

# new features

This section only deals with visible stuff that doesn't behave as per
the original docs. For notes about bug fixes (bringing the code in
line with the docs), performance improvements (hopefully not changing
behaviour! Just quicker!), or other internal changes, please consult
the version history.

## y2k "compliance"

The RTC year is now always 20xx rather than 19xx.

## startup banner

The startup banner prints the MOS version (as reported by `*FX0`)
rather than a generic `Acorn MOS` (or similar).

## `*X` is gone

The mysterious MOS 3.xx `*X` command (["for internal use
only"](https://www.beebmaster.co.uk/AcornLetters/Acorn%2011th%20November%201991.html))
has been removed.

# variants available

The following refreshed variants of the MOS are available,
distinguished from the official versions with an alphabetic suffix,
here indicated by `r`:

* MOS 3.20r - for Master 128, based on MOS 3.20 with Terminal removed
* MOS 3.50r - for Master 128, based on MOS 3.50 with Terminal removed
* MOS 5.10r - for Master Compact (or Olivetti PC128S), based on MOS
  5.10

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

## F (under development)

* All: remove [mystery write to
  $fe8e](https://stardot.org.uk/forums/viewtopic.php?p=328986&hilit=fe8e#p328986)
  on startup
* All: add new * (numpad)+BREAK safe mode shortcut
* All: add new - (numpad)+BREAK very safe mode shortcut 
* All: `*ROMS` notes with `ignored` ROMs that are being ignored
  because their entries in the ROMs table have been removed
* 3.20F, 3.50F: reduce amount of zero page used by Tube host code, so
  it now uses no more than the Acorn MOS did
* 3.50F: further slightly improve relocated language ROM Tube transfer
  speed
* 3.20F: bring in more of the MOS 3.50 code shuffling so the versions
  are more similar internally
* 3.20F, 3.50F: add Tube power-on boot delay to accommodate slower
  PiTube startup time
  
### safe mode

Use numpad `*`+BREAK to boot into safe mode: the OSCLI `*` prompt,
bypassing the configured language. Use this if you have problems with
the configured language ROM not starting properly.

In safe mode, the system will always start up with the ROM filing
system selected. If you'd like to use some other filing system, you'll
have to select it manually. You can use its `*` command, or hold down
its boot key and press BREAK. (The OSCLI `*` prompt will remain the
current language.)

### very safe mode

Use numpad `-`+BREAK (which counts as a hard BREAK, similar to a
CTRL+BREAK) to boot into very safe mode: the OSCLI `*` prompt, with
ROM FS selected, same as safe mode, but also ignoring all non-MOS
sideways ROMs, language ROMs and service ROMs alike. Use this if you
have problems too serious for ordinary safe mode!

You can't do much in very safe mode, but you can use `*ROMS`,
`*CONFIGURE` and `*UNPLUG`, hopefully letting you get things back into
a bootable state.

### `*ROMS` notes ignored ROMs

`*ROMS` will show a message `ignored` against non-unplugged ROMs that
being ignored due to having an empty entry in the ROM information
table.

You will see this in very safe mode, to indicate that ROMs are being
ignored.

You may also see this if you use 3rd-party tools designed for the B/B+
that disable ROMs by modifying the ROM information table.

### Tube power-on boot delay

The MOS can wait longer on initial power up for the 2nd processor to
become ready, to accomodate PiTube startup time when it's powered by
the Master PSU (as is the case if fitted internally).

Use `*CONFIGURE TUBEWAIT <n>` to set this value. `<n>` is a value from
0 to 15 inclusive, approximately the maximum number of seconds to wait
for. The wait time depends on the type of Pi, so you'll have to
experiment to find the right value for your setup. 

(This is a maximum; if it becomes ready sooner, the 2nd processor will
be detected then. But if the configured 2nd processor isn't connected,
you'll be waiting for the full period.)

The delay is ignored when `*CONFIGURE NOTUBE`, and always applies to
power-on reest only.

## E

No code changes, but prebuilt full MegaROM images are now included in
the zip file.

## D

* All: print version number in startup banner instead of `Acorn MOS`
* All: improve OSWRCH speed when printing text at text cursor
* 3.20D: bring in some of the MOS 3.50 code shuffling to free up space
  for future improvements 
* 3.50D: further improve relocated language ROM Tube transfer speed
* 3.50D: fix text printing speed in modes 1/5, which was previously
  needlessly a bit slower than in MOS 3.20

## C

There is no version C, to avoid confusion with MOS I5.10C, used for
the Olivetti PC 128 S.

## B

* 3.20B, 3.50B: RTC year is assumed to be 20xx not 19xx
* 3.20B, 3.50B: remove built-in `*X` command
* 3.50B: fix handling of missing language ROM Tube relocation bitmaps
* 3.50B: improve language ROM Tube transfer speed

## A

* 3.20A, 5.10A: fix OSBYTE &6B behaviour
