#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-drc-filled = \
	"DRC for sealed and filled design"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-drc-fill
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            ____    _____     _____                            #'
	@echo '#                           |  _ \  |  __ \   / ____|                           #'
	@echo '#                           | | | | | |__) | | |                                #'
	@echo '#                           | | | | |  _  /  | |                                #'
	@echo '#                           | |_| | | | \ \  | |____                            #'
	@echo '#                           |____/  |_|  \_\  \_____|                           #'
	@echo '#                                 F I L L E D                                   #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-drc-filled = drc-filled

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The GDS is available from a previous step

# Unfortunately, the intermediate DRC targets run before the build system has
# constructed the collect dir, so we temporarily magically reach into the
# correct handoff dir.

calibre_drc_filled_gds = $(handoff_dir.calibre-fill)/top.gds

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Runset files -- the template will be populated to generate the runset

calibre_drc_filled_runset_template      = $(plugins_dir)/calibre/drc-filled.runset.template

calibre_drc_filled_runset_chip          = $(results_dir.calibre-drc-filled)/drc-filled-chip.runset
calibre_drc_filled_runset_antenna       = $(results_dir.calibre-drc-filled)/drc-filled-antenna.runset
calibre_drc_filled_runset_wirebond      = $(results_dir.calibre-drc-filled)/drc-filled-wirebond.runset

# DRC rules files

calibre_drc_filled_rulesfile_chip       = $(adk_dir)/calibre-drc-chip.rule
calibre_drc_filled_rulesfile_antenna    = $(adk_dir)/calibre-drc-antenna.rule
calibre_drc_filled_rulesfile_wirebond   = $(adk_dir)/calibre-drc-wirebond.rule

# DRC log files

calibre_drc_filled_logsfile_chip        = $(logs_dir.calibre-drc-filled)/drc-chip.log
calibre_drc_filled_logsfile_antenna     = $(logs_dir.calibre-drc-filled)/drc-antenna.log
calibre_drc_filled_logsfile_wirebond    = $(logs_dir.calibre-drc-filled)/drc-wirebond.log

# DRC results files

calibre_drc_filled_resultsfile_chip     = $(results_dir.calibre-drc-filled)/drc-chip.results
calibre_drc_filled_resultsfile_antenna  = $(results_dir.calibre-drc-filled)/drc-antenna.results
calibre_drc_filled_resultsfile_wirebond = $(results_dir.calibre-drc-filled)/drc-wirebond.results

# DRC summary files

calibre_drc_filled_summaryfile_chip     = $(results_dir.calibre-drc-filled)/drc-chip.summary
calibre_drc_filled_summaryfile_antenna  = $(results_dir.calibre-drc-filled)/drc-antenna.summary
calibre_drc_filled_summaryfile_wirebond = $(results_dir.calibre-drc-filled)/drc-wirebond.summary

# Common variables to substitute into the runset template
#
# Note: The paths must be absolute or Calibre will complain

export calibre_drc_filled_rundir        = $(PWD)/$(results_dir.calibre-drc-filled)
export calibre_drc_filled_layoutpaths   = $(PWD)/$(calibre_drc_filled_gds)
export calibre_drc_filled_layoutprimary = top

#-------------------------------------------------------------------------
# Targets for individual DRC checks
#-------------------------------------------------------------------------

# Chip DRC

$(calibre_drc_filled_logsfile_chip): $(dependencies.calibre-drc-filled)
	@mkdir -p $(logs_dir.calibre-drc-filled)
	@mkdir -p $(results_dir.calibre-drc-filled)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Chip DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_filled_rulesfile=$(calibre_drc_filled_rulesfile_chip); \
		export calibre_drc_filled_transcriptfile=$(PWD)/$(calibre_drc_filled_logsfile_chip); \
		export calibre_drc_filled_resultsfile=$(PWD)/$(calibre_drc_filled_resultsfile_chip); \
		export calibre_drc_filled_summaryfile=$(PWD)/$(calibre_drc_filled_summaryfile_chip); \
		envsubst < $(calibre_drc_filled_runset_template) > $(calibre_drc_filled_runset_chip) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_filled_runset_chip)

