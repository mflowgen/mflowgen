#===============================================================================
# ValRdyDeserializer.py
#===============================================================================
# PyMTL Model that receives multiple ValRdy message of a certain width, and
# forwards them as one concatenated message
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, Mux

class ValRdyDeserializer( Model ):

  def __init__( s, dtype_in=8, dtype_out=32 ):

    #-Parameters---------------------------------------------------------

    p_nmsgs = dtype_out / dtype_in
    if ( dtype_out > p_nmsgs * dtype_in ):
      p_nmsgs += 1

    p_regwidth = p_nmsgs * dtype_in

    #-Interface----------------------------------------------------------

    s.in_ = InValRdyBundle ( dtype_in  )
    s.out = OutValRdyBundle( dtype_out )

    #-States-------------------------------------------------------------

    s.state = Wire( 3 )

    s.STATE_RECV = 0
    s.STATE_SEND = 1

    #-Structural Composition---------------------------------------------

    # Internal Wires
    s.reg_in       = Wire( p_regwidth )
    s.reg_en       = Wire( 1 )
    s.reg_out      = Wire( p_regwidth )
    s.count        = Wire( 1 )
    if ( p_nmsgs > 1 ) : s.counter = Wire( clog2( p_nmsgs ) )
    else               : s.counter = Wire( 1 )

    # Register
    s.reg_ = m = RegEn( p_regwidth )
    s.connect_dict({
      m.en  : s.reg_en,
      m.out : s.reg_out,
    })

    if ( p_nmsgs > 1 ):
      s.connect( m.in_[ p_regwidth-dtype_in:p_regwidth ], s.in_.msg )
      s.connect( m.in_[ 0:p_regwidth-dtype_in ], s.reg_out[ dtype_in:p_regwidth ] )
    else:
      s.connect( m.in_, s.in_.msg )

    # Register -> Output
    s.connect( s.reg_out[ 0:dtype_out ], s.out.msg )

    #-Combinational Logic-----------------------------------------------

    @s.combinational
    def combinational_logic():
      s.in_.rdy.value = s.state == s.STATE_RECV
      s.out.val.value = s.state == s.STATE_SEND
      s.reg_en.value  = s.in_.val & ( s.state == s.STATE_RECV )

    #-Sequential Logic---------------------------------------------------

    @s.posedge_clk
    def sequential_logic():
      if( s.reset ):
        s.state  .next = s.STATE_RECV
        s.counter.next = 0x0
      elif( s.state == s.STATE_RECV and s.in_.val and s.in_.rdy ):
        if ( s.counter == p_nmsgs-1 ):
          s.state  .next = s.STATE_SEND
          s.counter.next = 0x0
        else                         :
          s.state  .next = s.STATE_RECV
          s.counter.next = s.counter + 1
      elif( s.state == s.STATE_SEND and s.out.val and s.out.rdy ):
        s.state  .next = s.STATE_RECV
        s.counter.next = 0x0


  def line_trace( s ):
    if( s.state == s.STATE_SEND ):
      return "({})".format( s.reg_out )
    elif( s.counter._uint > 0 ):
      num_dash = (s.reg_out.nbits/4) - ( (s.in_.msg.nbits * s.counter._uint )/4 )
      return "({}{})".format( "-" * num_dash, s.reg_out[ s.reg_out.nbits-s.in_.msg.nbits*s.counter._uint:s.reg_out.nbits ] )
    else:
      return "({})".format( "-" * (s.reg_.in_.nbits/4) )
