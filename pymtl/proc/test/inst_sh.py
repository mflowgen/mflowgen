#=========================================================================
# sh
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
    csrr x2, mngr2proc < 0xdeadbeef
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sh   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > 0x0102beef

    .data
    .word 0x01020304
  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [

    gen_st_dest_dep_test( 5, "sh", 0x30313233, 0x2000, 0x00013233 ),
    gen_st_dest_dep_test( 4, "sh", 0x34353637, 0x2004, 0x04053637 ),
    gen_st_dest_dep_test( 3, "sh", 0x38393a3b, 0x2008, 0x08093a3b ),
    gen_st_dest_dep_test( 2, "sh", 0x3c3d3e3f, 0x200c, 0x0c0d3e3f ),
    gen_st_dest_dep_test( 1, "sh", 0x40414243, 0x2010, 0x10114243 ),
    gen_st_dest_dep_test( 0, "sh", 0x44454647, 0x2014, 0x14154647 ),

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

    gen_st_base_dep_test( 5, "sh", 0x30313233, 0x2000, 0x00013233 ),
    gen_st_base_dep_test( 4, "sh", 0x34353637, 0x2004, 0x04053637 ),
    gen_st_base_dep_test( 3, "sh", 0x38393a3b, 0x2008, 0x08093a3b ),
    gen_st_base_dep_test( 2, "sh", 0x3c3d3e3f, 0x200c, 0x0c0d3e3f ),
    gen_st_base_dep_test( 1, "sh", 0x40414243, 0x2010, 0x10114243 ),
    gen_st_base_dep_test( 0, "sh", 0x44454647, 0x2014, 0x14154647 ),

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
# gen_src_dep_test
#-------------------------------------------------------------------------

def gen_src_dep_test():
  return [

    gen_st_src_dep_test( 5, "sh", 0x30313233, 0x2000, 0x00013233 ),
    gen_st_src_dep_test( 4, "sh", 0x34353637, 0x2004, 0x04053637 ),
    gen_st_src_dep_test( 3, "sh", 0x38393a3b, 0x2008, 0x08093a3b ),
    gen_st_src_dep_test( 2, "sh", 0x3c3d3e3f, 0x200c, 0x0c0d3e3f ),
    gen_st_src_dep_test( 1, "sh", 0x40414243, 0x2010, 0x10114243 ),
    gen_st_src_dep_test( 0, "sh", 0x44454647, 0x2014, 0x14154647 ),

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
# gen_srcs_dep_test
#-------------------------------------------------------------------------

def gen_srcs_dep_test():
  return [

    gen_st_srcs_dep_test( 5, "sh", 0x30313233, 0x2000, 0x00013233 ),
    gen_st_srcs_dep_test( 4, "sh", 0x34353637, 0x2004, 0x04053637 ),
    gen_st_srcs_dep_test( 3, "sh", 0x38393a3b, 0x2008, 0x08093a3b ),
    gen_st_srcs_dep_test( 2, "sh", 0x3c3d3e3f, 0x200c, 0x0c0d3e3f ),
    gen_st_srcs_dep_test( 1, "sh", 0x40414243, 0x2010, 0x10114243 ),
    gen_st_srcs_dep_test( 0, "sh", 0x44454647, 0x2014, 0x14154647 ),

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
    gen_st_src_eq_base_test( "sh", 0x00002000, 0x01022000 ),
    gen_word_data([ 0x01020304 ])
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test positive offsets

    gen_st_value_test( "sh", 0x30313233,   0, 0x00002000, 0xdead3233 ),
    gen_st_value_test( "sh", 0x34353637,   4, 0x00002000, 0x00013637 ),
    gen_st_value_test( "sh", 0x38393a3b,   8, 0x00002000, 0x04053a3b ),
    gen_st_value_test( "sh", 0x3c3d3e3f,  12, 0x00002000, 0x08093e3f ),
    gen_st_value_test( "sh", 0x40414243,  16, 0x00002000, 0x0c0d4243 ),
    gen_st_value_test( "sh", 0x44454647,  20, 0x00002000, 0xcafe4647 ),

    # Test negative offsets

    gen_st_value_test( "sh", 0x48494a4b, -20, 0x00002014, 0xdead4a4b ),
    gen_st_value_test( "sh", 0x4c4d4e4f, -16, 0x00002014, 0x00014e4f ),
    gen_st_value_test( "sh", 0x50515253, -12, 0x00002014, 0x04055253 ),
    gen_st_value_test( "sh", 0x54555657,  -8, 0x00002014, 0x08095657 ),
    gen_st_value_test( "sh", 0x58595a5b,  -4, 0x00002014, 0x0c0d5a5b ),
    gen_st_value_test( "sh", 0x5c5d5e5f,   0, 0x00002014, 0xcafe5e5f ),

    # Test positive offset with unaligned base

    gen_st_value_test( "sh", 0x60616263,   1, 0x00001fff, 0xdead6263 ),
    gen_st_value_test( "sh", 0x64656667,   5, 0x00001fff, 0x00016667 ),
    gen_st_value_test( "sh", 0x68696a6b,   9, 0x00001fff, 0x04056a6b ),
    gen_st_value_test( "sh", 0x6c6d6e6f,  13, 0x00001fff, 0x08096e6f ),
    gen_st_value_test( "sh", 0x70717273,  17, 0x00001fff, 0x0c0d7273 ),
    gen_st_value_test( "sh", 0x74757677,  21, 0x00001fff, 0xcafe7677 ),

    # Test negative offset with unaligned base

    gen_st_value_test( "sh", 0x78797a7b, -21, 0x00002015, 0xdead7a7b ),
    gen_st_value_test( "sh", 0x7c7d7e7f, -17, 0x00002015, 0x00017e7f ),
    gen_st_value_test( "sh", 0x80818283, -13, 0x00002015, 0x04058283 ),
    gen_st_value_test( "sh", 0x84858687,  -9, 0x00002015, 0x08098687 ),
    gen_st_value_test( "sh", 0x88898a8b,  -5, 0x00002015, 0x0c0d8a8b ),
    gen_st_value_test( "sh", 0x8c8d8e8f,  -1, 0x00002015, 0xcafe8e8f ),

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

  # Generate some random data to initialize memory

  initial_data = []
  for i in xrange(128):
    initial_data.append( random.randint(0,0xffffffff) )

  # Generate random accesses to this data

  asm_code = []
  for i in xrange(100):

    a = random.randint(0,127)
    b = random.randint(0,127)

    base   = Bits( 32, 0x2000 + (4*b) )
    offset = Bits( 16, (4*(a - b)) )
    result = ( Bits( 32, initial_data[a] ) & 0xffff0000 ) \
           | ( Bits( 32,         data[a] ) & 0x0000ffff )

    asm_code.append( gen_st_value_test( "sh", result.int(), offset.int(), base.uint(), result.int() ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( initial_data ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
