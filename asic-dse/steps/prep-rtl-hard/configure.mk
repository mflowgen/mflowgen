#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Uses a hook in the RTL to swap in the Verilog from IP (e.g., SRAMs)

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.prep-rtl-hard
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                                                                               #'
	@echo '# Prepare RTL hard'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.prep-rtl-hard = ex

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.prep-rtl-hard
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.prep-rtl-hard)
	touch $(handoff_dir.prep-rtl-hard)/example-output.txt
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-prep-rtl-hard:
	rm -rf ./$(VPATH)/prep-rtl-hard
	rm -rf ./$(collect_dir.prep-rtl-hard)
	rm -rf ./$(handoff_dir.prep-rtl-hard)

clean-ex: clean-prep-rtl-hard

