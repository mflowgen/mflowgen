#=========================================================================
# add-endcaps-welltaps.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 4, 2020

# Add well taps if ADK contains well taps

if {[info exists ADK_WELL_TAP_CELL] && [expr {$ADK_WELL_TAP_CELL ne ""}]} {
  addWellTap -cell [list $ADK_WELL_TAP_CELL] \
             -prefix       WELLTAP \
             -cellInterval $ADK_WELL_TAP_INTERVAL \
             -checkerboard
  
  verifyWellTap -cells [list $ADK_WELL_TAP_CELL] \
                -report reports/welltap.rpt \
                -rule   [ expr $ADK_WELL_TAP_INTERVAL/2 ]
} else {
  echo "Warning: mflowgen skipping well tap insertion because no well taps found in ADK"
}


