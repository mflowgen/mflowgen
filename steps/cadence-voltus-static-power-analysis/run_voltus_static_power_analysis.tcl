# Runs Static Power Analysis on provided design

set design_name $::env(design_name)
set clock_period $::env(clock_period)
set power_analysis_dir "./static_power_analysis_results"

# First, import the design
read_design -physical_data inputs/design.checkpoint/save.enc.dat $design_name

# Read in power intent
#read_power_domain -cpf inputs/design.cpf

set is_routed [dbGet top.statusRouted]

# Spef only applicable in a routed design
if {$is_routed} {
    # Read in parasitics if provided. Otherwise, generate them.
    set spef_file inputs/design.spef.gz
    if {![file exists $spef_file]} {
        set spef_file design.spef.gz
        extract_rc
        rc_out -rc_corner typical -spef $spef_file
    }
    read_spef -rc_corner typical -decoupled $spef_file
}

# Set power analysis mode
set_power_analysis_mode \
    -reset

set_power_analysis_mode \
    -analysis_view              [lindex [all_setup_analysis_views] 0] \
    -write_static_currents      true \
    -create_binary_db           true \
    -method                     static

set_power_output_dir -reset
set_power_output_dir $power_analysis_dir
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period ${clock_period}

# Run static power analysis
report_power -rail_analysis_format VS -outfile ${power_analysis_dir}/${design_name}_static.rpt

exit

