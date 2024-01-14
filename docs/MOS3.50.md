# MOS 3.50 restrictions

As well as the MOS, MOS 3.50 contains 6 additional ROMs: DFS,
ViewSheet, EDIT, BASIC, ADFS, and View.

DFS, BASIC, EDIT and ADFS aren't quite standalone, so please bear in
mind the following restrictions if hoping to use them.

## ADFS and DFS

MOS 3.50 DFS (DFS 2.45) and MOS 3.50 ADFS (ADFS 2.03) share code. ADFS
won't work without DFS; DFS does work to at least some extent without
ADFS, but I haven't tested this thoroughly.
   
Both need to go in their default banks: DFS in bank 9, ADFS in bank
13.

## BASIC and EDIT
   
MOS 3.50 BASIC (BASIC 4r32) and MOS 3.50 EDIT (EDIT 1.50r) are
standalone when used without a 6502 2nd processor, and can be put in
any bank.

With a 6502 2nd processor, both depend on MOS 3.50 VIEW. All 3 must be
in their original banks for this to work: EDIT in bank 11, BASIC in
bank 12 and VIEW in bask 14.
   
# Workarounds

Patched ROMs are supplied to help work around the above restrictions.

## Not bothered about HIBASIC or HIEDIT? ##

If you use a 6502 2nd processor, but don't much care about getting
some more memory in BASIC or EDIT when using it, you can use the
non-relocating version of BASIC and EDIT. Find them in the
`other_350_roms.rel_none` folder in the distribution, next to the MOS
3.50 ROMs.

These can go in any bank, and don't depend on any other ROM.

## Want HIBASIC or HIEDIT, but don't want VIEW? ##

If you want the extra memory in BASIC or EDIT in your 6502 2nd
processor, but don't want to be stuck with View in bank 14, you might
like relocating versions of BASIC and EDIT that depend only on a
patched version of DFS. Find all 3 ROMs in the
`other_350_roms.rel_dfs` folder in the distribution, next to the MOS
3.50 ROMs.

BASIC and EDIT can go in any bank. DFS must go in bank 9, its usual
location.
