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

descriptions.info = \
	"Prints useful design information"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.info
	@echo -e $(echo_green)
	@echo '#--------------------------------------------------------------------------------'
	@echo '# Info'
	@echo '#--------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

skipvpath.info = yes

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.info
	@echo "- ADK          : " $(adk)
	@echo "- ADK View     : " $(adk_view)
	@echo
	@echo "- Design       : " $(design_name)
	@echo "- Clock Period : " $(clock_period)
	@echo "- Verilog Src  : " $(design_v)
	@echo "- Flow Path    : " $(flow_path)
	@echo
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

#clean-info:

#clean-ex: clean-info

