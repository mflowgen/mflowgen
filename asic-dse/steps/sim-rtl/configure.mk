#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Run the VCS simulator

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.sim-rtl
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# Sim RTL'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.sim-rtl =

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

sim_rtl_simulator_dir  = $(collect_dir.sim-rtl)
sim_rtl_simv           = $(sim_rtl_simulator_dir)/simv

# Run options

#sim_rtl_run_options += +test=basic_0x0

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.sim-rtl
	./$(sim_rtl_simv) $(sim_rtl_run_options)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-sim-rtl:
	rm -rf ./$(VPATH)/sim-rtl
	rm -rf ./$(collect_dir.sim-rtl)
	rm -rf ./$(handoff_dir.sim-rtl)

clean-ex: clean-sim-rtl

