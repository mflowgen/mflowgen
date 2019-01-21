#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- dc-synthesis
#-------------------------------------------------------------------------
# This step runs synthesis using Synopsys DC

descriptions.dc-synthesis = "Synthesize RTL into gates"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.dc-synthesis
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                      _____  __  __  _   _  _______  _   _                     #'
	@echo '#                     / ____||  \/  || \ | ||__   __|| | | |                    #'
	@echo '#                    | (___   \    / |  \| |   | |   | |_| |                    #'
	@echo '#                     \___ \   |  |  | . ` |   | |   |  _  |                    #'
	@echo '#                     ____) |  |  |  | |\  |   | |   | | | |                    #'
	@echo '#                    |_____/   |__|  |_| \_|   |_|   |_| |_|                    #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.dc-synthesis = synth

#-------------------------------------------------------------------------
# Interface to designer_interface.tcl
#-------------------------------------------------------------------------
# The designer_interface.tcl file is the first script run by Design
# Compiler (see the top of dc.tcl). It is the interface that connects the
# dc-synthesis scripts with the ASIC design kit, the build system, and the
# plugin scripts.
#
# This section defines variables passed from the build system to DC. The
# variables are exported to the environment so that the tcl script can see
# them.

# Directories

export dc_flow_dir     = $(flow_dir.dc-synthesis)
export dc_plugins_dir  = $(plugins_dir.dc-synthesis)
export dc_logs_dir     = $(logs_dir.dc-synthesis)
export dc_reports_dir  = $(reports_dir.dc-synthesis)
export dc_results_dir  = $(results_dir.dc-synthesis)
export dc_collect_dir  = $(collect_dir.dc-synthesis)

# Verilog source (do not include test harness!)

export dc_rtl_handoff = $(design_v)

# Clock period

export dc_clock_period = $(clock_period)

# alib
#
# Design Compiler caches analyzed libraries to improve performance using
# ".alib" directories. The alib takes a while to generate but is reused on
# subsequent runs. It is useful to store a centralized copy of the alib to
# avoid re-generating the alib (usually only several minutes but can be
# annoying) on every new clone of the ASIC repo.
#
# However, if DC sees a .db that does not have an associated .alib it will
# try to automatically create one. This is not usually a problem when
# students just use standard cells, but if a student is trying to use
# SRAMs, then they will be using new .db files that DC has not seen yet.
# The problem is that students do not have write permissions to the
# centralized copy of the alib in the ADK.
#
# The solution we use is to create a local alib directory in the current
# build directory with _per-file_ symlinks to the centralized alib (and
# with the same directory hierarchy). This allows students to reuse the
# centralized copies of the alib files while allowing new alibs (e.g., for
# SRAMs) to be generated locally.
#
# This is possible because the alibs are stored in a directory that holds
# a ".db.alib" file for each db file:
#
# - alib
#   - alib-52
#     - iocells.db.alib
#     - stdcells.db.alib
#
# This new alib directory just needs to contain symlinks to each saved
# alib in the ADK. This can be done simply by using "cp -srf" of the ADK
# alib to the build directory, which generates symbolic links to each file
# instead of copying. This way, the student can access the master copy of
# the saved alibs in the ADK, and if there are any additional db's
# specified, their alibs will be saved in the local build directory.

export dc_alib_dir = $(results_dir.dc-synthesis)/alib

# SAIF variables

#ifeq ($(strip $(viname)),)
#  export viname = NONE
#endif

#--------------------------------------------------------------------
# Build variables
#--------------------------------------------------------------------

dc_exec = dc_shell-xg-t -64bit -topographical_mode
dc_tcl  = $(flow_dir.dc-synthesis)/dc.tcl

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.dc-synthesis

# Build directories

	rm -rf ./$(logs_dir.dc-synthesis)
	rm -rf ./$(reports_dir.dc-synthesis)
	rm -rf ./$(results_dir.dc-synthesis)

	mkdir -p $(logs_dir.dc-synthesis)
	mkdir -p $(reports_dir.dc-synthesis)
	mkdir -p $(results_dir.dc-synthesis)

# Prepare alib (helps dc performance)

	mkdir -p $(dc_alib_dir)
	cp -srf $(adk_dir)/alib/* $(dc_alib_dir) || true

# Run the synthesis script

	$(dc_exec) -f $(dc_tcl) \
             -output_log_file $(logs_dir.dc-synthesis)/dc.log

# Clean up

	mv command.log          $(logs_dir.dc-synthesis) || true
	mv lc_shell_command.log $(logs_dir.dc-synthesis) || true
	mv *_lib                $(logs_dir.dc-synthesis) || true

# Prepare handoffs

	mkdir -p $(handoff_dir.dc-synthesis)
	(cd $(handoff_dir.dc-synthesis) && \
    ln -sf ../../$(results_dir.dc-synthesis)/* .)

# Grep for failure messages

	@grep --color "^Error" $(logs_dir.dc-synthesis)/dc.log || true
	@grep --color -B 3 "*** Presto compilation terminated" \
    $(logs_dir.dc-synthesis)/dc.log || true
	@grep --color "unresolved references." \
    $(logs_dir.dc-synthesis)/dc.log || true

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-dc-synthesis:
	rm -rf ./$(VPATH)/dc-synthesis
	rm -rf ./$(logs_dir.dc-synthesis)
	rm -rf ./$(reports_dir.dc-synthesis)
	rm -rf ./$(results_dir.dc-synthesis)
	rm -rf ./$(collect_dir.dc-synthesis)
	rm -rf ./$(handoff_dir.dc-synthesis)

clean-synth: clean-dc-synthesis

# Debug
# FIXME: design_name is pulled from Makefrag... it would be nice not to be
# pulling variables from everywhere. Maybe have a single array of vars so
# we know what is going to be used everywhere...

debug-dc-synthesis:
	export DC_EXIT_AFTER_SETUP=1 && \
    design_vision-xg -topographical -x \
      "source $(flow_dir.dc-synthesis)/dc.tcl; \
       read_ddc $(results_dir.dc-synthesis)/$(design_name).mapped.ddc"


debug-synth: debug-dc-synthesis

debug-dc-synthesis-elaborated:
	export DC_EXIT_AFTER_SETUP=1 && \
    design_vision-xg -topographical -x \
      "source $(flow_dir.dc-synthesis)/dc.tcl; \
       read_ddc $(results_dir.dc-synthesis)/$(design_name).elab.ddc"

debug-synth-elaborated: debug-dc-synthesis-elaborated

debug-synth-shell:
	$(dc_exec) -output_log_file $(logs_dir.dc-synthesis)/interactive.log


