#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : October 1, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-gds-merge = \
	"Merge the design GDS with the stdcell GDS"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-gds-merge
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Calibre -- Merge GDS -- design + stdcells'
	@echo '#-------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-gds-merge = gds-merge

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Final merged GDS

calibre_merged_gds = \
	$(handoff_dir.calibre-gds-merge)/$(design_name).gds

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.calibre-gds-merge
	mkdir -p $(logs_dir.calibre-gds-merge)
	mkdir -p $(handoff_dir.calibre-gds-merge)

# Merge the design gds with stdcell gds

	(set -x; \
	calibredrv -a layout filemerge \
		-indir $(collect_dir.calibre-gds-merge) \
		-in $(adk_dir)/stdcells.gds \
		-topcell $(design_name) \
		-out $(calibre_merged_gds) \
	) > $(logs_dir.calibre-gds-merge)/merge.log 2>&1
	@cat $(logs_dir.calibre-gds-merge)/merge.log

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-gds-merge:
	rm -rf ./$(VPATH)/calibre-gds-merge
	rm -rf ./$(logs_dir.calibre-gds-merge)
	rm -rf ./$(collect_dir.calibre-gds-merge)
	rm -rf ./$(handoff_dir.calibre-gds-merge)

clean-gds-merge: clean-calibre-gds-merge

# Debug

debug-gds-merge:
	calibredrv -m $(calibre_merged_gds) \
	           -l $(adk_dir)/calibre.layerprops

