#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-place
#-------------------------------------------------------------------------
# The place step does power planning and iterates on placing stdcells.
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-place = "Placement"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-place
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                      _____  _               _____ ______                      #'
	@echo '#                     |  __ \| |        /\   / ____|  ____|                     #'
	@echo '#                     | |__) | |       /  \ | |    | |__                        #'
	@echo '#                     |  ___/| |      / /\ \| |    |  __|                       #'
	@echo '#                     | |    | |____ / ____ \ |____| |____                      #'
	@echo '#                     |_|    |______/_/    \_\_____|______|                     #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-place = place

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

define commands.innovus-place
	$(innovus_exec) \
    -init $(collect_dir.innovus-place)/INNOVUS/run_place.tcl \
    -log $(innovus_logs_dir)/place.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-place)
	(cd $(handoff_dir.innovus-place) && \
    ln -sf ../../$(innovus_handoffs_dir)/place.* .)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-place:
	rm -rf ./$(VPATH)/innovus-place
	rm -rf ./$(innovus_logs_dir)/place.*
	rm -rf ./$(innovus_reports_dir)/place.*
	rm -rf ./$(innovus_results_dir)/place.*
	rm -rf ./$(innovus_handoffs_dir)/place.*
	rm -rf ./$(collect_dir.innovus-place)
	rm -rf ./$(handoff_dir.innovus-place)

clean-place: clean-innovus-place

# Debug

debug-innovus-place:
	export STEP=place && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-place)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-place: debug-innovus-place

