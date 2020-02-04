source -echo -verbose scripts/read_design.tcl

# Please do not modify the sdir variable.
# Doing so may cause script to fail.
set sdir "." 

##################################################################
#    Constraint Analysis Section
##################################################################
check_constraints -verbose > check_constraints.report

##################################################################
#    Update_timing and check_timing Section                      #
##################################################################

update_timing -full
check_timing -verbose > check_timing.report

##################################################################
#    Report_timing Section                                       #
##################################################################
report_timing -crosstalk_delta -slack_lesser_than 0.0 -max_paths 100 -pba_mode exhaustive -delay min_max -nosplit -input -net > report_timing_pba.report

write_sdf -significant_digits 6 design.sdf

exit

