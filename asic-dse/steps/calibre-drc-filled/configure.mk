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
# Variables
#-------------------------------------------------------------------------

# GDS file

calibre_drc_filled_gds = $(collect_dir.calibre-drc-filled)/top.gds

# Runset files -- the template will be populated to generate the runset

calibre_drc_filled_runset_template = $(plugins_dir)/calibre/drc-filled.runset.template
calibre_drc_filled_runset          = $(results_dir.calibre-drc-filled)/drc-filled.runset

# Variables to substitute into the runset template
#
# Note: The paths must be absolute or Calibre will complain

export calibre_drc_filled_rulesfile       = $(adk_dir)/calibre-drc-chip.rule
export calibre_drc_filled_rundir          = $(PWD)/$(results_dir.calibre-drc-filled)
export calibre_drc_filled_layoutpaths     = $(PWD)/$(calibre_drc_filled_gds)
export calibre_drc_filled_layoutprimary   = top
export calibre_drc_filled_transcriptfile  = $(PWD)/$(logs_dir.calibre-drc-filled)/drc.log

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
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.calibre-drc-filled
	mkdir -p $(results_dir.calibre-drc-filled)
# Generate the drc runset from the template
	envsubst < $(calibre_drc_filled_runset_template) > $(calibre_drc_filled_runset)
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_filled_runset)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-drc-filled:
	rm -rf ./$(VPATH)/calibre-drc-filled
	rm -rf ./$(collect_dir.calibre-drc-filled)
	rm -rf ./$(results_dir.calibre-drc-filled)

clean-drc-filled: clean-calibre-drc-filled

debug-drc-filled:
	calibredrv -m $(calibre_drc_filled_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(results_dir.calibre-drc-filled)/drc.results

