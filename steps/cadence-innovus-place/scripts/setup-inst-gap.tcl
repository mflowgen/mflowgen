#=========================================================================
# setup-inst-gap.tcl
#=========================================================================
# Author : Alex Carsello
# Date   : January 5, 2022

#-------------------------------------------------------------------------
# Inst gap
#-------------------------------------------------------------------------
# place_detail_legalization_inst_gap specifies the minimum size (in number
# of coreSites) of any gap between placed cells. This is useful when the 
# smallest available filler cell is larger than one coreSite.

if {[info exists ADK_MIN_INST_GAP]} {
  setPlaceMode -place_detail_legalization_inst_gap $ADK_MIN_INST_GAP
  # Without this setting, Innovus will still leave width=1 gaps in
  # advanced technology nodes.
  if {[expr $ADK_MIN_INST_GAP > 1]} {
    setPlaceMode -place_detail_use_no_diffusion_one_site_filler false
  }
}

