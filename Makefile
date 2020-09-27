# -*- mode:makefile-gmake; -*-

BEEBASM?=beebasm
PYTHON?=python
MKDIR:=mkdir -p
TASS:=64tass --m65c02 --nostart -Wall -q

BUILD:=build

##########################################################################
##########################################################################

.PHONY:all
all: $(BUILD)/mos.orig
	beebasm -i mos320.asm

	@sha1sum $(BUILD)/mos.orig
	@sha1sum $(BUILD)/mos.new

	$(PYTHON) fixup.py -o $(BUILD)/mos320_1stmt.asm mos320.asm

	beebasm -i $(BUILD)/mos320_1stmt.asm

	@sha1sum $(BUILD)/mos.new

	$(PYTHON) fixup.py --64tass -o $(BUILD)/mos320_64tass.s65 mos320.asm

	$(TASS) $(BUILD)/mos320_64tass.s65 -L$(BUILD)/mos320.lst -o$(BUILD)/mos320-64tass.rom

	@sha1sum $(BUILD)/mos320-64tass.rom


$(BUILD)/mos.orig: MOS320.rom
	$(MKDIR) $(BUILD)
	dd if=$< skip=114688 count=16384 bs=1 > $@
	dd if=$< skip=0 count=16384 bs=1 >> $@
