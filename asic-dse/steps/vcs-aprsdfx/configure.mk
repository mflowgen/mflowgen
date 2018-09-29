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
# Run the VCS simulator
#
# Note that this step uses the following variables from step "sim-prep":
#
# - "test_categories" : List of test categories
# - "tests.$(1)"      : List of test cases in each test category $(1)
#
# These variables are used to generate targets for each test case.

descriptions.vcs-aprsdfx = \
	"Post-APR SDF -- full x"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.vcs-aprsdfx
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# VCS APR-SDF Sim -- Full X'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.vcs-aprsdfx =

#-------------------------------------------------------------------------
# Collect
#-------------------------------------------------------------------------

# The simulator is available from the build step

# Unfortunately, the test case targets run before the build system has
# constructed the collect dir, so we temporarily magically reach into the
# correct handoff dir.

vcs_aprsdfx_simv = ./$(handoff_dir.vcs-aprsdfx-build)/simv

#-------------------------------------------------------------------------
# Generate simulation targets
#-------------------------------------------------------------------------

# Generate simulation targets for each test case
#
# For each test case, generate a target that runs that test case. The
# following naming scheme uses all uppercase letters so that users can
# type "make VCS" and tab-complete to run individual tests.
#
# - "VCS-APRSDFX.mdu.basic_0x0" : Test category "mdu" for test case "basic_0x0"
#

# vcs_aprsdfx_generate_test_cases
#
# - $(1): test category
# - $(2): test name

define vcs_aprsdfx_generate_test_cases

$$(logs_dir.vcs-aprsdfx)/run-$(1)-$(2).log: $$(dependencies.vcs-aprsdfx)
	@mkdir -p $$(logs_dir.vcs-aprsdfx)
	@touch $$@.start
	@echo '--------------------------------------------------------------------------------'
	@echo $$@
	@echo '--------------------------------------------------------------------------------'
	$$(vcs_aprsdfx_simv) $$(vcs_run_options) +test=$(2) 2>&1 | tee $$@

# Create alias target to help run an individual test

VCS_APRSDFX.$(1).$(2): $$(logs_dir.vcs-aprsdfx)/run-$(1)-$(2).log

# Gather all tests for this category

VCS_APRSDFX_$(1)_ALL += $$(logs_dir.vcs-aprsdfx)/run-$(1)-$(2).log

# Create target that prints the vcs command

VCS_APRSDFX.$(1).$(2).print:
	@echo "$$(vcs_aprsdfx_simv) $$(vcs_run_options) +test=$(2)"

endef

# Call template for each test case in each test category

$(foreach category, $(test_categories), \
  $(foreach test, $(tests.$(category)), \
    $(eval $(call vcs_aprsdfx_generate_test_cases,$(category),$(test)))))

# Generate targets for each test case
#
# For each test category, generate a target that runs all test cases in
# that category. The following naming scheme uses all lowercase letters so
# that all lowercase targets enable running "groups" of tests.
#
# - "vcs-aprsdfx.mdu" : Run all "mdu" test cases
#

# vcs_aprsdfx_generate_categories
#
# - $(1): test category

define vcs_aprsdfx_generate_categories
vcs-aprsdfx.$(1): $$(VCS_APRSDFX_$(1)_ALL)
endef

$(foreach category, $(test_categories), \
  $(eval $(call vcs_aprsdfx_generate_categories,$(category))))

# Summary txt file for the top-level target

vcs_aprsdfx_summary_txt = $(results_dir.vcs-aprsdfx)/summary.txt

#-------------------------------------------------------------------------
# Extra dependencies
#-------------------------------------------------------------------------
# Set up extra dependencies so that the top-level step target runs all
# test cases in every test category

extra_dependencies.vcs-aprsdfx = \
	$(foreach x, $(test_categories),vcs-aprsdfx.$x)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

ifeq (x"$(extra_dependencies.vcs-aprsdfx)",x"")
define commands.vcs-aprsdfx
	@echo -n "Please re-run this step so that the Makefile can read the"
	@echo -n " simulation targets from the test cases YAML file."
	@echo
endef
else
define commands.vcs-aprsdfx
	@mkdir -p $(results_dir.vcs-aprsdfx)
	@grep -r BRG $(logs_dir.vcs-aprsdfx) > $(vcs_aprsdfx_summary_txt)
	@cat $(vcs_aprsdfx_summary_txt)
	@echo
	@( echo -n "Total passing   : " ; grep -i pass $(vcs_aprsdfx_summary_txt) | wc -l; \
	   echo -n "Total num tests : " ; wc -l < $(vcs_aprsdfx_summary_txt) )
endef
endif

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-vcs-aprsdfx:
	rm -rf ./$(VPATH)/vcs-aprsdfx
	rm -rf ./$(logs_dir.vcs-aprsdfx)
	rm -rf ./$(results_dir.vcs-aprsdfx)
#  rm -rf ./$(collect_dir.vcs-aprsdfx) # don't clean the YAML file
	rm -rf ./$(handoff_dir.vcs-aprsdfx)

clean-aprsdfx: clean-vcs-aprsdfx clean-vcs-aprsdfx-build


