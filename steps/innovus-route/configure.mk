#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-route
#-------------------------------------------------------------------------
# The route step does global routing...
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-route = "Global routing"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-route
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                      _____   ____  _    _ _______ ______                      #'
	@echo '#                     |  __ \ / __ \| |  | |__   __|  ____|                     #'
	@echo '#                     | |__) | |  | | |  | |  | |  | |__                        #'
	@echo '#                     |  _  /| |  | | |  | |  | |  |  __|                       #'
	@echo '#                     | | \ \| |__| | |__| |  | |  | |____                      #'
	@echo '#                     |_|  \_\\____/ \____/   |_|  |______|                     #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-route = route

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

define commands.innovus-route
	$(innovus_exec) \
    -init $(collect_dir.innovus-route)/INNOVUS/run_route.tcl \
    -log $(innovus_logs_dir)/route.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-route)
	(cd $(handoff_dir.innovus-route) && \
    ln -sf ../../$(innovus_handoffs_dir)/route.* .)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-route:
	rm -rf ./$(VPATH)/innovus-route
	rm -rf ./$(innovus_logs_dir)/route.*
	rm -rf ./$(innovus_reports_dir)/route.*
	rm -rf ./$(innovus_results_dir)/route.*
	rm -rf ./$(innovus_handoffs_dir)/route.*
	rm -rf ./$(collect_dir.innovus-route)
	rm -rf ./$(handoff_dir.innovus-route)

clean-route: clean-innovus-route

# Debug

debug-innovus-route:
	export STEP=route && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-route)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-route: debug-innovus-route

