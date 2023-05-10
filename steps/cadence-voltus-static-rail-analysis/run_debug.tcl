# Opens DB and power analysis results

set design_name $::env(design_name)

read_design -physical_data inputs/design.checkpoint/save.enc.dat $design_name

win

read_power_rail_results -power_db inputs/static_power_analysis_results/power.db -rail_directory VDD_static_rail/VDD_25C_avg_1

set_power_rail_display -plot ir
