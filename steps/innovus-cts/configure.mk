#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-cts
#-------------------------------------------------------------------------
# The cts step does clock tree synthesis.
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-cts = "Clock tree synthesis"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-cts
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                              _____ _______ _____                              #'
	@echo '#                             / ____|__   __/ ____|                             #'
	@echo '#                            | |       | | | (___                               #'
	@echo '#                            | |       | |  \___ \                              #'
	@echo '#                            | |____   | |  ____) |                             #'
	@echo '#                             \_____|  |_| |_____/                              #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-cts = cts

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

define commands.innovus-cts
	$(innovus_exec) \
    -init $(collect_dir.innovus-cts)/INNOVUS/run_cts.tcl \
    -log $(innovus_logs_dir)/cts.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-cts)
	(cd $(handoff_dir.innovus-cts) && \
    ln -sf ../../$(innovus_handoffs_dir)/cts.* .)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-cts:
	rm -rf ./$(VPATH)/innovus-cts
	rm -rf ./$(innovus_logs_dir)/cts.*
	rm -rf ./$(innovus_reports_dir)/cts.*
	rm -rf ./$(innovus_results_dir)/cts.*
	rm -rf ./$(innovus_handoffs_dir)/cts.*
	rm -rf ./$(collect_dir.innovus-cts)
	rm -rf ./$(handoff_dir.innovus-cts)

clean-cts: clean-innovus-cts

# Debug

debug-innovus-cts:
	export STEP=cts && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-cts)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-cts: debug-innovus-cts

