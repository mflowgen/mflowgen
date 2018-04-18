#=========================================================================
# post_cts.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step

report_ccopt_clock_trees -filename $vars(rpt_dir)/$vars(step).clock_trees.rpt
report_ccopt_skew_groups -filename $vars(rpt_dir)/$vars(step).skew_groups.rpt

