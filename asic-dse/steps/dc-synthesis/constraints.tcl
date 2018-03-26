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

create_clock clk -name ideal_clock1 -period ${CLOCK_PERIOD}

# This constrainst sets the load capacitance in picofarads of the
# output pins of your design. 4fF is reasonable if your design is
# driving another block of on-chip logic.

set_load -pin_load 0.004 [all_outputs]

# This constraint sets the input drive strength of the input pins of
# your design. We specifiy a specific standard cell which models what
# would be driving the inputs. This should usually be a small inverter
# which is reasonable if another block of on-chip logic is driving
# your inputs.

set_driving_cell -no_design_rule \
  -lib_cell ${STDCELLS_DRIVING_CELL} [all_inputs]

# set_input_delay constraints for input ports

set_input_delay -clock ideal_clock1 0 [all_inputs]

# set_output_delay constraints for output ports

set_output_delay -clock ideal_clock1 0 [all_outputs]

