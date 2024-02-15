(Version numbers mentioned are as reported by `*FX0`.)

Click each .lst link to get a reasonably recent assembler listing
file, including assembled code, labels and comments.

The following released versions for Acorn systems are covered:

- MOS 3.20 (Master 128, UK): [../dist/mos320.lst](../dist/mos320.lst)
- MOS 3.50 (Master 128, UK): [../dist/mos350.lst](../dist/mos350.lst)
- MOS 4.00 (Master ET, UK): [../dist/mos400.lst](../dist/mos400.lst)
- MOS 5.00 (Master Compact, UK): [../dist/mos500.lst](../dist/mos500.lst)
- MOS 5.10 (Master Compact, UK): [../dist/mos510.lst](../dist/mos510.lst)
- MOS 5.11i (Master Compact, International):  [../dist/mos511.lst](../dist/mos511.lst)

The following unreleased versions for Acorn systems are covered:

- MOS 3.29 (looks to be a pre-release version of MOS 3.50):  [../dist/mos329.lst](../dist/mos329.lst)

The following non-Acorn systems are also covered:

- MOS I5.10C (variant of MOS 5.10) ([Olivetti PC128S](https://it.wikipedia.org/wiki/Olivetti_Prodest_PC_128_S)):  [../dist/mosPC128S.lst](../dist/mosPC128S.lst)
- MOS 3.5a (variant of MOS 3.50) ([Henson CFA3000](https://stardot.org.uk/forums/viewtopic.php?t=20676)):  [../dist/mosCFA3000.lst](../dist/mosCFA3000.lst)
- MOS 5.10i (variant of MOS 5.11i) ([Autocue 1500 teleprompter](https://stardot.org.uk/forums/viewtopic.php?t=7179)):  [../dist/mosautocue.lst](../dist/mosautocue.lst)

# Patched versions

This project only covers MOS builds that look like they were created
from the original source code. There are versions available that have
been binary patched with some combination of the following patches:

- Y2K fixes: http://www.adsb.co.uk/bbc/bbc_master.html
- Fix for OSBYTE &6B never selecting the external 2 MHz bus: https://github.com/tom-seddon/acorn_mos_disassembly/blob/ac672c5201fc65644731a07c9c2065abcefd1e24/dist/mos320.lst#L27565
- Fix for `*MOVE` permissions: https://mdfs.net/Info/Comp/BBC/SROMs/BuildMOS (detokenized text available here: [./BuildMOS.txt](./BuildMOS.txt))
