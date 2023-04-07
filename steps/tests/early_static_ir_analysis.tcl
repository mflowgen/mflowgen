# This runs early initial (as opposed to signoff) static IR analysis


# First, set up and run initial power analysis
proc run_power_analysis {} {
    set design_name [dbGet top.name]
    set clock_period $::env(clock_period)
    set power_analysis_dir "./power_analysis_output"
    set_power_analysis_mode -reset
    #** WARN:  (VOLTUS_POWR-3212): The 'set_power_analysis_mode -leakage_power_view |-dynamic_power_view|-analysis_view' will be obsolete in 18.20 release. Use 'set_analysis_view -leakage <> | -dynamic <>' to set leakage and dynamic power views.
    
    set_power_analysis_mode \
        -method static \
        -analysis_view analysis_default \
        -corner max \
        -create_binary_db true \
        -write_static_currents true \
        -honor_negative_energy true \
        -ignore_control_signals true
    #** WARN:  (VOLTUS_POWR-3212): The 'set_power_analysis_mode -leakage_power_view |-dynamic_power_view|-analysis_view' will be obsolete in 18.20 release. Use 'set_analysis_view -leakage <> | -dynamic <>' to set leakage and dynamic power views.
    
    set_power_output_dir -reset
    set_power_output_dir $power_analysis_dir
    set_default_switching_activity -reset
    set_default_switching_activity -input_activity 0.2 -period ${clock_period}
    #** INFO:  (VOLTUS_POWR-3229): Using user defined default frequency 900000MHz for power calculation.
    
    read_activity_file -reset
    set_power -reset
    set_powerup_analysis -reset
    set_dynamic_power_simulation -reset
    report_power -rail_analysis_format VS -outfile ${power_analysis_dir}/${design_name}.rpt
}

# Then set up and run rail analysis
proc run_rail_analysis {} {
    set design_name [dbGet top.name]
    set clock_period $::env(clock_period)
    set power_analysis_dir "./power_analysis_output"
    set_rail_analysis_mode \
        -method era_static \
        -power_switch_eco false \
        -generate_movies false \
        -save_voltage_waveforms false \
        -generate_decap_eco true \
        -accuracy xd \
        -analysis_view analysis_default \
        -process_techgen_em_rules false \
        -enable_rlrp_analysis false \
        -extraction_tech_file inputs/adk/pdk-typical-qrcTechFile \
        -vsrc_search_distance 50 \
        -ignore_shorts false \
        -enable_manufacturing_effects false \
        -report_via_current_direction false
    
    #**WARN: (VOLTUS-1179):	Settings of all PG nets have been reset to default due to change in the analysis view using set_rail_analysis_mode. Re-run set_pg_nets to set threshold values based on design requirements.
    set_pg_nets -net VDD -voltage 0.8 -threshold 0.71
    set_power_data -reset
    set_power_data -format current -scale 1 ${power_analysis_dir}/static_VDD.ptiavg
    set_power_pads -reset
    create_power_pads -auto_fetch -net VDD -format xy -vsrc_file ${design_name}_VDD.pp
    set_power_pads -net VDD -format xy -file ${design_name}_VDD.pp
    set_package -reset
    set_package -spice {} -mapping {}
    set_net_group -reset
    set_advanced_rail_options -reset
    analyze_rail -type net -results_directory ${power_analysis_dir} VDD
}

#run_power_analysis
#
#run_rail_analysis
