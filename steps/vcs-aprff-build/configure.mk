#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 8, 2018

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
#
# X-handling
#
# - Squash X's with ARM_EN_X_SQUASH
# - Initialize registers
# - Initialize memory
#

descriptions.vcs-aprff-build = \
	"Post-APR FF -- Xs squashed, init reg, init mem"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.vcs-aprff-build
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# VCS APR-FF Build -- Xs squashed, init reg, init mem'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.vcs-aprff-build =

#-------------------------------------------------------------------------
# Post-APR-FF-specific structural options
#-------------------------------------------------------------------------
# These are common options across VCS simulation steps, but they need to
# know the exact directory names to set up for the step.

# Specify the simulator binary and simulator compile directory

vcs_aprff_build_simv  = $(handoff_dir.vcs-aprff-build)/simv
vcs_aprff_compile_dir = $(handoff_dir.vcs-aprff-build)/csrc

vcs_aprff_structural_options += -o $(vcs_aprff_build_simv)
vcs_aprff_structural_options += -Mdir=$(vcs_aprff_compile_dir)

# Include directory -- Any collected includes are made available

vcs_aprff_structural_options += +incdir+$(collect_dir.vcs-aprff-build)

# Dump the bill of materials + file list to help double-check src files

vcs_aprff_structural_options += -bom top
vcs_aprff_structural_options += -bfl $(logs_dir.vcs-aprff-build)/vcs_filelist

#-------------------------------------------------------------------------
# Post-APR-FF-specific custom options
#-------------------------------------------------------------------------

# Gate-level model (magically reach into innovus results dir)

