#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 20, 2019

#-------------------------------------------------------------------------
# Step Description -- innovus-full
#-------------------------------------------------------------------------
# This step runs the entire place-and-route flow in a single step
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-full = "Full -- Place and route"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-full
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                       ______  _    _   _       _                              #'
	@echo '#                      |  ____|| |  | | | |     | |                             #'
	@echo '#                      | |__   | |  | | | |     | |                             #'
	@echo '#                      |  __|  | |  | | | |     | |                             #'
	@echo '#                      | |     | |__| | | |____ | |____                         #'
	@echo '#                      |_|      \____/  |______/|______/                        #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-full = place-route

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

define commands.innovus-full
	$(innovus_exec) \
    -init $(collect_dir.innovus-full)/INNOVUS/run_simple.tcl \
    -log  $(innovus_logs_dir)/full.log
# Clean up
	mv *.spef.gz $(innovus_results_dir) || true
	mv *.conn.rpt *.geom.rpt *.antenna.* $(innovus_reports_dir) || true
# Clean up extraction reports
	mkdir -p $(innovus_logs_dir)/extLogDir
	mv extLogDir/* $(innovus_logs_dir)/extLogDir 2> /dev/null || true
	rm -rf ./extLogDir
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-full)
	(cd $(handoff_dir.innovus-full) && \
    ln -sf ../../$(innovus_handoffs_dir)/signoff.* .)
# Hand off results too
	(cd $(handoff_dir.innovus-full) && \
    ln -sf ../../$(innovus_results_dir)/* .)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-full:
	rm -rf ./$(VPATH)/innovus-full
	rm -rf ./$(innovus_logs_dir)/full.*
	rm -rf ./$(innovus_reports_dir)/full.*
	rm -rf ./$(innovus_results_dir)/full.*
	rm -rf ./$(innovus_handoffs_dir)/full.*
	rm -rf ./$(collect_dir.innovus-full)
	rm -rf ./$(handoff_dir.innovus-full)

clean-full: clean-innovus-full

# Debug

debug-innovus-full:
	export STEP=signoff && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-full)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-full: debug-innovus-full

