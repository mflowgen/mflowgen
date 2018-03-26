#=======================================================================
# UCB VLSI FLOW: Makefile for dc-syn & fm-ver
#-----------------------------------------------------------------------
# Yunsup Lee (yunsup@cs.berkeley.edu)
#
# This makefile will use Synopsys Design Compiler to synthesize
# your RTL into a gate-level verilog netlist.
# This makefile will use Synopsys Formality to verify
# generated gate-level verilog netlist against your RTL implementation.
#

# UCB_VLSI_HOME = /research/brg/install/bare-pkgs/noarch
# UCB_STDCELLS = synopsys-90nm/toolflow

include Makefrag

# Derating the clock period for DC
#
# We push timing in DC to provide ICC with a better timing-optimized
# netlist to start out with. To do this, we derate the clock for DC, while
# ICC still works with the clock target defined in the Makefrag.
#
# Use the calculator `bc` to derate the clock:
#
# - "scale" is a bc parameter that determines the total number of decimal
#   digits after the decimal point

dc_clock_period = 0$(shell echo "scale=4; ${clock_period}*0.9" | bc)
#dc_clock_period = $(clock_period)

default: all

#--------------------------------------------------------------------
# Sources
#--------------------------------------------------------------------

basedir  = ../..

sim_search_dir = ../$(basedir)/$(sim_build_dir)

# Verilog sources (do not include test harness!)

vsrcs = $(basedir)/$(sim_build_dir)/$(vsrc)

# VCD

ifeq ($(strip $(vcd)),)
  vcdsrc = NONE
else
  vcdsrc = $(basedir)/$(sim_build_dir)/$(vcd)
endif

# viname

ifeq ($(strip $(viname)),)
  viname = NONE
endif

# Specify toplevel verilog module

toplevel = $(vmname)

# CACTI SRAMs

sram_dbs      = $(patsubst %, %.db, $(srams))
sram_mws      = $(patsubst %, %.mw, $(srams))
sram_mws_wdir = $(addprefix ../../cacti-mc/, $(sram_mws))

# The ALIB directory is where DC caches analyzed libraries (.alib files).
# Normally, we use: $(cells_dir)/alib
#
# If DC sees a .db that does not have an associated .alib it will
# automatically create one, but the problem is students do not have write
# permission to the above directory. This is not usually a problem when
# students just use standard cells, but if a student is trying to use
# SRAMs, then they will be using new .db files that DC has not seen yet.
# The only problem is, that analyzing the standard cell library does take
# a little while (minute or two) which is annoying on every build.
#
# So the current solution is if there are no SRAMs then we just use the
# above global ALIB directory. If there are SRAMs we use an ALIB
# directory that is in parallel with the build directories so we can at
# least amortize the analyze time across builds.

ifeq ($(strip $(srams)),)
  alib_dir=$(adk_dir)/alib
else
  alib_dir=../alib
endif

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

dc_exec         := dc_shell-xg-t -64bit -topographical_mode
fm_exec         := fm_shell -64bit
build_suffix    := $(shell date +%Y-%m%d-%H%M-%S)
build_dc_dir    := build-dc-$(build_suffix)
cur_build_dc_dir:= current-dc
reports_dir     := reports
results_dir     := results
log_dir         := log

dc_timestamp    := $(cur_build_dc_dir)/timestamp
dc_ddc          := $(cur_build_dc_dir)/$(results_dir)/$(toplevel).mapped.ddc
fm_rpt          := $(cur_build_dc_dir)/$(reports_dir)/$(toplevel).fmv_verify.rpt

vars_tcl        := rm_setup/common_setup.tcl rm_setup/dc_setup.tcl rm_setup/dc_setup_filenames.tcl
makegen_tcl     := make_generated_vars.tcl

dc_tcl          := rm_dc_scripts/dc.tcl
dc_misc_tcl     := rm_dc_scripts/find_regs.tcl
fm_tcl          := rm_dc_scripts/fm.tcl
constraints_tcl := $(basedir)/$(sim_build_dir)/constraints.tcl

