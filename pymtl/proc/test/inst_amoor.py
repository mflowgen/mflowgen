#=========================================================================
# amoor
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
    csrr x2, mngr2proc < 0x00000004
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    amoor x3, x1, x2
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
    csrw proc2mngr, x4 > 0x00000006

    .data
    .word 0x00000002
  """
#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test with shifting f

    gen_amo_value_test( "amoor", 0x00002000, 0x0000000f, 0x00000000, 0x0000000f ),
    gen_amo_value_test( "amoor", 0x00002000, 0x000000f0, 0x0000000f, 0x000000ff ),
    gen_amo_value_test( "amoor", 0x00002000, 0x00000f00, 0x000000ff, 0x00000fff ),
    gen_amo_value_test( "amoor", 0x00002000, 0x0000f000, 0x00000fff, 0x0000ffff ),
    gen_amo_value_test( "amoor", 0x00002000, 0x000f0000, 0x0000ffff, 0x000fffff ),
    gen_amo_value_test( "amoor", 0x00002000, 0x00f00000, 0x000fffff, 0x00ffffff ),
    gen_amo_value_test( "amoor", 0x00002000, 0x0f000000, 0x00ffffff, 0x0fffffff ),
    gen_amo_value_test( "amoor", 0x00002000, 0xf0000000, 0x0fffffff, 0xffffffff ),

    # Test misc

    gen_amo_value_test( "amoor", 0x00002004, 0x000f, 0xdeadbeef, 0xdeadbeef ),
    gen_amo_value_test( "amoor", 0x00002008, 0x00ff, 0xdeadbeef, 0xdeadbeff ),
    gen_amo_value_test( "amoor", 0x0000200c, 0x0fff, 0xdeadbeef, 0xdeadbfff ),
    gen_amo_value_test( "amoor", 0x00002010, 0xffff, 0xdeadbeef, 0xdeadffff ),
    gen_amo_value_test( "amoor", 0x00002014, 0xfff0, 0xdeadbeef, 0xdeadffff ),
    gen_amo_value_test( "amoor", 0x00002018, 0xff00, 0xdeadbeef, 0xdeadffef ),

    # Tests pulled from "or"

    gen_amo_value_test( "amoor", 0x0000201c, 0x0f0f0f0f, 0xff00ff00, 0xff0fff0f ),
    gen_amo_value_test( "amoor", 0x00002020, 0xf0f0f0f0, 0x0ff00ff0, 0xfff0fff0 ),
    gen_amo_value_test( "amoor", 0x00002024, 0x0f0f0f0f, 0x00ff00ff, 0x0fff0fff ),
    gen_amo_value_test( "amoor", 0x00002028, 0xf0f0f0f0, 0xf00ff00f, 0xf0fff0ff ),

    gen_word_data([
      0x00000000,

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
    result_post = data[a] | b # or
    data[a]     = result_post

    asm_code.append( \
        gen_amo_value_test( "amoor", addr, b, result_pre, result_post ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( original_data ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_basic_mcore_test
#-------------------------------------------------------------------------

def gen_basic_mcore_test():
  return """
    csrr    x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr    x2, mngr2proc < {0x0fff0f00,0xff00f0ff,0x00f0f0f0,0xffffffff}

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    amoor   x3, x1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lw      x4, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

    csrw    proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}
    csrw    proc2mngr, x4 > {0x0fff0f04,0xff03f4ff,0x03f4f5f6,0xffffffff}

    .data
    .word 0x01020304
    .word 0x02030405
    .word 0x03040506
    .word 0x04050607
  """

#-------------------------------------------------------------------------
# gen_random_mcore_test
#-------------------------------------------------------------------------

def gen_random_mcore_test():

  # Generate some random data

  data = []
  for i in xrange(128):
    data.append( random.randint(0,0xffffffff) )

  # AMOs modify the data, so keep a copy of the original data to dump later

  original_data = list(data)

  # Generate random accesses to this data

  asm_code = []

  # randomly shuffled list of indices
  # core i: index_list [ i*32 .. (i+1) * 32 - 1 ]

  index_list = [ i for i in range(128) ]
  random.shuffle( index_list )

  for i in xrange(50):

    addr        = [0] * 4
    b           = [0] * 4
    result_pre  = [0] * 4
    result_post = [0] * 4

    for j in xrange(4):
      a               = index_list[ random.randint( j*32, (j+1)*32-1 ) ]
      addr[j]         = 0x2000 + 4*a
      b[j]            = random.randint(0,127)
      result_pre[j]   = data[a]
      result_post[j]  = b[j] | data[a]
      data[a]         = result_post[j]

    asm_code.append( \
        gen_amo_value_test( "amoor",
                            "{" + ','.join(str(e) for e in addr)        + "}",    # addr
                            "{" + ','.join(str(e) for e in b)           + "}",    # b
                            "{" + ','.join(str(e) for e in result_pre)  + "}",    # result_pre
                            "{" + ','.join(str(e) for e in result_post) + "}",    # result_post
                          ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( original_data ) )
  return asm_code
