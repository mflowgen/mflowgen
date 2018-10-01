#=========================================================================
# Design Constraints File
#=========================================================================

create_clock -name clk_pll -period ${dc_clock_period} [get_ports clk] \

set_dont_touch ${DESIGN_NAME}

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

