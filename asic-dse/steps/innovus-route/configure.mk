#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

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

route: innovus-route

#-------------------------------------------------------------------------
# Variables shared across all Innovus steps
#-------------------------------------------------------------------------
# The Innovus execute commands should be set up during Innovus flow setup
#
# - $(innovus_exec)
# - $(innovus_exec_gui)
#
# The Innovus directories should also be set up during Innovus flow setup
#
# - $(innovus_logs_dir)
# - $(innovus_results_dir)
# - $(innovus_reports_dir)
# - $(innovus_handoffs_dir)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.innovus-route
	$(innovus_exec) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_route.tcl -log $(innovus_logs_dir)/route.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

debug-innovus-route:
	export STEP=route && $(innovus_exec_gui) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_debug.tcl -log $(innovus_logs_dir)/debug.log

clean-innovus-route:
	rm -rf ./$(VPATH)/innovus-route
	rm -rf ./$(innovus_logs_dir)/route.*
	rm -rf ./$(innovus_reports_dir)/route.*
	rm -rf ./$(innovus_handoffs_dir)/route.*

debug-route: debug-innovus-route
clean-route: clean-innovus-route


