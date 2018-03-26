#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

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

cts: innovus-cts

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

define commands.innovus-cts
	$(innovus_exec) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_cts.tcl -log $(innovus_logs_dir)/cts.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

debug-innovus-cts:
	export STEP=cts && $(innovus_exec_gui) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_debug.tcl -log $(innovus_logs_dir)/debug.log

clean-innovus-cts:
	rm -rf ./$(VPATH)/innovus-cts
	rm -rf ./$(innovus_logs_dir)/cts.*
	rm -rf ./$(innovus_reports_dir)/cts.*
	rm -rf ./$(innovus_handoffs_dir)/cts.*

debug-cts: debug-innovus-cts
clean-cts: clean-innovus-cts


