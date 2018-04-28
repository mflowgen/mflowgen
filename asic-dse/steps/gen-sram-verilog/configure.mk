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

define ascii.gen-sram-verilog
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '# Generate SRAM Verilog '
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.gen-sram-verilog = ex

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-verilog
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.gen-sram-verilog)
	touch $(handoff_dir.gen-sram-verilog)/example-output.txt
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-gen-sram-verilog:
	rm -rf ./$(VPATH)/gen-sram-verilog
	rm -rf ./$(collect_dir.gen-sram-verilog)
	rm -rf ./$(handoff_dir.gen-sram-verilog)

clean-ex: clean-gen-sram-verilog

