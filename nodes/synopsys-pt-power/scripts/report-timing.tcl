#=========================================================================
# report-timing.tcl
#=========================================================================
# This script checks for potential errors, performs timing analysis and
# reports the timing of the design
#
# Author : Maximilian Koschay
# Date   : 05.03.2021

# Check for potential errors in timing
check_timing > $ptpx_reports_dir/$ptpx_design_name.timing.check.rpt

# Perform timing analysis
update_timing -full > $ptpx_logs_dir/$ptpx_design_name.timing.update.rpt

# Report path timings, clocks, constraints violations, ...

report_global_timing > $ptpx_reports_dir/$ptpx_design_name.timing.global.rpt

report_clock -skew -attribute > $ptpx_reports_dir/$ptpx_design_name.timing.clocks.rpt 

report_analysis_coverage > $ptpx_reports_dir/$ptpx_design_name.timing.analysiscoverage.rpt

report_constraints -all_violators -verbose > $ptpx_reports_dir/$ptpx_design_name.timing.constraints.rpt

report_design > $ptpx_reports_dir/$ptpx_design_name.design.rpt

report_net > $ptpx_reports_dir/$ptpx_design_name.net.rpt

# Setup timing report

report_timing -delay max \
	-slack_lesser_than 1.0 -max_paths 1000 -sort_by slack \
	-input -net -crosstalk_delta -nosplit -capacitance -transition_time \
	-pba_mode exhaustive \
	> $ptpx_reports_dir/$ptpx_design_name.timing.setup.rpt

# Hold timing report
# (Slack result is inverted. Positive slack means hold timing met...)

report_timing -delay min \
	-slack_lesser_than 1.0 -max_paths 1000 -sort_by slack \
	-input -net -crosstalk_delta -nosplit -capacitance -transition_time \
	-pba_mode exhaustive \
	> $ptpx_reports_dir/$ptpx_design_name.timing.hold.rpt

# Write delay file

write_sdf -significant_digits 6  $ptpx_outputs_dir/design.sdf