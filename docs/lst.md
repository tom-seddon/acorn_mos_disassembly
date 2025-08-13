The listing file is currently just whatever 64tass produces. In the
long run I intended to postprocess it to produce something that looks
a bit prettier, but the 64tass format is fairly readable and it does
contain the addresses and code bytes that you'll need if trying to
follow along with the actual MOS code.

Each listing file includes up to 3 parts of the MOS, in this order:

- ext part - any code squeezed into an additional sideways ROM bank
  (the `extROM` constant indicates which bank it is, and the listing
  file indicates which addresses it occupies)
- utils/terminal part - the MOS code in sideways ROM bank 15
- mos part - the MOS code in the OS area

For some versions, the utils/terminal part includes the Terminal
application, the disassembly for which is pretty sparse. I've done
little more than simply identify which bits of the ROM are specific to
it.

# symbol names ##

The Master Reference Manual (part 1) mentions a few names, presumably
from the original source. I've used those where appropriate.
https://github.com/stardot/AcornOS120 has also provided some symbols -
mostly for ZP addresses. The 6 character limit is a bit limiting for
code.

Initially, I used some names from
https://tobylobster.github.io/mos/index.html, as there are some bits
of code that are obviously reused from MOS 1.20. I ended up finding
the cross-referencing a bit time-consuming in the end, though, so I
didn't keep up with this.

# notation ##

## BASIC-style notation

`?M` means the byte at address `M`. `M?N` means the byte at address
`M+N`.

`!M` and `M!N` are the same, but for 32-bit dwords.

`;` means the quantity is a 16-bit word, as per the BASIC `VDU`
statement. This doesn't really have any strict syntax. I've mainly
used it when commented the VDU driver code.

## 64tass-style notation

`<M` is the LSB of `M`, and `>M` is the MSB of M.

## entry/exit/preserves ###

Register names are of course `A`, `X`, `Y`, and `N`, `V`, `B`, `D`,
`I`, `Z`, `C` refer to the status register bits.

I've not been super consistent about this, but I've sometimes noted if
C is preserved, as that's useful to know. N, V, Z and C are often
outputs so I've noted when required.

## Stack contents ###

Where relevant, stack contents are noted as `S=[A; B...]`, where `A`
is the item at S+1, `B` is the item at S+2, and so on.

Registers are referred to using their names. `RL` and `RH` are the low
and high bytes of the return address. Other things get an English
description.
