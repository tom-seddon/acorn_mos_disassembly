# -*- mode:makefile-gmake; -*-

BEEBASM?=beebasm
MKDIR:=mkdir -p

BUILD:=build

##########################################################################
##########################################################################

.PHONY:all
all: $(BUILD)/mos.orig
	beebasm -i mos320.asm

	@sha1sum $(BUILD)/mos.new
	@sha1sum $(BUILD)/mos.orig

$(BUILD)/mos.orig: MOS320.rom
	$(MKDIR) $(BUILD)
	dd if=$< skip=114688 count=16384 bs=1 > $@
	dd if=$< skip=0 count=16384 bs=1 >> $@
