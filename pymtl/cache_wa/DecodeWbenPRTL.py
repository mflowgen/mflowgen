#========================================================================
# lab3-mem Decoder for Write Byte Enable
#========================================================================

from pymtl import *

#------------------------------------------------------------------------
# Decoder for Wben
#------------------------------------------------------------------------

class DecodeWbenPRTL( Model ):

  # interface

  def __init__( s, 
                p_in_nbits = 2, 
                c_out_nbits = (1 << (2+2))
  ):
    
    s.in_ = InPort  (  p_in_nbits )
    s.out = OutPort ( c_out_nbits )

  # Combinational logic

    @s.combinational
    def comb_logic():

      for i in xrange( c_out_nbits):
        # Width matches only if p_in_nbits = 2
        s.out[i].value = ( concat( Bits( 30, 0 ), s.in_ ) == i/4 )

