#=========================================================================
# imul_sim_eval
#=========================================================================
# Run the evaluations on the baseline and alternative design.

import os

from subprocess import check_output, CalledProcessError

impls  = [ "base", "alt" ]
inputs = [ "small", "large", "lomask", "himask", "lohimask", "sparse" ]

eval_runs = []

for impl in impls:
  for input_ in inputs:
    eval_runs.append([ impl, input_ ])

# Get path to simulator script

sim_dir = os.path.dirname( os.path.abspath( __file__ ) )
sim     = sim_dir + os.path.sep + 'imul-sim'

# Print header

print ""
print " Results from running simulator"
print ""

# Run the simulator

for eval_run in eval_runs:

  # Command

  impl   = eval_run[0]
  input_ = eval_run[1]

  cmd = [ sim, "--impl", impl, "--input", input_, "--stats" ]

  try:
    result = check_output( cmd ).strip()
  except CalledProcessError as e:
    raise Exception( "Error running simulator!" )

  # Find result

  num_cycles_per_mul = None
  for line in result.splitlines():
    if line.startswith('num_cycles_per_mul '):
      num_cycles_per_mul = line.split('=')[1].strip()

  # Display result

  print "  - {:<5} {:<9} {:>5}".format( impl, input_, num_cycles_per_mul )

print ""

