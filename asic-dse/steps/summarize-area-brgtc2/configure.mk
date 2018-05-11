#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.summarize-area-brgtc2 = \
	"Summarize area data from dc-synthesis"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.summarize-area-brgtc2
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Summarize Area from DC-Synthesis (for BRGTC2)'
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
	./$(summarize_area_script)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

#clean-summarize-area-brgtc2:

#clean-ex: clean-summarize-area-brgtc2

