#=========================================================================
# verify.tcl
#=========================================================================
# This script creates match compare points and verification.
#
# Author : Kartik Prabhu
# Date   : March 23, 2021

# Creates compare points to match objects between the reference and 
# implementation designs.
match

# Check this report to see what points were not matched
report_unmatched_points > ${fm_reports_dir}/$fm_design_name.unmatched.rpt

# Prove equivalence
verify > ${fm_reports_dir}/$fm_design_name.verif.rpt

# Points that were found to not be functionally equivalent
report_failing_points > ${fm_reports_dir}/$fm_design_name.failing_points.rpt
# Points that were not found to be passing or failing
report_aborted_points > ${fm_reports_dir}/$fm_design_name.aborted_points.rpt
# Points that were not verified (usually as a result of too many failing points)
report_unverified_points > ${fm_reports_dir}/$fm_design_name.unverified_points.rpt
