#========================================================================
# ubmark-vvadd-opt: vector-vector addition kernel
#========================================================================
#
# This code does adds the values of two arrays and stores the result to
# the destination array. The code is equivalent to:
#
# void vvadd( int *dest, int *src0, int *src1, int size ) {
#   for ( int i = 0; i < size; i++ )
#     *dest++ = *src0++ + *src1++;
# }

import struct

from pymtl                  import *
from parc_encoding          import assemble
from parc_encoding_test     import mk_section
from string                 import translate, maketrans
from SparseMemoryImage      import SparseMemoryImage

from proc_ubmark_vvadd_data import ref, src0, src1

c_vvadd_src0_ptr = 0x2000;
c_vvadd_src1_ptr = 0x3000;
c_vvadd_dest_ptr = 0x4000;
c_vvadd_size     = 100;

class ubmark_vvadd_opt:

  # verification function, argument is a bytearray from TestMemory instance

  @staticmethod
  def verify( memory ):

    is_pass      = True
    first_failed = -1

    for i in range(c_vvadd_size):
      x = struct.unpack('i', memory[c_vvadd_dest_ptr + i * 4 : c_vvadd_dest_ptr + (i+1) * 4] )[0]
      if not ( x == ref[i] ):
        is_pass     = False
        first_faild = i
        print( " [ failed ] dest[{i}]: {x} != ref[{i}]: {ref} ".format( i=i, x=x, ref=ref[i] ) )
        return False

    if is_pass:
      print( " [ passed ]: vvadd-opt" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """
    # load array pointers
    mfc0  r1, mngr2proc < 100
    mfc0  r2, mngr2proc < 0x2000
    mfc0  r3, mngr2proc < 0x3000
    mfc0  r4, mngr2proc < 0x4000
    addiu r5, r0, 0

    # main loop
  loop:
    lw    r6,   0(r2)
    lw    r7,   4(r2)
    lw    r8,   8(r2)
    lw    r9,  12(r2)
    lw    r10,  0(r3)
    lw    r11,  4(r3)
    lw    r12,  8(r3)
    lw    r13, 12(r3)
    addu  r6, r6, r10
    addu  r7, r7, r11
    addu  r8, r8, r12
    addu  r9, r9, r13
    sw    r6,   0(r4)
    sw    r7,   4(r4)
    sw    r8,   8(r4)
    sw    r9,  12(r4)
    addiu r5, r5, 4
    addiu r2, r2, 16
    addiu r3, r3, 16
    addiu r4, r4, 16
    bne   r5, r1, loop

    # end of the program
    mtc0  r0, proc2mngr > 0
    nop
    nop
    nop
    nop
    nop
    nop
"""

    mem_image = assemble( text )

    # load data by manually create data sections using binutils

    src0_section = mk_section( ".data", c_vvadd_src0_ptr, src0 )

    src1_section = mk_section( ".data", c_vvadd_src1_ptr, src1 )

    # load data

    mem_image.add_section( src0_section )
    mem_image.add_section( src1_section )

    return mem_image
