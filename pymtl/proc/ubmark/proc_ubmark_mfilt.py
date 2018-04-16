#========================================================================
# ubmark-mfilt: masked filter kernel
#========================================================================
#
# This code implements a median filter for a 2D array (e.g. an image).
# Filtering is selectively enabled for some of the pixels using a mask.
#
#
# void masked_filter( int dest[], int mask[], int src[],
#                     int nrows, int ncols )
# {
#   int coeff0 = 64;
#   int coeff1 = 48;
#   int norm_shamt = 8;
#   for ( int ridx = 1; ridx < nrows-1; ridx++ ) {
#     for ( int cidx = 1; cidx < ncols-1; cidx++ ) {
#       if ( mask[ ridx*ncols + cidx ] != 0 ) {
#         int out = ( src[ (ridx-1)*ncols + cidx     ] * coeff1 )
#                 + ( src[ ridx*ncols     + (cidx-1) ] * coeff1 )
#                 + ( src[ ridx*ncols     + cidx     ] * coeff0 )
#                 + ( src[ ridx*ncols     + (cidx+1) ] * coeff1 )
#                 + ( src[ (ridx+1)*ncols + cidx     ] * coeff1 );
#         dest[ ridx*ncols + cidx ] = out >> norm_shamt;
#       }
#       else
#         dest[ ridx*ncols + cidx ] = src[ ridx*ncols + cidx ];
#     }
#   }
# }

import struct

from pymtl                                import *
from lab2_proc.test.tinyrv2_encoding_test import mk_section
from string                               import translate, maketrans
from lab2_proc.tinyrv2_encoding           import assemble
from lab2_proc.SparseMemoryImage          import SparseMemoryImage

from proc_ubmark_mfilt_data         import src, mask, ref

# pointers for the input and output arrays
c_masked_filter_dest_ptr = 0x2000
c_masked_filter_mask_ptr = 0x3000;
c_masked_filter_src_ptr  = 0x4000;
c_masked_filter_nrows    = 10;
c_masked_filter_ncols    = 10;

class ubmark_mfilt:

  # verification function, argument is a bytearray from TestMemory instance

  @staticmethod
  def verify( memory ):

    is_pass      = True
    first_failed = -1

    for i in range(c_masked_filter_nrows * c_masked_filter_ncols):
      x = struct.unpack('i', memory[c_masked_filter_dest_ptr + i * 4 : c_masked_filter_dest_ptr + (i+1) * 4] )[0]
      if not ( x == ref[i] ):
        is_pass     = False
        first_faild = i
        print( " [ failed ] dest[{i}]: {x} != ref[{i}]: {ref} ".format( i=i, x=x, ref=ref[i] ) )
        return False

    if is_pass:
      print( " [ passed ]: mfilt" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """

    csrr  x4, mngr2proc < 0x2000
    csrr  x5, mngr2proc < 0x3000
    csrr  x6, mngr2proc < 0x4000
    csrr  x7, mngr2proc < 10
    csrr  x8, mngr2proc < 10

    addi  x24, x0, 64   # coeff0
    addi  x25, x0, 48   # coeff1

    # Assume that nrows and ncols are positive and otherwise well-behaved
    addi  x2, x7, -1    # end condition nrows
    addi  x3, x8, -1    # end condition ncols

    addi  x9, x0, 1     # ridx starts at 1
                        # zero: row loop
  zero:
    addi  x10, x0, 1
    # one: col loop
    # Calculate mask index
  one:
    mul   x11, x8, x9   # ridx*ncols
    add   x11, x11, x10 # ridx*ncols + cidx
    slli  x11, x11, 2   # ridx*ncols + cidx (pointer)
    add   x12, x5, x11  # ridx*ncols + cidx (pointer) for mask
    lw    x12, 0(x12)   # mask[ridx*ncols + cidx]

    # If block
    # if ( !mask[ridx*ncols + cidx] ) goto two:
    beq   x12, x0, two

    add   x12, x6, x11  # ridx*ncols + cidx (pointer) for src
    lw    x13, 0(x12)   # src[ridx*ncols + cidx]
    mul   x13, x13, x24 # src[ridx*ncols + cidx] * coeff0
    add   x23, x13, x0  # out = src[ridx*ncols + cidx] * coeff0

    lw    x13, 4(x12)   # src[ridx*ncols + (cidx+1)]
    mul   x13, x13, x25 # src[ridx*ncols + (cidx+1)] * coeff1
    add   x23, x23, x13 # out += src[ridx*ncols + (cidx+1)] * coeff1

    lw    x13, -4(x12)  # src[ridx*ncols + (cidx-1)]
    mul   x13, x13, x25 # src[ridx*ncols + (cidx-1)] * coeff1
    add   x23, x23, x13 # out += src[ridx*ncols + (cidx-1)] * coeff1

    addi  x22, x9, 1    # ridx+1
    mul   x12, x8, x22  # (ridx+1)*ncols
    add   x12, x12, x10 # (ridx+1)*ncols + cidx
    slli  x12, x12, 2   # (ridx+1)*ncols + cidx (pointer)
    add   x13, x6, x12  # (ridx+1)*ncols + cidx (pointer) for src
    lw    x13, 0(x13)   # src[(ridx+1)*ncols + cidx]
    mul   x14, x13, x25 # src[(ridx+1)*ncols + cidx] * coeff1
    add   x23, x23, x14 # out += src[(ridx+1)*ncols + cidx] * coeff1

    addi  x22, x9, -1   # ridx-1
    mul   x12, x8, x22  # (ridx-1)*ncols
    add   x12, x12, x10 # (ridx-1)*ncols + cidx
    slli  x12, x12, 2   # (ridx-1)*ncols + cidx (pointer)
    add   x13, x6, x12  # (ridx-1)*ncols + cidx (pointer) for src
    lw    x13, 0(x13)   # src[(ridx-1)*ncols + cidx]
    mul   x14, x13, x25 # src[(ridx-1)*ncols + cidx] * coeff1
    add   x23, x23, x14 # out += src[(ridx-1)*ncols + cidx] * coeff1

    add   x12, x4, x11  # ridx*ncols + cidx (pointer) for dest
    srai  x23, x23, 8   # out >>= shamt
    sw    x23, 0(x12)   # dest[ridx*ncols + cidx] = out
    jal   x0, three         # End of if block, goto three:

    # Else block
  two:
    add   x12, x6, x11  # ridx*ncols + cidx (pointer) for src
    lw    x13, 0(x12)   # src[ridx*ncols + cidx]
    add   x14, x4, x11  # ridx*ncols + cidx (pointer) for dest
    sw    x13, 0(x14)   # dest[ridx*ncols + cidx] = src[ridx*ncols + cidx]

  three:
    addi  x10, x10, 1   # cidx++
    bne   x10, x3, one  # if ( cidx != ncols - 1 ) goto one:
    addi  x9, x9, 1     # ridx++
    bne   x9, x2, zero  # if ( ridx != nrows - 1 ) goto zero:

    csrw  proc2mngr, x0 > 0
    nop
    nop
    nop
    nop
    nop
    nop
"""

    mem_image = assemble( text )

    # load data by manually create data sections using binutils

    src_section = mk_section( ".data", c_masked_filter_src_ptr, src )

    mem_image.add_section( src_section )

    mask_section = mk_section( ".data", c_masked_filter_mask_ptr, mask )

    mem_image.add_section( mask_section )

    return mem_image
