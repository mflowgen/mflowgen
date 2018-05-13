#=========================================================================
# Design Constraints File
#=========================================================================

#-------------------------------------------------------------------------
# Create clocks
#-------------------------------------------------------------------------

set core_clk_net    clk_io
set core_clk_name   core_clk
set core_clk_period $dc_clock_period

create_clock -name   $core_clk_name   \
             -period $core_clk_period \
             [get_ports $core_clk_net]

#-------------------------------------------------------------------------
# Clock uncertainty
#-------------------------------------------------------------------------

# Set clock uncertainty

set clock_uncertainty_percent 5
set core_clk_uncertainty \
  [expr ($clock_uncertainty_percent / 100.0) * $core_clk_period]

set_clock_uncertainty $core_clk_uncertainty [get_clocks $core_clk_name]

#-------------------------------------------------------------------------
# Max transition
#-------------------------------------------------------------------------
# Make all signals in the design meet good slew.
#
# The lib delay tables for the ARM 28nm standard cells seem to show
# about 300-400ps slew when driving the largest load the cell was
# characterized for (e.g., DFFQ_X1M_A9PP140TS_C30, INV_X11B_A9PP140TS_C30,
# INV_X4B_A9PP140TS_C30). So 300ps max transition seems like a good target
# to aim for across the design.

set_max_transition 0.3 ${DESIGN_NAME}

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------
# - Enter with 0.3 ns slew (lib tables imply 0.1-1ns is expected in the
#   lu_table_template "tphn28hpcgv18e_CHAR_LIB_TABLE_CORE_SLEW2IO_LOAD__5x6")
# - Have the entire clock period to propagate to regs (the chip interface
#   is asynchronous)

set_input_transition 0.3 [all_inputs]

set_input_delay -clock $core_clk_name 0 [all_inputs]

#-------------------------------------------------------------------------
# Outputs
#-------------------------------------------------------------------------
# - Drive 12 pF
# - Must meet 4ns slew (slow due to pads)
# - Timing is ignored for output signals because the chip interface is
#   asynchronous

set_load -pin_load 12 [all_outputs]

set_max_transition 4 [all_outputs]

set_false_path -to [all_outputs]

#-------------------------------------------------------------------------
# Reset
#-------------------------------------------------------------------------
# The reset input has special treatment. Give reset a set percentage of
# the core clock cycle to propagate into the chip.

set reset_port reset_io

set reset_percent 70
set reset_input_delay [expr ((100-$reset_percent) * $core_clk_period) / 100.0]

set_input_delay -clock $core_clk_name $reset_input_delay $reset_port

#-------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------

# Report constraints on the ports

report_port -verbose -nosplit > reports/dc-synthesis/ports.constraints.rpt
report_attribute -port        > reports/dc-synthesis/ports.attributes.rpt

# Report clocks

report_clock -groups -nosplit       > reports/dc-synthesis/clocks.rpt
report_clock -groups -nosplit -skew > reports/dc-synthesis/clocks.skew.rpt

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

