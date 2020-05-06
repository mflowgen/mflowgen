#=========================================================================
# reporting.tcl
#=========================================================================
# Final reports
#
# Author : Christopher Torng
# Date   : May 14, 2018
#

# Report variables

print_variable_group all > ${dc_reports_dir}/${dc_design_name}.vars.rpt

# Report units

redirect -tee \
  ${dc_reports_dir}/${dc_design_name}.mapped.units.rpt \
  {report_units}

# Report QOR

report_qor > ${dc_reports_dir}/${dc_design_name}.mapped.qor.rpt

# Report timing

report_clock_timing \
  -type summary     \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.clock.rpt

report_timing \
  -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit      \
  -path_type full_clock -attributes         \
  -nworst 10 -max_paths 30 -delay_type max  \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.setup.rpt

report_timing \
  -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit      \
  -path_type full_clock -attributes         \
  -nworst 10 -max_paths 30 -delay_type min  \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.hold.rpt

# Report constraints

report_constraint \
  -nosplit        \
  -verbose        \
  > ${dc_reports_dir}/${dc_design_name}.mapped.constraints.rpt

report_constraint \
  -nosplit        \
  -verbose        \
  -all_violators  \
  > ${dc_reports_dir}/${dc_design_name}.mapped.constraints.violators.rpt

report_timing_requirements \
  > ${dc_reports_dir}/${dc_design_name}.mapped.timing.requirements.rpt

# Report area

report_area  \
  -hierarchy \
  -physical  \
  -nosplit   \
  > ${dc_reports_dir}/${dc_design_name}.mapped.area.rpt

# Report references and resources

report_reference \
  -nosplit       \
  -hierarchy     \
  > ${dc_reports_dir}/${dc_design_name}.mapped.reference.rpt

report_resources \
  -nosplit       \
  -hierarchy     \
  > ${dc_reports_dir}/${dc_design_name}.mapped.resources.rpt

# Report power
#
# - Use SAIF file for power analysis
#

if {[file exists "inputs/run.saif" ]} {

  read_saif                            \
    -map_names                         \
    -input "inputs/run.saif"           \
    -instance_name $dc_saif_instance   \
    -verbose

  report_saif        \
    -hier            \
    -annotated_flag  \
    -rtl_saif        \
    > ${dc_reports_dir}/${dc_design_name}.mapped.saif.rpt

  saif_map     \
    -type ptpx \
    -write_map \
    ${dc_reports_dir}/${dc_design_name}.namemap

}

report_power \
  -nosplit   \
  -hier      \
  > ${dc_reports_dir}/${dc_design_name}.mapped.power.rpt

# Report clock gating

report_clock_gating \
  -nosplit          \
  > ${dc_reports_dir}/${dc_design_name}.mapped.clock_gating.rpt


