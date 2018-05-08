#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# This is not really a real step. It just collects common VCS options into
# one place. As long as it is listed as a step in an assembled flow's
# "setup-flow.mk", these variables will be available. This step does not
# need to appear in any dependencies.

descriptions.vcs-common-build = \
	"Fake target that gathers all common VCS build options in one place"

#-------------------------------------------------------------------------
# VCS Common Options
#-------------------------------------------------------------------------
# These are the common options used across all VCS simulation

vcs_common_options += -full64 -sverilog +v2k +vc -notice -V
vcs_common_options += +libext+.v
vcs_common_options += +noportcoerce

# Useful diagnostics
#
# - timescale : shows timescales for all modules to check for consistency
# - env       : dumps the environment vars at time of simulation

vcs_common_options += -diag timescale
vcs_common_options += -diag env

# Enable dumping waveforms

vcs_common_options += -debug_pp

# The timescale may need to be tweaked so that the timescales in all IP
# verilog match and use consistent units for their "pound-delays"

vcs_common_options += -timescale=1ns/1ps

# Dump info about how registers were initialized with +vcs+initreg

export VCS_PRINT_INITREG_INITIALIZATION=1

# Libconfig logs are useful to see what source code VCS is using for each
# instance. The dump is large, so this can be turned on with LIBCONFIG=yes
# when running make. Highly recommend dumping this to a file.

ifdef LIBCONFIG
vcs_common_options += -diag libconfig
endif

#-------------------------------------------------------------------------
# Design-specific options
#-------------------------------------------------------------------------

# Specify the verilog test harness, and the top module

sim_test_harness_v   = $(relative_base_dir)/$(test_harness_v)
sim_test_harness_top = $(test_harness_top)

vcs_design_options  += $(sim_test_harness_v)
vcs_design_options  += -top $(sim_test_harness_top)

# Support `include vc, which is currently in rtl-handoff

vcs_design_options  += +incdir+$(relative_base_dir)/rtl-handoff

# Pull in any extra includes

vcs_design_options  += $(foreach f, $(extra_includes),-v $(relative_base_dir)/$f)

#-------------------------------------------------------------------------
# Run options
#-------------------------------------------------------------------------

ifdef VPD
vcs_run_options += +vcdplusfile=$(VPD).vpd
endif

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-vcs:
	rm -rf ./$(VPATH)/vcs*
	rm -rf ./$(logs_dir)/vcs*
	rm -rf ./$(reports_dir)/vcs*
	rm -rf ./$(results_dir)/vcs*
	rm -rf ./$(collect_dir)/vcs*
	rm -rf ./$(handoff_dir)/vcs*

