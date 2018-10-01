#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 6, 2018

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

# Enable dumping waveforms

vcs_common_options += -debug_pp

# Dump info about how registers were initialized with +vcs+initreg

export VCS_PRINT_INITREG_INITIALIZATION=1

# Useful diagnostics
#
# - timescale : shows timescales for all modules to check for consistency
# - env       : dumps the environment vars at time of simulation

vcs_common_options += -diag timescale
vcs_common_options += -diag env

# Libconfig logs are useful to see what source code VCS is using for each
# instance. The dump is large, so this can be turned on with LIBCONFIG=yes
# when running make. Highly recommend dumping this to a file.

ifdef LIBCONFIG
vcs_common_options += -diag libconfig
endif

# The timescale may need to be tweaked so that the timescales in all IP
# verilog match and use consistent units for their "pound-delays"

vcs_common_options += -timescale=1ns/1ps

# Enable certain error-checking cases
#
# If there are problems with the verilog config, modules will be mapped to
# the wrong verilog source definitions. They are warnings by default, but
# they should be errors, so we enable errors for these cases here:
#
# - Warning-[CIRNU] Config instance rule not used
#   Instance 'top.th.swshim.dut' may not exist in the scope of the sign
#   for which the configuration was attempted.
#

vcs_common_options += -error=CIRNU

# Enable error-checking when ports and connections mismatch in bit-width
#
# This is very important to double-check on parameterized input and output
# ports. Ignoring this warning caused bugs in every tests related to data
# caches. We configured the test memory to have data interface with 32-bit
# bit-width. This caused the memory to slice the wrong bits from incoming
# requests. Since the very first bits are data and data is 128-bit for the
# other end of the interface, the test memory was extracting the data as
# different request fields. Since request for memory reads have X's in the
# data and thus the memory read request will be all X's for all fields
# including address. So we want to catch these warning:
#
# Lint-[CAWM-L] Width mismatch
# ../rtl-handoff/vc/vc-TestMemory_1i1d.v, 94
#   Continuous assignment width mismatch
#   5 bits (lhs) versus 32 bits (rhs).
#   Source info: assign imemreq0_msg_len_modified_M = ((imemreq0_msg[((p_i_nbits
#   + $clog2((p_i_nbits / 8))) - 1):p_i_nbits] == 0) ? (p_i_nbits / 8) :
#   imemreq0_msg[((p_i_nbits  ...

vcs_common_options += -error=CAWM-L

#-------------------------------------------------------------------------
# Design-specific options
#-------------------------------------------------------------------------

# Specify the verilog config and the top module

vcs_design_options += $(plugins_dir)/sim/brg_config.v
vcs_design_options += -top brg_config

# Support `include vc, which is currently in rtl-handoff

vcs_design_options += +incdir+$(relative_base_dir)/rtl-handoff

# Pull in testing files as design files

vcs_design_options += $(foreach f, $(testing_files),$(relative_base_dir)/$f)

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

