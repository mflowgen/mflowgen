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

descriptions.calibre-stamp = \
	"Stamp the final gds"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-stamp
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Calibre -- Stamp'
	@echo '#-------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-stamp = stamp

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Logo gds

brg_logo_gds             = $(adk_dir)/brgtc2_logo.gds.gz

# Input gds

calibre_stamp_input_gds  = $(handoff_dir.calibre-fill)/filled.gds

# Output gds

calibre_stamp_output_gds = $(handoff_dir.calibre-stamp)/stamped.gds

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.calibre-stamp
	mkdir -p $(logs_dir.calibre-stamp)
	mkdir -p $(handoff_dir.calibre-stamp)

# Stamp the design by merging with the logo gds

	(set -x; \
	calibredrv -a layout filemerge \
		-in $(brg_logo_gds) \
		-in $(calibre_stamp_input_gds) \
		-createtop top_stamped \
		-out $(calibre_stamp_output_gds) \
	) > $(logs_dir.calibre-stamp)/stamp.log 2>&1
	@cat $(logs_dir.calibre-stamp)/stamp.log

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-stamp:
	rm -rf ./$(VPATH)/calibre-stamp
	rm -rf ./$(logs_dir.calibre-stamp)
	rm -rf ./$(collect_dir.calibre-stamp)
	rm -rf ./$(handoff_dir.calibre-stamp)

clean-stamp: clean-calibre-stamp

# Debug

debug-stamp:
	calibredrv -m $(calibre_stamp_output_gds) \
	           -l $(adk_dir)/calibre.layerprops

