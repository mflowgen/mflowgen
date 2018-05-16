source -echo -verbose $::env(pt_flow_dir)/rm_setup/pt_setup.tcl

#################################################################################
# PrimeTime Reference Methodology Script
# Script: pt.tcl
# Version: K-2015.12-SP2 (April 4, 2016)
# Copyright (C) 2008-2016 Synopsys All rights reserved.
################################################################################

# Please do not modify the sdir variable.
# Doing so may cause script to fail.
set sdir "." 

##################################################################
#    Search Path, Library and Operating Condition Section        #
##################################################################

# Under normal circumstances, when executing a script with source, Tcl
# errors (syntax and semantic) cause the execution of the script to terminate.
# Uncomment the following line to set sh_continue_on_error to true to allow 
# processing to continue when errors occur.
#set sh_continue_on_error true 

set pba_exhaustive_endpoint_path_limit 100         

set si_enable_analysis true 
set si_xtalk_double_switching_mode clock_network 
  
set power_enable_analysis true 
set power_enable_multi_rail_analysis true 
set power_analysis_mode averaged 

set report_default_significant_digits 3 ;
set sh_source_uses_search_path true ;
set search_path ". $search_path" ;

##################################################################
#    Netlist Reading Section                                     #
##################################################################
set link_path "* $link_path"
read_verilog $NETLIST_FILES

current_design $DESIGN_NAME 
link

##################################################################
#    Back Annotation Section                                     #
##################################################################
if { [info exists PARASITIC_FILES] } {
foreach para_file $PARASITIC_FILES {
      read_parasitics -keep_capacitive_coupling $para_file 
}
}

##################################################################
#    Reading Constraints Section                                 #
##################################################################
if  {[info exists CONSTRAINT_FILES]} {
        foreach constraint_file $CONSTRAINT_FILES {
                if {[file extension $constraint_file] eq ".sdc"} {
                        read_sdc -echo $constraint_file
                } else {
                        source -echo $constraint_file
                }
        }
}

##################################################################
#    Setting Derate and CRPR Section                             #
##################################################################

set timing_remove_clock_reconvergence_pessimism true 

##################################################################
#    Constraint Analysis Section
##################################################################
check_constraints -verbose > $REPORTS/${DESIGN_NAME}_${corner_case}_check_constraints.report

##################################################################
#    Update_timing and check_timing Section                      #
##################################################################

update_timing -full
check_timing -verbose > $REPORTS/${DESIGN_NAME}_${corner_case}_check_timing.report

##################################################################
#    Report_timing Section                                       #
##################################################################
report_global_timing > $REPORTS/${DESIGN_NAME}_${corner_case}_report_global_timing.report
report_clock -skew -attribute > $REPORTS/${DESIGN_NAME}_${corner_case}_report_clock.report 
report_analysis_coverage > $REPORTS/${DESIGN_NAME}_${corner_case}_report_analysis_coverage.report
report_timing -crosstalk_delta -slack_lesser_than 0.0 -max_paths 100 -pba_mode exhaustive -delay min_max -nosplit -input -net  > $REPORTS/${DESIGN_NAME}_${corner_case}_report_timing_pba.report
# Clock Network Double Switching Report
report_si_double_switching -nosplit -rise -fall > $REPORTS/${DESIGN_NAME}_${corner_case}_report_si_double_switching.report

# Noise Settings
set_noise_parameters -enable_propagation -analysis_mode report_at_endpoint -include_beyond_rails
set si_filter_keep_all_port_aggressors TRUE
check_noise > $REPORTS/${DESIGN_NAME}_${corner_case}_check_noise.report
check_noise -include "noise_driver" -verbose > $REPORTS/${DESIGN_NAME}_${corner_case}_check_noise_verbose.report
update_noise
# Noise Reporting
report_noise -nosplit -verbose -all_violators -above -low           > $REPORTS/${DESIGN_NAME}_${corner_case}_report_noise_all_viol_abv_low.report
report_noise -nosplit -verbose -clock_pins -above -low              > $REPORTS/${DESIGN_NAME}_${corner_case}_report_noise_clk_pins_abv_low.report
report_noise -nosplit -verbose -nworst 10 -above -low               > $REPORTS/${DESIGN_NAME}_${corner_case}_report_noise_alow.report

report_noise -nosplit -verbose -all_violators -below -high          > $REPORTS/${DESIGN_NAME}_${corner_case}_report_noise_all_viol_below_high.report
report_noise -nosplit -verbose -clock_pins -below -high             > $REPORTS/${DESIGN_NAME}_${corner_case}_report_noise_clk_pins_below_high.report
report_noise -nosplit -verbose -nworst 10 -below -high              > $REPORTS/${DESIGN_NAME}_${corner_case}_report_noise_below_high.report
                      
report_si_bottleneck -nosplit -cost_type delta_delay                > $REPORTS/${DESIGN_NAME}_${corner_case}_report_si_bottleneck.rpt
report_si_bottleneck -nosplit -cost_type delta_delay_ratio          >> $REPORTS/${DESIGN_NAME}_${corner_case}_report_si_bottleneck.rpt
report_si_bottleneck -cost_type delay_bump_per_aggressor            >> $REPORTS/${DESIGN_NAME}_${corner_case}_report_si_bottleneck.rpt

write_sdf -significant_digits 6 $RESULTS/${DESIGN_NAME}_${corner_case}_si.sdf


##################################################################  
#    Power Switching Activity: Vector Free Flow                  #  
##################################################################  
set power_default_toggle_rate 0.1 
set power_default_static_probability 0.5 
report_switching_activity           

##################################################################
#    Power Analysis Section                                      #
##################################################################
## run power analysis
check_power   > $REPORTS/${DESIGN_NAME}_${corner_case}_check_power.report
update_power  

## report_power
report_power > $REPORTS/${DESIGN_NAME}_${corner_case}_report_power.report

# Set 10% toggle rate on clock gates
set_switching_activity -clock_derate 0.1 -clock_domains [all_clocks] -type clock_gating_cells

# Clock Gating & Vth Group Reporting Section
report_clock_gate_savings  

# Set Vth attribute for each library if not set already
foreach_in_collection l [get_libs] {
        if {[get_attribute [get_lib $l] default_threshold_voltage_group] == ""} {
                set lname [get_object_name [get_lib $l]]
                set_user_attribute [get_lib $l] default_threshold_voltage_group $lname -class lib
        }
}
report_power -threshold_voltage_group > $REPORTS/${DESIGN_NAME}_${corner_case}_pwr.per_lib_leakage
report_threshold_voltage_group > $REPORTS/${DESIGN_NAME}_${corner_case}_pwr.per_volt_threshold_group

##################################################################
#    Generation of Hierarchical Model Section                    #
#                                                                #
#  Extracted Timing Model (ETM) will contain composite current   #
#  source (CCS) timing models, if design libraries contains both #
#  CCS timing and noise data along with design for which model   #
#  is extracted has waveform propogation enable using variable   #
#  'set delay_calc_waveform_analysis_mode full_design'           # 
##################################################################

extract_model -library_cell -output ${RESULTS}/${DESIGN_NAME}_${corner_case} -format {lib db} -block_scope

file rename -force ${RESULTS}/${DESIGN_NAME}_${corner_case}_lib.db ${RESULTS}/${DESIGN_NAME}_${corner_case}.db

write_interface_timing ${REPORTS}/${DESIGN_NAME}_${corner_case}_etm_netlist_interface_timing.report

exit
