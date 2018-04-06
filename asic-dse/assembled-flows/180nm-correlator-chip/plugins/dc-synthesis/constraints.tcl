#=========================================================================
# Design Constraints File
#=========================================================================

# Create the clocks

set core1_clk_name core1_clk
set core2_clk_name core2_clk
set pco_clk_name   pco_clk
set spi_clk_name   spi_clk

set core1_clk_period 50
set core2_clk_period 50
set pco_clk_period   50
set spi_clk_period   50

create_clock -name $core1_clk_name -period $core1_clk_period [get_ports clk1_io]
create_clock -name $core2_clk_name -period $core2_clk_period [get_ports clk2_io]
create_clock -name $pco_clk_name   -period $pco_clk_period   [get_ports clkpco_io]
create_clock -name $spi_clk_name   -period $spi_clk_period   [get_ports spiclk_io]

# Declare these clocks to be asynchronous
#
# Note that this disables all timing checks between groups. Make sure this
# is what you want!

set_clock_groups -asynchronous \
  -group $pco_clk_name \
  -group $spi_clk_name

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

set_clock_uncertainty 1 [get_clocks $core1_clk_name]
set_clock_uncertainty 1 [get_clocks $core2_clk_name]
set_clock_uncertainty 1 [get_clocks $pco_clk_name]
set_clock_uncertainty 1 [get_clocks $spi_clk_name]

# Things to check
#
# 1. CDC paths between clocks (i.e., "get_timing -from clk1 ... -to clk2 ...")
# 2. Warnings in check_timing report (e.g., unconstrained paths)
# 2. Can a different cost function do better?

# FIXME: apply data checks for I and Q
#
# FIXME: watch fanout of spiload
#
# FIXME:
#
# The spi active reg is unconstrained since it is clocked by the load
# signal
#
# report_timing -to spi1/active_reg_reg[275]/next_state

# Make all signals in the design meet good slew

set_max_transition [expr 0.25 * 50] ${DESIGN_NAME}

# Inputs
#
# - Enter with slew of 10ns (slow due to pads)
# - Have 25ns (half of core1_clk cycle) to propagate to input regs
#
# Note that the spi load is a special clock for the SPI active reg

set_input_transition 10 [all_inputs]

set inputs_excluding_clocks \
  [remove_from_collection \
    [remove_from_collection [all_inputs] [get_ports *clk*]] \
    [get_ports *spiload*]]

set_input_delay -clock core1_clk 25 $inputs_excluding_clocks

# Outputs
#
# - Drive 15 pF
# - Must meet 6ns slew (slow due to pads)
# - Have 25ns (half of pco_clk cycle) to propagate to output ports

set_load -pin_load 15 [all_outputs]

set_max_transition 6 [all_outputs]

set_output_delay -clock pco_clk 25 [all_outputs]

# Reset
#
# The reset input has special treatment. Give reset 50% of the core1 clock
# cycle to propagate into the chip.

set reset_port greset_n_io

set reset_percent 50
set reset_input_delay [expr ((100-$reset_percent) * $core1_clk_period) / 100.0]

set_input_delay -clock core1_clk $reset_input_delay $reset_port

# Report constraints on the ports

report_port -verbose -nosplit > reports/dc-synthesis/ports.constraints.rpt

# Report clocks

report_clock -groups -nosplit       > reports/dc-synthesis/clocks.rpt
report_clock -groups -nosplit -skew > reports/dc-synthesis/clocks.skew.rpt

