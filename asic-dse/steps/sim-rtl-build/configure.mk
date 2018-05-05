#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Build the VCS simulator with options for RTL

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.sim-rtl-build
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# Sim RTL (build)'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.sim-rtl-build =

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

#sim_rtl_build_handoff_v      = $(relative_base_dir)/$(verilog_src)
#sim_rtl_build_test_harness_v = ../rtl-handoff/brgtc2-th.v

sim_rtl_build_handoff_v        = ../rtl-handoff/dff/dut.v
sim_rtl_build_test_harness_v   = ../rtl-handoff/dff/th.v
sim_rtl_build_test_harness_top = th

sim_rtl_build_simulator_dir  = $(handoff_dir.sim-rtl-build)
sim_rtl_build_simv           = $(sim_rtl_build_simulator_dir)/simv

# Compile options

sim_rtl_build_compile_options += -o $(sim_rtl_build_simv)
sim_rtl_build_compile_options += -Mdir=$(sim_rtl_build_simulator_dir)/csrc
sim_rtl_build_compile_options += -full64 -sverilog -timescale=1ns/1ps
sim_rtl_build_compile_options += -rad
sim_rtl_build_compile_options += +notimingcheck
sim_rtl_build_compile_options += -v $(sim_rtl_build_handoff_v)
sim_rtl_build_compile_options += -v $(adk_dir)/stdcells.v
sim_rtl_build_compile_options += -top $(sim_rtl_build_test_harness_top)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.sim-rtl-build
	mkdir -p $(handoff_dir.sim-rtl-build)
	vcs $(sim_rtl_build_compile_options) $(sim_rtl_build_test_harness_v)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-sim-rtl-build:
	rm -rf ./$(VPATH)/sim-rtl-build
	rm -rf ./$(collect_dir.sim-rtl-build)
	rm -rf ./$(handoff_dir.sim-rtl-build)

clean-ex: clean-sim-rtl-build

