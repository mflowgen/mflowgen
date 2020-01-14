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

specifyCellPad *DFF* 2
reportCellPad -file $vars(rpt_dir)/$vars(step).cellpad.rpt

