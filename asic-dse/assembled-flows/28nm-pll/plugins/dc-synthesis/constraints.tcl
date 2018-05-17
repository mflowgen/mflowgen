#=========================================================================
# Design Constraints File
#=========================================================================

create_clock -name clk_pll -period 0.416 \
  [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

# Generated clocks

# Procedure:
#
# - The clk_pll is set based on the extracted simulation of the fastest
# ring oscillator
#
# - The clk_ref is a generated clock from the clk_pll waveform to create a
# 25MHz (the expected frequency of the reference source)
#
# - All other generated clocks are now phase-shifted versions of the
# reference clock and each goes to clock a part of the PLL. So the signals
# essentially travel in a pipeline fashion through the PLL using
# progressively delayed clocks.
#
#     - clk_alpha_and_accum :  90    degree phase (just because)
#     - clk_dlc             : 180    degree phase (just because)
#     - clk_fce             : 270    degree phase (just because)
#     - clk_dco             : 281.25 degree phase (just because)
#

create_generated_clock -name clk_ref -edges { 1 49 97 } [get_ports in_clk_ref] \
  -add -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_alpha_and_accum -edges { 25 73 121 } [get_ports in_clk_ref] \
  -add -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_dlc -edges { 49 97 145 } [get_ports in_clk_ref] \
  -add -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_fce -edges { 73 121 169 } [get_ports in_clk_ref] \
  -add -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

create_generated_clock -name clk_dco -edges { 76 124 172 } [get_ports in_clk_ref] \
  -add -source [get_pins pll_loop/ring_oscillator_top/out_pll_clk]

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

# Output can drive:
#
# - 1  fF, which is the gate cap of INV_X2 pin A
# - 38 fF, which is the gate cap of PRWDWUWHWSWDGE digital IO "I" pin
# - Something bigger to be a bit more conservative to upsize output paths

set_load -pin_load 0.050 [all_outputs]

# Input transition will be reasonably strong

set_input_transition 0.100 [all_inputs]

# Set max transition to make edges sharper than this. We want to make sure
# this constraint doesn't make the tool start upsizing the ring
# oscillators though, but based on simulation, 100ps won't be an issue for
# that.

set_max_transition 0.100 ${DESIGN_NAME}

# set_input_delay constraints for input ports

#set_input_delay -clock ideal_clock 0 [all_inputs]

# set_output_delay constraints for output ports

#set_output_delay -clock ideal_clock 0 [all_outputs]

