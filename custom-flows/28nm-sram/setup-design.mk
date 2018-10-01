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

design_name  = SramValRdyPRTL
clock_period = 1.0
design_v     = ../pymtl/build/SramValRdyPRTL_blackbox.v

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


