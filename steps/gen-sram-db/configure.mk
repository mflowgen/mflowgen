#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates Verilog from the SRAM generator

descriptions.gen-sram-db = "Run memory compiler -- DB"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.gen-sram-db
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '#                                Generate SRAM DB                               #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.gen-sram-db = ex

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

define commands.gen-sram-db

	# Create handoff directory

	mkdir -p $(handoff_dir.gen-sram-db)

	# For every specs, invoke the memory generator

	for specs in $(var.dir)/*; do \
	  $(mem_generator) $${specs} -o $(handoff_dir.gen-sram-db) -g db; \
	done

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-gen-sram-db:
	rm -rf ./$(VPATH)/gen-sram-db
	rm -rf ./$(collect_dir.gen-sram-db)
	rm -rf ./$(handoff_dir.gen-sram-db)

clean-ex: clean-gen-sram-db

