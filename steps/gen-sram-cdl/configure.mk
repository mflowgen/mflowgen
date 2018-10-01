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

var.dir = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/Chansey-sram
mem_generator = $(plugins_dir)/srams/gen-srams

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-cdl

	# Create handoff directory

	mkdir -p $(handoff_dir.gen-sram-cdl)

	# For every specs, invoke the memory generator

	for specs in $(var.dir)/*; do \
	  $(mem_generator) $${specs} -o $(handoff_dir.gen-sram-cdl) -g cdl; \
	done

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

