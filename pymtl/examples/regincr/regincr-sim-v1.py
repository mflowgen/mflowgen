#!/usr/bin/env python
#=========================================================================
# regincr-sim-v1 <input-values>
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
model.elaborate()

# Create and reset simulator

sim = SimulationTool( model )
sim.reset()

# Apply input values and display output values

for input_value in input_values:

  # Write input value to input port

  model.in_.value = input_value

  # Display input and output values

  print " cycle = {}: in = {}, out = {}" \
    .format( sim.ncycles, model.in_, model.out )

  # Tick simulator one cycle

  sim.cycle()

