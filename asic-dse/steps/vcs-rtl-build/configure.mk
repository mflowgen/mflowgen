#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Build the VCS simulator with options for RTL
#
# This step depends on the "vcs-common-build" step, which is a fake target
# that gathers common VCS build options:
#
# - vcs_common_options
# - vcs_design_options
#
# This step also depends on the "sim-prep" step, which generates the
# Verilog snippet that is `included in the test harness and that contains
# all of the test cases.

descriptions.vcs-rtl-build = "Build the RTL simulator"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.vcs-rtl-build
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# VCS RTL Build'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.vcs-rtl-build =

#-------------------------------------------------------------------------
# RTL-specific options
#-------------------------------------------------------------------------

# Specify the simulator binary and simulator compile directory

vcs_rtl_build_simv  = $(handoff_dir.vcs-rtl-build)/simv
vcs_rtl_compile_dir = $(handoff_dir.vcs-rtl-build)/csrc

vcs_rtl_options    += -o $(vcs_rtl_build_simv)
vcs_rtl_options    += -Mdir=$(vcs_rtl_compile_dir)

# Library files -- IO cells

vcs_rtl_options += -v $(adk_dir)/iocells.v

# Library files -- Miscellaneous collected verilog (e.g., SRAMs)

vcs_rtl_options += \
	$(foreach x, $(wildcard $(collect_dir.sim-rtl-build)/*.v),-v $x)

# The test harness uses an `include statement to include the test_cases
# verilog, which was collected from the "sim-prep" step. We can tell VCS
# about this directory by specifying this step's collect directory as a
# VCS include directory.

vcs_rtl_options  += +incdir+$(collect_dir.vcs-rtl-build)

# Dump the bill of materials + file list to help double-check src files

vcs_rtl_options += -bom $(sim_test_harness_top)
vcs_rtl_options += -bfl $(logs_dir.vcs-rtl-build)/vcs_filelist

# Performance options for RTL simulation

vcs_rtl_options += -rad

# Disable timing checks

vcs_rtl_options += +notimingcheck +nospecify

# Register initialization

ifdef INITREG
vcs_rtl_options += +vcs+initreg+random
endif

# Suppress lint and warnings

vcs_rtl_options += +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.vcs-rtl-build
	mkdir -p $(logs_dir.vcs-rtl-build)
	mkdir -p $(handoff_dir.vcs-rtl-build)
# Build the simulator
	@echo "vcs $(vcs_design_options) $(vcs_common_options) $(vcs_rtl_options)" \
		> $(logs_dir.vcs-rtl-build)/build.log
	vcs $(vcs_design_options) $(vcs_common_options) $(vcs_rtl_options) \
		| tee -a $(logs_dir.vcs-rtl-build)/build.log
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-vcs-rtl-build:
	rm -rf ./$(VPATH)/vcs-rtl-build
	rm -rf ./$(logs_dir.vcs-rtl-build)
	rm -rf ./$(collect_dir.vcs-rtl-build)
	rm -rf ./$(handoff_dir.vcs-rtl-build)

#clean-ex: clean-vcs-rtl-build

