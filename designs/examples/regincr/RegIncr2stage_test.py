#=========================================================================
# Regincr2stage_test
#=========================================================================

import random

from pymtl         import *
from pclib.test    import run_test_vector_sim
from RegIncr2stage import RegIncr2stage

#-------------------------------------------------------------------------
# test_small
#-------------------------------------------------------------------------

def test_small( dump_vcd ):
  run_test_vector_sim( RegIncr2stage(), [
    ('in_   out*'),
    [ 0x00, '?'  ],
    [ 0x03, '?'  ],
    [ 0x06, 0x02 ],
    [ 0x00, 0x05 ],
    [ 0x00, 0x08 ],
  ], dump_vcd )

#-------------------------------------------------------------------------
# test_large
#-------------------------------------------------------------------------

def test_large( dump_vcd ):
  run_test_vector_sim( RegIncr2stage(), [
    ('in_   out*'),
    [ 0xa0, '?'  ],
    [ 0xb3, '?'  ],
    [ 0xc6, 0xa2 ],
    [ 0x00, 0xb5 ],
    [ 0x00, 0xc8 ],
  ], dump_vcd )

#-------------------------------------------------------------------------
# test_overflow
#-------------------------------------------------------------------------

def test_overflow( dump_vcd ):
  run_test_vector_sim( RegIncr2stage(), [
    ('in_   out*'),
    [ 0x00, '?'  ],
    [ 0xfe, '?'  ],
    [ 0xff, 0x02 ],
    [ 0x00, 0x00 ],
    [ 0x00, 0x01 ],
  ], dump_vcd )

#-------------------------------------------------------------------------
# test_random
#-------------------------------------------------------------------------

def test_random( dump_vcd ):

  test_vector_table = [( 'in_', 'out*' )]
  last_result_0 = '?'
  last_result_1 = '?'
  for i in xrange(20):
    rand_value = Bits( 8, random.randint(0,0xff) )
    test_vector_table.append( [ rand_value, last_result_1 ] )
    last_result_1 = last_result_0
    last_result_0 = Bits( 8, rand_value + 2 )

  run_test_vector_sim( RegIncr2stage(), test_vector_table, dump_vcd )

