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

create_clock -name ref_clk \
             -period 1.0 \
             [get_ports clk]

# Divided clocks

set clk1_name         clk1
set clk1_divide_by    5
set clk1_master       ref_clk
set clk1_source       clk
set clk1_pin          clk_div_1/clk_divided

create_generated_clock -name         $clk1_name \
                       -divide_by    $clk1_divide_by \
                       -master_clock $clk1_master \
                       -source       $clk1_source \
                       [ get_pins    $clk1_pin ]

set clk2_name         clk2
set clk2_divide_by    3
set clk2_master       ref_clk
set clk2_source       clk
set clk2_pin          clk_div_2/clk_divided

#create_generated_clock -name         $clk2_name \
#                       -divide_by    $clk2_divide_by \
#                       -master_clock $clk2_master \
#                       -source       $clk2_source \
#                       [ get_pins    $clk2_pin ]

# Suppress one of the edges

create_generated_clock -name         $clk2_name \
                       -edges        { 1 3   7 9   19 21   25 27   31 } \
                       -master_clock $clk2_master \
                       -source       $clk2_source \
                       [ get_pins    $clk2_pin ]

# Path groups

remove_path_group $clk1_name
remove_path_group $clk2_name

group_path -name $clk1_name -from $clk1_name -to $clk1_name
group_path -name $clk2_name -from $clk2_name -to $clk2_name

group_path -name clk1_to_clk2 -from $clk1_name -to $clk2_name
group_path -name clk2_to_clk1 -from $clk2_name -to $clk1_name

# This constrainst sets the load capacitance in picofarads of the
# output pins of your design. 4fF is reasonable if your design is
# driving another block of on-chip logic.

# FIXME: make this general across technologies

set_load -pin_load 0.004 [all_outputs]

# This constraint sets the input drive strength of the input pins of
# your design. We specifiy a specific standard cell which models what
# would be driving the inputs. This should usually be a small inverter
# which is reasonable if another block of on-chip logic is driving
# your inputs.

set_driving_cell -no_design_rule \
  -lib_cell ${STDCELLS_DRIVING_CELL} [all_inputs]

# set_input_delay constraints for input ports

set_input_delay -clock ref_clk 0 [all_inputs]

# set_output_delay constraints for output ports

set_output_delay -clock ref_clk 0 [all_outputs]

#Make all signals limit their fanout

#set_max_fanout 20 ${DESIGN_NAME}

# Make all signals meet good slew

#set_max_transition [expr 0.25*${dc_clock_period}] ${DESIGN_NAME}

#set_input_transition 1 [all_inputs]
#set_max_transition 10 [all_outputs]

