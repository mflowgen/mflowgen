#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-postroute
#-------------------------------------------------------------------------
# The postroute step does detailed route. By this stage there should be no
# design rule violations left and timing should have settled.
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-postroute = "Detailed routing"

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

define commands.innovus-postroute
	$(innovus_exec) \
    -init $(collect_dir.innovus-postroute)/INNOVUS/run_postroute.tcl \
    -log $(innovus_logs_dir)/postroute.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-postroute)
	(cd $(handoff_dir.innovus-postroute) && \
    ln -sf ../../$(innovus_handoffs_dir)/postroute.* .)
# Clean up extraction reports
	mkdir -p $(innovus_logs_dir)/extLogDir
	mv extLogDir/* $(innovus_logs_dir)/extLogDir 2> /dev/null || true
	rm -rf ./extLogDir
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-postroute:
	rm -rf ./$(VPATH)/innovus-postroute
	rm -rf ./$(innovus_logs_dir)/postroute.*
	rm -rf ./$(innovus_reports_dir)/postroute.*
	rm -rf ./$(innovus_results_dir)/postroute.*
	rm -rf ./$(innovus_handoffs_dir)/postroute.*
	rm -rf ./$(collect_dir.innovus-postroute)
	rm -rf ./$(handoff_dir.innovus-postroute)

clean-postroute: clean-innovus-postroute

# Debug

debug-innovus-postroute:
	export STEP=postroute && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-postroute)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-postroute: debug-innovus-postroute

