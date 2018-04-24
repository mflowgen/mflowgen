#=========================================================================
# lhu
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lhu   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x2 > 0x00008070

    .data
    .word 0x50608070
  """

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [

    gen_ld_dest_dep_test( 5, "lhu", 0x2000, 0x00000203 ),
    gen_ld_dest_dep_test( 4, "lhu", 0x2004, 0x00000607 ),
    gen_ld_dest_dep_test( 3, "lhu", 0x2008, 0x00000a0b ),
    gen_ld_dest_dep_test( 2, "lhu", 0x200c, 0x00000e0f ),
    gen_ld_dest_dep_test( 1, "lhu", 0x2010, 0x00001213 ),
    gen_ld_dest_dep_test( 0, "lhu", 0x2014, 0x00001617 ),

    gen_word_data([
      0x00010203,
      0x04050607,
      0x08090a0b,
      0x0c0d0e0f,
      0x10111213,
      0x14151617,
    ])

  ]

#-------------------------------------------------------------------------
# gen_base_dep_test
#-------------------------------------------------------------------------

def gen_base_dep_test():
  return [

    gen_ld_base_dep_test( 5, "lhu", 0x2000, 0x00000203 ),
    gen_ld_base_dep_test( 4, "lhu", 0x2004, 0x00000607 ),
    gen_ld_base_dep_test( 3, "lhu", 0x2008, 0x00000a0b ),
    gen_ld_base_dep_test( 2, "lhu", 0x200c, 0x00000e0f ),
    gen_ld_base_dep_test( 1, "lhu", 0x2010, 0x00001213 ),
    gen_ld_base_dep_test( 0, "lhu", 0x2014, 0x00001617 ),

    gen_word_data([
      0x00010203,
      0x04050607,
      0x08090a0b,
      0x0c0d0e0f,
      0x10111213,
      0x14151617,
    ])

  ]

#-------------------------------------------------------------------------
# gen_srcs_dest_test
#-------------------------------------------------------------------------

def gen_srcs_dest_test():
  return [
    gen_ld_base_eq_dest_test( "lhu", 0x2000, 0x00000304 ),
    gen_word_data([ 0x01020304 ])
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test positive offsets

    gen_ld_value_test( "lhu",   0, 0x00002000, 0x0000beef ),
    gen_ld_value_test( "lhu",   4, 0x00002000, 0x00000203 ),
    gen_ld_value_test( "lhu",   8, 0x00002000, 0x00000607 ),
    gen_ld_value_test( "lhu",  12, 0x00002000, 0x00000a0b ),
    gen_ld_value_test( "lhu",  16, 0x00002000, 0x00000e0f ),
    gen_ld_value_test( "lhu",  20, 0x00002000, 0x0000cafe ),

    # Test negative offsets

    gen_ld_value_test( "lhu", -20, 0x00002014, 0x0000beef ),
    gen_ld_value_test( "lhu", -16, 0x00002014, 0x00000203 ),
    gen_ld_value_test( "lhu", -12, 0x00002014, 0x00000607 ),
    gen_ld_value_test( "lhu",  -8, 0x00002014, 0x00000a0b ),
    gen_ld_value_test( "lhu",  -4, 0x00002014, 0x00000e0f ),
    gen_ld_value_test( "lhu",   0, 0x00002014, 0x0000cafe ),

    # Test positive offset with unaligned base

    gen_ld_value_test( "lhu",   1, 0x00001fff, 0x0000beef ),
    gen_ld_value_test( "lhu",   5, 0x00001fff, 0x00000203 ),
    gen_ld_value_test( "lhu",   9, 0x00001fff, 0x00000607 ),
    gen_ld_value_test( "lhu",  13, 0x00001fff, 0x00000a0b ),
    gen_ld_value_test( "lhu",  17, 0x00001fff, 0x00000e0f ),
    gen_ld_value_test( "lhu",  21, 0x00001fff, 0x0000cafe ),

    # Test negative offset with unaligned base

    gen_ld_value_test( "lhu", -21, 0x00002015, 0x0000beef ),
    gen_ld_value_test( "lhu", -17, 0x00002015, 0x00000203 ),
    gen_ld_value_test( "lhu", -13, 0x00002015, 0x00000607 ),
    gen_ld_value_test( "lhu",  -9, 0x00002015, 0x00000a0b ),
    gen_ld_value_test( "lhu",  -5, 0x00002015, 0x00000e0f ),
    gen_ld_value_test( "lhu",  -1, 0x00002015, 0x0000cafe ),

    # Test subword accesses

    gen_ld_value_test( "lhu",   0, 0x00002000, 0x0000beef ),
    gen_ld_value_test( "lhu",   0, 0x00002002, 0x0000dead ),
    gen_ld_value_test( "lhu",   0, 0x00002004, 0x00000203 ),
    gen_ld_value_test( "lhu",   0, 0x00002006, 0x00000001 ),

    gen_word_data([
      0xdeadbeef,
      0x00010203,
      0x04050607,
      0x08090a0b,
      0x0c0d0e0f,
      0xcafecafe,
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

  # Generate random accesses to this data

  asm_code = []
  for i in xrange(100):

    a = random.randint(0,127)
    b = random.randint(0,127)

    base   = Bits( 32, 0x2000 + (4*b) )
    offset = Bits( 16, (4*(a - b)) )
    result = Bits( 32, data[a] )[0:16]

    asm_code.append( gen_ld_value_test( "lhu", offset.int(), base.uint(), result.uint() ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( data ) )
  return asm_code

