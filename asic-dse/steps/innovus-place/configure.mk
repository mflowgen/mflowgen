#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

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

place: innovus-place

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

define commands.innovus-place
	$(innovus_exec) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_place.tcl -log $(innovus_logs_dir)/place.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

debug-innovus-place:
	export STEP=place && $(innovus_exec_gui) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_debug.tcl -log $(innovus_logs_dir)/debug.log

clean-innovus-place:
	rm -rf ./$(VPATH)/innovus-place
	rm -rf ./$(innovus_logs_dir)/place.*
	rm -rf ./$(innovus_reports_dir)/place.*
	rm -rf ./$(innovus_handoffs_dir)/place.*

debug-place: debug-innovus-place
clean-place: clean-innovus-place


