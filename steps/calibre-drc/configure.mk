#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 8, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-drc = \
	"DRC for block-level design"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-drc
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            ____    _____     _____                            #'
	@echo '#                           |  _ \  |  __ \   / ____|                           #'
	@echo '#                           | | | | | |__) | | |                                #'
	@echo '#                           | | | | |  _  /  | |                                #'
	@echo '#                           | |_| | | | \ \  | |____                            #'
	@echo '#                           |____/  |_|  \_\  \_____|                           #'
	@echo '#                                   B L O C K                                   #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-drc = drc

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The GDS is available from a previous step

# Unfortunately, the intermediate DRC targets run before the build system has
# constructed the collect dir, so we temporarily magically reach into the
# correct handoff dir.

calibre_drc_gds = $(handoff_dir.calibre-gds-merge)/$(design_name).gds

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Runset files -- the template will be populated to generate the runset

calibre_drc_runset_template      = $(plugins_dir)/calibre/drc.runset.template
calibre_drc_runset               = $(results_dir.calibre-drc)/drc.runset

# DRC rules files

calibre_drc_rulesfile            = $(adk_dir)/calibre-drc-block.rule

# DRC output files

calibre_drc_logsfile             = $(logs_dir.calibre-drc)/drc.log
calibre_drc_resultsfile          = $(results_dir.calibre-drc)/drc.results
calibre_drc_summaryfile          = $(results_dir.calibre-drc)/drc.summary

# Common variables to substitute into the runset template
#
# Note: The paths must be absolute or Calibre will complain

export calibre_drc_rundir        = $(PWD)/$(results_dir.calibre-drc)
export calibre_drc_layoutpaths   = $(PWD)/$(calibre_drc_gds)
export calibre_drc_layoutprimary = $(design_name)

#-------------------------------------------------------------------------
# Targets for individual DRC checks
#-------------------------------------------------------------------------

# Block-level DRC

$(calibre_drc_logsfile): $(dependencies.calibre-drc)
	@mkdir -p $(logs_dir.calibre-drc)
	@mkdir -p $(results_dir.calibre-drc)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Block-Level DRC'
	@echo '================================================================================'
# Select the DRC rules file and generate the drc runset from the template
	( export calibre_drc_rulesfile=$(calibre_drc_rulesfile); \
		export calibre_drc_transcriptfile=$(PWD)/$(calibre_drc_logsfile); \
		export calibre_drc_resultsfile=$(PWD)/$(calibre_drc_resultsfile); \
		export calibre_drc_summaryfile=$(PWD)/$(calibre_drc_summaryfile); \
		envsubst < $(calibre_drc_runset_template) > $(calibre_drc_runset) )
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_runset)

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

extra_dependencies.calibre-drc += $(calibre_drc_logsfile)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

skipvpath.calibre-drc = yes

define commands.calibre-drc
	@echo '================================================================================'
	@echo 'Block-Level DRC'
	@echo '================================================================================'
	@tail -11 $(calibre_drc_logsfile)
	@echo
	@grep --color -e "TOTAL RESULTS GENERATED" $(calibre_drc_logsfile)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-drc:
	rm -rf ./$(VPATH)/calibre-drc
	rm -rf ./$(logs_dir.calibre-drc)
	rm -rf ./$(collect_dir.calibre-drc)
	rm -rf ./$(results_dir.calibre-drc)

clean-drc: clean-calibre-drc

# Debug

debug-drc:
	calibredrv -m $(calibre_drc_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(calibre_drc_resultsfile)

