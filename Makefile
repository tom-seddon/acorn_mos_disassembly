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
_VERBOSE_OPTION:=--verbose
else
_V:=@
_TASSQ:=-q
_VERBOSE_OPTION:=
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
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).full.lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom --output-section ext -o $(BUILD)/$(VERSION)/ext.rom
	$(_V)$(PYTHON) "bin/improve_lst.py" -o "$(BUILD)/mos$(VERSION).lst" "$(BUILD)/mos$(VERSION).full.lst"

##########################################################################
##########################################################################

.PHONY:_build_orig
_build_orig:
	$(_V)$(MAKE) _build VERSION=$(VERSION)
	$(_V)$(MAKE) _check_identical VERSION=$(VERSION)

.PHONY:_build
_build:
	$(_V)$(SHELLCMD) mkdir $(BUILD)/$(VERSION)
	$(_V)$(TASS) mos$(VERSION).s65 -L$(BUILD)/mos$(VERSION).full.lst --output-section mos -o $(BUILD)/$(VERSION)/mos.rom --output-section utils -o $(BUILD)/$(VERSION)/utils.rom
	$(_V)$(PYTHON) "bin/improve_lst.py" -o "$(BUILD)/mos$(VERSION).lst" "$(BUILD)/mos$(VERSION).full.lst"

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
	$(SHELLCMD) copy-file "build/basic.4r32.relocation.dat" "build/350nt"
	$(SHELLCMD) copy-file "build/edit.1.50r.relocation.dat" "build/350nt"
	cd build && zip -9r "../$(CI_NT_ARCHIVE)" 320nt 350nt
	zip -9j "$(CI_NT_ARCHIVE)" "docs/README.txt" "build/mos320nt.lst" "build/mos350nt.lst"

##########################################################################
##########################################################################

# Example setup, creating a 1 Mbit image that you might actually want
# to use, and creating a 512 KByte multi-OS image.

.PHONY:tom_example
tom_example: _DEST:=$(BUILD)/tom_example
tom_example: _BASIC_EDITOR:=../basic_editor/
tom_example: _EXMON2:=../exmon2_disassembly/
tom_example:
# Build prerequisites.
	$(_V)$(MAKE) all
	$(_V)cd "$(_BASIC_EDITOR)" && $(MAKE)
	$(_V)cd "$(_EXMON2)" && $(MAKE)

# Add relevant Tube relocation stuff to DFS ROM.
	$(_V)$(SHELLCMD) mkdir "$(_DEST)"
	$(_V)$(SHELLCMD) copy-file "orig/350/dfs.2.45.rom" "$(_DEST)/"
	$(_V)$(SHELLCMD) copy-file "orig/350/basic.4r32.rom" "$(_DEST)/"
	$(_V)$(SHELLCMD) copy-file "orig/350/edit.1.50r.rom" "$(_DEST)/"
	$(_V)$(SHELLCMD) copy-file "$(_BASIC_EDITOR)/.build/rbasiced.rom" "$(_DEST)/"
	$(_V)$(PYTHON) submodules/beeb/bin/tube_relocation.py $(_VERBOSE_OPTION) set-multi --bitmap-rom "$(_DEST)/dfs.2.45.rom" 14 --begin 0xaf00 --end 0xb800 --rom "$(_DEST)/basic.4r32.rom" "$(BUILD)/basic.4r32.relocation.dat" --rom "$(_DEST)/edit.1.50r.rom" "$(BUILD)/edit.1.50r.relocation.dat" --rom "$(_DEST)/rbasiced.rom" "$(_BASIC_EDITOR)/.build/rbasiced.relocation.dat" --set-multi

# Concatenate all files to form 128 KByte image.
	$(_V)$(SHELLCMD) concat --pad 16384 -o "$(_DEST)/megarom.bin" "$(BUILD)/350r/mos.rom" "$(_EXMON2)/.build/exmon2.rom" "orig/350/adfs.2.03.rom" "$(_DEST)/edit.1.50r.rom" "$(_DEST)/basic.4r32.rom" "$(_DEST)/rbasiced.rom" "$(_DEST)/dfs.2.45.rom" "$(BUILD)/350r/utils.rom"
	$(_V)$(SHELLCMD) stat "$(_DEST)/megarom.bin"

# Split apart into 8 x 16 KB ROM images for testing in b2. Split
# generates generic output names, so they'll need renaming.
	$(_V)$(SHELLCMD) split -b 16384 "$(_DEST)/megarom.bin" "$(_DEST)/rom"
	$(_V)$(SHELLCMD) rm-file -f "$(_DEST)/mos.rom" "$(_DEST)/9.rom" "$(_DEST)/a.rom" "$(_DEST)/b.rom" "$(_DEST)/c.rom" "$(_DEST)/d.rom" "$(_DEST)/e.rom" "$(_DEST)/f.rom" 
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom0" "$(_DEST)/mos.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom1" "$(_DEST)/9.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom2" "$(_DEST)/a.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom3" "$(_DEST)/b.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom4" "$(_DEST)/c.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom5" "$(_DEST)/d.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom6" "$(_DEST)/e.rom"
	$(_V)$(SHELLCMD) rename "$(_DEST)/rom7" "$(_DEST)/f.rom"

