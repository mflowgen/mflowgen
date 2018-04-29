#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates Verilog from the SRAM generator

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.gen-sram-lef
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '#                                Generate SRAM Lef                              #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.gen-sram-lef = ex

#-------------------------------------------------------------------------
# Stuff
#-------------------------------------------------------------------------

var.dir = ../../pymtl/build/srams

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-lef
	# Create Verilog SRAMs
	mkdir -p $(handoff_dir.gen-sram-lef)
	SPECS_DIR=$(var.dir) OUTPUT_DIR=$(handoff_dir.gen-sram-lef) make -f $(plugins_dir)/srams/Makefile lef
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-gen-sram-lef:
	rm -rf ./$(VPATH)/gen-sram-lef
	rm -rf ./$(collect_dir.gen-sram-lef)
	rm -rf ./$(handoff_dir.gen-sram-lef)

clean-ex: clean-gen-sram-lef

