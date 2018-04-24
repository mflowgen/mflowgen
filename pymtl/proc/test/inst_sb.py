#=========================================================================
# sb
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
    sb   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > 0x010203ef

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

    gen_st_dest_dep_test( 5, "sb", 0x30313233, 0x2000, 0x00010233 ),
    gen_st_dest_dep_test( 4, "sb", 0x34353637, 0x2004, 0x04050637 ),
    gen_st_dest_dep_test( 3, "sb", 0x38393a3b, 0x2008, 0x08090a3b ),
    gen_st_dest_dep_test( 2, "sb", 0x3c3d3e3f, 0x200c, 0x0c0d0e3f ),
    gen_st_dest_dep_test( 1, "sb", 0x40414243, 0x2010, 0x10111243 ),
    gen_st_dest_dep_test( 0, "sb", 0x44454647, 0x2014, 0x14151647 ),

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

    gen_st_base_dep_test( 5, "sb", 0x30313233, 0x2000, 0x00010233 ),
    gen_st_base_dep_test( 4, "sb", 0x34353637, 0x2004, 0x04050637 ),
    gen_st_base_dep_test( 3, "sb", 0x38393a3b, 0x2008, 0x08090a3b ),
    gen_st_base_dep_test( 2, "sb", 0x3c3d3e3f, 0x200c, 0x0c0d0e3f ),
    gen_st_base_dep_test( 1, "sb", 0x40414243, 0x2010, 0x10111243 ),
    gen_st_base_dep_test( 0, "sb", 0x44454647, 0x2014, 0x14151647 ),

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

    gen_st_src_dep_test( 5, "sb", 0x30313233, 0x2000, 0x00010233 ),
    gen_st_src_dep_test( 4, "sb", 0x34353637, 0x2004, 0x04050637 ),
    gen_st_src_dep_test( 3, "sb", 0x38393a3b, 0x2008, 0x08090a3b ),
    gen_st_src_dep_test( 2, "sb", 0x3c3d3e3f, 0x200c, 0x0c0d0e3f ),
    gen_st_src_dep_test( 1, "sb", 0x40414243, 0x2010, 0x10111243 ),
    gen_st_src_dep_test( 0, "sb", 0x44454647, 0x2014, 0x14151647 ),

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

    gen_st_srcs_dep_test( 5, "sb", 0x30313233, 0x2000, 0x00010233 ),
    gen_st_srcs_dep_test( 4, "sb", 0x34353637, 0x2004, 0x04050637 ),
    gen_st_srcs_dep_test( 3, "sb", 0x38393a3b, 0x2008, 0x08090a3b ),
    gen_st_srcs_dep_test( 2, "sb", 0x3c3d3e3f, 0x200c, 0x0c0d0e3f ),
    gen_st_srcs_dep_test( 1, "sb", 0x40414243, 0x2010, 0x10111243 ),
    gen_st_srcs_dep_test( 0, "sb", 0x44454647, 0x2014, 0x14151647 ),

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
    gen_st_src_eq_base_test( "sb", 0x00002000, 0x01020300 ),
    gen_word_data([ 0x01020304 ])
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test positive offsets

    gen_st_value_test( "sb", 0x30313233,   0, 0x00002000, 0xdeadbe33 ),
    gen_st_value_test( "sb", 0x34353637,   4, 0x00002000, 0x00010237 ),
    gen_st_value_test( "sb", 0x38393a3b,   8, 0x00002000, 0x0405063b ),
    gen_st_value_test( "sb", 0x3c3d3e3f,  12, 0x00002000, 0x08090a3f ),
    gen_st_value_test( "sb", 0x40414243,  16, 0x00002000, 0x0c0d0e43 ),
    gen_st_value_test( "sb", 0x44454647,  20, 0x00002000, 0xcafeca47 ),

    # Test negative offsets

    gen_st_value_test( "sb", 0x48494a4b, -20, 0x00002014, 0xdeadbe4b ),
    gen_st_value_test( "sb", 0x4c4d4e4f, -16, 0x00002014, 0x0001024f ),
    gen_st_value_test( "sb", 0x50515253, -12, 0x00002014, 0x04050653 ),
    gen_st_value_test( "sb", 0x54555657,  -8, 0x00002014, 0x08090a57 ),
    gen_st_value_test( "sb", 0x58595a5b,  -4, 0x00002014, 0x0c0d0e5b ),
    gen_st_value_test( "sb", 0x5c5d5e5f,   0, 0x00002014, 0xcafeca5f ),

    # Test positive offset with unaligned base

    gen_st_value_test( "sb", 0x60616263,   1, 0x00001fff, 0xdeadbe63 ),
    gen_st_value_test( "sb", 0x64656667,   5, 0x00001fff, 0x00010267 ),
    gen_st_value_test( "sb", 0x68696a6b,   9, 0x00001fff, 0x0405066b ),
    gen_st_value_test( "sb", 0x6c6d6e6f,  13, 0x00001fff, 0x08090a6f ),
    gen_st_value_test( "sb", 0x70717273,  17, 0x00001fff, 0x0c0d0e73 ),
    gen_st_value_test( "sb", 0x74757677,  21, 0x00001fff, 0xcafeca77 ),

    # Test negative offset with unaligned base

    gen_st_value_test( "sb", 0x78797a7b, -21, 0x00002015, 0xdeadbe7b ),
    gen_st_value_test( "sb", 0x7c7d7e7f, -17, 0x00002015, 0x0001027f ),
    gen_st_value_test( "sb", 0x80818283, -13, 0x00002015, 0x04050683 ),
    gen_st_value_test( "sb", 0x84858687,  -9, 0x00002015, 0x08090a87 ),
    gen_st_value_test( "sb", 0x88898a8b,  -5, 0x00002015, 0x0c0d0e8b ),
    gen_st_value_test( "sb", 0x8c8d8e8f,  -1, 0x00002015, 0xcafeca8f ),

    # Test subword accesses

    gen_st_value_test( "sb", 0x99999999, 0, 0x00002000, 0xdeadbe99 ),
    gen_st_value_test( "sb", 0x99999999, 0, 0x00002001, 0xdead9999 ),
    gen_st_value_test( "sb", 0x99999999, 0, 0x00002002, 0xde999999 ),
    gen_st_value_test( "sb", 0x99999999, 0, 0x00002003, 0x99999999 ),

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
    result = ( Bits( 32, initial_data[a] ) & 0xffffff00 ) \
           | ( Bits( 32,         data[a] ) & 0x000000ff )

    asm_code.append( gen_st_value_test( "sb", result.int(), offset.int(), base.uint(), result.int() ) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( initial_data ) )
  return asm_code

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
