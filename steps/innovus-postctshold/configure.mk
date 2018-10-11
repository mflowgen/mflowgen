#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-postctshold
#-------------------------------------------------------------------------
# The postctshold step does hold fixing right after cts finishes..
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-postctshold = "Post-CTS hold fixing"

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

abbr.innovus-postctshold = postctshold

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

define commands.innovus-postctshold
	$(innovus_exec) \
    -init $(collect_dir.innovus-postctshold)/INNOVUS/run_postcts_hold.tcl \
    -log $(innovus_logs_dir)/postctshold.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-postctshold)
	(cd $(handoff_dir.innovus-postctshold) && \
    ln -sf ../../$(innovus_handoffs_dir)/postcts_hold.* .)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-innovus-postctshold:
	rm -rf ./$(VPATH)/innovus-postctshold
	rm -rf ./$(innovus_logs_dir)/postctshold.*
	rm -rf ./$(innovus_reports_dir)/postctshold.*
	rm -rf ./$(innovus_results_dir)/postctshold.*
	rm -rf ./$(innovus_handoffs_dir)/postctshold.*
	rm -rf ./$(collect_dir.innovus-postctshold)
	rm -rf ./$(handoff_dir.innovus-postctshold)

clean-postctshold: clean-innovus-postctshold

# Debug

debug-innovus-postctshold:
	export STEP=postctshold && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-postctshold)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-postctshold: debug-innovus-postctshold

