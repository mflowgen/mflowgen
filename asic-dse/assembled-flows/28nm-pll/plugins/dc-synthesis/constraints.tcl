#=========================================================================
# Design Constraints File
#=========================================================================

# This constraint sets the target clock period for the chip in
# nanoseconds. Note that the first parameter is the name of the clock
# signal in your verlog design. If you called it something different than
# clk you will need to change this. You should set this constraint
# carefully. If the period is unrealistically small then the tools will
# spend forever trying to meet timing and ultimately fail. If the period
# is too large the tools will have no trouble but you will get a very
# conservative implementation.

#set CLOCK_NET in_clk_ref
#set CLOCK_NET clk

#create_clock -name clk_pll -period ${dc_clock_period} \

#create_clock -name clk_pll -period 0.334 \

create_clock -name clk_pll -period 0.500 \
  [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

# Generated clocks

create_generated_clock -name clk_ref -edges { 1 113 225 } [get_ports in_clk_ref] \
  -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_alpha_and_accum -edges { 113 225 337 } [get_ports in_clk_ref] \
  -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_dlc -edges { 135 247 359 } [get_ports in_clk_ref] \
  -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

#create_generated_clock -name clk_dlc -edges { 155 267 379 } [get_ports in_clk_ref] \
  -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_fce -edges { 177 289 401 } [get_ports in_clk_ref] \
  -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_dco -edges { 182 294 406 } [get_ports in_clk_ref] \
  -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

#-------------------------------------------------------------------------
# Special dont touch and dont retime
#-------------------------------------------------------------------------
# These are from Julian's original DC script settings

set_disable_timing pll_loop/fdc_top/flip_flop/in_clk_div

set_dont_retime pll_loop/dlc_top/*
set_dont_retime pll_loop/dco_top/*

#set_dont_touch pll_loop/dlc_top/iir0_logic/*
#set_dont_touch pll_loop/dlc_top/iir1_logic/*
#set_dont_touch pll_loop/dlc_top/iir2_logic/*
#set_dont_touch pll_loop/dlc_top/iir3_logic/*
#set_dont_touch pll_loop/dco_top/*

#-------------------------------------------------------------------------
# Other stuff
#-------------------------------------------------------------------------

# Output will drive a 1 fF output, which is the gate cap of INV_X2 pin A

set_load -pin_load 0.001 [all_outputs]

# Input transition will be reasonably strong

set_input_transition 0.125 [all_inputs]

# set_input_delay constraints for input ports

#set_input_delay -clock ideal_clock 0 [all_inputs]

# set_output_delay constraints for output ports

#set_output_delay -clock ideal_clock 0 [all_outputs]

# Make all signals meet good slew

#set_max_transition 0.125 ${DESIGN_NAME}

