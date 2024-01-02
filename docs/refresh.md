**The refreshed MOS versions are experimental**

The following refreshed new versions of the MOS are available:

* MOS 6.xx - for Master 128, based on MOS 3.20 with Terminal removed
* MOS 7.xx - for Master 128, based on MOS 3.50 with Terminal removed
* MOS 8.xx - for Master Compact (or Olivetti PC128S), based on MOS
  5.10

For Master 128, you can use either MOS 6.xx or MOS 7.xx.

For Master Compact (or Olivetti PC128S), you need to use 8.xx.

Currently, these versions must be built manually, following
[the building instructions](./build.md). Find the output in the build
folder: `mos.rom` and `utils.rom` in `build/6xx`, `build/7xx` or
`build/8xx`.

(Note that `mos.rom` and `utils.rom` are closely related and cannot be
mixed freely. Both ROMs must come from the exact same build!)

Each version comes in two 16 KB parts: `mos.rom`, for programming into
the MOS region, and `utils.rom`, for programming into bank 15. No
additional ROMs are required, so you can put whatever you like the
other banks.

# Other notes

- The new version number can be seen in response to `*FX0` or `*HELP`
- [OSBYTE &81 machine detection](https://beebwiki.mdfs.net/OSBYTE_%2681)
  results are deliberately unchanged
- There will be no refreshed versions of MOS 4.00 for the Master ET
- There are no refreshed versions of MOS 5.11 or the Olivetti PC128S
  MOS planned, but any useful changes may make their way into MOS 8.xx

# Versions

The following versions are available. All 3 versions are built from
the same code, and are released together, so the version numbers for
all 3 versions increase in sync.

## .00

* 6.00, 7.00: RTC year is assumed to be 20xx not 19xx
* 6.00, 8.00: fix OSBYTE &6B behaviour

## .01 (under development)
