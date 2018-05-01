#=========================================================================
# mem_sim_eval
#=========================================================================
# Run the evaluations on the baseline and alternative design.

import os

from subprocess import check_output, CalledProcessError

impls  = [ "alt" ]
inputs = [ "loop-1d", "loop-2d", "loop-3d" ]

eval_runs = []

for impl in impls:
  for input_ in inputs:
    eval_runs.append([ impl, input_ ])

# Get path to simulator script

sim_dir = os.path.dirname( os.path.abspath( __file__ ) )
sim     = sim_dir + os.path.sep + 'mem-sim'

# Print header

print ""
print " Results from running simulator"
print ""
print "    {:<5} {:<10} {:>9}".format( "Impl", "Pattern", "Miss Rate" )
print "    " + "-" * 26

# Run the simulator

for eval_run in eval_runs:

  # Command

  impl   = eval_run[0]
  input_ = eval_run[1]

  cmd = [ sim, "--impl", impl, "--pattern", input_, "--stats" ]

  try:
    result = check_output( cmd ).strip()
  except CalledProcessError as e:
    raise Exception( "Error running simulator!\n\n"
                     "Simulator command line: {cmd}\n\n"
                     "Simulator output:\n {output}"
                     .format( cmd=' '.join(e.cmd), output=e.output ) )

  # Find result

  miss_rate = None
  for line in result.splitlines():
    if line.startswith('miss_rate'):
      miss_rate = line.split('=')[1].strip()

  # Display result

  print "  - {:<5} {:<10} {:>9.2f}".format( impl, input_, float( miss_rate ) )

print ""

