#=========================================================================
# flw
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x2, mngr2proc < 0x00001000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrr x1, mngr2proc < 0x00002000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    flw   f2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    fmv.x.w x3, f2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x3 > 0x01020304
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x2 > 0x00001000

    .data
    .word 0x01020304
  """

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [

    gen_fp_ld_dest_dep_test( 5, "flw", 0x2000, 0x00010203 ),
    gen_fp_ld_dest_dep_test( 4, "flw", 0x2004, 0x04050607 ),
    gen_fp_ld_dest_dep_test( 3, "flw", 0x2008, 0x08090a0b ),
    gen_fp_ld_dest_dep_test( 2, "flw", 0x200c, 0x0c0d0e0f ),
    gen_fp_ld_dest_dep_test( 1, "flw", 0x2010, 0x10111213 ),
    gen_fp_ld_dest_dep_test( 0, "flw", 0x2014, 0x14151617 ),

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

    gen_fp_ld_base_dep_test( 5, "flw", 0x2000, 0x00010203 ),
    gen_fp_ld_base_dep_test( 4, "flw", 0x2004, 0x04050607 ),
    gen_fp_ld_base_dep_test( 3, "flw", 0x2008, 0x08090a0b ),
    gen_fp_ld_base_dep_test( 2, "flw", 0x200c, 0x0c0d0e0f ),
    gen_fp_ld_base_dep_test( 1, "flw", 0x2010, 0x10111213 ),
    gen_fp_ld_base_dep_test( 0, "flw", 0x2014, 0x14151617 ),

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
    gen_fp_ld_base_eq_dest_test( "flw", 0x2000, 0x01020304 ),
    gen_word_data([ 0x01020304 ])
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test positive offsets

    gen_fp_ld_value_test( "flw",   0, 0x00002000, 0xdeadbeef ),
    gen_fp_ld_value_test( "flw",   4, 0x00002000, 0x00010203 ),
    gen_fp_ld_value_test( "flw",   8, 0x00002000, 0x04050607 ),
    gen_fp_ld_value_test( "flw",  12, 0x00002000, 0x08090a0b ),
    gen_fp_ld_value_test( "flw",  16, 0x00002000, 0x0c0d0e0f ),
    gen_fp_ld_value_test( "flw",  20, 0x00002000, 0xcafecafe ),

    # Test negative offsets

    gen_fp_ld_value_test( "flw", -20, 0x00002014, 0xdeadbeef ),
    gen_fp_ld_value_test( "flw", -16, 0x00002014, 0x00010203 ),
    gen_fp_ld_value_test( "flw", -12, 0x00002014, 0x04050607 ),
    gen_fp_ld_value_test( "flw",  -8, 0x00002014, 0x08090a0b ),
    gen_fp_ld_value_test( "flw",  -4, 0x00002014, 0x0c0d0e0f ),
    gen_fp_ld_value_test( "flw",   0, 0x00002014, 0xcafecafe ),

    # Test positive offset with unaligned base

    gen_fp_ld_value_test( "flw",   1, 0x00001fff, 0xdeadbeef ),
    gen_fp_ld_value_test( "flw",   5, 0x00001fff, 0x00010203 ),
    gen_fp_ld_value_test( "flw",   9, 0x00001fff, 0x04050607 ),
    gen_fp_ld_value_test( "flw",  13, 0x00001fff, 0x08090a0b ),
    gen_fp_ld_value_test( "flw",  17, 0x00001fff, 0x0c0d0e0f ),
    gen_fp_ld_value_test( "flw",  21, 0x00001fff, 0xcafecafe ),

    # Test negative offset with unaligned base

    gen_fp_ld_value_test( "flw", -21, 0x00002015, 0xdeadbeef ),
    gen_fp_ld_value_test( "flw", -17, 0x00002015, 0x00010203 ),
    gen_fp_ld_value_test( "flw", -13, 0x00002015, 0x04050607 ),
    gen_fp_ld_value_test( "flw",  -9, 0x00002015, 0x08090a0b ),
    gen_fp_ld_value_test( "flw",  -5, 0x00002015, 0x0c0d0e0f ),
    gen_fp_ld_value_test( "flw",  -1, 0x00002015, 0xcafecafe ),

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
    result = data[a]

    asm_code.append( gen_fp_ld_value_test( "flw", offset.int(), base.uint(), result ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( data ) )
  return asm_code

