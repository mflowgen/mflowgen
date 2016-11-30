#!/usr/bin/env python
#=========================================================================
# regincr-sim-v2 <input-values>
#=========================================================================

from pymtl   import *
from sys     import argv
from RegIncr import RegIncr

# Get list of input values from command line

input_values = [ int(x,0) for x in argv[1:] ]

# Add three zero values to end of list of input values

input_values.extend( [0]*3 )

# Elaborate the model

model = RegIncr()
model.vcd_file = "regincr-sim.vcd"
model.elaborate()

# Create a simulator using simulation tool

sim = SimulationTool( model )

# Reset simulator

sim.reset()

# Apply input values and display output values

for input_value in input_values:

  # Write input value to input port

  model.in_.value = input_value

  # Display line trace

  sim.print_line_trace()

  # Tick simulator one cycle

  sim.cycle()

