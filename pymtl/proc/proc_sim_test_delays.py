#=========================================================================
# proc_sim_test_delays
#=========================================================================
# Run the evaluations on the baseline and alternative design with random
# delays

import os

from subprocess import check_output, CalledProcessError

impls  = [ "base", "alt" ]
inputs = [ "vvadd-unopt", "vvadd-opt", "cmplx-mult", "bin-search", "masked-filter" ]

eval_runs = []

for impl in impls:
  for input_ in inputs:
    eval_runs.append([ impl, input_ ])

# Get path to simulator script

sim_dir = os.path.dirname( os.path.abspath( __file__ ) )
sim     = sim_dir + os.path.sep + 'proc-sim'

# Print header

print ""
print " Results from running simulator with mem-lantency = 2 and mem-dprob = 0.2"
print ""

# Run the simulator

for eval_run in eval_runs:

  # Command

  impl   = eval_run[0]
  input_ = eval_run[1]

  cmd = [ sim, "--impl", impl, "--input", input_, "--stats", "--verify", 
          "--max-cycles",  "100000", "--mem-latency", "2", "--mem-dprob", "0.2" ]

  try:
    result = check_output( cmd ).strip()
  except CalledProcessError as e:
    raise Exception( "Error running simulator!\n\n"
                     "Simulator command line: {cmd}\n\n"
                     "Simulator output:\n {output}"
                     .format( cmd=' '.join(e.cmd), output=e.output ) )

  # Find result

  cpi = None
  for line in result.splitlines():
    if line.startswith(' CPI '):
      cpi = line.split('=')[1].strip()

  # Display result

  print "  - {:<5} {:<13} {:>5}".format( impl, input_, cpi )

print ""

