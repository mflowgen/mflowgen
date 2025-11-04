#=========================================================================
# reporting.tcl
#=========================================================================
# Author : Christopher Torng
# Date   : March 26, 2018

report_ccopt_clock_trees -list_special_pins -filename $vars(rpt_dir)/$vars(step).clock_trees.rpt
report_ccopt_skew_groups -filename $vars(rpt_dir)/$vars(step).skew_groups.rpt

report_ccopt_clock_tree_structure -show_sinks -expand_generated_clock_trees independently -file $vars(rpt_dir)/$vars(step).structure.rpt

