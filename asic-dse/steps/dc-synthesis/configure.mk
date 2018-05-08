#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

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
# dc-synthesis scripts with the build system, the plugin scripts, and the
# ASIC design kit.
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

export dc_rtl_handoff = $(relative_base_dir)/$(design_v)

# Clock period

export dc_clock_period = $(clock_period)

# SAIF variables

#ifeq ($(strip $(viname)),)
#  export viname = NONE
#endif

#--------------------------------------------------------------------
# Build rules
#--------------------------------------------------------------------

dc_exec = dc_shell-xg-t -64bit -topographical_mode
dc_tcl  = $(flow_dir.dc-synthesis)/rm_dc_scripts/dc.tcl

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.dc-synthesis

# Build directories

	rm -rf ./$(logs_dir.dc-synthesis)
	mkdir -p $(logs_dir.dc-synthesis)

# Prepare alib (helps dc performance)
# Make a shadow directory that links alibs from the ADK

	mkdir -p alib
	cp -srf $(adk_dir)/alib/* alib/ || true

# Run the synthesis script

	$(dc_exec) -f $(dc_tcl) \
             -output_log_file $(logs_dir.dc-synthesis)/dc.log

# Clean up

	mv command.log             $(logs_dir.dc-synthesis)
	mv lc_shell_command.log    $(logs_dir.dc-synthesis)
	mv *_LIB                   $(logs_dir.dc-synthesis)

# Prepare handoffs

	mkdir -p $(handoff_dir.dc-synthesis)
	ln -srf $(results_dir.dc-synthesis)/* $(handoff_dir.dc-synthesis)

# Grep for errors

	grep --color "^Error" $(logs_dir.dc-synthesis)/dc.log || true
	grep --color -B 3 "*** Presto compilation terminated" \
    $(logs_dir.dc-synthesis)/dc.log || true
	grep --color "unresolved references." \
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
	design_vision-xg -topographical -x \
                      "source $(flow_dir.dc-synthesis)/rm_setup/dc_setup.tcl; \
                       read_ddc $(results_dir.dc-synthesis)/$(design_name).mapped.ddc"


debug-synth: debug-dc-synthesis

debug-dc-synthesis-elaborated:
	design_vision-xg -topographical -x \
                      "source $(flow_dir.dc-synthesis)/rm_setup/dc_setup.tcl; \
                       read_ddc $(results_dir.dc-synthesis)/$(design_name).elab.ddc"

debug-synth-elaborated: debug-dc-synthesis-elaborated


