#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates GDS from the SRAM generator

descriptions.gen-sram-gds = "Run memory compiler -- GDS"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.gen-sram-gds
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '#                                Generate SRAM gds                              #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.gen-sram-gds = ex

#-------------------------------------------------------------------------
# Stuff
#-------------------------------------------------------------------------

var.dir = ../../pymtl/build/srams

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-gds
	mkdir -p $(handoff_dir.gen-sram-gds)
	SPECS_DIR=$(var.dir) OUTPUT_DIR=$(handoff_dir.gen-sram-gds) make -f $(plugins_dir)/srams/Makefile gds
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-gen-sram-gds:
	rm -rf ./$(VPATH)/gen-sram-gds
	rm -rf ./$(collect_dir.gen-sram-gds)
	rm -rf ./$(handoff_dir.gen-sram-gds)

clean-ex: clean-gen-sram-gds