# Form 512 KByte multi-OS ROM image.
	$(_V)$(SHELLCMD) split -b 131072 "orig/multios/multios.bin" "$(_DEST)/multios"
	$(_V)$(SHELLCMD) concat -o "$(_DEST)/multios.bin" "$(_DEST)/multios0" "$(_DEST)/megarom.bin" "$(_DEST)/multios2" "$(_DEST)/multios3"

##########################################################################
##########################################################################

# Build prebuilt ROM images. Very similar to tom_example.
.PHONY:prebuilt_versions
prebuilt_versions: export _DEST:=$(BUILD)
prebuilt_versions:
	$(_V)$(MAKE) all
	$(_V)$(MAKE) _prebuilt_320r 
	$(_V)$(MAKE) _prebuilt_350r
	$(_V)$(MAKE) _prebuilt_510r

.PHONY:_prebuilt_320r
_prebuilt_320r: export _DEST:=$(_DEST)/320r
_prebuilt_320r:
# MOS 3.20r
	$(_V)$(SHELLCMD) mkdir "$(_DEST)/roms"
	$(_V)$(SHELLCMD) copy-file "$(BUILD)/320r/mos.rom" "$(_DEST)/roms/mos.rom"
	$(_V)$(SHELLCMD) copy-file "$(BUILD)/320r/utils.rom" "$(_DEST)/roms/15.utils.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/blank.rom" "$(_DEST)/roms/14.blank.rom"
	$(_V)$(SHELLCMD) copy-file "orig/320/adfs.1.50.rom" "$(_DEST)/roms/13.adfs.1.50.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/Acorn ADFS 153 (IDE).rom" "$(_DEST)/roms/13.adfs.1.53.ide.rom"
	$(_V)$(SHELLCMD) copy-file "orig/320/basic.4.rom" "$(_DEST)/roms/12.basic.4.rom"
	$(_V)$(SHELLCMD) copy-file "orig/320/edit.1.00.rom" "$(_DEST)/roms/11.edit.1.00.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/basiced.1.46.rom" "$(_DEST)/roms/10.basiced.1.4.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/dfs.2.29.rom" "$(_DEST)/roms/09.dfs.2.29.rom"
	$(_V)$(MAKE) _prebuilt_320r_2 ADFS="$(_DEST)/roms/13.adfs.1.50.rom" SUFFIX=
	$(_V)$(MAKE) _prebuilt_320r_2 ADFS="$(_DEST)/roms/13.adfs.1.53.ide.rom" SUFFIX=_ide

.PHONY:_prebuilt_320r_2
_prebuilt_320r_2:
	$(_V)$(SHELLCMD) concat --pad 16384 -o "$(_DEST)/320r$(SUFFIX).bin" "$(_DEST)/roms/mos.rom" "$(_DEST)/roms/09.dfs.2.29.rom" "$(_DEST)/roms/10.basiced.1.4.rom" "$(_DEST)/roms/11.edit.1.00.rom" "$(_DEST)/roms/12.basic.4.rom" "$(ADFS)" "$(_DEST)/roms/14.blank.rom" "$(_DEST)/roms/15.utils.rom"

.PHONY:_prebuilt_350r
_prebuilt_350r: export _DEST:=$(_DEST)/350r
_prebuilt_350r: _BE_ROM:=orig/other/rbasiced.1.46.rom
_prebuilt_350r: _BE_REL:=orig/other/rbasiced.1.46.relocation.dat
# _prebuilt_350r: _BE_ROM:=../basic_editor/.build/rbasiced.rom
# _prebuilt_350r: _BE_REL:=../basic_editor/.build/rbasiced.relocation.dat
_prebuilt_350r:
# MOS 3.50r
	$(_V)$(SHELLCMD) mkdir "$(_DEST)/roms"
	$(_V)$(SHELLCMD) copy-file "$(BUILD)/350r/mos.rom" "$(_DEST)/roms/mos.rom"
	$(_V)$(SHELLCMD) copy-file "$(BUILD)/350r/utils.rom" "$(_DEST)/roms/15.utils.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/blank.rom" "$(_DEST)/roms/14.blank.rom"
	$(_V)$(SHELLCMD) copy-file "orig/350/adfs.2.03.rom" "$(_DEST)/roms/13.adfs.2.03.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/Acorn ADFS 205 (IDE).rom" "$(_DEST)/roms/13.adfs.2.05.ide.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/basic.4r33.rom" "$(_DEST)/roms/12.basic.4r33.rom"
	$(_V)$(SHELLCMD) copy-file "orig/350/edit.1.50r.rom" "$(_DEST)/roms/11.edit.1.50r.rom"
	$(_V)$(SHELLCMD) copy-file "$(_BE_ROM)" "$(_DEST)/roms/10.rbasiced.1.46.rom"
	$(_V)$(SHELLCMD) copy-file "orig/other/dfs.2.45.no_mos.rom" "$(_DEST)/roms/09.dfs.2.45.rom"
	$(_V)$(PYTHON) "submodules/beeb/bin/tube_relocation.py" $(_VERBOSE_OPTION) set-multi --bitmap-rom "$(_DEST)/roms/09.dfs.2.45.rom" 9 --begin 0xaf00 --end 0xb800 --rom "$(_DEST)/roms/12.basic.4r33.rom" "$(BUILD)/basic.4r32.relocation.dat" --rom "$(_DEST)/roms/11.edit.1.50r.rom" "$(BUILD)/edit.1.50r.relocation.dat" --rom "$(_DEST)/roms/10.rbasiced.1.46.rom" "$(_BE_REL)" --set-multi
	$(_V)$(MAKE) _prebuilt_350r_2 ADFS="$(_DEST)/roms/13.adfs.2.03.rom" SUFFIX=
	$(_V)$(MAKE) _prebuilt_350r_2 ADFS="$(_DEST)/roms/13.adfs.2.05.ide.rom" SUFFIX=_ide

