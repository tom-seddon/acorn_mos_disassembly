**The refreshed MOS versions are experimental**

The following refreshed new versions of the MOS are available,
distinguished from the official versions with an alphabetic suffix,
here indicated by `r`:

* MOS 3.20r - for Master 128, based on MOS 3.20 with Terminal removed
* MOS 3.50r - for Master 128, based on MOS 3.50 with Terminal removed
* MOS 5.10r - for Master Compact (or Olivetti PC128S), based on MOS
  5.10

The actual suffix for the first released refresh version is `A`.
Future versions will be `B`, `D`, `E` - and so on. (To avoid confusion
with MOS I5.10C, there will be no refresh version `C`.)

For Master 128, you can use either MOS 3.20r or MOS 3.50r.

For Master Compact (or Olivetti PC128S), you need to use MOS 5.10r.

Each version comes in two 16 KB parts: `mos.rom`, for programming into
the MOS region, and `utils.rom`, for programming into bank 15. No
additional ROMs are required, so you can put whatever you like the
other banks.

(Note that `mos.rom` and `utils.rom` are closely related and cannot be
mixed freely. Both ROMs must come from the exact same build!)

Please bear in mind [the MOS 3.50 notes](./MOS3.50.md) if using
MOS 3.50r and hoping to use the standard MOS 3.50 ROMs for DFS, BASIC,
EDIT or ADFS.

If you're feeling adventurous, I have some notes on putting together
a [MOS 3.50 DIY build](./MOS3.50.DIY.md).

# Other notes

- The new version number can be seen in response to `*FX0` or `*HELP`
- [OSBYTE &81 machine detection](https://beebwiki.mdfs.net/OSBYTE_%2681)
  results are deliberately unchanged
- There will be no refreshed versions of MOS 4.00 for the Master ET
- There are no refreshed versions of MOS 5.11 or the Olivetti PC128S
  MOS planned, but any useful changes may make their way into MOS
  5.10r

# Released versions

There's a separate releases page for these:
https://github.com/tom-seddon/acorn_mos_refreshed/releases

The following versions are available. All 3 versions are built from
the same code, and are released together, so the version numbers for
all 3 versions increase in sync.

## A

* 3.20A, 5.10A: fix OSBYTE &6B behaviour

## B

* 3.20B, 3.50B: RTC year is assumed to be 20xx not 19xx
* 3.20B, 3.50B: remove built-in  `*X` command
* 3.50B: fix handling of missing language ROM Tube relocation bitmaps
* 3.50B: improve language ROM Tube transfer speed

## C

There is no version C.

## D (under development)

