#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-lvs = \
	"LVS for unsealed and unfilled design"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-lvs
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            _     __      __  _____                            #'
	@echo '#                           | |    \ \    / / / ____|                           #'
	@echo '#                           | |     \ \  / / | (___                             #'
	@echo '#                           | |      \ \/ /   \___ \                            #'
	@echo '#                           | |____   \  /    ____) |                           #'
	@echo '#                           |______|   \/    |_____/                            #'
	@echo '#                                U N S E A L E D                                #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-lvs = lvs

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The GDS and LVS netlist are available from a previous step

# Unfortunately, the intermediate LVS target will try to run before the
# build system has constructed the collect dir, so we temporarily
# magically reach into the correct handoff dir.

calibre_lvs_gds = $(handoff_dir.calibre-seal)/unsealed.gds
calibre_lvs_v   = $(wildcard $(handoff_dir.innovus-signoff)/*.lvs.v)

# Also pull in any extra files we need (e.g., SRAM cdl)

calibre_lvs_extras += $(wildcard $(handoff_dir.gen-sram-cdl)/*.cdl)

#-------------------------------------------------------------------------
# BRGTC2-specific netlists
#-------------------------------------------------------------------------

pll_lvs_v = $(wildcard /work/global/brgtc2/pll-innovus/*.lvs.v)

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Runset files -- the template will be populated to generate the runset

calibre_lvs_runset_template       = $(plugins_dir)/calibre/lvs.runset.template
calibre_lvs_runset                = $(results_dir.calibre-lvs)/lvs.runset

# Common variables to substitute into the runset template
#
# Note: Some of the paths must be absolute

export calibre_lvs_rulesfile      = $(adk_dir)/calibre-lvs.rule
export calibre_lvs_rundir         = $(PWD)/$(results_dir.calibre-lvs)

export calibre_lvs_layoutpaths    = $(PWD)/$(calibre_lvs_gds)
export calibre_lvs_layoutprimary  = $(design_name)
export calibre_lvs_extractedspice = $(calibre_lvs_rundir)/lvs.extracted.sp

export calibre_lvs_sourcepath     = $(PWD)/$(calibre_lvs_v)
export calibre_lvs_sourcepath    += $(pll_lvs_v)
export calibre_lvs_sourceprimary  = $(design_name)

export calibre_lvs_logsfile       = $(calibre_lvs_rundir)/lvs.log
export calibre_lvs_ercdatabase    = $(calibre_lvs_rundir)/lvs.erc.results
export calibre_lvs_ercsummaryfile = $(calibre_lvs_rundir)/lvs.erc.summary
export calibre_lvs_reportfile     = $(calibre_lvs_rundir)/lvs.report

calibre_lvs_spiceincfiles        += $(adk_dir)/stdcells.cdl
calibre_lvs_spiceincfiles        += $(adk_dir)/iocells.spi
calibre_lvs_spiceincfiles        += $(foreach x, $(calibre_lvs_extras),$(PWD)/$x)

export calibre_lvs_spiceincfiles

#-------------------------------------------------------------------------
# Targets for LVS checks
#-------------------------------------------------------------------------

# Chip LVS (unsealed)

$(calibre_lvs_logsfile): $(dependencies.calibre-lvs)
	@mkdir -p $(results_dir.calibre-lvs)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Chip LVS (Unsealed)'
	@echo '================================================================================'
# Select the LVS rules file and generate the lvs runset from the template
	envsubst < $(calibre_lvs_runset_template) > $(calibre_lvs_runset)
# Run lvs using the runset
	calibre -gui -lvs -batch -runset $(calibre_lvs_runset)

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

extra_dependencies.calibre-lvs += $(calibre_lvs_logsfile)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

skipvpath.calibre-lvs = yes

define commands.calibre-lvs
	@echo "Layout    : $(calibre_lvs_gds)"
	@echo "Schematic : $(calibre_lvs_v)"
	@echo
	@echo '================================================================================'
	@echo 'Chip LVS (unsealed and unfilled)'
	@echo '================================================================================'
	@sed -n "/OVERALL COMPARISON RESULTS/,/\*\*\*\*/p" $(calibre_lvs_reportfile)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-lvs:
	rm -rf ./$(VPATH)/calibre-lvs
	rm -rf ./$(results_dir.calibre-lvs)
	rm -rf ./$(collect_dir.calibre-lvs)

clean-lvs: clean-calibre-lvs

# Debug

debug-lvs:
	calibredrv -m $(calibre_lvs_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -lvs $(calibre_lvs_rundir)/svdb

