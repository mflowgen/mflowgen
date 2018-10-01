#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 16, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-drc-top = \
	"DRC for sealed and filled design"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-drc-top
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            ____    _____     _____                            #'
	@echo '#                           |  _ \  |  __ \   / ____|                           #'
	@echo '#                           | | | | | |__) | | |                                #'
	@echo '#                           | | | | |  _  /  | |                                #'
	@echo '#                           | |_| | | | \ \  | |____                            #'
	@echo '#                           |____/  |_|  \_\  \_____|                           #'
	@echo '#                                   T  O  P                                     #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-drc-top = drc-top

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The GDS is available from a previous step

# Unfortunately, the intermediate DRC targets run before the build system has
# constructed the collect dir, so we temporarily magically reach into the
# correct handoff dir.

calibre_drc_top_gds = $(handoff_dir.calibre-stamp)/stamped.gds

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Runset files -- the template will be populated to generate the runset

calibre_drc_top_runset_template      = $(plugins_dir)/calibre/drc-top.runset.template

calibre_drc_top_runset_chip          = $(results_dir.calibre-drc-top)/drc-top-chip.runset
calibre_drc_top_runset_antenna       = $(results_dir.calibre-drc-top)/drc-top-antenna.runset
calibre_drc_top_runset_wirebond      = $(results_dir.calibre-drc-top)/drc-top-wirebond.runset

# DRC rules files

calibre_drc_top_rulesfile_chip       = $(adk_dir)/calibre-drc-chip.rule
calibre_drc_top_rulesfile_antenna    = $(adk_dir)/calibre-drc-antenna.rule
calibre_drc_top_rulesfile_wirebond   = $(adk_dir)/calibre-drc-wirebond.rule

# DRC log files

calibre_drc_top_logsfile_chip        = $(logs_dir.calibre-drc-top)/drc-chip.log
calibre_drc_top_logsfile_antenna     = $(logs_dir.calibre-drc-top)/drc-antenna.log
calibre_drc_top_logsfile_wirebond    = $(logs_dir.calibre-drc-top)/drc-wirebond.log

# DRC results files

calibre_drc_top_resultsfile_chip     = $(results_dir.calibre-drc-top)/drc-chip.results
calibre_drc_top_resultsfile_antenna  = $(results_dir.calibre-drc-top)/drc-antenna.results
calibre_drc_top_resultsfile_wirebond = $(results_dir.calibre-drc-top)/drc-wirebond.results

# DRC summary files

calibre_drc_top_summaryfile_chip     = $(results_dir.calibre-drc-top)/drc-chip.summary
calibre_drc_top_summaryfile_antenna  = $(results_dir.calibre-drc-top)/drc-antenna.summary
calibre_drc_top_summaryfile_wirebond = $(results_dir.calibre-drc-top)/drc-wirebond.summary

# Common variables to substitute into the runset template
#
# Note: The paths must be absolute or Calibre will complain

export calibre_drc_top_rundir        = $(PWD)/$(results_dir.calibre-drc-top)
export calibre_drc_top_layoutpaths   = $(PWD)/$(calibre_drc_top_gds)
export calibre_drc_top_layoutprimary = top_stamped

#-------------------------------------------------------------------------
# Targets for individual DRC checks
#-------------------------------------------------------------------------

# Chip DRC

$(calibre_drc_top_logsfile_chip): $(dependencies.calibre-drc-top)
	@mkdir -p $(logs_dir.calibre-drc-top)
	@mkdir -p $(results_dir.calibre-drc-top)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Chip DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_top_rulesfile=$(calibre_drc_top_rulesfile_chip); \
		export calibre_drc_top_transcriptfile=$(PWD)/$(calibre_drc_top_logsfile_chip); \
		export calibre_drc_top_resultsfile=$(PWD)/$(calibre_drc_top_resultsfile_chip); \
		export calibre_drc_top_summaryfile=$(PWD)/$(calibre_drc_top_summaryfile_chip); \
		envsubst < $(calibre_drc_top_runset_template) > $(calibre_drc_top_runset_chip) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_top_runset_chip)

# Antenna DRC

$(calibre_drc_top_logsfile_antenna): $(dependencies.calibre-drc-top)
	@mkdir -p $(logs_dir.calibre-drc-top)
	@mkdir -p $(results_dir.calibre-drc-top)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Antenna DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_top_rulesfile=$(calibre_drc_top_rulesfile_antenna); \
		export calibre_drc_top_transcriptfile=$(PWD)/$(calibre_drc_top_logsfile_antenna); \
		export calibre_drc_top_resultsfile=$(PWD)/$(calibre_drc_top_resultsfile_antenna); \
		export calibre_drc_top_summaryfile=$(PWD)/$(calibre_drc_top_summaryfile_antenna); \
		envsubst < $(calibre_drc_top_runset_template) > $(calibre_drc_top_runset_antenna) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_top_runset_antenna)

# Wirebond DRC

$(calibre_drc_top_logsfile_wirebond): $(dependencies.calibre-drc-top)
	@mkdir -p $(logs_dir.calibre-drc-top)
	@mkdir -p $(results_dir.calibre-drc-top)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Wirebond DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_top_rulesfile=$(calibre_drc_top_rulesfile_wirebond); \
		export calibre_drc_top_transcriptfile=$(PWD)/$(calibre_drc_top_logsfile_wirebond); \
		export calibre_drc_top_resultsfile=$(PWD)/$(calibre_drc_top_resultsfile_wirebond); \
		export calibre_drc_top_summaryfile=$(PWD)/$(calibre_drc_top_summaryfile_wirebond); \
		envsubst < $(calibre_drc_top_runset_template) > $(calibre_drc_top_runset_wirebond) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_top_runset_wirebond)

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

extra_dependencies.calibre-drc-top += $(calibre_drc_top_logsfile_chip)
extra_dependencies.calibre-drc-top += $(calibre_drc_top_logsfile_antenna)
extra_dependencies.calibre-drc-top += $(calibre_drc_top_logsfile_wirebond)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

skipvpath.calibre-drc-top = yes

define commands.calibre-drc-top
	@echo '================================================================================'
	@echo 'Chip DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_top_logsfile_chip)
	@echo '================================================================================'
	@echo 'Antenna DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_top_logsfile_antenna)
	@echo '================================================================================'
	@echo 'Wirebond DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_top_logsfile_wirebond)
	@echo '================================================================================'
	@echo 'DRC Summary'
	@echo '================================================================================'
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_top_logsfile_chip)
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_top_logsfile_antenna)
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_top_logsfile_wirebond)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

drc: calibre-drc-top

# Clean

clean-calibre-drc-top:
	rm -rf ./$(VPATH)/calibre-drc-top
	rm -rf ./$(logs_dir.calibre-drc-top)
	rm -rf ./$(collect_dir.calibre-drc-top)
	rm -rf ./$(results_dir.calibre-drc-top)

clean-drc-top: clean-calibre-drc-top

# Debug

debug-drc-top-chip:
	calibredrv -m $(calibre_drc_top_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_top_resultsfile_chip)

debug-drc-top-antenna:
	calibredrv -m $(calibre_drc_top_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_top_resultsfile_antenna)

debug-drc-top-wirebond:
	calibredrv -m $(calibre_drc_top_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_top_resultsfile_wirebond)

