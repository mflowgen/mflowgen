#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

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

signoff: innovus-signoff

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

define commands.innovus-signoff
	$(innovus_exec) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_signoff.tcl -log $(innovus_logs_dir)/signoff.log
# Clean up
	mv *.spef.gz $(innovus_results_dir)
	mv *.conn.rpt *.geom.rpt *.antenna.* $(innovus_reports_dir)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

debug-innovus-signoff:
	export STEP=signoff && $(innovus_exec_gui) -init $(innovus_flowsetup_handoffs_dir)/INNOVUS/run_debug.tcl -log $(innovus_logs_dir)/debug.log

clean-innovus-signoff:
	rm -rf ./$(VPATH)/innovus-signoff
	rm -rf ./$(innovus_logs_dir)/signoff.*
	rm -rf ./$(innovus_reports_dir)/signoff.*
	rm -rf ./$(innovus_handoffs_dir)/signoff.*

debug-signoff: debug-innovus-signoff
clean-signoff: clean-innovus-signoff


