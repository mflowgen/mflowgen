#=========================================================================
# amoand
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
    amoand x3, x1, x2
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
    csrw proc2mngr, x4 > 0x00000ff0

    .data
    .word 0x00000fff
  """
#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test with shifting 0

    gen_amo_value_test( "amoand", 0x00002000, 0xfffffff0, 0xffffffff, 0xfffffff0 ),
    gen_amo_value_test( "amoand", 0x00002000, 0xffffff0f, 0xfffffff0, 0xffffff00 ),
    gen_amo_value_test( "amoand", 0x00002000, 0xfffff0ff, 0xffffff00, 0xfffff000 ),
    gen_amo_value_test( "amoand", 0x00002000, 0xffff0fff, 0xfffff000, 0xffff0000 ),
    gen_amo_value_test( "amoand", 0x00002000, 0xfff0ffff, 0xffff0000, 0xfff00000 ),
    gen_amo_value_test( "amoand", 0x00002000, 0xff0fffff, 0xfff00000, 0xff000000 ),
    gen_amo_value_test( "amoand", 0x00002000, 0xf0ffffff, 0xff000000, 0xf0000000 ),
    gen_amo_value_test( "amoand", 0x00002000, 0x0fffffff, 0xf0000000, 0x00000000 ),

    # Test misc

    gen_amo_value_test( "amoand", 0x00002004, 0x000f, 0xdeadbeef, 0x0000000f ),
    gen_amo_value_test( "amoand", 0x00002008, 0x00ff, 0xdeadbeef, 0x000000ef ),
    gen_amo_value_test( "amoand", 0x0000200c, 0x0fff, 0xdeadbeef, 0x00000eef ),
    gen_amo_value_test( "amoand", 0x00002010, 0xffff, 0xdeadbeef, 0x0000beef ),
    gen_amo_value_test( "amoand", 0x00002014, 0xfff0, 0xdeadbeef, 0x0000bee0 ),
    gen_amo_value_test( "amoand", 0x00002018, 0xff00, 0xdeadbeef, 0x0000be00 ),

    # Tests pulled from "and"

    gen_amo_value_test( "amoand", 0x0000201c, 0x0f0f0f0f, 0xff00ff00, 0x0f000f00 ),
    gen_amo_value_test( "amoand", 0x00002020, 0xf0f0f0f0, 0x0ff00ff0, 0x00f000f0 ),
    gen_amo_value_test( "amoand", 0x00002024, 0x0f0f0f0f, 0x00ff00ff, 0x000f000f ),
    gen_amo_value_test( "amoand", 0x00002028, 0xf0f0f0f0, 0xf00ff00f, 0xf000f000 ),

    gen_word_data([
      0xffffffff,

      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,

      0xff00ff00,
      0x0ff00ff0,
      0x00ff00ff,
      0xf00ff00f,
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
    result_post = data[a] & b # and
    data[a]     = result_post

    asm_code.append( \
        gen_amo_value_test( "amoand", addr, b, result_pre, result_post ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( original_data ) )
  return asm_code

