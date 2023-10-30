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
all: $(BUILD)/320/all.orig $(BUILD)/400/all.orig $(BUILD)/500/all.orig $(BUILD)/510/all.orig $(BUILD)/511/all.orig $(BUILD)/PC128S/all.orig
	$(_V)$(TASS) mos320.s65 -L$(BUILD)/mos320.lst --output-section mos -o$(BUILD)/320/mos.rom --output-section terminal -o $(BUILD)/320/terminal.rom --output-section ext -o $(BUILD)/320/ext.rom
	$(_V)cat $(BUILD)/320/terminal.rom $(BUILD)/320/mos.rom $(BUILD)/320/ext.rom > $(BUILD)/320/all.new
	$(_V)$(MAKE) _check_identical VERSION=320

	$(_V)$(MAKE) _build VERSION=500
	$(_V)$(MAKE) _build VERSION=510
	$(_V)$(MAKE) _build VERSION=511
	$(_V)$(MAKE) _build VERSION=400

.PHONY:_build
_build:
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom
	$(_V)cat $(BUILD)/$(VERSION)/utils.rom $(BUILD)/$(VERSION)/mos.rom > $(BUILD)/$(VERSION)/all.new
	$(_V)$(MAKE) _check_identical VERSION=$(VERSION)

.PHONY:_check_identical
_check_identical: ORIG:=$(BUILD)/$(VERSION)/all.orig
_check_identical: NEW:=$(BUILD)/$(VERSION)/all.new
_check_identical:
	@cmp --quiet $(ORIG) $(NEW) || ( sha1sum $(BUILD)/$(VERSION)/all.orig && sha1sum $(BUILD)/$(VERSION)/all.new )

.PHONY:_test
_test:
	@echo hello

##########################################################################
##########################################################################

.PHONY:clean
clean:
	rm -Rf $(BUILD)

##########################################################################
##########################################################################

.PHONY:diff320
diff320:
	$(MAKE) _diff VERSION=320

.PHONY:diff400
diff400:
	$(MAKE) _diff VERSION=400

.PHONY:diff500
diff500:
	$(MAKE) _diff VERSION=500

.PHONY:diff510
diff510:
	$(MAKE) _diff VERSION=510

.PHONY:diff511
diff511:
	$(MAKE) _diff VERSION=511

.PHONY:diffPC128S
diffPC128S:
	$(MAKE) _diff VERSION=PC128S

.PHONY:_diff
_diff: all
	vbindiff $(BUILD)/$(VERSION)/all.orig $(BUILD)/$(VERSION)/all.new

##########################################################################
##########################################################################

$(BUILD)/320/all.orig: orig/MOS320.rom
	$(_V)$(MKDIR) $(BUILD)/320
	$(_V)dd status=none if=$< skip=114688 count=16384 bs=1 > $@
	$(_V)dd status=none if=$< skip=0 count=16384 bs=1 >> $@
	$(_V)dd status=none if=$< skip=113152 count=1536 bs=1 >> $@

##########################################################################
##########################################################################

$(BUILD)/400/all.orig: orig/400/mos.rom orig/400/utils.rom
	$(_V)$(MAKE) _orig VERSION=400

$(BUILD)/500/all.orig: orig/500/mos.rom orig/500/utils.rom
	$(_V)$(MAKE) _orig VERSION=500

$(BUILD)/510/all.orig: orig/510/mos.rom orig/510/utils.rom
	$(_V)$(MAKE) _orig VERSION=510

$(BUILD)/511/all.orig: orig/511/mos.rom orig/511/utils.rom
	$(_V)$(MAKE) _orig VERSION=511

$(BUILD)/PC128S/all.orig: orig/PC128S/mos.rom orig/PC128S/utils.rom
	$(_V)$(MAKE) _orig VERSION=PC128S

_orig:
	$(_V)$(MKDIR) $(BUILD)/$(VERSION)
	$(_V)cat orig/$(VERSION)/utils.rom orig/$(VERSION)/mos.rom > $(BUILD)/$(VERSION)/all.orig

##########################################################################
##########################################################################
