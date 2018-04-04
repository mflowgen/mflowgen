#=========================================================================
# imul_sim_test
#=========================================================================
# Make sure that imul-sim works.

import pytest
import os

from subprocess import check_call, CalledProcessError
from itertools  import product

impls  = [ "base", "alt" ]
inputs = [ "small" ]

test_cases = []

for input_ in inputs:
  for impl in impls:
    test_cases.append([ impl, input_ ])

@pytest.mark.parametrize( "impl,input_", test_cases )
def test( impl, input_, test_verilog ):

  # Get path to simulator script

  sim_dir = os.path.dirname( os.path.abspath( __file__ ) )
  sim     = sim_dir + os.path.sep + 'imul-sim'

  # Command

  cmd = [ sim, "--impl", impl, "--input", input_ ]

  # Display simulator command line

  print ""
  print "Simulator command line:", ' '.join(cmd)

  # Run the simulator

  try:
    check_call(cmd)
  except CalledProcessError as e:
    raise Exception( "Error running simulator!" )

