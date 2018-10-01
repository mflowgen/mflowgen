#=========================================================================
# GcdUnitCL_test
#=========================================================================

import pytest

from pymtl      import *
from pclib.test import run_sim
from GcdUnitCL  import gcd, GcdUnitCL

# Reuse tests from FL model

from GcdUnitFL_test import TestHarness
from GcdUnitFL_test import basic_msgs, random_msgs, test_case_table

#-------------------------------------------------------------------------
# test_gcd
#-------------------------------------------------------------------------

def test_gcd():
  #           a   b         result ncycles
  assert gcd( 0,  0  ) == ( 0,     1       )
  assert gcd( 1,  0  ) == ( 1,     1       )
  assert gcd( 0,  1  ) == ( 1,     2       )
  assert gcd( 5,  5  ) == ( 5,     3       )
  assert gcd( 15, 5  ) == ( 5,     5       )
  assert gcd( 5,  15 ) == ( 5,     6       )
  assert gcd( 7,  13 ) == ( 1,     13      )
#  assert gcd( 75, 45 ) == ( 15,    8       )
#  assert gcd( 36, 96 ) == ( 12,    10      )

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd ):
  run_sim( TestHarness( GcdUnitCL(),
                        test_params.msgs[::2], test_params.msgs[1::2],
                        test_params.src_delay, test_params.sink_delay ),
           dump_vcd )

