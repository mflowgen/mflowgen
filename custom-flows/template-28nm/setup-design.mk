#=========================================================================
# setup-design.mk
#=========================================================================
# Here we select the design to push as well as its top-level Verilog
# module name, the clock target, and the Verilog source file.
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Design
#-------------------------------------------------------------------------

design_name  = GcdUnit
clock_period = 1.0
design_v     = rtl-handoff/GcdUnit.v

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


