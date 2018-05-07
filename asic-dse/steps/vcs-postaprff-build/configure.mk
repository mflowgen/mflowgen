#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------
# Build the VCS simulator with options for post-APR fast-functional mode
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

descriptions.vcs-postaprff-build = "Build the post-APR fast-functional simulator"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.vcs-postaprff-build
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# VCS Post-APR FF Build'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.vcs-postaprff-build =

#-------------------------------------------------------------------------
# Post-APR-FF-specific structural options
#-------------------------------------------------------------------------
# These are common options across VCS simulation steps, but they need to
# know the exact directory names to set up for the step.

# Specify the simulator binary and simulator compile directory

vcs_postaprff_build_simv  = $(handoff_dir.vcs-postaprff-build)/simv
vcs_postaprff_compile_dir = $(handoff_dir.vcs-postaprff-build)/csrc

vcs_postaprff_structural_options += -o $(vcs_postaprff_build_simv)
vcs_postaprff_structural_options += -Mdir=$(vcs_postaprff_compile_dir)

# Library files -- Any collected verilog (e.g., SRAMs)

vcs_postaprff_structural_options += \
	$(foreach f, $(wildcard $(collect_dir.sim-postaprff-build)/*.v),-v $f)

# Include directory -- Any collected includes are made available

vcs_postaprff_structural_options += +incdir+$(collect_dir.vcs-postaprff-build)

# Dump the bill of materials + file list to help double-check src files

vcs_postaprff_structural_options += -bom $(sim_test_harness_top)
vcs_postaprff_structural_options += -bfl $(logs_dir.vcs-postaprff-build)/vcs_filelist

#-------------------------------------------------------------------------
# Post-APR-FF-specific custom options
#-------------------------------------------------------------------------

# Gate-level model (magically reach into innovus results dir)

vcs_postaprff_custom_options += \
	$(wildcard $(innovus_results_dir)/*.vcs.v)

# Library files -- IO cells and stdcells

vcs_postaprff_custom_options += -v $(adk_dir)/iocells.v
vcs_postaprff_custom_options += -v $(adk_dir)/stdcells.v

# Performance options for post-APR FF simulation

vcs_postaprff_custom_options += -hsopt=gates
vcs_postaprff_custom_options += -rad

# Disable timing checks

vcs_postaprff_custom_options += +notimingcheck

# Register initialization

#ifdef INITREG
vcs_postaprff_custom_options += +vcs+initreg+random
#endif

# Suppress lint and warnings

vcs_postaprff_custom_options += +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE

# ARM memories can be initialized to 0 to avoid unknown outputs (according
# to "ARM® 28nm TSMC CLN28HPC EDA Tools Support, Revision: r0p0,
# Application Note", "arm_28nm_tsmc_cln28hpc_eda_an_100298_0000_a.pdf")

vcs_postaprff_custom_options += +define+INITIALIZE_MEMORY

# ARM Fast functional Verilog model
#
# Excerpt from "ARM® 28nm TSMC CLN28HPC EDA Tools Support, Revision: r0p0,
# Application Note", "arm_28nm_tsmc_cln28hpc_eda_an_100298_0000_a.pdf")
#
#     The fast functional model is a unit delay model. The following is a
#     typical use of the fast functional model:
#
#     1. Create the Verilog model.
#     2. Compare the default delays to your design.
#     3. Re-apply required delays, combinational, sequential, clock, and
#        BIST.
#

vcs_postaprff_custom_options += +define+ARM_UD_MODEL

#vcs_postaprff_custom_options += +define+ARM_UD_CP=\#0
#vcs_postaprff_custom_options += +define+ARM_UD_DLY=\#0
#vcs_postaprff_custom_options += +define+ARM_UD_DP=\#0
#vcs_postaprff_custom_options += +define+ARM_UD_SEQ=\#0.001

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

vcs_postaprff_build_log = $(logs_dir.vcs-postaprff-build)/build.log

define commands.vcs-postaprff-build

	mkdir -p $(logs_dir.vcs-postaprff-build)
	mkdir -p $(handoff_dir.vcs-postaprff-build)

# Record the options used to build the simulator

	@echo "vcs_common_options = $(vcs_common_options)" \
		>  $(vcs_postaprff_build_log)
	@echo "vcs_design_options = $(vcs_design_options)" \
		>> $(vcs_postaprff_build_log)
	@echo "vcs_postaprff_structural_options = $(vcs_postaprff_structural_options)" \
		>> $(vcs_postaprff_build_log)
	@echo "vcs_postaprff_custom_options = $(vcs_postaprff_custom_options)" \
		>> $(vcs_postaprff_build_log)
	@printf "%.s-" {1..80} >> $(vcs_postaprff_build_log)
	@echo >> $(vcs_postaprff_build_log)
	@echo "vcs $(vcs_common_options) $(vcs_design_options) $(vcs_postaprff_structural_options) $(vcs_postaprff_custom_options)" \
		>> $(vcs_postaprff_build_log)
	@printf "%.s-" {1..80} >> $(vcs_postaprff_build_log)
	@echo >> $(vcs_postaprff_build_log)

# Build the simulator

	vcs $(vcs_common_options) $(vcs_design_options) $(vcs_postaprff_structural_options) $(vcs_postaprff_custom_options) \
		| tee -a $(vcs_postaprff_build_log)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-vcs-postaprff-build:
	rm -rf ./$(VPATH)/vcs-postaprff-build
	rm -rf ./$(logs_dir.vcs-postaprff-build)
	rm -rf ./$(collect_dir.vcs-postaprff-build)
	rm -rf ./$(handoff_dir.vcs-postaprff-build)

#clean-ex: clean-vcs-postaprff-build

