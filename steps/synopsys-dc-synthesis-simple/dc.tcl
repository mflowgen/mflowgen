#=========================================================================
# Minimal Synthesis Script
#=========================================================================
# Author : Christopher Torng
# Date   : January 30, 2020

set_app_var target_library "inputs/adk/stdcells.db"
set_app_var link_library   "* inputs/adk/stdcells.db"

analyze -format sverilog inputs/design.v

elaborate $env(design_name)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
create_clock clk -name ideal_clock -period $env(clock_period)
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# set period 1.0
# create_clock -name ideal_clock -period $period [get_ports clk]
# set_input_delay -clock ideal_clock [expr $period*0.90] [all_inputs]
# set_driving_cell -lib_cell INV_X4 [all_inputs]
# set_output_delay -clock ideal_clock [expr $period*0.10] [all_outputs]
# set_load -pin_load 8 [all_outputs]
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
# set_max_transition 0.0001 $env(design_name)
# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

compile

write -format verilog -hierarchy -output post-synth.v
write_sdc -nosplit post-synth.sdc

#-------------------------------------------------------------------------
# Reporting
#-------------------------------------------------------------------------

file mkdir reports

report_qor > reports/design.mapped.qor.rpt

report_timing \
  -input_pins -capacitance -transition_time \
  -nets -significant_digits 4 -nosplit      \
  -path_type full_clock -attributes         \
  -nworst 10 -max_paths 30 -delay_type max  \
  > reports/design.mapped.timing.setup.rpt

exit

