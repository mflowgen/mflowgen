#=========================================================================
# amoadd
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
    csrr x2, mngr2proc < 0x00000003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    amoadd x3, x1, x2
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
    csrw proc2mngr, x3 > 0x00000002
    csrw proc2mngr, x4 > 0x00000005

    .data
    .word 0x00000002
  """
#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test misc

    gen_amo_value_test( "amoadd", 0x00002000, 1, 0xdeadbeef, 0xdeadbef0 ),
    gen_amo_value_test( "amoadd", 0x00002004, 2, 0xdeadbeef, 0xdeadbef1 ),
    gen_amo_value_test( "amoadd", 0x00002008, 3, 0xdeadbeef, 0xdeadbef2 ),
    gen_amo_value_test( "amoadd", 0x0000200c, 4, 0xdeadbeef, 0xdeadbef3 ),
    gen_amo_value_test( "amoadd", 0x00002010, 5, 0xdeadbeef, 0xdeadbef4 ),
    gen_amo_value_test( "amoadd", 0x00002014, 6, 0xdeadbeef, 0xdeadbef5 ),

    # Tests pulled from "add"

    gen_amo_value_test( "amoadd", 0x00002018, 0x00000000, 0x00000000, 0x00000000 ),
    gen_amo_value_test( "amoadd", 0x0000201c, 0x00000001, 0x00000001, 0x00000002 ),
    gen_amo_value_test( "amoadd", 0x00002020, 0x00000007, 0x00000003, 0x0000000a ),

    gen_amo_value_test( "amoadd", 0x00002024, 0xffff8000, 0x00000000, 0xffff8000 ),
    gen_amo_value_test( "amoadd", 0x00002028, 0x00000000, 0x80000000, 0x80000000 ),
    gen_amo_value_test( "amoadd", 0x0000202c, 0xffff8000, 0x80000000, 0x7fff8000 ),

    gen_amo_value_test( "amoadd", 0x00002030, 0x00007fff, 0x00000000, 0x00007fff ),
    gen_amo_value_test( "amoadd", 0x00002034, 0x00000000, 0x7fffffff, 0x7fffffff ),
    gen_amo_value_test( "amoadd", 0x00002038, 0x00007fff, 0x7fffffff, 0x80007ffe ),

    gen_amo_value_test( "amoadd", 0x0000203c, 0x00007fff, 0x80000000, 0x80007fff ),
    gen_amo_value_test( "amoadd", 0x00002040, 0xffff8000, 0x7fffffff, 0x7fff7fff ),

    gen_amo_value_test( "amoadd", 0x00002044, 0xffffffff, 0x00000000, 0xffffffff ),
    gen_amo_value_test( "amoadd", 0x00002048, 0x00000001, 0xffffffff, 0x00000000 ),
    gen_amo_value_test( "amoadd", 0x0000204c, 0xffffffff, 0xffffffff, 0xfffffffe ),

    gen_word_data([
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,
      0xdeadbeef,

      0x00000000,
      0x00000001,
      0x00000003,

      0x00000000,
      0x80000000,
      0x80000000,

      0x00000000,
      0x7fffffff,
      0x7fffffff,

      0x80000000,
      0x7fffffff,

      0x00000000,
      0xffffffff,
      0xffffffff,
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
    result_post = data[a] + b # add
    data[a]     = result_post

    asm_code.append( \
        gen_amo_value_test( "amoadd", addr, b, result_pre, result_post ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( original_data ) )
  return asm_code

