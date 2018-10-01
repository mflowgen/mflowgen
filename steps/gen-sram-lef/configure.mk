#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates Verilog from the SRAM generator

descriptions.gen-sram-lef = "Run memory compiler -- LEF"

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

var.dir = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/Chansey-sram
mem_generator = $(plugins_dir)/srams/gen-srams

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-lef

	# Create handoff directory

	mkdir -p $(handoff_dir.gen-sram-lef)

	# For every specs, invoke the memory generator

	for specs in $(var.dir)/*; do \
	  $(mem_generator) $${specs} -o $(handoff_dir.gen-sram-lef) -g lef; \
	done

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

