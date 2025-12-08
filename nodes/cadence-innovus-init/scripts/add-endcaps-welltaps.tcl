#=========================================================================
# add-endcaps-welltaps.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 4, 2020

# Add end caps if ADK contains end caps

if {   [info exists ADK_END_CAP_CELL_LEFT]
    && [expr {$ADK_END_CAP_CELL_LEFT ne ""}]
    && [info exists ADK_END_CAP_CELL_RIGHT]
    && [expr {$ADK_END_CAP_CELL_RIGHT ne ""}] } {
  # The -rightEdge option is for precap (left edge of core rows)
  # The -leftEdge option is for postcap (right edge of core rows)
  setEndCapMode -rightEdge $ADK_END_CAP_CELL_LEFT
  setEndCapMode -leftEdge  $ADK_END_CAP_CELL_RIGHT
  addEndCap     -prefix    ENDCAP
} else {
  echo "Warning: mflowgen skipping end cap insertion because none found in ADK"
}

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


