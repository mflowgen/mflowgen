#=========================================================================
# run-debug.tcl
#=========================================================================
# Opens an Innovus session with GUI enabled and loads the finished
# checkpoint for this step.
#
# Author : Christopher Torng
# Date   : January 10, 2020
#

#-------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------
# Restore from the finished checkpoint for this step and set up variables

source checkpoints/design.checkpoint/save.enc
source innovus-foundation-flow/custom-scripts/setup-session.tcl

#-------------------------------------------------------------------------
# Open the Innovus GUI
#-------------------------------------------------------------------------

win


