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
# - There are no X-suppression flags used
#

descriptions.vcs-aprffx-build = \
	"Post-APR FF -- full X"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.vcs-aprffx-build
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# VCS APR-FF Build -- Full X'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.vcs-aprffx-build =

#-------------------------------------------------------------------------
# Post-APR-FF-specific structural options
#-------------------------------------------------------------------------
# These are common options across VCS simulation steps, but they need to
# know the exact directory names to set up for the step.

# Specify the simulator binary and simulator compile directory

vcs_aprffx_build_simv  = $(handoff_dir.vcs-aprffx-build)/simv
vcs_aprffx_compile_dir = $(handoff_dir.vcs-aprffx-build)/csrc

vcs_aprffx_structural_options += -o $(vcs_aprffx_build_simv)
vcs_aprffx_structural_options += -Mdir=$(vcs_aprffx_compile_dir)

# Include directory -- Any collected includes are made available

vcs_aprffx_structural_options += +incdir+$(collect_dir.vcs-aprffx-build)

# Dump the bill of materials + file list to help double-check src files

vcs_aprffx_structural_options += -bom top
vcs_aprffx_structural_options += -bfl $(logs_dir.vcs-aprffx-build)/vcs_filelist

#-------------------------------------------------------------------------
# Post-APR-FF-specific custom options
#-------------------------------------------------------------------------

# Gate-level model (magically reach into innovus results dir)

vcs_aprffx_gl_model        = $(wildcard $(innovus_results_dir)/*.vcs.v)
vcs_aprffx_custom_options += -v $(vcs_aprffx_gl_model)

# Library files -- IO cells and stdcells

vcs_aprffx_custom_options += -v $(adk_dir)/iocells.v
vcs_aprffx_custom_options += -v $(adk_dir)/stdcells.v

# Library files -- SRAMs (magically reach into handoff dir)

vcs_aprffx_srams = $(wildcard $(PWD)/$(handoff_dir.gen-sram-verilog)/*.v)
vcs_aprffx_custom_options += $(foreach f, $(vcs_aprffx_srams),-v $f)

# Performance options for post-APR FF simulation

vcs_aprffx_custom_options += -hsopt=gates
vcs_aprffx_custom_options += -rad

# Disable timing checks

vcs_aprffx_custom_options += +notimingcheck

# Suppress lint and warnings

vcs_aprffx_custom_options += +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE

# Testing library map -- the tests will only use files from this library

vcs_aprffx_testing_library  = $(handoff_dir.vcs-aprffx-build)/testing.library
vcs_aprffx_custom_options  += -libmap $(vcs_aprffx_testing_library)

# Design library map -- the design will only use files from this library

vcs_aprffx_design_library  = $(handoff_dir.vcs-aprffx-build)/design.library
vcs_aprffx_custom_options += -libmap $(vcs_aprffx_design_library)

#-------------------------------------------------------------------------
# Modeling options and X-handling
#-------------------------------------------------------------------------

# Use ARM fast-functional model of stdcells and memory

vcs_aprffx_custom_options += +define+ARM_UD_MODEL

#vcs_aprffx_custom_options += +define+ARM_UD_CP=\#0
#vcs_aprffx_custom_options += +define+ARM_UD_DLY=\#0
#vcs_aprffx_custom_options += +define+ARM_UD_DP=\#0
#vcs_aprffx_custom_options += +define+ARM_UD_SEQ=\#0.001

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

vcs_aprffx_build_log = $(logs_dir.vcs-aprffx-build)/build.log

vcs_aprffx_build_cmd = vcs $(vcs_common_options) \
                           $(vcs_design_options) \
                           $(vcs_aprffx_structural_options) \
                           $(vcs_aprffx_custom_options)

define commands.vcs-aprffx-build

	mkdir -p $(logs_dir.vcs-aprffx-build)
	mkdir -p $(handoff_dir.vcs-aprffx-build)

# Build the testing library map

	echo "library testinglib" \
		$(foreach f, $(testing_files),$(base_dir)/$f,) > $(vcs_aprffx_testing_library)
	sed -i "s/,\$$/;/" $(vcs_aprffx_testing_library)

# Build the design library map

	echo "library designlib $(PWD)/$(vcs_aprffx_gl_model);" > $(vcs_aprffx_design_library)

# Record the options used to build the simulator

	@printf "%.s-" {1..80}           > $(vcs_aprffx_build_log)
	@echo                           >> $(vcs_aprffx_build_log)
	@echo   "VCS Options"           >> $(vcs_aprffx_build_log)
	@printf "%.s-" {1..80}          >> $(vcs_aprffx_build_log)
	@echo                           >> $(vcs_aprffx_build_log)
	@echo "vcs_common_options = $(vcs_common_options)" \
		>> $(vcs_aprffx_build_log)
	@echo "vcs_design_options = $(vcs_design_options)" \
		>> $(vcs_aprffx_build_log)
	@echo "vcs_aprffx_structural_options = $(vcs_aprffx_structural_options)" \
		>> $(vcs_aprffx_build_log)
	@echo "vcs_aprffx_custom_options = $(vcs_aprffx_custom_options)" \
		>> $(vcs_aprffx_build_log)

# Record the full command used to build the simulator

	@printf "%.s-" {1..80}          >> $(vcs_aprffx_build_log)
	@echo                           >> $(vcs_aprffx_build_log)
	@echo   "Full VCS Command"      >> $(vcs_aprffx_build_log)
	@printf "%.s-" {1..80}          >> $(vcs_aprffx_build_log)
	@echo                           >> $(vcs_aprffx_build_log)
	@echo "$(vcs_aprffx_build_cmd)" >> $(vcs_aprffx_build_log)

# Build the simulator

	@printf "%.s-" {1..80}          >> $(vcs_aprffx_build_log)
	@echo                           >> $(vcs_aprffx_build_log)
	@echo   "Build log"             >> $(vcs_aprffx_build_log)
	@printf "%.s-" {1..80}          >> $(vcs_aprffx_build_log)
	@echo                           >> $(vcs_aprffx_build_log)
	$(vcs_aprffx_build_cmd) | tee -a   $(vcs_aprffx_build_log)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Print the VCS build command

print.vcs-aprffx-build:
	@echo $(vcs_aprffx_build_cmd)

print_list += vcs_aprffx_build_cmd

# Clean

clean-vcs-aprffx-build:
	rm -rf ./$(VPATH)/vcs-aprffx-build
	rm -rf ./$(logs_dir.vcs-aprffx-build)
	rm -rf ./$(collect_dir.vcs-aprffx-build)
	rm -rf ./$(handoff_dir.vcs-aprffx-build)

#clean-ex: clean-vcs-aprffx-build

