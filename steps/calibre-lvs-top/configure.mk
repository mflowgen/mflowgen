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

descriptions.calibre-lvs-top = \
	"LVS for sealed and filled design"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-lvs-top
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                            _     __      __  _____                            #'
	@echo '#                           | |    \ \    / / / ____|                           #'
	@echo '#                           | |     \ \  / / | (___                             #'
	@echo '#                           | |      \ \/ /   \___ \                            #'
	@echo '#                           | |____   \  /    ____) |                           #'
	@echo '#                           |______|   \/    |_____/                            #'
	@echo '#                                    T  O  P                                    #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-lvs-top = lvs-top

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The GDS and LVS netlist are available from a previous step

# Unfortunately, the intermediate LVS target will try to run before the
# build system has constructed the collect dir, so we temporarily
# magically reach into the correct handoff dir.

calibre_lvs_top_gds = $(handoff_dir.calibre-stamp)/stamped.gds
calibre_lvs_top_v   = $(wildcard $(handoff_dir.innovus-signoff)/*.lvs.v)

# Also pull in any extra files we need (e.g., SRAM cdl)

calibre_lvs_top_extras += $(wildcard $(handoff_dir.gen-sram-cdl)/*.cdl)

#-------------------------------------------------------------------------
# BRGTC2-specific netlists
#-------------------------------------------------------------------------

pll_lvs_v = $(wildcard /work/global/brgtc2/pll-innovus/*.lvs.v)

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Runset files -- the template will be populated to generate the runset

calibre_lvs_top_runset_template = $(plugins_dir)/calibre/lvs-top.runset.template
calibre_lvs_top_runset          = $(results_dir.calibre-lvs-top)/lvs-top.runset

# Common variables to substitute into the runset template
#
# Note: Some of the paths must be absolute

export calibre_lvs_top_rulesfile      = $(adk_dir)/calibre-lvs.rule
export calibre_lvs_top_rundir         = $(PWD)/$(results_dir.calibre-lvs-top)

export calibre_lvs_top_layoutpaths    = $(PWD)/$(calibre_lvs_top_gds)
export calibre_lvs_top_layoutprimary  = $(design_name)_design
export calibre_lvs_top_extractedspice = $(calibre_lvs_top_rundir)/lvs.extracted.sp

export calibre_lvs_top_sourcepath     = $(PWD)/$(calibre_lvs_top_v)
export calibre_lvs_top_sourcepath    += $(pll_lvs_v)
export calibre_lvs_top_sourceprimary  = $(design_name)

export calibre_lvs_top_logsfile       = $(calibre_lvs_top_rundir)/lvs.log
export calibre_lvs_top_ercdatabase    = $(calibre_lvs_top_rundir)/lvs.erc.results
export calibre_lvs_top_ercsummaryfile = $(calibre_lvs_top_rundir)/lvs.erc.summary
export calibre_lvs_top_reportfile     = $(calibre_lvs_top_rundir)/lvs.report

calibre_lvs_top_spiceincfiles        += $(adk_dir)/stdcells.cdl
calibre_lvs_top_spiceincfiles        += $(adk_dir)/iocells.spi
calibre_lvs_top_spiceincfiles        += $(foreach x, $(calibre_lvs_top_extras),$(PWD)/$x)

export calibre_lvs_top_spiceincfiles

#-------------------------------------------------------------------------
# Targets for LVS checks
#-------------------------------------------------------------------------

# Chip LVS (Filled)

$(calibre_lvs_top_logsfile): $(dependencies.calibre-lvs-top)
	@mkdir -p $(results_dir.calibre-lvs-top)
	@touch $@.start
	@echo '================================================================================'
	@echo 'Chip LVS (Sealed and filled)'
	@echo '================================================================================'
# Select the LVS rules file and generate the lvs runset from the template
	envsubst < $(calibre_lvs_top_runset_template) > $(calibre_lvs_top_runset)
# Run lvs using the runset
	calibre -gui -lvs -batch -runset $(calibre_lvs_top_runset)

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

extra_dependencies.calibre-lvs-top += $(calibre_lvs_top_logsfile)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

skipvpath.calibre-lvs-top = yes

define commands.calibre-lvs-top
	@echo "Layout    : $(calibre_lvs_top_gds)"
	@echo "Schematic : $(calibre_lvs_top_v)"
	@echo
	@echo '================================================================================'
	@echo 'Chip LVS (sealed and filled)'
	@echo '================================================================================'
	@sed -n "/OVERALL COMPARISON RESULTS/,/\*\*\*\*/p" $(calibre_lvs_top_reportfile)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-lvs-top:
	rm -rf ./$(VPATH)/calibre-lvs-top
	rm -rf ./$(results_dir.calibre-lvs-top)
	rm -rf ./$(collect_dir.calibre-lvs-top)

clean-lvs-top: clean-calibre-lvs-top

# Debug

debug-lvs-top:
	calibredrv -m $(calibre_lvs_top_gds) \
	           -l $(adk_dir)/calibre.layerprops \
	           -rve -lvs $(calibre_lvs_top_rundir)/svdb

