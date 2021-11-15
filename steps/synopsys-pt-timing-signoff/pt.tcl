#=========================================================================
# reporting.tcl
#=========================================================================
# Final reports
#
# Author : Alex Carsello
# Date   : November 15, 2021
#

source -echo -verbose scripts/read_design.tcl

# Please do not modify the sdir variable.
# Doing so may cause script to fail.
set sdir "." 

set report_default_significant_digits 3

##################################################################
#    Constraint Analysis Section
##################################################################
check_constraints -verbose > reports/check_constraints.report

##################################################################
#    Update_timing and check_timing Section                      #
##################################################################

update_timing -full

check_timing -verbose > reports/check_timing.report

##################################################################
#    Report_timing Section                                       #
##################################################################
report_global_timing > reports/report_global_timing.report

report_clock -skew -attribute > reports/report_clock.report 

report_analysis_coverage > reports/report_analysis_coverage.report

report_timing \
  -crosstalk_delta \
  -slack_lesser_than 1000.0 \
  -max_paths 100 \
  -pba_mode exhaustive \
  -delay max \
  -nosplit \
  -input \
  -net \
  -transition_time \
  -path_type full_clock_expanded \
  > reports/$::env(design_name).timing.setup.rpt

report_timing \
  -crosstalk_delta \
  -slack_lesser_than 1000.0 \
  -max_paths 100 \
  -pba_mode exhaustive \
  -delay min \
  -nosplit \
  -input \
  -net \
  -transition_time \
  -path_type full_clock_expanded \
  > reports/$::env(design_name).timing.hold.rpt

write_sdf -significant_digits 6 design.sdf

exit

