#=========================================================================
# Design Constraints File
#=========================================================================

# Create the clocks

set core1_clk_name core1_clk
set core2_clk_name core2_clk
set pco_clk_name   pco_clk
set spi_clk_name   spi_clk
set spi_load_name  spi_load

set core1_clk_period 100
set core2_clk_period 100
set pco_clk_period   50
set spi_clk_period   100
set spi_load_period  100

create_clock -name $core1_clk_name -period $core1_clk_period [get_ports clk1_io]
create_clock -name $core2_clk_name -period $core2_clk_period [get_ports clk2_io]
create_clock -name $pco_clk_name   -period $pco_clk_period   [get_ports clkpco_io]
create_clock -name $spi_clk_name   -period $spi_clk_period   [get_ports spiclk_io]
create_clock -name $spi_load_name  -period $spi_load_period  [get_ports spiload_io]

# Declare these clocks to be asynchronous
#
# Note that this disables all timing checks between groups. Make sure this
# is what you want!

# For this design, note that core1_clk is used for output paths, so we are
# in fact ignoring paths from pco outputs to pads. Be careful!

set_clock_groups -asynchronous \
  -group [get_clocks -filter "name == $core1_clk_name || name == $core2_clk_name"] \
  -group $pco_clk_name \
  -group $spi_clk_name \
  -group $spi_load_name

set_clock_groups -logically_exclusive \
  -group $core1_clk_name \
  -group $core2_clk_name

# Set clock uncertainty

#set clock_uncertainty_percent 5

#set core1_clk_uncertainty [expr ($clock_uncertainty_percent / 100.0) * $core1_clk_period]
#set core2_clk_uncertainty [expr ($clock_uncertainty_percent / 100.0) * $core2_clk_period]
#set pco_clk_uncertainty   [expr ($clock_uncertainty_percent / 100.0) * $pco_clk_period]
#set spi_clk_uncertainty   [expr ($clock_uncertainty_percent / 100.0) * $spi_clk_period]

#set_clock_uncertainty $core1_clk_uncertainty [get_clocks $core1_clk_name]
#set_clock_uncertainty $core2_clk_uncertainty [get_clocks $core2_clk_name]
#set_clock_uncertainty $pco_clk_uncertainty [get_clocks $pco_clk_name]
#set_clock_uncertainty $spi_clk_uncertainty [get_clocks $spi_clk_name]

# Just set 1 ns clock uncertainty since the clock cycle is so long

set_clock_uncertainty 1   [get_clocks $core1_clk_name]
set_clock_uncertainty 1   [get_clocks $core2_clk_name]
set_clock_uncertainty 0.5 [get_clocks $pco_clk_name]
set_clock_uncertainty 1   [get_clocks $spi_clk_name]
set_clock_uncertainty 1   [get_clocks $spi_load_name]

# Things to check
#
# 1. CDC paths between clocks (i.e., "get_timing -from clk1 ... -to clk2 ...")
# 2. Warnings in check_timing report (e.g., unconstrained paths)
# 2. Can a different cost function do better?

# FIXME: apply data checks for I and Q

# Make all signals in the design meet good slew.
#
# The lib delay tables for the TSMC 180nm standard cells seem to show
# about 1.6ns slew when driving the largest load the cell was characterized
# for (e.g., DFQD2BWP7T, INVD0BWP7T, INVD4BWP7T). So 1ns max transition
# seems like a good target to aim for across the design.

set_max_transition 1 ${DESIGN_NAME}

# Inputs
#
# - Enter with 1ns slew (lib tables imply 0.5-5ns is expected)
# - Ivan's scope shows about 1ns with active probe
#
# Delay
#
# - ADC inputs have 1/8 core clk period to propagate to regs
# - SPI Din / debug inputs both have 1/8 clk period as well

set_input_transition 1 [all_inputs]

# ADC input constraints

set ADC_input_ports \
  [filter_collection [all_inputs] -regexp {name=~ ADC.*}]

set ADC_input_delay [expr $core1_clk_period/8]

set_input_delay -clock $core1_clk_name $ADC_input_delay $ADC_input_ports
set_input_delay -clock $core2_clk_name $ADC_input_delay $ADC_input_ports

# SPI Din / debug input constraints

set spidin_input_delay [expr $spi_clk_period/8]

set_input_delay -clock $spi_clk_name $spidin_input_delay spidin_io

set debug_input_delay [expr $pco_clk_period/4]

set_input_delay -clock $pco_clk_name $debug_input_delay debug_in_io

# Outputs
#
# - Drive 12 pF
# - Must meet 6ns slew (slow due to pads)
# - Have 1/8 core clk period to propagate to output ports

set_load -pin_load 12 [all_outputs]

set_max_transition 6 [all_outputs]

set outmux_output_delay [expr $core1_clk_period/8]

set_output_delay -clock $core1_clk_name $outmux_output_delay [all_outputs]

# Reset
#
# The reset input has special treatment. Give reset 50% of the pco clock
# cycle to propagate into the chip.

set reset_port greset_n_io

set reset_percent 50
set reset_input_delay [expr ((100-$reset_percent) * $pco_clk_period) / 100.0]

set_input_delay -clock $pco_clk_name $reset_input_delay $reset_port

# Special constraints
#
# Try to make ADC inputs all arrive at registers at similar times

set_min_delay -from [get_ports ADC*] 11.5; # Restrict arrival between
set_max_delay -from [get_ports ADC*] 15.0; # 11.5 ns to 15.0 ns

# Report constraints on the ports

report_port -verbose -nosplit > reports/dc-synthesis/ports.constraints.rpt
report_attribute -port        > reports/dc-synthesis/ports.attributes.rpt

# Report clocks

report_clock -groups -nosplit       > reports/dc-synthesis/clocks.rpt
report_clock -groups -nosplit -skew > reports/dc-synthesis/clocks.skew.rpt

