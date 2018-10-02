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

design_name        = brgtc2_chip
clock_period       = 2.0
design_v           = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/brgtc2-chip.v

# For simulation

pytest_target_str  = ../../alloy-sim/brgtc2/pymtl/CompChansey/test/Chansey_test*
testing_files      = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/brgtc2-chip-test/Chansey_tb.v
testing_files     += ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/brgtc2-chip.swshim.v

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


