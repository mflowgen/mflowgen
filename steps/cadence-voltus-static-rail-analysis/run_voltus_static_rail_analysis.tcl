# Runs Static Rail Analysis on provided design
# using results of static power analysis

set design_name $::env(design_name)

set_multi_cpu_usage -localCpu 8

# First, import the design
read_design -physical_data inputs/design.checkpoint/save.enc.dat $design_name

# Read in power intent
#read_power_domain -cpf inputs/design.cpf
set techonly_pg_lib inputs/adk/techonly.cl
set stdcell_pg_libs [glob inputs/adk/stdcell*.cl]
set macro_pg_libs [glob -nocomplain inputs/*.cl]

# Set rail analysis mode
set_rail_analysis_mode \
    -method                     static \
    -accuracy                   xd \
    -analysis_view              [lindex [all_setup_analysis_views] 0] \
    -power_grid_library "$techonly_pg_lib $stdcell_pg_libs $macro_pg_libs" \
    -enable_rlrp_analysis       true \
    -verbosity true

#    -use_em_view_list           ../data/voltus/em_view.list \

# Since we're not using a CPF file, specify pg nets
set_pg_nets -net VDD        -voltage 0.8 -threshold 0.71
set_pg_nets -net VSS        -voltage 0.0 -threshold 0.09

set_power_data -reset
set current_files [glob inputs/static_power_analysis_results/static_*.ptiavg]
set_power_data -format current -scale 1 $current_files

# Auto fetch power pad locations and run rail analysis for each net
set_power_pads -reset
set power_nets "VDD VSS"
foreach net $power_nets {
    create_power_pads -auto_fetch -net $net -vsrc_file ${net}.pp
    set_power_pads -net $net -format xy -file ${net}.pp
    analyze_rail -output ./${net}_static_rail -type net $net
}



exit

