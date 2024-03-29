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
BBIN:=submodules/beeb/bin
MKDIR:=$(SHELLCMD) mkdir
TASS:="$(TASSCMD)" --m65c02 --nostart -Wall $(_TASSQ) --case-sensitive --line-numbers --verbose-list
BUILD:=build
DIST:=dist
TUBE_RELOCATION_PY:=$(BBIN)/tube_relocation.py

##########################################################################
##########################################################################

OTHER_350_ROMS_REL_NONE:=$(BUILD)/other_350_roms.rel_none
OTHER_350_ROMS_REL_DFS:=$(BUILD)/other_350_roms.rel_dfs

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
	$(_V)$(MAKE) _build VERSION=320r
	$(_V)$(MAKE) _build VERSION=350r
	$(_V)$(MAKE) _build VERSION=510r
	$(_V)$(TASS) src/refresh_version.s65 -o $(BUILD)/refresh_version.dat

# Produce non-relocating ROMs for the updated 3.50 builds.
	$(_V)$(MAKE) _updated_350_roms

# Free space for the refreshed builds
	$(_V)$(PYTHON) "bin/unused.py" "build/mos320r.lst"
	$(_V)$(PYTHON) "bin/unused.py" "build/mos350r.lst"
	$(_V)$(PYTHON) "bin/unused.py" "build/mos510r.lst"

##########################################################################
##########################################################################

.PHONY:_updated_350_roms
_updated_350_roms:
	$(_V)$(SHELLCMD) mkdir "$(OTHER_350_ROMS_REL_NONE)"
	$(_V)$(SHELLCMD) mkdir "$(OTHER_350_ROMS_REL_DFS)"

# Create non-relocating BASIC and EDIT ROMs.
	$(_V)$(PYTHON) "$(TUBE_RELOCATION_PY)" unset -o "$(OTHER_350_ROMS_REL_NONE)/basic.4r32.rom" "orig/350/basic.4r32.rom"
	$(_V)$(PYTHON) "$(TUBE_RELOCATION_PY)" unset -o "$(OTHER_350_ROMS_REL_NONE)/edit.1.50r.rom" "orig/350/edit.1.50r.rom"

# Extract BASIC and EDIT relocation bitmaps.
	$(_V)$(PYTHON) "$(TUBE_RELOCATION_PY)" extract -o "build/basic.4r32.relocation.dat" "orig/350/basic.4r32.rom" "orig/350/view.rom"
	$(_V)$(PYTHON) "$(TUBE_RELOCATION_PY)" extract -o "build/edit.1.50r.relocation.dat" "orig/350/edit.1.50r.rom" "orig/350/view.rom"

# Generate some new ROMs with the relocation bitmaps in the DFS ROM.
	$(_V)$(SHELLCMD) copy-file "orig/350/dfs.2.45.rom" "$(OTHER_350_ROMS_REL_DFS)/dfs.2.45.rom"
	$(_V)$(PYTHON) "$(TUBE_RELOCATION_PY)" set -o "$(OTHER_350_ROMS_REL_DFS)/basic.4r32.rom" "$(OTHER_350_ROMS_REL_DFS)/dfs.2.45.rom" --absolute-bank --bitmap-address 0xaf00 "orig/350/basic.4r32.rom" "build/basic.4r32.relocation.dat" 9
	$(_V)$(PYTHON) "$(TUBE_RELOCATION_PY)" set -o "$(OTHER_350_ROMS_REL_DFS)/edit.1.50r.rom" "$(OTHER_350_ROMS_REL_DFS)/dfs.2.45.rom" --absolute-bank --bitmap-address 0xb162 "orig/350/edit.1.50r.rom" "build/edit.1.50r.relocation.dat" 9

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

# this only needs to be portable to POSIX-type systems, so
# Windows-friendliness is a bit half-arsed. It does work on my laptop.
.PHONY:ci
ci: CI_LST_ARCHIVE?=$(error must set CI_LST_ARCHIVE)
ci: CI_NT_ARCHIVE?=$(error must set CI_NT_ARCHIVE)
ci:
	$(MAKE) clean
	$(MAKE) VERBOSE=1 MUST_MATCH=1 "TASSCMD=$(TASSCMD)"

# Orginal versions
	zip -9j "$(CI_LST_ARCHIVE)" "docs/README.txt" "build/mos320.lst" "build/mos500.lst" "build/mos510.lst" "build/mos511.lst" "build/mos400.lst" "build/mosPC128S.lst" "build/mos350.lst" "build/mosCFA3000.lst" "build/mosautocue.lst" "build/mos329.lst"

# NT versions
	$(SHELLCMD) move "$(OTHER_350_ROMS_REL_NONE)" "build/350nt"
	$(SHELLCMD) move "$(OTHER_350_ROMS_REL_DFS)" "build/350nt"
	cd build && zip -9r "../$(CI_NT_ARCHIVE)" 320nt 350nt
	zip -9j "$(CI_NT_ARCHIVE)" "docs/README.txt" "build/mos320nt.lst" "build/mos350nt.lst"

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
tom_laptop:
	$(ECTAGS) '--exclude=.#*' --langdef=64tass --langmap=64tass:.s65 '--regex-64tass=/^([A-Za-z_][A-Za-z0-9_]*):/\1/l,label/' '--regex-64tass=/^([A-Za-z_][A-Za-z0-9_]*)=/\1/k,const/' -e *.s65 src/*.s65
	$(PYTHON) bin/check7bit.py '*.s65'
	$(MAKE) all

# /opt/local/bin/ctags --exclude='.#*' --langdef=beebasm --langmap=beebasm:.6502.asm '--regex-beebasm=/^\.(\^|\*)?([A-Za-z0-9_]+)/\2/l,label/' '--regex-beebasm=/^[ \t]*macro[ \t]+([A-Za-z0-9_]+)/\1/m,macro/i' '--regex-beebasm=/^[ \t]*([A-Za-z0-9_]+)[ \t]*=[^=]/\1/v,value/' -eR src lib stnicc-beeb.asm
