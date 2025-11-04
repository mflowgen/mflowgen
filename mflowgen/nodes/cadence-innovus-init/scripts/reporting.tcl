#=========================================================================
# reporting.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : January 13, 2020

#-------------------------------------------------------------------------
# Useful reporting
#-------------------------------------------------------------------------

# Report timing -- hold
#
# Report zero-load timing now to identify hard macros (memories or IP
# blocks), which have large hold time requirements. Identifying these
# situations early allows planning for enough space to insert the required
# buffers and delay cells to fix them.

timeDesign -preplace -hold -expandedViews -prefix preplace -outDir $vars(rpt_dir)

# Report ports

report_ports > $vars(rpt_dir)/$vars(step).ports.rpt


