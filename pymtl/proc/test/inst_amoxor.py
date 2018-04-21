#=========================================================================
# amoxor
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
    csrr x2, mngr2proc < 0x0000fff0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    amoxor x3, x1, x2
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
    csrw proc2mngr, x3 > 0x00000fff
    csrw proc2mngr, x4 > 0x0000f00f

    .data
    .word 0x00000fff
  """
#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test with shifting f

    gen_amo_value_test( "amoxor", 0x00002000, 0x0000000f, 0xffff0000, 0xffff000f ),
    gen_amo_value_test( "amoxor", 0x00002000, 0x000000f0, 0xffff000f, 0xffff00ff ),
    gen_amo_value_test( "amoxor", 0x00002000, 0x00000f00, 0xffff00ff, 0xffff0fff ),
    gen_amo_value_test( "amoxor", 0x00002000, 0x0000f000, 0xffff0fff, 0xffffffff ),
    gen_amo_value_test( "amoxor", 0x00002000, 0x000f0000, 0xffffffff, 0xfff0ffff ),
    gen_amo_value_test( "amoxor", 0x00002000, 0x00f00000, 0xfff0ffff, 0xff00ffff ),
    gen_amo_value_test( "amoxor", 0x00002000, 0x0f000000, 0xff00ffff, 0xf000ffff ),
    gen_amo_value_test( "amoxor", 0x00002000, 0xf0000000, 0xf000ffff, 0x0000ffff ),

    # Test misc

    gen_amo_value_test( "amoxor", 0x00002004, 0x000f, 0xdeadbeef, 0xdeadbee0 ),
    gen_amo_value_test( "amoxor", 0x00002008, 0x00ff, 0xdeadbeef, 0xdeadbe10 ),
    gen_amo_value_test( "amoxor", 0x0000200c, 0x0fff, 0xdeadbeef, 0xdeadb110 ),
    gen_amo_value_test( "amoxor", 0x00002010, 0xffff, 0xdeadbeef, 0xdead4110 ),
    gen_amo_value_test( "amoxor", 0x00002014, 0xfff0, 0xdeadbeef, 0xdead411f ),
    gen_amo_value_test( "amoxor", 0x00002018, 0xff00, 0xdeadbeef, 0xdead41ef ),

    gen_word_data([
      0xffff0000,

      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
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
    result_post = data[a] ^ b # xor
    data[a]     = result_post

    asm_code.append( \
        gen_amo_value_test( "amoxor", addr, b, result_pre, result_post ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( original_data ) )
  return asm_code

