#=========================================================================
# reporting.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

report_ccopt_clock_trees -filename $vars(rpt_dir)/$vars(step).clock_trees.rpt
report_ccopt_skew_groups -filename $vars(rpt_dir)/$vars(step).skew_groups.rpt

