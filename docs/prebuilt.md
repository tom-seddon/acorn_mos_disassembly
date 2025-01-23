# prebuilt versions

The following prebuilt images are available. 

# 3.20

Find inside the `320r` folder in the zip, where `r` is the version
letter.

There are two versions. The standard version (`320r.bin`) contains the
standard ADFS 1.50 ROM supplied with MOS 3.20, which supports SCSI
hard drives; the IDE version (`320r_ide.bin`) contains a patched
version (reporting itself as version 1.53) that supports modern IDE
interfaces.

The two versions are otherwise identical, and include the following
ROMs:

| ROM | Offset | What                  | Notes                 |
|-----|--------|-----------------------|-----------------------|
| 15  | 1C000  | UTILS for MOS 3.20r   | Required              |
| 14  | 18000  | blank                 |                       |
| 13  | 14000  | ADFS 1.50/1.53        | may include IDE patch |
| 12  | 10000  | BASIC 4               |                       |
| 11  | 0C000  | EDIT 1.00             |                       |
| 10  | 08000  | The BASIC Editor 1.46 |                       |
| 9   | 04000  | DFS 2.29              |                       |
| OS  | 00000  | MOS 3.20r             | Required              |

# 3.50

Find inside the `350r` folder in the zip.

There are two versions. The standard version (`350r.bin`) contains the
standard ADFS 2.03 ROM supplied with MOS 3.20, which supports SCSI
hard drives; the IDE version (`350r_ide.bin`) contains a patched
version (reporting itself as version 2.05) that supports modern IDE
interfaces.

The two versions are otherwise identical, and include the following
ROMs:

| ROM | Offset | What                   | Notes                                                                           |
|-----|--------|------------------------|---------------------------------------------------------------------------------|
| 15  | 1C000  | UTILS for MOS 3.50r    | Required                                                                        |
| 14  | 18000  | blank                  |                                                                                 |
| 13  | 14000  | ADFS 2.03/2.05         | may include IDE patch. Must be in bank 13 if present                            |
| 12  | 10000  | BASIC 4r33             | patched to improve maths accuracy. See https://github.com/hoglet67/BBCBasic4r32 |
| 11  | 0C000  | EDIT 1.50r             |                                                                                 |
| 10  | 08000  | The BASIC Editor 1.46r |                                                                                 |
| 9   | 04000  | DFS 2.45               | Required                                                                        |
| OS  | 00000  | MOS 3.50r              | Required                                                                        |

BASIC, EDIT and The BASIC Editor are relocatable versions, giving you
more memory available when using a 6502 second processor.

Note the ADFS restriction: it's fine to replace it, but if it's
included, it must be in bank 13.

# 5.10

Find inside the `510` folder in the zip.

There is one version, `510r.bin`, containing the following:

| ROM | Offset | What                | Notes    |
|-----|--------|---------------------|----------|
| 15  | c000   | UTILS for MOS 5.10r | Required |
| 14  | 8000   | BASIC 4             |          |
| 13  | 4000   | ADFS 2.10           |          |
| OS  | 0000   | MOS 5.10r           | Required |

ADFS and BASIC are just as supplied with original MOS 5.10.

# Modifying the images

(This section mainly applies to 3.20r and 3.50r. You don't have all
that many options with the Compact's 64 KB ROM.)

These images are useable as-is, but the intention is they'll serve as
a starting point for additional modification. Both 3.20r and 3.50r
have a spare bank (that could be used for something!), and if you
don't use EDIT or The BASIC Editor then perhaps you could find some
other use for those banks.

Any ROM not marked "Required" in its Notes column can be replaced. The
Offset column is a hex number indicating where in the MegaROM image
each one begins, if your preferred tools let you edit in place.

Alternatively, concatenate the files in each version's `roms` folder
to produce a new image: MOS first, then the ROM images in ascending
order of ROM number, replacing any replaceable images with the
alternative image you'd prefer.

(Yes, sorry, this is the other way round from the tables above, which
are arranged to roughly match the output from `*ROMS`.)

Each image has to be 16,384 bytes. The resulting concatenated file
needs to be exactly 131,072 bytes for 3.20r or 3.50r, and 65,536 bytes
for 5.10r.
