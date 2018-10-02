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
# This step hands off these files:
#
# - pytest-collect.txt    : All tests collected by py.test
# - test_cases.yaml       : YAML listing of test cases and test categories
# - list-test-case.txt    : Text listing of test cases (uncategorized)
# - $(design)_all_tests.v : Verilog snippet with load_data for all tests

descriptions.sim-prep = \
	"Generates files needed by all sim steps (e.g., list of tests)"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.sim-prep
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# Simulation Prep'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.sim-prep = template

#-------------------------------------------------------------------------
# Script variables
#-------------------------------------------------------------------------

# Run py.test on the pymtl source dir to collect the tests

pytest_target     = $(relative_base_dir)/$(pytest_target_str)
pytest_output     = $(handoff_dir.sim-prep)/pytest-collect.txt

# Convert the py.test dump to YAML and txt
#
# - YAML : used to tell the build system about the list of test cases
# - txt  : used to hook into Shunning's gen-all-tests.sh script
#
# Shunning's gen-all-tests.sh script generates the verilog test cases

convert_script_py = $(plugins_dir)/sim/convert_pytest_to_yaml.py
test_cases_yaml   = $(handoff_dir.sim-prep)/test_cases.yaml
test_cases_txt    = $(handoff_dir.sim-prep)/list-test-case.txt

# Variables for gen-all-tests.sh

gen_all_tests_sh  = $(plugins_dir)/sim/gen-all-tests.sh

export ALLOY_ASIC_ROOT = $(base_dir)/..

#-------------------------------------------------------------------------
# Test variables
#-------------------------------------------------------------------------
# This section use the test case YAML listing to read these variables:
#
# - "test_categories" : List of test categories
# - "tests.$(1)"      : List of test cases in each test category $(1)
#
# From a list of keys like this:
#
#     HostGcdUnit/HostGcdUnit_test.py:
#     - basic_0x0
#     - basic_5x0
#     HostGcdUnit/FooBar_test.py:
#     - foo_0x0
#     - foo_5x0
#
# The test categories will be:
#
#     test_categories = HostGcdUnit_test FooBar_test
#
# The tests in each category will be:
#
#     tests.HostGcdUnit_test = basic_0x0 basic_5x0
#     tests.FooBar_test      = foo_0x0 foo_5x0
#

# List of test categories

test_categories = \
  $(shell grep \: $(test_cases_yaml) 2>/dev/null | \
          sed -r "s|.*/(\w+).py.*|\1|" )

# Table of test cases in each category

# list_tests_in_category
#
# - $(1): name of test category

define list_tests_in_category
tests.$(1) = \
  $$(shell sed -n "\|$(1)|,\|:|p" $$(test_cases_yaml) | \
           grep -v \: | \
           sed "s|^- ||" )
endef

$(foreach x, $(test_categories), $(eval $(call list_tests_in_category,$x)))

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.sim-prep
	mkdir -p $(handoff_dir.sim-prep)
# Collect tests with py.test
	py.test $(pytest_target) --collect-only > $(pytest_output)
# Convert the py.test dump to YAML
	./$(convert_script_py) --file $(pytest_output) --out $(test_cases_yaml)
# Convert the YAML dump to txt
	grep -v ":" < $(test_cases_yaml) | sed "s/^- //" > $(test_cases_txt)
# Generate verilog test cases from test case txt
	cd $(handoff_dir.sim-prep) && PYTEST_DRYRUN=y ../../$(gen_all_tests_sh)
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Print test categories

print.sim-prep.test-categories:
	@echo $(test_categories)

print_list += test_categories

# Print test cases

define print_tests_in_category
print.sim-prep.tests.$(1):
	@echo $$(tests.$(1))
print_list += sim-prep.tests.$(1)
endef

$(foreach x, $(test_categories), $(eval $(call print_tests_in_category,$x)))

# Clean

clean-sim-prep:
	rm -rf ./$(VPATH)/sim-prep
	rm -rf ./$(collect_dir.sim-prep)
	rm -rf ./$(handoff_dir.sim-prep)

#clean-ex: clean-sim-prep

