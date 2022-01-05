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
}

