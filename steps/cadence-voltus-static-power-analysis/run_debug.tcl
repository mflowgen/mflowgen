# Opens DB and power analysis results

set design_name $::env(design_name)
set power_analysis_dir "./static_power_analysis_results"

read_design -physical_data inputs/design.checkpoint/save.enc.dat $design_name

win

read_power_rail_results -power_db ${power_analysis_dir}/power.db

set_power_rail_display -plot none

