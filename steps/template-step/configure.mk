#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.template-step = \
	"This is an example step that shows how to configure a new step"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.template-step
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

#abbr.template-step = template

#-------------------------------------------------------------------------
# Extra dependencies
#-------------------------------------------------------------------------

#extra_dependencies.template-step = none

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.template-step
	echo "Hello world!"
# Prepare handoffs
	mkdir -p $(handoff_dir.template-step)
	touch $(handoff_dir.template-step)/template-output.txt
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-template-step:
	rm -rf ./$(VPATH)/template-step
	rm -rf ./$(collect_dir.template-step)
	rm -rf ./$(handoff_dir.template-step)

#clean-ex: clean-template-step

