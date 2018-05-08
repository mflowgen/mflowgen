#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Build the VCS simulator with options for post-APR SDF mode
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
#
# X-handling
#
# - There are no X-suppression flags used
#

descriptions.vcs-aprsdfx-build = \
	"Post-APR SDF -- full X"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.vcs-aprsdfx-build
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# VCS APR-SDF Build -- Full X'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.vcs-aprsdfx-build =

#-------------------------------------------------------------------------
# Post-APR-SDF-specific structural options
#-------------------------------------------------------------------------
# These are common options across VCS simulation steps, but they need to
# know the exact directory names to set up for the step.

# Specify the simulator binary and simulator compile directory

vcs_aprsdfx_build_simv  = $(handoff_dir.vcs-aprsdfx-build)/simv
vcs_aprsdfx_compile_dir = $(handoff_dir.vcs-aprsdfx-build)/csrc

vcs_aprsdfx_structural_options += -o $(vcs_aprsdfx_build_simv)
vcs_aprsdfx_structural_options += -Mdir=$(vcs_aprsdfx_compile_dir)

# Library files -- Any collected verilog (e.g., SRAMs)

vcs_aprsdfx_structural_options += \
	$(foreach f, $(wildcard $(collect_dir.sim-aprsdfx-build)/*.v),-v $f)

# Include directory -- Any collected includes are made available

vcs_aprsdfx_structural_options += +incdir+$(collect_dir.vcs-aprsdfx-build)

# Dump the bill of materials + file list to help double-check src files

vcs_aprsdfx_structural_options += -bom $(sim_test_harness_top)
vcs_aprsdfx_structural_options += -bfl $(logs_dir.vcs-aprsdfx-build)/vcs_filelist

#-------------------------------------------------------------------------
# Post-APR-SDF-specific custom options
#-------------------------------------------------------------------------

# Gate-level model (magically reach into innovus results dir)

vcs_aprsdfx_custom_options += \
	$(wildcard $(innovus_results_dir)/*.vcs.v)

# Library files -- IO cells and stdcells

vcs_aprsdfx_custom_options += -v $(adk_dir)/iocells.v
vcs_aprsdfx_custom_options += -v $(adk_dir)/stdcells.v

# Performance options for post-APR SDF simulation

vcs_aprsdfx_custom_options += -hsopt=gates

# Suppress lint and warnings

vcs_aprsdfx_custom_options += +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE

# SDF-related options

vcs_aprsdfx_custom_options += +sdfverbose
vcs_aprsdfx_custom_options += +overlap
vcs_aprsdfx_custom_options += +multisource_int_delays
vcs_aprsdfx_custom_options += +neg_tchk
vcs_aprsdfx_custom_options += -negdelay

# Pull in the Innovus SDF file

vcs_aprsdfx_custom_options += \
	-sdf max:$(design_name):$(wildcard $(innovus_results_dir)/*.sdf)

#-------------------------------------------------------------------------
# Modeling options and X-handling
#-------------------------------------------------------------------------

# Use ARM neg delay model of stdcells with annotation

vcs_aprsdfx_custom_options += +define+ARM_NEG_MODEL

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

vcs_aprsdfx_build_log = $(logs_dir.vcs-aprsdfx-build)/build.log

define commands.vcs-aprsdfx-build

	mkdir -p $(logs_dir.vcs-aprsdfx-build)
	mkdir -p $(handoff_dir.vcs-aprsdfx-build)

# Record the options used to build the simulator

	@echo "vcs_common_options = $(vcs_common_options)" \
		>  $(vcs_aprsdfx_build_log)
	@echo "vcs_design_options = $(vcs_design_options)" \
		>> $(vcs_aprsdfx_build_log)
	@echo "vcs_aprsdfx_structural_options = $(vcs_aprsdfx_structural_options)" \
		>> $(vcs_aprsdfx_build_log)
	@echo "vcs_aprsdfx_custom_options = $(vcs_aprsdfx_custom_options)" \
		>> $(vcs_aprsdfx_build_log)
	@printf "%.s-" {1..80} >> $(vcs_aprsdfx_build_log)
	@echo >> $(vcs_aprsdfx_build_log)
	@echo "vcs $(vcs_common_options) $(vcs_design_options) $(vcs_aprsdfx_structural_options) $(vcs_aprsdfx_custom_options)" \
		>> $(vcs_aprsdfx_build_log)
	@printf "%.s-" {1..80} >> $(vcs_aprsdfx_build_log)
	@echo >> $(vcs_aprsdfx_build_log)

# Build the simulator

	vcs $(vcs_common_options) $(vcs_design_options) $(vcs_aprsdfx_structural_options) $(vcs_aprsdfx_custom_options) \
		| tee -a $(vcs_aprsdfx_build_log)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-vcs-aprsdfx-build:
	rm -rf ./$(VPATH)/vcs-aprsdfx-build
	rm -rf ./$(logs_dir.vcs-aprsdfx-build)
	rm -rf ./$(collect_dir.vcs-aprsdfx-build)
	rm -rf ./$(handoff_dir.vcs-aprsdfx-build)

#clean-ex: clean-vcs-aprsdfx-build