.PHONY:_prebuilt_350r_2
_prebuilt_350r_2:
	$(_V)$(SHELLCMD) concat --pad 16384 -o "$(_DEST)/350r$(SUFFIX).bin" "$(_DEST)/roms/mos.rom" "$(_DEST)/roms/09.dfs.2.45.rom" "$(_DEST)/roms/10.rbasiced.1.46.rom" "$(_DEST)/roms/11.edit.1.50r.rom" "$(_DEST)/roms/12.basic.4r33.rom" "$(ADFS)" "$(_DEST)/roms/14.blank.rom" "$(_DEST)/roms/15.utils.rom"

.PHONY:_prebuilt_510r
_prebuilt_510r: _DEST:=$(_DEST)/510r
_prebuilt_510r:
# MOS 5.10r
	$(_V)$(SHELLCMD) mkdir "$(_DEST)/roms"
	$(_V)$(SHELLCMD) copy-file "$(BUILD)/510r/mos.rom" "$(_DEST)/roms/mos.rom"
	$(_V)$(SHELLCMD) copy-file "$(BUILD)/510r/utils.rom" "$(_DEST)/roms/15.utils.rom"
	$(_V)$(SHELLCMD) copy-file "orig/510/basic.4.rom" "$(_DEST)/roms/14.basic.4.rom"
	$(_V)$(SHELLCMD) copy-file "orig/510/adfs.2.10.rom" "$(_DEST)/roms/13.adfs.2.10.rom"

	$(_V)$(SHELLCMD) concat --pad 16384 -o "$(_DEST)/510r.bin" "$(_DEST)/roms/mos.rom" "$(_DEST)/roms/13.adfs.2.10.rom" "$(_DEST)/roms/14.basic.4.rom" "$(_DEST)/roms/15.utils.rom"

##########################################################################
##########################################################################
#
# Test stuff, for me on my laptop.
#

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
	$(MAKE) tom_reset
#	$(MAKE) tom_wrchspd

# /opt/local/bin/ctags --exclude='.#*' --langdef=beebasm --langmap=beebasm:.6502.asm '--regex-beebasm=/^\.(\^|\*)?([A-Za-z0-9_]+)/\2/l,label/' '--regex-beebasm=/^[ \t]*macro[ \t]+([A-Za-z0-9_]+)/\1/m,macro/i' '--regex-beebasm=/^[ \t]*([A-Za-z0-9_]+)[ \t]*=[^=]/\1/v,value/' -eR src lib stnicc-beeb.asm

.PHONY:tom_reset
tom_reset: _CURL:=curl --no-progress-meter
tom_reset:
	$(_CURL) -G "http://localhost:48075/reset/b2" --data-urlencode "config=Master 128 (MOS 3.50 refreshed)"

.PHONY:tom_tube_transfer
tom_tube_transfer: _CURL:=curl --no-progress-meter
tom_tube_transfer:
	$(SHELLCMD) copy-file tools/language_relocate_speed.txt build/language_relocate_speed.dat
	$(PYTHON) submodules/beeb/bin/text2bbc.py build/language_relocate_speed.dat
	$(_CURL) -G "http://localhost:48075/reset/b2" --data-urlencode "config=Master 128 (MOS 3.50 refreshed)"
	$(_CURL) "http://localhost:48075/paste/b2" -H "Content-Type:text/plain" -H "Content-Encoding:utf-8" --upload-file build/language_relocate_speed.dat

.PHONY:tom_wrchspd
tom_wrchspd: _CURL:=curl --no-progress-meter
tom_wrchspd: _SSD:=build/wrchspd.ssd
tom_wrchspd:
	$(PYTHON) "submodules/beeb/bin/ssd_create.py" -o "$(_SSD)" -b "*BASIC" -b "CHAIN\"WRCHSPD\"" "beeb/acorn_mos_disassembly/0/$$.WRCHSPD"
	$(_CURL) --connect-timeout 0.25 -G "http://localhost:48075/reset/b2" --data-urlencode "config=Master 128 (MOS 3.50 refreshed)"
	$(_CURL) -H "Content-Type:application/binary" --upload-file "$(_SSD)" "http://localhost:48075/run/b2?name=$(_SSD)"
