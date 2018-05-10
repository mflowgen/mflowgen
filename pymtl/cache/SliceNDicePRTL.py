#========================================================================
# Slice and Dice Unit
#========================================================================

from pymtl import *

#------------------------------------------------------------------------
# This unit will select a subset of bytes
#------------------------------------------------------------------------
#
# Inputs will be offset and number of bytes
#

class SliceNDicePRTL( Model ):

  # interface

  def __init__( s, num_in_bytes = 4, num_out_bytes = 4 ):

    # Internal parameters
    num_in_bits   = num_in_bytes  * 8
    in_lnb        = clog2( num_in_bytes  )

    num_out_bits  = num_out_bytes * 8
    out_lnb       = clog2( num_out_bytes )

    s.in_         = InPort ( num_in_bits  )
    s.offset      = InPort (    in_lnb    )
    s.len         = InPort (   out_lnb    )
    s.out         = OutPort( num_out_bits )

    # Internal Signals

    s.int_mask    = Wire ( num_in_bits  )
    s.int_in_     = Wire ( num_in_bits  )
    s.len_d       = Wire (   out_lnb    )
    s.len_shft    = Wire ( out_lnb + 3  )
    s.int_out     = Wire ( num_in_bits  )
    s.offset_shft = Wire (  in_lnb + 3  )

    # I assume len is a count for bytes
    # a len of zero means we want the whole thing

    @s.combinational
    def gen_mask():

      # Force ones in all bits
      s.int_mask.value = 0
      s.int_mask.value = s.int_mask - 1

      # Shift the mask left by one byte
      s.int_mask.value = s.int_mask << 8

      # Decrement the len and shift by the resulting value
      s.len_d.value = s.len - 1

      # Multiply the shift amount by 8
      s.len_shft           .value = 0
      s.len_shft[0:out_lnb].value = s.len_d
      s.len_shft           .value = s.len_shft << 3

      # Generate Offset
      s.offset_shft          .value = 0
      s.offset_shft[0:in_lnb].value = s.offset
      s.offset_shft          .value = s.offset_shft << 3

      # Re-orient the input bits based on the offset
      s.int_in_.value = s.in_ >> s.offset_shft

      # Shift by the resulting value
      s.int_mask.value = s.int_mask << ( s.len_shft )

      # Generate output
      s.int_out.value = (~s.int_mask) & s.int_in_

      # Slice to the output
      s.out.value = s.int_out[0:num_out_bits]
