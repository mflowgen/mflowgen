#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 11, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.summarize-area-brgtc2 = \
	"Summarize area data from dc-synthesis"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

summarize_area_clock_frequency = $(shell echo "1000/$(clock_period)" | bc)

define ascii.summarize-area-brgtc2
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Area Summary -- DC Synthesis ($(design_name), $(summarize_area_clock_frequency) MHz)'
	@echo '#-------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.summarize-area-brgtc2 = area

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# Path to script

summarize_area_script = $(plugins_dir)/dc-synthesis/summarize_area.py

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

skipvpath.summarize-area-brgtc2 = yes

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.summarize-area-brgtc2
	@./$(summarize_area_script)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

area-long:
	$(ascii.summarize-area-brgtc2)
	@./$(summarize_area_script) --detailed

# Clean

#clean-summarize-area-brgtc2:

#clean-ex: clean-summarize-area-brgtc2

