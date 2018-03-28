#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description -- example-step
#-------------------------------------------------------------------------
# This is an example step showing how to configure a new asic flow step.
#
# Note that the minimum contents for a step is just this:
#
#     commands.example-step = echo "Here is my example step"
#
# More than one command can be specified by using a define:
#
#     define commands.example-step
#       echo "Running example-step"
#       echo "Done with example-step"
#     endef
#
# Variables that interface with the build system are suffixed with the
# name of the step (e.g., "commands.example-step").
#
#     IMPORTANT NOTE: The name of the step _MUST_ match the name of the
#     directory (which contains the configure.mk fragment)!
#         .
#         └── steps
#             └── example-step     <- because this is "example-step",
#                 └── configure.mk <- the step name in the configure
#                                     script must also be "example-step"
#
# The build system provides many useful variables that you can use:
#
# - flow_dir.example-step
# - plugins_dir.example-step
#
# - logs_dir.example-step
# - reports_dir.example-step
# - results_dir.example-step
#
# - collect_dir.example-step
# - handoff_dir.example-step
#
# Your step can use all of these variables or not use any of them.

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------
# The build system has a feature to enable printing a banner before the
# step is executed if the variable "ascii.example-step" is defined.
#
# Here is an example ascii banner that is in the style of the ones used
# for Cadence Innovus steps:

define ascii.example-step
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
#     % make example-step
#
# If this is too long, you can make a short name here. The build system
# will create the alias for you and also track it for support (e.g.,
# the alias showing up when running "make list").

abbr.example-step = ex

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

define commands.example-step
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.example-step)
	touch $(handoff_dir.example-step)/example-output.txt
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-example-step:
	rm -rf ./$(VPATH)/example-step
	rm -rf ./$(collect_dir.example-step)
	rm -rf ./$(handoff_dir.example-step)

clean-ex: clean-example-step

