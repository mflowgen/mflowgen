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

design_name        = HostButterfree
clock_period       = 3.0
design_v           = rtl-handoff/HostButterfree_blackbox.v

# For simulation

pytest_target_str  = ../pymtl/CompButterfree/test/Butterfree_test*
testing_files      = rtl-handoff/Butterfree-test/Butterfree_tb.v
testing_files     += rtl-handoff/HostButterfree.swshim.v

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


