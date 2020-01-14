#=========================================================================
# cleanup-session.tcl
#=========================================================================
# Cleans up an Innovus session
#
# This script was adapted from the Innovus Foundation Flow Code
# Generator's generated run_debug.tcl ( Version : 19.10-p002_1 ).
#
# Author : Christopher Torng
# Date   : January 10, 2020
#

#-------------------------------------------------------------------------
# Clean up
#-------------------------------------------------------------------------
# Exit unless we are running simple mode (i.e., straight through without
# stopping)

if { [ info exists vars(run_simple) ] && $vars(run_simple) } {
  return
} else {
  exit 0
}


