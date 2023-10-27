# -*- mode:makefile-gmake; -*-

PYTHON?=python
MKDIR:=mkdir -p
TASS:=64tass --m65c02 --nostart -Wall -q --case-sensitive --line-numbers --verbose-list
BUILD:=build

ifeq ($(VERBOSE),1)
_V:=
else
_V:=@
endif

##########################################################################
##########################################################################

.PHONY:all
all: $(BUILD)/3.20/all.orig $(BUILD)/5.00/all.orig
	$(_V)$(MKDIR) $(BUILD)/3.20

	$(_V)$(TASS) mos320.s65 -L$(BUILD)/mos320.lst --output-section mos -o$(BUILD)/3.20/mos.rom --output-section terminal -o $(BUILD)/3.20/terminal.rom --output-section ext -o $(BUILD)/3.20/ext.rom
	$(_V)cat $(BUILD)/3.20/terminal.rom $(BUILD)/3.20/mos.rom $(BUILD)/3.20/ext.rom > $(BUILD)/3.20/all.new
	@sha1sum $(BUILD)/3.20/all.orig
	@sha1sum $(BUILD)/3.20/all.new

	$(_V)$(TASS) mos500.s65 -L$(BUILD)/mos500.lst --output-section mos -o $(BUILD)/5.00/mos.rom --output-section utils -o $(BUILD)/5.00/utils.rom
	$(_V)cat $(BUILD)/5.00/utils.rom $(BUILD)/5.00/mos.rom > $(BUILD)/5.00/all.new
	@sha1sum $(BUILD)/5.00/all.orig
	@sha1sum $(BUILD)/5.00/all.new

##########################################################################
##########################################################################

.PHONY:clean
clean:
	rm -Rf $(BUILD)

##########################################################################
##########################################################################

.PHONY:diff320
diff320:
	$(MAKE) _diff VERSION=3.20

.PHONY:diff500
diff500:
	$(MAKE) _diff VERSION=5.00

.PHONY:_diff
_diff: all
	vbindiff $(BUILD)/$(VERSION)/all.orig $(BUILD)/$(VERSION)/all.new

##########################################################################
##########################################################################

$(BUILD)/3.20/all.orig: orig/MOS320.rom
	$(_V)$(MKDIR) $(BUILD)/3.20
	$(_V)dd status=none if=$< skip=114688 count=16384 bs=1 > $@
	$(_V)dd status=none if=$< skip=0 count=16384 bs=1 >> $@
	$(_V)dd status=none if=$< skip=113152 count=1536 bs=1 >> $@

##########################################################################
##########################################################################

$(BUILD)/5.00/all.orig: orig/mos500/mos.rom orig/mos500/utils.rom
	$(_V)$(MKDIR) $(BUILD)/5.00
	$(_V)cat orig/mos500/utils.rom orig/mos500/mos.rom > $(BUILD)/5.00/all.orig

##########################################################################
##########################################################################
