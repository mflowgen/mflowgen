#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates DBs from the SRAM generator

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.gen-sram-db
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '# Generate SRAM db '
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.gen-sram-db = ex

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.gen-sram-db
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.gen-sram-db)
	touch $(handoff_dir.gen-sram-db)/example-output.txt
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

