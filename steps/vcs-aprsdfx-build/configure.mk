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

# Include directory -- Any collected includes are made available

vcs_aprsdfx_structural_options += +incdir+$(collect_dir.vcs-aprsdfx-build)

# Dump the bill of materials + file list to help double-check src files

vcs_aprsdfx_structural_options += -bom top
vcs_aprsdfx_structural_options += -bfl $(logs_dir.vcs-aprsdfx-build)/vcs_filelist

#-------------------------------------------------------------------------
# Post-APR-SDF-specific custom options
#-------------------------------------------------------------------------

# Gate-level model (magically reach into innovus results dir)

vcs_aprsdfx_gl_model        = $(wildcard $(innovus_results_dir)/*.vcs.v)
vcs_aprsdfx_custom_options += -v $(vcs_aprsdfx_gl_model)

# Library files -- IO cells and stdcells

vcs_aprsdfx_custom_options += -v $(adk_dir)/iocells.v
vcs_aprsdfx_custom_options += -v $(adk_dir)/stdcells.v

# Library files -- SRAMs (magically reach into handoff dir)

vcs_aprsdfx_srams = $(wildcard $(PWD)/$(handoff_dir.gen-sram-verilog)/*.v)
vcs_aprsdfx_custom_options += $(foreach f, $(vcs_aprsdfx_srams),-v $f)

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

vcs_aprsdfx_instance_scope  = top.th.dut.dut

vcs_aprsdfx_custom_options += \
	-sdf max:$(vcs_aprsdfx_instance_scope):$(wildcard $(innovus_results_dir)/*.sdf)

# Testing library map -- the tests will only use files from this library

vcs_aprsdfx_testing_library  = $(handoff_dir.vcs-aprsdfx-build)/testing.library
vcs_aprsdfx_custom_options  += -libmap $(vcs_aprsdfx_testing_library)

# Design library map -- the design will only use files from this library

vcs_aprsdfx_design_library  = $(handoff_dir.vcs-aprsdfx-build)/design.library
vcs_aprsdfx_custom_options += -libmap $(vcs_aprsdfx_design_library)

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

vcs_aprsdfx_build_cmd = vcs $(vcs_common_options) \
                            $(vcs_design_options) \
                            $(vcs_aprsdfx_structural_options) \
                            $(vcs_aprsdfx_custom_options)

define commands.vcs-aprsdfx-build

	mkdir -p $(logs_dir.vcs-aprsdfx-build)
	mkdir -p $(handoff_dir.vcs-aprsdfx-build)

# Build the testing library map

	echo "library testinglib" \
		$(foreach f, $(testing_files),$(base_dir)/$f,) > $(vcs_aprsdfx_testing_library)
	sed -i "s/,\$$/;/" $(vcs_aprsdfx_testing_library)

# Build the design library map

	echo "library designlib $(PWD)/$(vcs_aprsdfx_gl_model);" > $(vcs_aprsdfx_design_library)

# Record the options used to build the simulator

	@printf "%.s-" {1..80}            > $(vcs_aprsdfx_build_log)
	@echo                            >> $(vcs_aprsdfx_build_log)
	@echo   "VCS Options"            >> $(vcs_aprsdfx_build_log)
	@printf "%.s-" {1..80}           >> $(vcs_aprsdfx_build_log)
	@echo                            >> $(vcs_aprsdfx_build_log)
	@echo "vcs_common_options = $(vcs_common_options)" \
		>> $(vcs_aprsdfx_build_log)
	@echo "vcs_design_options = $(vcs_design_options)" \
		>> $(vcs_aprsdfx_build_log)
	@echo "vcs_aprsdfx_structural_options = $(vcs_aprsdfx_structural_options)" \
		>> $(vcs_aprsdfx_build_log)
	@echo "vcs_aprsdfx_custom_options = $(vcs_aprsdfx_custom_options)" \
		>> $(vcs_aprsdfx_build_log)

# Record the full command used to build the simulator

	@printf "%.s-" {1..80}           >> $(vcs_aprsdfx_build_log)
	@echo                            >> $(vcs_aprsdfx_build_log)
	@echo   "Full VCS Command"       >> $(vcs_aprsdfx_build_log)
	@printf "%.s-" {1..80}           >> $(vcs_aprsdfx_build_log)
	@echo                            >> $(vcs_aprsdfx_build_log)
	@echo "$(vcs_aprsdfx_build_cmd)" >> $(vcs_aprsdfx_build_log)

# Build the simulator

	@printf "%.s-" {1..80}           >> $(vcs_aprsdfx_build_log)
	@echo                            >> $(vcs_aprsdfx_build_log)
	@echo   "Build log"              >> $(vcs_aprsdfx_build_log)
	@printf "%.s-" {1..80}           >> $(vcs_aprsdfx_build_log)
	@echo                            >> $(vcs_aprsdfx_build_log)
	$(vcs_aprsdfx_build_cmd) | tee -a   $(vcs_aprsdfx_build_log)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Print the VCS build command

print.vcs-aprsdfx-build:
	@echo $(vcs_aprsdfx_build_cmd)

print_list += vcs_aprsdfx_build_cmd

# Clean

clean-vcs-aprsdfx-build:
	rm -rf ./$(VPATH)/vcs-aprsdfx-build
	rm -rf ./$(logs_dir.vcs-aprsdfx-build)
	rm -rf ./$(collect_dir.vcs-aprsdfx-build)
	rm -rf ./$(handoff_dir.vcs-aprsdfx-build)

#clean-ex: clean-vcs-aprsdfx-build

