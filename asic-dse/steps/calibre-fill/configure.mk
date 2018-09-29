#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 9, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-fill = \
	"Run OD/PO and metal fill"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-fill
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Calibre -- Run OD/PO and Metal Fill'
	@echo '#-------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-fill = fill

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------
# The fill utility reads the input GDS and generates a GDS with fill
# shapes. The fill GDS has the same instance name as the input GDS
# toplevel. We just need to merge the two GDS files and we are done.

# Input GDS to fill

calibre_fill_input_gds  = $(collect_dir.calibre-fill)/sealed.gds

# Output GDS with fill shapes

calibre_fill_fill_gds   = $(handoff_dir.calibre-fill)/fill.gds

# Merged GDS with filled design

calibre_fill_output_gds = $(handoff_dir.calibre-fill)/filled.gds

# Runset files -- the template will be populated to generate the runset

calibre_fill_runset_template = $(plugins_dir)/calibre/fill.runset.template
calibre_fill_runset          = $(results_dir.calibre-fill)/fill.runset

# Variables to substitute into the runset template
#
# Note: The paths must be absolute or Calibre will complain

export calibre_fill_rulesfile      = $(adk_dir)/calibre-fill.rule
export calibre_fill_rundir         = $(PWD)/$(results_dir.calibre-fill)
export calibre_fill_layoutpaths    = $(PWD)/$(calibre_fill_input_gds)
export calibre_fill_layoutprimary  = top_sealed
export calibre_fill_resultsfile    = $(PWD)/$(calibre_fill_fill_gds)
export calibre_fill_transcriptfile = $(PWD)/$(logs_dir.calibre-fill)/fill.log

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.calibre-fill
	mkdir -p $(logs_dir.calibre-fill)
	mkdir -p $(results_dir.calibre-fill)
# Generate the drc runset from the template
	envsubst < $(calibre_fill_runset_template) > $(calibre_fill_runset)
# Run fill using the runset
	calibre -gui -drc -batch -runset $(calibre_fill_runset)
# Merge the design with the fill gds
	(set -x; \
	calibredrv -a layout filemerge \
		-infile [list -name $(calibre_fill_input_gds) -suffix _design] \
		-infile [list -name $(calibre_fill_fill_gds) -suffix _fill] \
		-createtop top_filled \
		-out $(calibre_fill_output_gds) \
	) > $(logs_dir.calibre-fill)/fill-merge.log 2>&1
	@cat $(logs_dir.calibre-fill)/fill-merge.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-fill:
	rm -rf ./$(VPATH)/calibre-fill
	rm -rf ./$(logs_dir.calibre-fill)
	rm -rf ./$(results_dir.calibre-fill)
	rm -rf ./$(collect_dir.calibre-fill)
	rm -rf ./$(handoff_dir.calibre-fill)

clean-fill: clean-calibre-fill

# Debug

debug-fill-fill:
	calibredrv -m $(calibre_fill_fill_gds) \
	           -l $(adk_dir)/calibre.layerprops

debug-fill-top:
	calibredrv -m $(calibre_fill_output_gds) \
	           -l $(adk_dir)/calibre.layerprops

