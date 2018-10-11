#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description -- innovus-signoff
#-------------------------------------------------------------------------
# The signoff step does final timing and verification checks and outputs
# files (e.g., netlist, gds, lef, etc.).
#
# Required collection:
#
#     innovus-flowsetup
#     -----------------
#
#     - Need the Innovus foundation flow scripts
#     - Need the common Innovus variables (e.g., exec command)
#

descriptions.innovus-signoff = "Signoff"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.innovus-signoff
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                  _____ _____ _____ _   _  ____  ______ ______                 #'
	@echo '#                 / ____|_   _/ ____| \ | |/ __ \|  ____|  ____|                #'
	@echo '#                | (___   | || |  __|  \| | |  | | |__  | |__                   #'
	@echo '#                 \___ \  | || | |_ | . ` | |  | |  __| |  __|                  #'
	@echo '#                 ____) |_| || |__| | |\  | |__| | |    | |                     #'
	@echo '#                |_____/|_____\_____|_| \_|\____/|_|    |_|                     #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.innovus-signoff = signoff

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

define commands.innovus-signoff
	$(innovus_exec) \
    -init $(collect_dir.innovus-signoff)/INNOVUS/run_signoff.tcl \
    -log $(innovus_logs_dir)/signoff.log
# Prepare handoffs
	mkdir -p $(handoff_dir.innovus-signoff)
	(cd $(handoff_dir.innovus-signoff) && \
    ln -sf ../../$(innovus_handoffs_dir)/signoff.* .)
# Hand off results too
	(cd $(handoff_dir.innovus-signoff) && \
    ln -sf ../../$(innovus_results_dir)/* .)
# Clean up
	mv *.spef.gz $(innovus_results_dir) || true
	mv *.conn.rpt *.geom.rpt *.antenna.* $(innovus_reports_dir) || true
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

clean-innovus-signoff:
	rm -rf ./$(VPATH)/innovus-signoff
	rm -rf ./$(innovus_logs_dir)/signoff.*
	rm -rf ./$(innovus_reports_dir)/signoff.*
	rm -rf ./$(innovus_results_dir)/signoff.*
	rm -rf ./$(innovus_handoffs_dir)/signoff.*
	rm -rf ./$(collect_dir.innovus-signoff)
	rm -rf ./$(handoff_dir.innovus-signoff)

clean-signoff: clean-innovus-signoff

# Debug

debug-innovus-signoff:
	export STEP=signoff && \
  $(innovus_exec_gui) \
    -init $(collect_dir.innovus-signoff)/INNOVUS/run_debug.tcl \
    -log $(innovus_logs_dir)/debug.log

debug-signoff: debug-innovus-signoff

