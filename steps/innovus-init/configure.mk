#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-init
#-------------------------------------------------------------------------
# The init step reads the netlist from DC and does floorplanning.
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-init = "Init -- Read the design, floorplan, etc."

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-init
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                           _____ _   _ _____ _______                           #'
	@echo '#                          |_   _| \ | |_   _|__   __|                          #'
	@echo '#                            | | |  \| | | |    | |                             #'
	@echo '#                            | | | . ` | | |    | |                             #'
	@echo '#                           _| |_| |\  |_| |_   | |                             #'
	@echo '#                          |_____|_| \_|_____|  |_|                             #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-init = init

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

# Assumed variables from Innovus flow setup
#
# - $(innovus_exec)
# - $(innovus_exec_gui)
# - $(innovus_logs_dir)
# - $(innovus_reports_dir)
# - $(innovus_results_dir)
# - $(innovus_handoffs_dir)

define commands.innovus-init
	$(innovus_exec) \
    -init $(collect_dir.innovus-init)/INNOVUS/run_init.tcl \
    -log  $(innovus_logs_dir)/init.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-init)
	(cd $(handoff_dir.innovus-init) && \
    ln -sf ../../$(innovus_handoffs_dir)/init.* .)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-init:
	rm -rf ./$(VPATH)/innovus-init
	rm -rf ./$(innovus_logs_dir)/init.*
	rm -rf ./$(innovus_reports_dir)/init.*
	rm -rf ./$(innovus_results_dir)/init.*
	rm -rf ./$(innovus_handoffs_dir)/init.*
	rm -rf ./$(collect_dir.innovus-init)
	rm -rf ./$(handoff_dir.innovus-init)

clean-init: clean-innovus-init

# Debug

debug-innovus-init:
	export STEP=init && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-init)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-init: debug-innovus-init

