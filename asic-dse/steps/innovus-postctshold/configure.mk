#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-postctshold
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#    ____   ___   ____ ______ ___ ______ ___          _   _  ___  _    ____     #'
	@echo '#   |  _ \ / _ \ / ___|_   __/ __|_   __/ __|        | | | |/ _ \| |  |  _ \    #'
	@echo '#   | |_) | | | | (__   | | | |    | | | (__         | |_| | | | | |  | | | |   #'
	@echo '#   |  __/| | | |\__ \  | | | |    | |  \__ \        |  _  | | | | |  | | | |   #'
	@echo '#   | |   | |_| |___) | | | | |__  | |  ___) | _____ | | | | |_| | |__| |_| |   #'
	@echo '#   |_|    \___/|____/  |_|  \___| |_| |____/ |_____||_| |_|\___/|____|____/    #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

postctshold: innovus-postctshold

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

define commands.innovus-postctshold
	$(innovus_exec) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_postcts_hold.tcl -log $(innovus_logs_dir)/postctshold.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

debug-innovus-postctshold:
	export STEP=postcts_hold && $(innovus_exec_gui) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_debug.tcl -log $(innovus_logs_dir)/debug.log

clean-innovus-postctshold:
	rm -rf ./$(VPATH)/innovus-postctshold
	rm -rf ./$(innovus_logs_dir)/postctshold.*
	rm -rf ./$(innovus_reports_dir)/postctshold.*
	rm -rf ./$(innovus_handoffs_dir)/postctshold.*

debug-postctshold: debug-innovus-postctshold
clean-postctshold: clean-innovus-postctshold


