#===============================================================================
# ValRdyMerge.py
#===============================================================================
# PyMTL Model that arbitrates between a number of ValRdy signals
# Author: Taylor Pritchard (tjp79)
#
# Shunning: I try to make this code look better
#-------------------------------------------------------------------------------

from pymtl             import *
from pclib.ifcs        import InValRdyBundle, OutValRdyBundle
from pclib.rtl         import RoundRobinArbiter

# Custom BRGTC2 mux without inferred latch

from rtl.onehot        import Mux as OneHotMux

class ValRdyMerge( Model ):

  def __init__( s, p_nports=2, p_nbits=32 ):

    #-Interface----------------------------------------------------------

    s.in_ = InValRdyBundle[p_nports]( p_nbits )
    s.out = OutValRdyBundle         ( p_nports + p_nbits )

    #-Structural Composition---------------------------------------------

    # Internal Wires

    s.in_val = Wire( p_nports )
    s.in_rdy = Wire( p_nports )
    s.reqs   = Wire( p_nports )
    s.grants = Wire( p_nports )

    # Input Signals

    for i in range( p_nports ):
      s.connect( s.in_[i].val, s.in_val[i] )
      s.connect( s.in_[i].rdy, s.in_rdy[i] )

    # Arbiter

    if p_nports > 1:
      s.arbiter = m = RoundRobinArbiter( p_nports )
      s.connect_dict({
        m.reqs   : s.reqs,
        m.grants : s.grants,
      })
    else:
      s.connect( s.grants, 1 )

    # Mux

    s.mux = m = OneHotMux( p_nports, p_nbits )
    for i in range( p_nports ):
      s.connect( m.in_[i], s.in_[i].msg )
    s.connect( m.sel, s.grants  )
    s.connect( m.out, s.out.msg[0:p_nbits] )

    # Channel Output

    s.connect( s.grants, s.out.msg[p_nbits:p_nports+p_nbits] )

    #-Combinational Logic------------------------------------------------

    if p_nports > 1:
      @s.combinational
      def combinational_logic():
        s.reqs.value    = s.in_val & sext( s.out.rdy, p_nports )
        s.in_rdy.value  = s.grants & sext( s.out.rdy, p_nports )
        s.out.val.value = reduce_or( s.reqs & s.in_val )

    else:
      @s.combinational
      def combinational_logic():
        s.reqs.value    = 1
        s.in_rdy.value  = s.out.rdy
        s.out.val.value = reduce_or( s.reqs & s.in_val )

  def line_trace( s ):
    p_nbits = s.out.msg.nbits - s.grants.nbits
    return "{}:{}".format( s.grants, s.out.msg[0:p_nbits] )