# Antenna DRC

$(calibre_drc_filled_logsfile_antenna): $(dependencies.calibre-drc-filled)
	@mkdir -p $(logs_dir.calibre-drc-filled)
	@mkdir -p $(results_dir.calibre-drc-filled)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Antenna DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_filled_rulesfile=$(calibre_drc_filled_rulesfile_antenna); \
		export calibre_drc_filled_transcriptfile=$(PWD)/$(calibre_drc_filled_logsfile_antenna); \
		export calibre_drc_filled_resultsfile=$(PWD)/$(calibre_drc_filled_resultsfile_antenna); \
		export calibre_drc_filled_summaryfile=$(PWD)/$(calibre_drc_filled_summaryfile_antenna); \
		envsubst < $(calibre_drc_filled_runset_template) > $(calibre_drc_filled_runset_antenna) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_filled_runset_antenna)

# Wirebond DRC

$(calibre_drc_filled_logsfile_wirebond): $(dependencies.calibre-drc-filled)
	@mkdir -p $(logs_dir.calibre-drc-filled)
	@mkdir -p $(results_dir.calibre-drc-filled)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Wirebond DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_filled_rulesfile=$(calibre_drc_filled_rulesfile_wirebond); \
		export calibre_drc_filled_transcriptfile=$(PWD)/$(calibre_drc_filled_logsfile_wirebond); \
		export calibre_drc_filled_resultsfile=$(PWD)/$(calibre_drc_filled_resultsfile_wirebond); \
		export calibre_drc_filled_summaryfile=$(PWD)/$(calibre_drc_filled_summaryfile_wirebond); \
		envsubst < $(calibre_drc_filled_runset_template) > $(calibre_drc_filled_runset_wirebond) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_filled_runset_wirebond)

#-------------------------------------------------------------------------
# Options
#-------------------------------------------------------------------------
# We use batch mode to run calibre based on a runset saved from the GUI.
#
#     Calibre® InteractiveTM and Calibre® RVETM User's Manual
#     (calbr_inter_user.pdf)
#
#     "You can run Calibre Interactive in batch mode without opening the
#     GUI. This mode of operation preserves the important features of
#     Calibre Interactive, such as runsets, customization files, and
#     export from layout, while letting you run in batch mode."

#-------------------------------------------------------------------------
# Extra dependencies
#-------------------------------------------------------------------------

extra_dependencies.calibre-drc-filled += $(calibre_drc_filled_logsfile_chip)
extra_dependencies.calibre-drc-filled += $(calibre_drc_filled_logsfile_antenna)
extra_dependencies.calibre-drc-filled += $(calibre_drc_filled_logsfile_wirebond)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

skipvpath.calibre-drc-filled = yes

define commands.calibre-drc-filled
	@echo '================================================================================'
	@echo 'Chip DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_filled_logsfile_chip)
	@echo '================================================================================'
	@echo 'Antenna DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_filled_logsfile_antenna)
	@echo '================================================================================'
	@echo 'Wirebond DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_filled_logsfile_wirebond)
	@echo '================================================================================'
	@echo 'DRC Summary'
	@echo '================================================================================'
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_filled_logsfile_chip)
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_filled_logsfile_antenna)
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_filled_logsfile_wirebond)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-drc-filled:
	rm -rf ./$(VPATH)/calibre-drc-filled
	rm -rf ./$(logs_dir.calibre-drc-filled)
	rm -rf ./$(collect_dir.calibre-drc-filled)
	rm -rf ./$(results_dir.calibre-drc-filled)

clean-drc-filled: clean-calibre-drc-filled

# Debug

debug-drc-filled-chip:
	calibredrv -m $(calibre_drc_filled_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_filled_resultsfile_chip)

debug-drc-filled-antenna:
	calibredrv -m $(calibre_drc_filled_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_filled_resultsfile_antenna)

debug-drc-filled-wirebond:
	calibredrv -m $(calibre_drc_filled_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_filled_resultsfile_wirebond)

