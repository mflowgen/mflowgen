#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Overview
#-------------------------------------------------------------------------
# Note that the minimum contents for a step is just this:
#
#     commands.template-step-verbose = echo "Here is my example step"
#
# More than one command can be specified by using a define:
#
#     define commands.template-step-verbose
#       echo "Running template-step-verbose"
#       echo "Done with template-step-verbose"
#     endef
#
# Variables that interface with the build system are suffixed with the
# name of the step (e.g., "commands.template-step-verbose").
#
#     asic-dse
#     └── steps
#         └── template-step-verbose  <- name of the step
#             └── configure.mk
#
# Given the name of the step, the build system provides many useful
# variables that you can use:
#
# - flow_dir.template-step-verbose
# - plugins_dir.template-step-verbose
#
# - logs_dir.template-step-verbose
# - reports_dir.template-step-verbose
# - results_dir.template-step-verbose
#
# - collect_dir.template-step-verbose
# - handoff_dir.template-step-verbose
#
# Your step can use all of these variables or not use any of them.

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.template-step-verbose = \
	"This is an example step that shows how to configure a new step"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------
# The build system has a feature to enable printing a banner before the
# step is executed if the variable "ascii.template-step-verbose" is defined.
#
# Here is an example ascii banner that is in the style of the ones used
# for Cadence Innovus steps:

define ascii.template-step-verbose
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                ______   ____   ____    _____            _____                 #'
	@echo '#               |  ____| / __ \ / __ \  |  __ \    /\    |  __ \                #'
	@echo '#               | |__   | |  | | |  | | | |__) |  /  \   | |__) |               #'
	@echo '#               |  __|  | |  | | |  | | |  __ Y  / /\ \  |  _  /                #'
	@echo '#               | |     | |__| | |__| | | |__) |/ ____ \ | | \ \                #'
	@echo '#               |_|      \____/ \____/  |_____/ _/    \_\|_|  \_\               #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------
# The build system uses the name of the step for the make target:
#
#     % make template-step-verbose
#
# If this is too long, you can make a short name here. The build system
# will create the alias for you and also track it for support (e.g.,
# the alias showing up when running "make list").

abbr.template-step-verbose = ex

#-------------------------------------------------------------------------
# Extra dependencies
#-------------------------------------------------------------------------
# The build system takes care of any step dependencies, but you can draw
# up any additional custom dependencies for this step here (e.g., extra
# files not visible to the build sytem).

#extra_dependencies.template-step-verbose = none

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.
#
# The build system includes this configure.mk and when it comes time to
# execute the step, it essentially just tells the step to run itself by
# calling this command.

# This example step does an echo and then generates an output in the
# handoff directory for this step. If another step depends on this step,
# the build system takes care of moving / linking these handed-off files
# to the collect directory of the next step.

define commands.template-step-verbose
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.template-step-verbose)
	touch $(handoff_dir.template-step-verbose)/example-output.txt
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-template-step-verbose:
	rm -rf ./$(VPATH)/template-step-verbose
	rm -rf ./$(collect_dir.template-step-verbose)
	rm -rf ./$(handoff_dir.template-step-verbose)

#clean-ex: clean-template-step-verbose

