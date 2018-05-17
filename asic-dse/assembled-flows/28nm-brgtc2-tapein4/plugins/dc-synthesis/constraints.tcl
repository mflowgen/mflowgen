#=========================================================================
# Design Constraints File
#=========================================================================

#-------------------------------------------------------------------------
# Special constraints
#-------------------------------------------------------------------------

# Make sure that min_delay has priority, since the chip will not work if
# we violate hold time

set_cost_priority {min_delay}

#-------------------------------------------------------------------------
# Create clocks
#-------------------------------------------------------------------------

# External core clock

set core_clk_name        core_clk
set core_clk_period      $dc_clock_period
set core_clk_port        clk_io

create_clock -name       $core_clk_name   \
             -period     $core_clk_period \
             [ get_ports $core_clk_port ]

# PLL reference clock
#
# The reference clock will actually be ~25-26 MHz, but from DC's
# perspective it doesn't matter since we just want DC to connect
# pads directly to the pll. So we just set double the target
# clock and multiply by 2.

set pll_ref_clk_name     pll_ref_clk
set pll_ref_clk_period   [ expr $dc_clock_period * 2 ]
set pll_ref_clk_port     pll_clk_ref_io

create_clock -name       $pll_ref_clk_name   \
             -period     $pll_ref_clk_period \
             [ get_ports $pll_ref_clk_port ]

# PLL multiplied clock

set pll_clk_name         pll_clk
set pll_clk_multiply_by  2
set pll_clk_master       $pll_ref_clk_name
set pll_clk_source       $pll_ref_clk_port
set pll_clk_pin          pll/out_clk

create_generated_clock -name         $pll_clk_name \
                       -multiply_by  $pll_clk_multiply_by \
                       -source       $pll_clk_source \
                       -master_clock $pll_clk_master \
                       [ get_pins    $pll_clk_pin ]

# Print summary in a block to keep outputs together

if (true) {
  puts ""
  puts "--------------------------------------------------------------------------"
  puts "Clock information"
  puts "--------------------------------------------------------------------------"
  puts ""
  puts "Core clock name            : $core_clk_name"
  puts "Core clock period          : $core_clk_period"
  puts "Core clock port            : $core_clk_port"
  puts ""
  puts "PLL ref clock name         : $pll_ref_clk_name"
  puts "PLL ref clock period       : $pll_ref_clk_period"
  puts "PLL ref clock port         : $pll_ref_clk_port"
  puts ""
  puts "PLL generated clock name   : $pll_clk_name"
  puts "PLL generated clock period : [ expr $pll_ref_clk_period / $pll_clk_multiply_by ]"
  puts "PLL generated clock pin    : $pll_clk_pin"
  puts ""
}

#-------------------------------------------------------------------------
# Clock groups
#-------------------------------------------------------------------------
# The core clock and the pll clock are asynchronous and only one of them
# will be used to clock the chip at a time (after the clock mux). Set up
# clock groups to tell DC to ignore clock-domain-crossing timing paths.

# Note: This turns off all timing checks between these clocks, so make
# sure this is what you want!

set_clock_groups -asynchronous \
                 -group $core_clk_name \
                 -group $pll_ref_clk_name

#-------------------------------------------------------------------------
# Clock uncertainty
#-------------------------------------------------------------------------

# Set clock uncertainty

set clock_uncertainty_percent 5

set core_clk_uncertainty \
  [expr ($clock_uncertainty_percent / 100.0) * $core_clk_period]

set pll_ref_clk_uncertainty \
  [expr ($clock_uncertainty_percent / 100.0) * $pll_ref_clk_period]

set_clock_uncertainty $core_clk_uncertainty    [get_clocks $core_clk_name]
set_clock_uncertainty $pll_ref_clk_uncertainty [get_clocks $pll_ref_clk_name]

#-------------------------------------------------------------------------
# Max transition
#-------------------------------------------------------------------------
# Make all signals in the design meet good slew.
#
# The lib delay tables for the ARM 28nm standard cells seem to show
# about 300-400ps slew when driving the _largest_ load the cell was
# characterized for (e.g., DFFQ_X1M_A9PP140TS_C30, INV_X11B_A9PP140TS_C30,
# INV_X4B_A9PP140TS_C30). A bad slew is more like 150ps. Middle of the
# table is ~20ps.
#
# General rule of thumb for max transition is 20% of the clock period.

set_max_transition 0.15 ${DESIGN_NAME}

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------
# - Enter with 0.3 ns slew (lib tables imply 0.1-1ns is expected in the
#   lu_table_template "tphn28hpcgv18e_CHAR_LIB_TABLE_CORE_SLEW2IO_LOAD__5x6")
# - Have the entire clock period to propagate to regs

