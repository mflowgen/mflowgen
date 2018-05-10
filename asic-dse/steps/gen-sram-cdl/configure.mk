#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates CDL from the SRAM generator

descriptions.gen-sram-cdl = "Run memory compiler -- CDL (for LVS)"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.gen-sram-cdl
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '#                                Generate SRAM cdl                              #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.gen-sram-cdl = ex

#-------------------------------------------------------------------------
# Stuff
#-------------------------------------------------------------------------

var.dir = ../../pymtl/build/srams

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-cdl
	mkdir -p $(handoff_dir.gen-sram-cdl)
	SPECS_DIR=$(var.dir) OUTPUT_DIR=$(handoff_dir.gen-sram-cdl) make -f $(plugins_dir)/srams/Makefile cdl
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-gen-sram-cdl:
	rm -rf ./$(VPATH)/gen-sram-cdl
	rm -rf ./$(collect_dir.gen-sram-cdl)
	rm -rf ./$(handoff_dir.gen-sram-cdl)

clean-ex: clean-gen-sram-cdl

