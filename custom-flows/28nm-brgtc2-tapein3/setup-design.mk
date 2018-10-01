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

design_name        = HostChansey
clock_period       = 3.0
design_v           = rtl-handoff/HostChansey_blackbox.v

# For simulation

pytest_target_str  = ../pymtl/CompChansey/test/Chansey_test*
testing_files      = rtl-handoff/Chansey-test/Chansey_tb.v
testing_files     += rtl-handoff/HostChansey.swshim.v

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