set_input_transition 0.3 [all_inputs]

# Input delay for PLL ports

set pll_inputs [ filter_collection -regexp [all_inputs] "name =~ pll.*" ]
set pll_inputs [ remove_from_collection $pll_inputs $pll_ref_clk_port ]

set_input_delay -clock $pll_ref_clk_name 0 $pll_inputs

# Input delay for core ports

set core_inputs [ remove_from_collection [all_inputs] $pll_inputs ]
set core_inputs [ remove_from_collection $core_inputs $pll_ref_clk_port ]
set core_inputs [ remove_from_collection $core_inputs $core_clk_port ]

set_input_delay -clock $core_clk_name 0 $core_inputs

#-------------------------------------------------------------------------
# Outputs
#-------------------------------------------------------------------------
# - Drive 12 pF
# - Must meet 4ns slew (slow due to pads)
# - Have the entire clock period to propagate to pads

set_load -pin_load 12 [all_outputs]

set_max_transition 4 [all_outputs]

# Technically we should constrain:
#
# - Path from the PLL clock output port to the "pll_out_clk" pad
#
#     - Make it a certain length to prevent a meandering path
#     - FIXME: For now, leaving it constrained to the clock period and
#       hoping the tool is smart enough to just connect it quickly.
#
# - Path from clk in pad to clk out pad (same reason, prevent meandering)
#
# - Path to all output ports for the 8-bit data buses
#
#     - Make all data paths arrive at the outputs at similar times
#     - FIXME: For now, leaving it constrained to the clock period..

set pll_outputs  [ filter_collection -regexp [all_outputs] "name =~ pll.*" ]
set core_outputs [ remove_from_collection [all_outputs] $pll_outputs ]

set_output_delay -clock $core_clk_name 0 $core_outputs
set_output_delay -clock $pll_clk_name  0 $pll_outputs

#-------------------------------------------------------------------------
# Reset
#-------------------------------------------------------------------------
# The reset input has special treatment. Give reset a set percentage of
# the core clock cycle to propagate into the chip.

# Note: Reset now goes through a synchronizer and does not need any
#       special treatment

#set reset_port reset_io

#set reset_percent 75
#set reset_input_delay [expr ((100-$reset_percent) * $core_clk_period) / 100.0]

#set_input_delay -clock $core_clk_name $reset_input_delay $reset_port

#-------------------------------------------------------------------------
# False paths
#-------------------------------------------------------------------------

# To -> clk_out_io[0]
#
# Reason: As long as the edge is sharp on the clk out, this is a false
# path from a delay perspective. It does not matter too much how long it
# takes. We should constrain its length to some reasonable number, but for
# now it is a false path.

set_false_path -to clk_out_io[0]

# To -> pll_out_clk_io[0]
#
# Reason: As long as the edge is sharp, this is a false path from a delay
# perspective. See above note.

set_false_path -to pll_out_clk_io[0]

# From -> clk_sel_io[0]
#
# Reason: The clock select will not change during operation, so it is
# essentially a constant.

set_false_path -from clk_sel_io[0]

#-------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------

# Report constraints on the ports

report_port -verbose -nosplit > reports/dc-synthesis/${DESIGN_NAME}.ports.constraints.rpt
report_attribute -port        > reports/dc-synthesis/${DESIGN_NAME}.ports.attributes.rpt

# Report clocks

report_clock -groups -nosplit       > reports/dc-synthesis/${DESIGN_NAME}.clocks.rpt
report_clock -groups -nosplit -skew > reports/dc-synthesis/${DESIGN_NAME}.clocks.skew.rpt

#-------------------------------------------------------------------------
# Register retiming
#-------------------------------------------------------------------------

# Retime the multiplier

set_optimize_registers true \
                       -design IntMulPipelined_2Stage \
                       -clock $core_clk_name \
                       -delay_threshold $core_clk_period \
                       -check_design \
                       -verbose \
                       -print_critical_loop


# Register retiming for the fp div

set_optimize_registers true \
                       -design DW_fp_div_pipelined \
                       -clock $core_clk_name \
                       -delay_threshold $core_clk_period \
                       -check_design \
                       -verbose \
                       -print_critical_loop

# Register retiming for the fp addsub


set_optimize_registers true \
                       -design DW_fp_addsub_pipelined \
                       -clock $core_clk_name \
                       -delay_threshold $core_clk_period \
                       -check_design \
                       -verbose \
                       -print_critical_loop

