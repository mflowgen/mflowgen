#=========================================================================
# sw
#=========================================================================

import random

from pymtl import *
from proc.test.inst_utils import gen_nops, gen_word_data

#-------------------------------------------------------------------------
# gen_st_template
#-------------------------------------------------------------------------
# Template for store instructions. We first write the src and base
# registers before executing the instruction under test. We parameterize
# the number of nops after writing these register and the instruction
# under test to enable using this template for testing various bypass
# paths. We also parameterize the register specifiers to enable using
# this template to test situations where the base register is equal to
# the destination register. We use a lw to bring back in the stored data
# to verify the store. The lw address is formed by simply masking off the
# lower two bits of the store address. The result needs to be specified
# accordingly. This helps make sure that the store doesn't store more
# data then it is supposed to.

def gen_st_template(
  num_nops_src, num_nops_base, num_nops_dest,
  reg_src, reg_base,
  inst, src, offset, base, result
):
  return """

    # Move src value into register
    csrr {reg_src}, mngr2proc < {src}
    {nops_src}

    # Move base value into register
    csrr {reg_base}, mngr2proc < {base}
    {nops_base}

    # Instruction under test
    {inst} {reg_src}, {offset}({reg_base})
    {nops_dest}

    # Check the result
    csrr x4, mngr2proc < {lw_base}
    lw   x3, 0(x4)
    csrw proc2mngr, x3 > {result}

  """.format(
    nops_src  = gen_nops(num_nops_src),
    nops_base = gen_nops(num_nops_base),
    nops_dest = gen_nops(num_nops_dest),
    lw_base   = (base + offset) & 0xfffffffc,
    **locals()
  )

#-------------------------------------------------------------------------
# gen_st_dest_dep_test
#-------------------------------------------------------------------------
# Test the destination bypass path by varying how many nops are
# inserted between the instruction under test and reading the destination
# register with a lw instruction.

def gen_st_dest_dep_test( num_nops, inst, src, base, result ):
  return gen_st_template( 0, 8, num_nops, "x1", "x2",
                          inst, src, 0, base, result )

#-------------------------------------------------------------------------
# gen_st_base_dep_test
#-------------------------------------------------------------------------
# Test the base register bypass paths by varying how many nops are
# inserted between writing the base register and reading this register in
# the instruction under test.

def gen_st_base_dep_test( num_nops, inst, src, base, result ):
  return gen_st_template( 8-num_nops, num_nops, 0, "x1", "x2",
                          inst, src, 0, base, result )

#-------------------------------------------------------------------------
# gen_st_src_dep_test
#-------------------------------------------------------------------------
# Test the src register bypass paths by varying how many nops are
# inserted between writing the src register and reading this register in
# the instruction under test.

def gen_st_src_dep_test( num_nops, inst, src, base, result ):
  return gen_st_template( num_nops, 0, 0, "x1", "x2",
                          inst, src, 0, base, result )

#-------------------------------------------------------------------------
# gen_st_srcs_dep_test
#-------------------------------------------------------------------------
# Test both source bypass paths at the same time by varying how many nops
# are inserted between writing both src registers and reading both
# registers in the instruction under test.

def gen_st_srcs_dep_test( num_nops, inst, src, base, result ):
  return gen_st_template( 0, num_nops, 0, "x1", "x2",
                          inst, src, 0, base, result )

#-------------------------------------------------------------------------
# gen_st_src_eq_base_test
#-------------------------------------------------------------------------
# Test situation where the src register specifier is the same as the base
# register specifier.

def gen_st_src_eq_base_test( inst, src, result ):
  return gen_st_template( 0, 0, 0, "x1", "x1",
                          inst, src, 0, src, result )

#-------------------------------------------------------------------------
# gen_st_value_test
#-------------------------------------------------------------------------
# Test the actual operation of a store instruction under test. We assume
# that bypassing has already been tested.

def gen_st_value_test( inst, src, offset, base, result ):
  return gen_st_template( 0, 0, 0, "x1", "x2",
                          inst, src, offset, base, result )

#-------------------------------------------------------------------------
# gen_st_random_test
#-------------------------------------------------------------------------
# Similar to gen_st_value_test except that we can specifically use lhu or
# lbu so that we don't need to worry about the high order bits.

