#========================================================================
# Generate a cache-line to be written to the data SRAMs
#========================================================================

from pymtl import *

#------------------------------------------------------------------------
# This unit produces a CL suitable to be written to SRAMs with a mask
#------------------------------------------------------------------------
#
# Inputs will be cache-response-sized data and offset
# Output will be cache-line-sized data aligning the writing data
#

class GenWriteDataPRTL( Model ):

  # interface

  def __init__( s, num_in_bytes = 4, num_out_bytes = 4 ):

    # Internal parameters

    num_in_bits   = num_in_bytes  * 8
    in_lnb        = clog2( num_in_bytes  )

    num_out_bits  = num_out_bytes * 8
    out_lnb       = clog2( num_out_bytes )

    s.in_         = InPort ( num_in_bits  )
    s.offset      = InPort (   out_lnb    )
    s.out         = OutPort( num_out_bits )

    # Internal Signals

    s.int_out     = Wire ( num_out_bits  )
    s.int_in_     = Wire ( num_out_bits  )
    s.offset_shft = Wire ( out_lnb + 3   )

    @s.combinational
    def gen_out():

      # Get input in a more spacier wire
      s.int_in_               .value = 0
      s.int_in_[0:num_in_bits].value = s.in_

      # Offset generation
      s.offset_shft           .value = 0
      s.offset_shft[0:out_lnb].value = s.offset

      # Re-orient the input bits based on the offset
      s.int_out.value = s.int_in_ << (s.offset_shft << 3)

      # Assign the output
      s.out.value = s.int_out
