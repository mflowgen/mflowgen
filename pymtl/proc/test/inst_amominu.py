#=========================================================================
# amominu
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x00002000
    csrr x2, mngr2proc < 0x00000002
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    amominu x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lw x4, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x00000008
    csrw proc2mngr, x4 > 0x00000002

    .data
    .word 0x00000008
  """
#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test misc

    gen_amo_value_test( "amominu", 0x00002000, 0x77777777, 0x55555555, 0x55555555 ),
    gen_amo_value_test( "amominu", 0x00002000, 0x66666666, 0x55555555, 0x55555555 ),
    gen_amo_value_test( "amominu", 0x00002000, 0x55555555, 0x55555555, 0x55555555 ),
    gen_amo_value_test( "amominu", 0x00002000, 0x44444444, 0x55555555, 0x44444444 ),
    gen_amo_value_test( "amominu", 0x00002000, 0x33333333, 0x44444444, 0x33333333 ),
    gen_amo_value_test( "amominu", 0x00002000, 0x22222222, 0x33333333, 0x22222222 ),
    gen_amo_value_test( "amominu", 0x00002000, 0x11111111, 0x22222222, 0x11111111 ),

    # Test signedness

    gen_amo_value_test( "amominu", 0x00002004, 0x00000002, 0xffffffff, 0x00000002 ),
    gen_amo_value_test( "amominu", 0x00002008, 0xffffffff, 0x00000002, 0x00000002 ),

    gen_word_data([
      0x55555555,
      0xffffffff,
      0x00000002,
    ])

  ]

#-------------------------------------------------------------------------
# gen_random_test
#-------------------------------------------------------------------------

def gen_random_test():

  # Generate some random data

  data = []
  for i in xrange(128):
    data.append( random.randint(0,0xffffffff) )

  # AMOs modify the data, so keep a copy of the original data to dump later

  original_data = list(data)

  # Generate random accesses to this data

  asm_code = []
  for i in xrange(50):

    a = random.randint(0,127)
    b = random.randint(0,127)

    addr        = 0x2000 + (4*a)
    result_pre  = data[a]
    result_post = min( data[a], b ) # min (unsigned)
    data[a]     = result_post

    asm_code.append( \
        gen_amo_value_test( "amominu", addr, b, result_pre, result_post ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( original_data ) )
  return asm_code

