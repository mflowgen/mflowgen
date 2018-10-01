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

design_name        = HostGcdUnit
clock_period       = 1.0
design_v           = rtl-handoff/HostGcdUnit.v

# For simulation

pytest_target_str  = ../pymtl/HostGcdUnit
testing_files      = rtl-handoff/HostGcdUnit-test/HostGcdUnit_tb.v
testing_files     += rtl-handoff/HostGcdUnit.swshim.v

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


