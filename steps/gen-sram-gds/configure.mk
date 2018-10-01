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

var.dir = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/Chansey-sram
mem_generator = $(plugins_dir)/srams/gen-srams

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-gds

	# Create handoff directory

	mkdir -p $(handoff_dir.gen-sram-gds)

	# For every specs, invoke the memory generator

	for specs in $(var.dir)/*; do \
	  $(mem_generator) $${specs} -o $(handoff_dir.gen-sram-gds) -g gds; \
	done

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

