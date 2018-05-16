#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-lvs-filled = \
	"LVS for sealed and filled design"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-lvs-filled
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            _     __      __  _____                            #'
	@echo '#                           | |    \ \    / / / ____|                           #'
	@echo '#                           | |     \ \  / / | (___                             #'
	@echo '#                           | |      \ \/ /   \___ \                            #'
	@echo '#                           | |____   \  /    ____) |                           #'
	@echo '#                           |______|   \/    |_____/                            #'
	@echo '#                                  F I L L E D                                  #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-lvs-filled = lvs-filled

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The GDS and LVS netlist are available from a previous step

# Unfortunately, the intermediate LVS target will try to run before the
# build system has constructed the collect dir, so we temporarily
# magically reach into the correct handoff dir.

calibre_lvs_filled_gds = $(handoff_dir.calibre-fill)/top.gds
calibre_lvs_filled_v   = $(wildcard $(handoff_dir.innovus-signoff)/*.lvs.v)

# Also pull in any extra files we need (e.g., SRAM cdl)

calibre_lvs_filled_extras += $(wildcard $(handoff_dir.gen-sram-cdl)/*.cdl)

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Runset files -- the template will be populated to generate the runset

calibre_lvs_filled_runset_template = $(plugins_dir)/calibre/lvs-filled.runset.template
calibre_lvs_filled_runset          = $(results_dir.calibre-lvs-filled)/lvs-filled.runset

# Common variables to substitute into the runset template
#
# Note: Some of the paths must be absolute

export calibre_lvs_filled_rulesfile      = $(adk_dir)/calibre-lvs.rule
export calibre_lvs_filled_rundir         = $(PWD)/$(results_dir.calibre-lvs-filled)

export calibre_lvs_filled_layoutpaths    = $(PWD)/$(calibre_lvs_filled_gds)
export calibre_lvs_filled_layoutprimary  = $(design_name)
export calibre_lvs_filled_extractedspice = $(calibre_lvs_filled_rundir)/lvs.extracted.sp

export calibre_lvs_filled_sourcepath     = $(PWD)/$(calibre_lvs_filled_v)
export calibre_lvs_filled_sourceprimary  = $(design_name)

export calibre_lvs_filled_logsfile       = $(calibre_lvs_filled_rundir)/lvs.log
export calibre_lvs_filled_ercdatabase    = $(calibre_lvs_filled_rundir)/lvs.erc.results
export calibre_lvs_filled_ercsummaryfile = $(calibre_lvs_filled_rundir)/lvs.erc.summary
export calibre_lvs_filled_reportfile     = $(calibre_lvs_filled_rundir)/lvs.report

calibre_lvs_filled_spiceincfiles        += $(adk_dir)/stdcells.cdl
calibre_lvs_filled_spiceincfiles        += $(adk_dir)/iocells.spi
calibre_lvs_filled_spiceincfiles        += $(foreach x, $(calibre_lvs_filled_extras),$(PWD)/$x)

export calibre_lvs_filled_spiceincfiles

#-------------------------------------------------------------------------
# Targets for LVS checks
#-------------------------------------------------------------------------

# Chip LVS (Filled)

$(calibre_lvs_filled_logsfile): $(dependencies.calibre-lvs-filled)
	@mkdir -p $(results_dir.calibre-lvs-filled)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Chip LVS (Sealed and filled)'
	@echo '================================================================================'
# Select the LVS rules file and generate the lvs runset from the template
	envsubst < $(calibre_lvs_filled_runset_template) > $(calibre_lvs_filled_runset)
# Run lvs using the runset
	calibre -gui -lvs -batch -runset $(calibre_lvs_filled_runset)

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

extra_dependencies.calibre-lvs-filled += $(calibre_lvs_filled_logsfile)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

skipvpath.calibre-lvs-filled = yes

define commands.calibre-lvs-filled
	@echo "Layout    : $(calibre_lvs_filled_gds)"
	@echo "Schematic : $(calibre_lvs_filled_v)"
	@echo
	@echo '================================================================================'
	@echo 'Chip LVS (sealed and filled)'
	@echo '================================================================================'
	@sed -n "/OVERALL COMPARISON RESULTS/,/\*\*\*\*/p" $(calibre_lvs_filled_reportfile)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-lvs-filled:
	rm -rf ./$(VPATH)/calibre-lvs-filled
	rm -rf ./$(results_dir.calibre-lvs-filled)
	rm -rf ./$(collect_dir.calibre-lvs-filled)

clean-lvs-filled: clean-calibre-lvs-filled

# Debug

debug-lvs-filled:
	calibredrv -m $(calibre_lvs_filled_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -lvs $(calibre_lvs_filled_rundir)/svdb

