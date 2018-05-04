#===============================================================================
# ValRdySplit.py
#===============================================================================
# PyMTL Model that takes a stream of ValRdy messages and channels, and routes
# each message to the proper output channel.
# Author: Taylor Pritchard (tjp79)
#
# Shunning: I try to make this code look better
#-------------------------------------------------------------------------------

from pymtl             import *
from pclib.ifcs        import InValRdyBundle, OutValRdyBundle
from pclib.rtl.onehot  import Demux as OneHotDemux

class ValRdySplit( Model ):

  def __init__( s, p_nports=2, p_nbits=32 ):

    #-Interface----------------------------------------------------------

    s.in_     = InValRdyBundle           ( p_nports + p_nbits )
    s.out     = OutValRdyBundle[p_nports]( p_nbits )

    #-Structural Composition---------------------------------------------

    # Internal Wires

    s.channel = Wire( p_nports )
    s.out_val = Wire( p_nports )
    s.out_rdy = Wire( p_nports )

    # Channel Selection Bits

    s.connect( s.channel, s.in_.msg[ p_nbits:p_nports+p_nbits ] )

    # Demux

    s.demux = m = OneHotDemux( p_nports, p_nbits )
    s.connect( m.sel, s.channel )
    s.connect( m.in_, s.in_.msg[ 0:p_nbits ] )
    for i in range( p_nports ):
      s.connect( m.out[i], s.out[i].msg )

    # Output Ports
    for i in range( p_nports ):
      s.connect( s.out[i].val, s.out_val[i] )
      s.connect( s.out[i].rdy, s.out_rdy[i] )

    #-Combinational Logic------------------------------------------------

    if p_nports > 1:
      @s.combinational
      def combinational_logic():
        s.out_val.value = sext( s.in_.val, p_nports ) & s.channel
        s.in_.rdy.value = reduce_or( s.channel & s.out_rdy )

    else:
      @s.combinational
      def combinational_logic():
        s.out_val.value = s.in_.val & s.channel
        s.in_.rdy.value = reduce_or( s.channel & s.out_rdy )

  def line_trace( s ):
    p_nbits = s.in_.msg.nbits - s.channel.nbits
    return "{}:{}".format( s.out_val, s.in_.msg[ 0:p_nbits ] )