def gen_st_random_test( inst, ld_inst, src, offset, base ):
  return """

    # Move src value into register
    csrr x1, mngr2proc < {src}

    # Move base value into register
    csrr x2, mngr2proc < {base}

    # Instruction under test
    {inst} x1, {offset}(x2)

    # Check the result
    csrr x4, mngr2proc < {ld_base}
    {ld_inst} x3, 0(x4)
    csrw proc2mngr, x3 > {src}

  """.format(
    ld_base = (base + offset),
    **locals()
  )

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
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > 0xdeadbeef

    .data
    .word 0x01020304
  """

#-------------------------------------------------------------------------
# gen_dest_dep_test
#-------------------------------------------------------------------------

def gen_dest_dep_test():
  return [

    gen_st_dest_dep_test( 5, "sw", 0x30313233, 0x2000, 0x30313233 ),
    gen_st_dest_dep_test( 4, "sw", 0x34353637, 0x2004, 0x34353637 ),
    gen_st_dest_dep_test( 3, "sw", 0x38393a3b, 0x2008, 0x38393a3b ),
    gen_st_dest_dep_test( 2, "sw", 0x3c3d3e3f, 0x200c, 0x3c3d3e3f ),
    gen_st_dest_dep_test( 1, "sw", 0x40414243, 0x2010, 0x40414243 ),
    gen_st_dest_dep_test( 0, "sw", 0x44454647, 0x2014, 0x44454647 ),

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

    gen_st_base_dep_test( 5, "sw", 0x30313233, 0x2000, 0x30313233 ),
    gen_st_base_dep_test( 4, "sw", 0x34353637, 0x2004, 0x34353637 ),
    gen_st_base_dep_test( 3, "sw", 0x38393a3b, 0x2008, 0x38393a3b ),
    gen_st_base_dep_test( 2, "sw", 0x3c3d3e3f, 0x200c, 0x3c3d3e3f ),
    gen_st_base_dep_test( 1, "sw", 0x40414243, 0x2010, 0x40414243 ),
    gen_st_base_dep_test( 0, "sw", 0x44454647, 0x2014, 0x44454647 ),

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

    gen_st_src_dep_test( 5, "sw", 0x30313233, 0x2000, 0x30313233 ),
    gen_st_src_dep_test( 4, "sw", 0x34353637, 0x2004, 0x34353637 ),
    gen_st_src_dep_test( 3, "sw", 0x38393a3b, 0x2008, 0x38393a3b ),
    gen_st_src_dep_test( 2, "sw", 0x3c3d3e3f, 0x200c, 0x3c3d3e3f ),
    gen_st_src_dep_test( 1, "sw", 0x40414243, 0x2010, 0x40414243 ),
    gen_st_src_dep_test( 0, "sw", 0x44454647, 0x2014, 0x44454647 ),

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

    gen_st_srcs_dep_test( 5, "sw", 0x30313233, 0x2000, 0x30313233 ),
    gen_st_srcs_dep_test( 4, "sw", 0x34353637, 0x2004, 0x34353637 ),
    gen_st_srcs_dep_test( 3, "sw", 0x38393a3b, 0x2008, 0x38393a3b ),
    gen_st_srcs_dep_test( 2, "sw", 0x3c3d3e3f, 0x200c, 0x3c3d3e3f ),
    gen_st_srcs_dep_test( 1, "sw", 0x40414243, 0x2010, 0x40414243 ),
    gen_st_srcs_dep_test( 0, "sw", 0x44454647, 0x2014, 0x44454647 ),

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
    gen_st_src_eq_base_test( "sw", 0x00002000, 0x00002000 ),
    gen_word_data([ 0x01020304 ])
  ]

#-------------------------------------------------------------------------
# gen_value_test
#-------------------------------------------------------------------------

def gen_value_test():
  return [

    # Test positive offsets

    gen_st_value_test( "sw", 0x30313233,   0, 0x00002000, 0x30313233 ),
    gen_st_value_test( "sw", 0x34353637,   4, 0x00002000, 0x34353637 ),
    gen_st_value_test( "sw", 0x38393a3b,   8, 0x00002000, 0x38393a3b ),
    gen_st_value_test( "sw", 0x3c3d3e3f,  12, 0x00002000, 0x3c3d3e3f ),
    gen_st_value_test( "sw", 0x40414243,  16, 0x00002000, 0x40414243 ),
    gen_st_value_test( "sw", 0x44454647,  20, 0x00002000, 0x44454647 ),

    # Test negative offsets

    gen_st_value_test( "sw", 0x48494a4b, -20, 0x00002014, 0x48494a4b ),
    gen_st_value_test( "sw", 0x4c4d4e4f, -16, 0x00002014, 0x4c4d4e4f ),
    gen_st_value_test( "sw", 0x50515253, -12, 0x00002014, 0x50515253 ),
    gen_st_value_test( "sw", 0x54555657,  -8, 0x00002014, 0x54555657 ),
    gen_st_value_test( "sw", 0x58595a5b,  -4, 0x00002014, 0x58595a5b ),
    gen_st_value_test( "sw", 0x5c5d5e5f,   0, 0x00002014, 0x5c5d5e5f ),

    # Test positive offset with unaligned base

    gen_st_value_test( "sw", 0x60616263,   1, 0x00001fff, 0x60616263 ),
    gen_st_value_test( "sw", 0x64656667,   5, 0x00001fff, 0x64656667 ),
    gen_st_value_test( "sw", 0x68696a6b,   9, 0x00001fff, 0x68696a6b ),
    gen_st_value_test( "sw", 0x6c6d6e6f,  13, 0x00001fff, 0x6c6d6e6f ),
    gen_st_value_test( "sw", 0x70717273,  17, 0x00001fff, 0x70717273 ),
    gen_st_value_test( "sw", 0x74757677,  21, 0x00001fff, 0x74757677 ),

    # Test negative offset with unaligned base

    gen_st_value_test( "sw", 0x78797a7b, -21, 0x00002015, 0x78797a7b ),
    gen_st_value_test( "sw", 0x7c7d7e7f, -17, 0x00002015, 0x7c7d7e7f ),
    gen_st_value_test( "sw", 0x80818283, -13, 0x00002015, 0x80818283 ),
    gen_st_value_test( "sw", 0x84858687,  -9, 0x00002015, 0x84858687 ),
    gen_st_value_test( "sw", 0x88898a8b,  -5, 0x00002015, 0x88898a8b ),
    gen_st_value_test( "sw", 0x8c8d8e8f,  -1, 0x00002015, 0x8c8d8e8f ),

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

    asm_code.append( gen_st_value_test( "sw", result, offset.int(), base.uint(), result ) )

  # Generate some random data to initialize memory

  initial_data = []
  for i in xrange(128):
    initial_data.append( random.randint(0,0xffffffff) )

  # Add the data to the end of the assembly code

  asm_code.append( gen_word_data( initial_data ) )
  return asm_code

#-------------------------------------------------------------------------
# gen_sameline_deps_test
#-------------------------------------------------------------------------

def gen_sameline_deps_test():
  return """
    csrr x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    csrr x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    csrr x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002004,0x00002008,0x0000200c}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    .data
    .word 0x01020304
    .word 0x02030405
    .word 0x03040506
    .word 0x04050607
  """

#-------------------------------------------------------------------------
# gen_twoline_deps_test
#-------------------------------------------------------------------------

def gen_twoline_deps_test():
  return """
    csrr x1, mngr2proc < {0x00002000,0x00002008,0x00002010,0x00002018}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002008,0x00002010,0x00002018}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    csrr x1, mngr2proc < {0x00002000,0x00002008,0x00002010,0x00002018}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002008,0x00002010,0x00002018}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    csrr x1, mngr2proc < {0x00002000,0x00002008,0x00002010,0x00002018}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002008,0x00002010,0x00002018}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    .data
    .word 0x01020304
    .word 0x00000000
    .word 0x02030405
    .word 0x00000000
    .word 0x03040506
    .word 0x00000000
    .word 0x04050607
  """

#-------------------------------------------------------------------------
# gen_diffline_deps_test
#-------------------------------------------------------------------------

def gen_diffline_deps_test():
  return """
    csrr x1, mngr2proc < {0x00002000,0x00002010,0x00002020,0x00002030}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002010,0x00002020,0x00002030}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    csrr x1, mngr2proc < {0x00002000,0x00002010,0x00002020,0x00002030}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002010,0x00002020,0x00002030}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    csrr x1, mngr2proc < {0x00002000,0x00002010,0x00002020,0x00002030}
    csrr x2, mngr2proc < {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0xdeadbeef,0xeeadbeef,0xfeadbeef,0x0eadbeef}

    csrr x1, mngr2proc < {0x00002000,0x00002010,0x00002020,0x00002030}
    csrr x2, mngr2proc < {0x01020304,0x02030405,0x03040506,0x04050607}
    sw   x2, 0(x1)
    nop
    nop
    nop
    nop
    nop
    lw   x3, 0(x1)
    csrw proc2mngr, x3 > {0x01020304,0x02030405,0x03040506,0x04050607}

    .data
    .word 0x01020304
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x02030405
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x03040506
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    .word 0x04050607
  """