#TODO: add clock gated cells?
#set TARGET_LIBRARY_FILES        "cells.db cells_cg.db";\n \

vars = \
	set VINAME                      "$(viname)";\n \
	set DESIGN_NAME                 "$(toplevel)";\n \
	set STRIP_PATH                  "$(toplevel)";\n \
	set ADDITIONAL_SEARCH_PATH      "$(adk_dir) $(sim_search_dir) ../../cacti-mc";\n \
	set TARGET_LIBRARY_FILES        "stdcells.db iocells.db $(sram_dbs)";\n \
	set MW_REFERENCE_LIB_DIRS       "$(adk_dir)/stdcells.mwlib $(sram_mws_wdir)";\n \
	set TECH_FILE                   "$(adk_dir)/rtk-tech.tf";\n \
	set MAP_FILE                    "$(adk_dir)/rtk-tluplus.map";\n \
	set TLUPLUS_MAX_FILE            "$(adk_dir)/rtk-max.tluplus";\n \
	set TLUPLUS_MIN_FILE            "$(adk_dir)/rtk-min.tluplus";\n \
	set ALIB_DIR                    "$(alib_dir)";\n \
	set RTL_SOURCE_FILES            "$(notdir $(vsrcs))";\n \
	set DCRM_CONSTRAINTS_INPUT_FILE "constraints.tcl";\n \
	set REPORTS_DIR                 "$(reports_dir)";\n \
	set RESULTS_DIR                 "$(results_dir)";\n \
	set CLOCK_PERIOD                "$(dc_clock_period)";\n \
	set CELLS_TCL                   "$(adk_dir)/stdcells.tcl";\n \

define new-build-dir-cmds
	mkdir $(build_dc_dir)
	rm -f $(cur_build_dc_dir)
	ln -s $(build_dc_dir) $(cur_build_dc_dir)
	cp $(dc_tcl) $(dc_misc_tcl) $(constraints_tcl) $(vars_tcl) $(cur_build_dc_dir)
	echo -e '$(vars)' > $(cur_build_dc_dir)/$(makegen_tcl)
	date > $(dc_timestamp)
endef

new-build-dir:
	$(new-build-dir-cmds)

$(dc_timestamp): Makefile Makefrag $(vsrcs) $(vars_tcl) $(constraints_tcl) $(dc_tcl) $(dc_misc_tcl)
	$(new-build-dir-cmds)

$(dc_ddc): $(dc_timestamp)
	if [[ "$(vcdsrc)" != "NONE" ]]; then \
    vcd2saif -64 -input $(vcdsrc) -output current-dc/rtl-sim.saif; \
  fi
	cd $(cur_build_dc_dir); \
	cp ../Makefrag .; \
	mkdir -p $(log_dir); \
	$(dc_exec) -f $(notdir $(dc_tcl)) | tee $(log_dir)/dc.log; \
	cd ..; \
	mkdir handoff; \
	cd handoff; \
	ln -s ../$(cur_build_dc_dir)/results/* .; \
	cd ..

#	sdfcorrect.py results/$(toplevel).mapped.sdf results/$(toplevel).mapped.corrected.sdf \

dc: $(dc_ddc)

$(fm_rpt): $(dc_ddc) $(fm_tcl)
	cp $(fm_tcl) $(constraints_tcl) $(vars_tcl) $(cur_build_dc_dir)
	echo -e '$(vars)' > $(cur_build_dc_dir)/$(makegen_tcl)
	cd $(cur_build_dc_dir); \
	mkdir -p $(log_dir); \
	$(fm_exec) -f $(notdir $(fm_tcl)) | tee $(log_dir)/fm.log; \
	cd ..

fm: $(fm_rpt)

#--------------------------------------------------------------------
# Default make target
#--------------------------------------------------------------------

.PHONY: dc fm

all: dc

#--------------------------------------------------------------------
# Clean up
#--------------------------------------------------------------------

junk +=

clean:
	rm -rf handoff* build* current* $(junk) *~ \#* alib

