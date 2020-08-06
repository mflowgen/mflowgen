#=========================================================================
# setup-cellpad.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# Cell padding
#-------------------------------------------------------------------------
# Cell padding adds an extra bit of space whenever the specified cell is
# placed. This leaves room for setup/hold fixing buffers to be placed next
# to them later on.

if {[info exists ADK_CELLS_TO_BE_PADDED]} {
    specifyCellPad $ADK_CELLS_TO_BE_PADDED $::env(cell_padding)
} else {
    specifyCellPad *DFF* $::env(cell_padding)
}

reportCellPad -file $vars(rpt_dir)/$vars(step).cellpad.rpt

