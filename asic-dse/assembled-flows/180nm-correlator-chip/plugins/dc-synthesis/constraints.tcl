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

#-------------------------------------------------------------------------
# Clock domain crossings
#-------------------------------------------------------------------------
# Check clock domain crossings using Paul Zimmer's "No Man's Land:
# Constraining async clock domain crossings" article from 2013 on handling
# them.

# Create shadow clocks for cdc checking

create_clock -add -name ${core1_clk_name}_cdc -period $core1_clk_period [get_ports clk1_io]
create_clock -add -name ${core2_clk_name}_cdc -period $core2_clk_period [get_ports clk2_io]
create_clock -add -name ${pco_clk_name}_cdc   -period $pco_clk_period   [get_ports clkpco_io]
create_clock -add -name ${spi_clk_name}_cdc   -period $spi_clk_period   [get_ports spiclk_io]
create_clock -add -name ${spi_load_name}_cdc  -period $spi_load_period  [get_ports spiload_io]

# Clean up and remove the auto-generated path groups for each of these

remove_path_group ${core1_clk_name}_cdc
remove_path_group ${core2_clk_name}_cdc
remove_path_group ${pco_clk_name}_cdc
remove_path_group ${spi_clk_name}_cdc
remove_path_group ${spi_load_name}_cdc

# Create new path groups for the CDCs we care about
#
# For some reason the commands don't work with variables... so we have to
# hardcode the clock names

group_path -name cores_to_pco -from {core1_clk_cdc core2_clk_cdc} -to ${pco_clk_name}_cdc
group_path -name pco_to_cores -from ${pco_clk_name}_cdc -to {core1_clk_cdc core2_clk_cdc}

group_path -name core1_to_core2 -from ${core1_clk_name}_cdc -to ${core2_clk_name}_cdc
group_path -name core2_to_core1 -from ${core2_clk_name}_cdc -to ${core1_clk_name}_cdc

group_path -name spi_to_spiload -from ${spi_clk_name}_cdc -to ${spi_load_name}_cdc
group_path -name spiload_to_chip -from ${spi_load_name}_cdc -to {core1_clk_cdc core2_clk_cdc pco_clk_cdc}

# Make sure cdc clocks aren't propagated

remove_propagated_clock [get_clocks *_cdc]

# No internal paths on cdc clocks

foreach_in_collection cdcclk [get_clocks *_cdc] {
  set_false_path -from [get_clock $cdcclk] -to [get_clock $cdcclk]
}

# Make cdc clocks physically exclusive from all other clocks

set_clock_groups -physically_exclusive \
  -group [remove_from_collection [get_clocks *] [get_clocks *_cdc]] \
  -group [get_clocks *_cdc]

# Constraints
#
#
#                     Constraint (ns)
# From      To        Hold      Setup
# ----------------------------------------------------
# core1     core2     0.0       10.0
# core1     pco       0.0       10.0
# core1     spi       -- false path --
# core1     spiload   -- false path --
#
# core2     core1     0.0       10.0
# core2     pco       0.0       10.0
# core2     spi       -- false path --
# core2     spiload   -- false path --
#
# pco       core1     0.0       10.0
# pco       core2     0.0       10.0
# pco       spi       -- false path --
# pco       spiload   -- false path --
#
# spi       core1     -- false path --
# spi       core2     -- false path --
# spi       pco       -- false path --
# spi       spiload   0.0       25.0    <-- don't care
#
# spiload   core1     0.0       25.0    <-- don't care
# spiload   core2     0.0       25.0    <-- don't care
# spiload   pco       0.0       25.0    <-- don't care
# spiload   spi       -- false path --

# Constrain paths from core 1

set_min_delay -from ${core1_clk_name}_cdc -to ${core2_clk_name}_cdc 0.0
set_max_delay -from ${core1_clk_name}_cdc -to ${core2_clk_name}_cdc 10.0

set_min_delay -from ${core1_clk_name}_cdc -to ${pco_clk_name}_cdc 0.0
set_max_delay -from ${core1_clk_name}_cdc -to ${pco_clk_name}_cdc 10.0

set_false_path -from ${core1_clk_name}_cdc -to ${spi_clk_name}_cdc
set_false_path -from ${core1_clk_name}_cdc -to ${spi_load_name}_cdc

# Constrain paths from core 2

