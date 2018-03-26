#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-postroute
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#       _____   ____   _____ _______ _____   ____  _    _ _______ ______        #'
	@echo '#      |  __ \ / __ \ / ____|__   __|  __ \ / __ \| |  | |__   __|  ____|       #'
	@echo '#      | |__) | |  | | (___    | |  | |__) | |  | | |  | |  | |  | |__          #'
	@echo '#      |  ___/| |  | |\___ \   | |  |  _  /| |  | | |  | |  | |  |  __|         #'
	@echo '#      | |    | |__| |____) |  | |  | | \ \| |__| | |__| |  | |  | |____        #'
	@echo '#      |_|     \____/|_____/   |_|  |_|  \_\\____/ \____/   |_|  |______|       #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-postroute = postroute

postroute: innovus-postroute

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

define commands.innovus-postroute
	$(innovus_exec) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_postroute.tcl -log $(innovus_logs_dir)/postroute.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

debug-innovus-postroute:
	export STEP=postroute && $(innovus_exec_gui) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_debug.tcl -log $(innovus_logs_dir)/debug.log

clean-innovus-postroute:
	rm -rf ./$(VPATH)/innovus-postroute
	rm -rf ./$(innovus_logs_dir)/postroute.*
	rm -rf ./$(innovus_reports_dir)/postroute.*
	rm -rf ./$(innovus_handoffs_dir)/postroute.*

debug-postroute: debug-innovus-postroute
clean-postroute: clean-innovus-postroute


