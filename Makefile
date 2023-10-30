# -*- mode:makefile-gmake; -*-

ifeq ($(OS),Windows_NT)
PYTHON:=py -3
else
PYTHON:=/usr/bin/python
endif
SHELLCMD:=$(PYTHON) submodules/shellcmd.py/shellcmd.py
MKDIR:=$(SHELLCMD) mkdir
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
all:
	$(_V)$(SHELLCMD) mkdir $(BUILD)/320
	$(_V)$(TASS) mos320.s65 -L$(BUILD)/mos320.lst --output-section mos -o$(BUILD)/320/mos.rom --output-section terminal -o $(BUILD)/320/utils.rom --output-section ext -o $(BUILD)/320/ext.rom
	$(_V)$(MAKE) _check_identical VERSION=320 EXTRA=ext.rom

	$(_V)$(MAKE) _build VERSION=500
	$(_V)$(MAKE) _build VERSION=510
	$(_V)$(MAKE) _build VERSION=511
	$(_V)$(MAKE) _build VERSION=400
	$(_V)$(MAKE) _build VERSION=PC128S

.PHONY:_build
_build:
	$(_V)$(SHELLCMD) mkdir $(BUILD)/$(VERSION)
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom
	$(_V)$(MAKE) _check_identical VERSION=$(VERSION)

.PHONY:_check_identical
_check_identical:
	@$(PYTHON) bin/romdiffs.py -a orig/$(VERSION) -b $(BUILD)/$(VERSION) mos.rom utils.rom $(EXTRA)

.PHONY:_test
_test:
	@echo hello

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(_V)$(SHELLCMD) rm-tree $(BUILD)

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

