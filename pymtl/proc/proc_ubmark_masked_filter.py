#========================================================================
# ubmark-masked-filter: masked filter kernel
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

from pymtl                          import *
from parc_encoding                  import assemble
from parc_encoding_test             import mk_section
from string                         import translate, maketrans
from SparseMemoryImage              import SparseMemoryImage

from proc_ubmark_masked_filter_data import src, mask, ref

# pointers for the input and output arrays
c_masked_filter_dest_ptr = 0x2000
c_masked_filter_mask_ptr = 0x3000;
c_masked_filter_src_ptr  = 0x4000;
c_masked_filter_nrows    = 10;
c_masked_filter_ncols    = 10;

class ubmark_masked_filter:

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
      print( " [ passed ]: masked-filter" )
      return True

  @staticmethod
  def gen_mem_image():

    # text section

    text = """

    mfc0  r4, mngr2proc < 0x2000
    mfc0  r5, mngr2proc < 0x3000
    mfc0  r6, mngr2proc < 0x4000
    mfc0  r7, mngr2proc < 10
    mfc0  r8, mngr2proc < 10

    addiu r24, r0, 64   # coeff0
    addiu r25, r0, 48   # coeff1

    # Assume that nrows and ncols are positive and otherwise well-behaved
    addiu r2, r7, -1    # end condition nrows
    addiu r3, r8, -1    # end condition ncols

    addiu r9, r0, 1     # ridx starts at 1
                        # zero: row loop
  zero:
    addiu r10, r0, 1
    # one: col loop
    # Calculate mask index
  one:
    mul   r11, r8, r9   # ridx*ncols
    addu  r11, r11, r10 # ridx*ncols + cidx
    sll   r11, r11, 2   # ridx*ncols + cidx (pointer)
    addu  r12, r5, r11  # ridx*ncols + cidx (pointer) for mask
    lw    r12, 0(r12)   # mask[ridx*ncols + cidx]

    # If block
    # if ( !mask[ridx*ncols + cidx] ) goto two:
    beq   r12, r0, two

    addu  r12, r6, r11  # ridx*ncols + cidx (pointer) for src
    lw    r13, 0(r12)   # src[ridx*ncols + cidx]
    mul   r13, r13, r24 # src[ridx*ncols + cidx] * coeff0
    addu  r23, r13, r0  # out = src[ridx*ncols + cidx] * coeff0

    lw    r13, 4(r12)   # src[ridx*ncols + (cidx+1)]
    mul   r13, r13, r25 # src[ridx*ncols + (cidx+1)] * coeff1
    addu  r23, r23, r13 # out += src[ridx*ncols + (cidx+1)] * coeff1

    lw    r13, -4(r12)  # src[ridx*ncols + (cidx-1)]
    mul   r13, r13, r25 # src[ridx*ncols + (cidx-1)] * coeff1
    addu  r23, r23, r13 # out += src[ridx*ncols + (cidx-1)] * coeff1

    addiu r22, r9, 1    # ridx+1
    mul   r12, r8, r22  # (ridx+1)*ncols
    addu  r12, r12, r10 # (ridx+1)*ncols + cidx
    sll   r12, r12, 2   # (ridx+1)*ncols + cidx (pointer)
    addu  r13, r6, r12  # (ridx+1)*ncols + cidx (pointer) for src
    lw    r13, 0(r13)   # src[(ridx+1)*ncols + cidx]
    mul   r14, r13, r25 # src[(ridx+1)*ncols + cidx] * coeff1
    addu  r23, r23, r14 # out += src[(ridx+1)*ncols + cidx] * coeff1

    addiu r22, r9, -1   # ridx-1
    mul   r12, r8, r22  # (ridx-1)*ncols
    addu  r12, r12, r10 # (ridx-1)*ncols + cidx
    sll   r12, r12, 2   # (ridx-1)*ncols + cidx (pointer)
    addu  r13, r6, r12  # (ridx-1)*ncols + cidx (pointer) for src
    lw    r13, 0(r13)   # src[(ridx-1)*ncols + cidx]
    mul   r14, r13, r25 # src[(ridx-1)*ncols + cidx] * coeff1
    addu  r23, r23, r14 # out += src[(ridx-1)*ncols + cidx] * coeff1

    addu  r12, r4, r11  # ridx*ncols + cidx (pointer) for dest
    sra   r23, r23, 8   # out >>= shamt
    sw    r23, 0(r12)   # dest[ridx*ncols + cidx] = out
    j     three         # End of if block, goto three:

    # Else block
  two:
    addu  r12, r6, r11  # ridx*ncols + cidx (pointer) for src
    lw    r13, 0(r12)   # src[ridx*ncols + cidx]
    addu  r14, r4, r11  # ridx*ncols + cidx (pointer) for dest
    sw    r13, 0(r14)   # dest[ridx*ncols + cidx] = src[ridx*ncols + cidx]

  three:
    addiu r10, r10, 1   # cidx++
    bne   r10, r3, one  # if ( cidx != ncols - 1 ) goto one:
    addiu r9, r9, 1     # ridx++
    bne   r9, r2, zero  # if ( ridx != nrows - 1 ) goto zero:

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

    src_section = mk_section( ".data", c_masked_filter_src_ptr, src )

    mem_image.add_section( src_section )

    mask_section = mk_section( ".data", c_masked_filter_mask_ptr, mask )

    mem_image.add_section( mask_section )

    return mem_image
