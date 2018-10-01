#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Generates the simulator for rtl hard in the scratch space

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.sim-rtl-hard
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '# Simulate RTL Hard'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.sim-rtl-hard = ex

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.sim-rtl-hard
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.sim-rtl-hard)
	touch $(handoff_dir.sim-rtl-hard)/example-output.txt
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-sim-rtl-hard:
	rm -rf ./$(VPATH)/sim-rtl-hard
	rm -rf ./$(collect_dir.sim-rtl-hard)
	rm -rf ./$(handoff_dir.sim-rtl-hard)

clean-ex: clean-sim-rtl-hard