set_min_delay -from ${core2_clk_name}_cdc -to ${core1_clk_name}_cdc 0.0
set_max_delay -from ${core2_clk_name}_cdc -to ${core1_clk_name}_cdc 10.0

set_min_delay -from ${core2_clk_name}_cdc -to ${pco_clk_name}_cdc 0.0
set_max_delay -from ${core2_clk_name}_cdc -to ${pco_clk_name}_cdc 10.0

set_false_path -from ${core2_clk_name}_cdc -to ${spi_clk_name}_cdc
set_false_path -from ${core2_clk_name}_cdc -to ${spi_load_name}_cdc

# Constrain paths from pco

set_min_delay -from ${pco_clk_name}_cdc -to ${core1_clk_name}_cdc 0.0
set_max_delay -from ${pco_clk_name}_cdc -to ${core1_clk_name}_cdc 10.0

set_min_delay -from ${pco_clk_name}_cdc -to ${core2_clk_name}_cdc 0.0
set_max_delay -from ${pco_clk_name}_cdc -to ${core2_clk_name}_cdc 10.0

set_false_path -from ${pco_clk_name}_cdc -to ${spi_clk_name}_cdc
set_false_path -from ${pco_clk_name}_cdc -to ${spi_load_name}_cdc

# Constrain paths from spiclk

set_false_path -from ${spi_clk_name}_cdc -to ${core1_clk_name}_cdc
set_false_path -from ${spi_clk_name}_cdc -to ${core2_clk_name}_cdc
set_false_path -from ${spi_clk_name}_cdc -to ${pco_clk_name}_cdc

set_min_delay -from ${spi_clk_name}_cdc -to ${spi_load_name}_cdc 0.0
set_max_delay -from ${spi_clk_name}_cdc -to ${spi_load_name}_cdc 25.0

# Constrain paths from spiload

set_min_delay -from ${spi_load_name}_cdc -to ${core1_clk_name}_cdc 0.0
set_max_delay -from ${spi_load_name}_cdc -to ${core1_clk_name}_cdc 25.0

set_min_delay -from ${spi_load_name}_cdc -to ${core2_clk_name}_cdc 0.0
set_max_delay -from ${spi_load_name}_cdc -to ${core2_clk_name}_cdc 25.0

set_min_delay -from ${spi_load_name}_cdc -to ${pco_clk_name}_cdc 0.0
set_max_delay -from ${spi_load_name}_cdc -to ${pco_clk_name}_cdc 25.0

set_false_path -from ${spi_load_name}_cdc -to ${spi_clk_name}_cdc

# Make sure these delay constraints have priority. The chip will not work if
# these are not honored.

set_cost_priority {min_delay max_delay}

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

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

set_input_delay -clock $core1_clk_name            $ADC_input_delay $ADC_input_ports
set_input_delay -clock $core2_clk_name -add_delay $ADC_input_delay $ADC_input_ports

# SPI Din / debug input constraints

set spidin_input_delay [expr $spi_clk_period/8]

set_input_delay -clock $spi_clk_name $spidin_input_delay spidin_io

set debug_input_delay [expr $pco_clk_period/4]

set_input_delay -clock $pco_clk_name $debug_input_delay debug_in_io

# Outputs
#
# - Drive 12 pF
# - Must meet 6ns slew (slow due to pads)
# - Have 1/4 pco clk period to propagate to output ports

set_load -pin_load 12 [all_outputs]

set_max_transition 6 [all_outputs]

set outmux_output_delay [expr 3*$pco_clk_period/4]

set_output_delay -clock $core1_clk_name            $outmux_output_delay [all_outputs]
set_output_delay -clock $core2_clk_name -add_delay $outmux_output_delay [all_outputs]
set_output_delay -clock $pco_clk_name   -add_delay $outmux_output_delay [all_outputs]

# Reset
#
# The reset input has special treatment. Give reset 50% of the pco clock
# cycle to propagate into the chip.

set reset_port greset_n_io

set reset_percent 50
set reset_input_delay [expr ((100-$reset_percent) * $pco_clk_period) / 100.0]

set_input_delay -clock $core1_clk_name            $reset_input_delay $reset_port
set_input_delay -clock $core2_clk_name -add_delay $reset_input_delay $reset_port
set_input_delay -clock $pco_clk_name   -add_delay $reset_input_delay $reset_port

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

