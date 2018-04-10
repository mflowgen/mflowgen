#=========================================================================
# post_cts.tcl
#=========================================================================
# This plug-in script is called after the corresponding Innovus flow step

report_ccopt_clock_trees -filename $vars(rpt_dir)/cts.clock_trees.rpt
report_ccopt_skew_groups -filename $vars(rpt_dir)/cts.skew_groups.rpt

