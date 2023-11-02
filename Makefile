# -*- mode:makefile-gmake; -*-

ifeq ($(OS),Windows_NT)
PYTHON:=py -3
TASSCMD:=bin\64tass.exe
else
PYTHON:=/usr/bin/python3
TASSCMD:=64tass
endif
SHELLCMD:=$(PYTHON) submodules/shellcmd.py/shellcmd.py
MKDIR:=$(SHELLCMD) mkdir
TASS:=$(TASSCMD) --m65c02 --nostart -Wall -q --case-sensitive --line-numbers --verbose-list
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
	$(_V)$(MAKE) _build_with_ext VERSION=320
	$(_V)$(MAKE) _build VERSION=500
	$(_V)$(MAKE) _build VERSION=510
	$(_V)$(MAKE) _build VERSION=511
	$(_V)$(MAKE) _build VERSION=400
	$(_V)$(MAKE) _build VERSION=PC128S
	$(_V)$(MAKE) _build_with_ext VERSION=350

.PHONY:_build_with_ext
_build_with_ext:
	$(_V)$(SHELLCMD) mkdir $(BUILD)/$(VERSION)
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom --output-section ext -o $(BUILD)/$(VERSION)/ext.rom
	$(_V)$(MAKE) _check_identical VERSION=$(VERSION) EXTRA=ext.rom

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
