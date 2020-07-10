#=========================================================================
# main.tcl
#=========================================================================
# Author : Maxwell Strange
# Date   : July 10, 2020

#-------------------------------------------------------------------------
# Checks for REAL shorts that might manifest as LVS errors.
#-------------------------------------------------------------------------
#
# In this step, we want to ensure that there are no real shorts in the design.
# For now, we define a real short as a short between a Regular Wire and a cell blockage.
# This definition is likely to change, but we are largely excluding routing blockages in our definition.

# Put the verify_drc command in a report
verify_drc -report logs/verify_drc.log