vcs_aprff_gl_model        = $(wildcard $(innovus_results_dir)/*.vcs.v)
vcs_aprff_custom_options += -v $(vcs_aprff_gl_model)

# Library files -- IO cells and stdcells

vcs_aprff_custom_options += -v $(adk_dir)/iocells.v
vcs_aprff_custom_options += -v $(adk_dir)/stdcells.v

# Library files -- SRAMs (magically reach into handoff dir)

vcs_aprff_srams = $(wildcard $(PWD)/$(handoff_dir.gen-sram-verilog)/*.v)
vcs_aprff_custom_options += $(foreach f, $(vcs_aprff_srams),-v $f)

# Performance options for post-APR FF simulation


# hawajkm:
#   We cannot have -hsopt=gates or -hsopt=udp when using +vcs+initreg+config.
#   vcs spits out the following messages
#
#        Error-[UNSUPP-W-HSGATES] Unsupported option combination used.
#          Option '+vcs+initreg+config' is not supported with '-hsopt=gates or 
#          -hsopt=udp'.
#
#
#vcs_aprff_custom_options += -hsopt=gates
vcs_aprff_custom_options += -rad

# Disable timing checks

vcs_aprff_custom_options += +notimingcheck +nospecify

# Suppress lint and warnings

vcs_aprff_custom_options += +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE

# Testing library map -- the tests will only use files from this library

vcs_aprff_testing_library  = $(handoff_dir.vcs-aprff-build)/testing.library
vcs_aprff_custom_options  += -libmap $(vcs_aprff_testing_library)

# Design library map -- the design will only use files from this library

vcs_aprff_design_library  = $(handoff_dir.vcs-aprff-build)/design.library
vcs_aprff_custom_options += -libmap $(vcs_aprff_design_library)

#-------------------------------------------------------------------------
# Modeling options and X-handling
#-------------------------------------------------------------------------

# Use ARM fast-functional model of stdcells and memory

vcs_aprff_custom_options += +define+ARM_UD_MODEL

#vcs_aprff_custom_options += +define+ARM_UD_CP=\#0
#vcs_aprff_custom_options += +define+ARM_UD_DLY=\#0
#vcs_aprff_custom_options += +define+ARM_UD_DP=\#0
#vcs_aprff_custom_options += +define+ARM_UD_SEQ=\#0.001

# Squash X's in ARM stdcells

vcs_aprff_custom_options += +define+ARM_EN_X_SQUASH

# Register initialization
# hawajkm: We need to scope the register initialization

vcs_aprff_initreg_config  = $(handoff_dir.vcs-aprff-build)/initreg.config
vcs_aprff_custom_options += +vcs+initreg+config+$(vcs_aprff_initreg_config)

# ARM memory initialization
#
# The INITIALIZE_MEMORY flag initializes memory state to 0 (according to
# "ARM® 28nm TSMC CLN28HPC EDA Tools Support, Revision: r0p0, Application
# Note", "arm_28nm_tsmc_cln28hpc_eda_an_100298_0000_a.pdf")

vcs_aprff_custom_options += +define+INITIALIZE_MEMORY

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

vcs_aprff_build_log = $(logs_dir.vcs-aprff-build)/build.log

vcs_aprff_build_cmd = vcs $(vcs_common_options) \
                          $(vcs_design_options) \
                          $(vcs_aprff_structural_options) \
                          $(vcs_aprff_custom_options)

define commands.vcs-aprff-build

	mkdir -p $(logs_dir.vcs-aprff-build)
	mkdir -p $(handoff_dir.vcs-aprff-build)

# initreg configuration

	echo "modtree $(design_name) 0 random" > $(vcs_aprff_initreg_config)

# Build the testing library map

	echo "library testinglib" \
		$(foreach f, $(testing_files),$(base_dir)/$f,) > $(vcs_aprff_testing_library)
	sed -i "s/,\$$/;/" $(vcs_aprff_testing_library)

# Build the design library map

	echo "library designlib $(PWD)/$(vcs_aprff_gl_model);" > $(vcs_aprff_design_library)

# Record the options used to build the simulator

	@printf "%.s-" {1..80}          > $(vcs_aprff_build_log)
	@echo                          >> $(vcs_aprff_build_log)
	@echo   "VCS Options"          >> $(vcs_aprff_build_log)
	@printf "%.s-" {1..80}         >> $(vcs_aprff_build_log)
	@echo                          >> $(vcs_aprff_build_log)
	@echo "vcs_common_options = $(vcs_common_options)" \
		>> $(vcs_aprff_build_log)
	@echo "vcs_design_options = $(vcs_design_options)" \
		>> $(vcs_aprff_build_log)
	@echo "vcs_aprff_structural_options = $(vcs_aprff_structural_options)" \
		>> $(vcs_aprff_build_log)
	@echo "vcs_aprff_custom_options = $(vcs_aprff_custom_options)" \
		>> $(vcs_aprff_build_log)

# Record the full command used to build the simulator

	@printf "%.s-" {1..80}         >> $(vcs_aprff_build_log)
	@echo                          >> $(vcs_aprff_build_log)
	@echo   "Full VCS Command"     >> $(vcs_aprff_build_log)
	@printf "%.s-" {1..80}         >> $(vcs_aprff_build_log)
	@echo                          >> $(vcs_aprff_build_log)
	@echo "$(vcs_aprff_build_cmd)" >> $(vcs_aprff_build_log)

# Build the simulator

	@printf "%.s-" {1..80}         >> $(vcs_aprff_build_log)
	@echo                          >> $(vcs_aprff_build_log)
	@echo   "Build log"            >> $(vcs_aprff_build_log)
	@printf "%.s-" {1..80}         >> $(vcs_aprff_build_log)
	@echo                          >> $(vcs_aprff_build_log)
	$(vcs_aprff_build_cmd) | tee -a   $(vcs_aprff_build_log)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Print the VCS build command

print.vcs-aprff-build:
	@echo $(vcs_aprff_build_cmd)

print_list += vcs_aprff_build_cmd

# Clean

clean-vcs-aprff-build:
	rm -rf ./$(VPATH)/vcs-aprff-build
	rm -rf ./$(logs_dir.vcs-aprff-build)
	rm -rf ./$(collect_dir.vcs-aprff-build)
	rm -rf ./$(handoff_dir.vcs-aprff-build)

#clean-ex: clean-vcs-aprff-build

