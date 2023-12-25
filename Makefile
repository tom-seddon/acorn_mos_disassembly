# -*- mode:makefile-gmake; -*-

ifeq ($(OS),Windows_NT)
PYTHON:=py -3
TASSCMD:=bin\64tass.exe
else
PYTHON:=/usr/bin/python3
TASSCMD:=64tass
endif

##########################################################################
##########################################################################

ifeq ($(VERBOSE),1)
_V:=
_TASSQ:=
else
_V:=@
_TASSQ:=-q
endif

ifeq ($(MUST_MATCH),1)
_ROM_DIFF_MUST_MATCH:=--must-match
else
_ROM_DIFF_MUST_MATCH:=
endif

##########################################################################
##########################################################################

SHELLCMD:=$(PYTHON) submodules/shellcmd.py/shellcmd.py
MKDIR:=$(SHELLCMD) mkdir
TASS:=$(TASSCMD) --m65c02 --nostart -Wall $(_TASSQ) --case-sensitive --line-numbers --verbose-list
BUILD:=build
DIST:=dist

##########################################################################
##########################################################################

.PHONY:all
all:
	$(_V)$(MAKE) _build_orig_with_ext VERSION=320
	$(_V)$(MAKE) _build_orig VERSION=500
	$(_V)$(MAKE) _build_orig VERSION=510
	$(_V)$(MAKE) _build_orig VERSION=511
	$(_V)$(MAKE) _build_orig VERSION=400
	$(_V)$(MAKE) _build_orig VERSION=PC128S
	$(_V)$(MAKE) _build_orig_with_ext VERSION=350
	$(_V)$(MAKE) _build_orig_with_ext VERSION=CFA3000
	$(_V)$(MAKE) _build_orig VERSION=autocue
	$(_V)$(MAKE) _build_orig_with_ext VERSION=329

# New versions.
	$(_V)$(MAKE) _build VERSION=320nt
	$(_V)$(MAKE) _build VERSION=350nt

##########################################################################
##########################################################################

.PHONY:_build_orig_with_ext
_build_orig_with_ext:
	$(_V)$(MAKE) _build_with_ext VERSION=$(VERSION)
	$(_V)$(MAKE) _check_identical VERSION=$(VERSION) EXTRA=ext.rom

.PHONY:_build_with_ext
_build_with_ext:
	$(_V)$(SHELLCMD) mkdir $(BUILD)/$(VERSION)
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom --output-section ext -o $(BUILD)/$(VERSION)/ext.rom

##########################################################################
##########################################################################

.PHONY:_build_orig
_build_orig:
	$(_V)$(MAKE) _build VERSION=$(VERSION)
	$(_V)$(MAKE) _check_identical VERSION=$(VERSION)

.PHONY:_build
_build:
	$(_V)$(SHELLCMD) mkdir $(BUILD)/$(VERSION)
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom

##########################################################################
##########################################################################

.PHONY:_check_identical
_check_identical:
	@$(PYTHON) bin/romdiffs.py $(_ROM_DIFF_MUST_MATCH) -a orig/$(VERSION) -b $(BUILD)/$(VERSION) mos.rom utils.rom $(EXTRA)

##########################################################################
##########################################################################

.PHONY:clean
clean:
	$(_V)$(SHELLCMD) rm-tree $(BUILD)

##########################################################################
##########################################################################

.PHONY:dist
dist:
	$(_V)$(MAKE) clean
	$(_V)$(MAKE) all MUST_MATCH=1
	$(_V)$(SHELLCMD) mkdir $(DIST)
# If shellcmd.py copy-file handled wildcards, this would be a bit
# simpler.
	$(_V)$(MAKE) _dist_copy VERSION=320
	$(_V)$(MAKE) _dist_copy VERSION=500
	$(_V)$(MAKE) _dist_copy VERSION=510
	$(_V)$(MAKE) _dist_copy VERSION=511
	$(_V)$(MAKE) _dist_copy VERSION=400
	$(_V)$(MAKE) _dist_copy VERSION=PC128S
	$(_V)$(MAKE) _dist_copy VERSION=350
	$(_V)$(MAKE) _dist_copy VERSION=CFA3000
	$(_V)$(MAKE) _dist_copy VERSION=autocue
	$(_V)$(MAKE) _dist_copy VERSION=329

.PHONY:_dist_copy
_dist_copy:
	$(_V)$(SHELLCMD) copy-file $(BUILD)/mos$(VERSION).lst $(DIST)/

##########################################################################
##########################################################################

ifeq ($(OS),Windows_NT)
UNAME:=$(OS)
else
UNAME:=$(shell uname -s)
endif

.PHONY:tom_laptop
ifeq ($(UNAME),Darwin)
tom_laptop: ECTAGS:=exuberant-ctags
else
tom_laptop: ECTAGS:=ctags
endif
tom_laptop: all
	$(ECTAGS) '--exclude=.#*' --langdef=64tass --langmap=64tass:.s65 '--regex-64tass=/^([A-Za-z_][A-Za-z0-9_]*):/\1/l.label/' -e *.s65 src/*.s65

# /opt/local/bin/ctags --exclude='.#*' --langdef=beebasm --langmap=beebasm:.6502.asm '--regex-beebasm=/^\.(\^|\*)?([A-Za-z0-9_]+)/\2/l,label/' '--regex-beebasm=/^[ \t]*macro[ \t]+([A-Za-z0-9_]+)/\1/m,macro/i' '--regex-beebasm=/^[ \t]*([A-Za-z0-9_]+)[ \t]*=[^=]/\1/v,value/' -eR src lib stnicc-beeb.asm
