#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-drc-sealed = \
	"DRC for design with sealring"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-drc-sealed
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            ____    _____     _____                            #'
	@echo '#                           |  _ \  |  __ \   / ____|                           #'
	@echo '#                           | | | | | |__) | | |                                #'
	@echo '#                           | | | | |  _  /  | |                                #'
	@echo '#                           | |_| | | | \ \  | |____                            #'
	@echo '#                           |____/  |_|  \_\  \_____|                           #'
	@echo '#                                 S E A L E D                                   #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-drc-sealed = drc-sealed

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# GDS file

calibre_drc_sealed_gds = $(collect_dir.calibre-drc-sealed)/sealed.gds

# Runset files -- the template will be populated to generate the runset

calibre_drc_sealed_runset_template = $(plugins_dir)/calibre/drc-sealed.runset.template
calibre_drc_sealed_runset          = $(results_dir.calibre-drc-sealed)/drc-sealed.runset

# Variables to substitute into the runset template
#
# Note: The paths must be absolute or Calibre will complain

export calibre_drc_sealed_rulesfile       = $(adk_dir)/calibre-drc-chip.rule
export calibre_drc_sealed_rundir          = $(PWD)/$(results_dir.calibre-drc-sealed)
export calibre_drc_sealed_layoutpaths     = $(PWD)/$(calibre_drc_sealed_gds)
export calibre_drc_sealed_layoutprimary   = top_sealed
export calibre_drc_sealed_transcriptfile  = $(PWD)/$(logs_dir.calibre-drc-sealed)/drc.log

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

define commands.calibre-drc-sealed
	mkdir -p $(results_dir.calibre-drc-sealed)
# Generate the drc runset from the template
	envsubst < $(calibre_drc_sealed_runset_template) > $(calibre_drc_sealed_runset)
# Run drc using the runset
	calibre -gui -drc -batch -runset $(calibre_drc_sealed_runset)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-drc-sealed:
	rm -rf ./$(VPATH)/calibre-drc-sealed
	rm -rf ./$(collect_dir.calibre-drc-sealed)
	rm -rf ./$(results_dir.calibre-drc-sealed)

clean-drc-sealed: clean-calibre-drc-sealed

debug-drc-sealed:
	calibredrv -m $(calibre_drc_sealed_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -drc $(results_dir.calibre-drc-sealed)/drc.results

