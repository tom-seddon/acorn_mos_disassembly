# -*- mode:makefile-gmake; -*-

BEEBASM?=beebasm
PYTHON?=python
MKDIR:=mkdir -p
TASS:=64tass --m65c02 --nostart -Wall -q --case-sensitive

BUILD:=build

##########################################################################
##########################################################################

.PHONY:all
all: $(BUILD)/mos.orig
	$(TASS) mos320.s65 -L$(BUILD)/mos320.lst -o$(BUILD)/mos320.rom

	@sha1sum $(BUILD)/mos.orig
	@sha1sum $(BUILD)/mos320.rom

.PHONY:clean
clean:
	rm -Rf $(BUILD)

.PHONY:diff
diff: all
	vbindiff $(BUILD)/mos.orig $(BUILD)/mos320.rom

$(BUILD)/mos.orig: orig/MOS320.rom
	$(MKDIR) $(BUILD)
	dd if=$< skip=114688 count=16384 bs=1 > $@
	dd if=$< skip=0 count=16384 bs=1 >> $@
