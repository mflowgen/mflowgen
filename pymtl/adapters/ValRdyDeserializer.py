#===============================================================================
# ValRdyDeserializer.py
#===============================================================================
# PyMTL Model that receives multiple ValRdy message of a certain width, and
# forwards them as one concatenated message
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, RegRst, Reg, Mux

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

    #-Structural Composition---------------------------------------------

    if ( p_nmsgs > 1 ) : s.counter = RegRst( clog2(p_nmsgs), reset_value = 0 )
    else               : s.counter = RegRst( 1, reset_value = 0 )

    # Shunning: I use RegRst to keep the hierarchy for debugging

    s.STATE_RECV = 0
    s.STATE_SEND = 1

    s.state = RegRst( 1, reset_value = s.STATE_RECV )

    # Input -> Register

    s.reg_in  = Wire( p_regwidth )
    s.reg_en  = Wire( 1 )
    s.reg_out = Wire( p_regwidth )

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
    def state_transition():
      s.state.in_.value = s.state.out

      if   s.state.out == s.STATE_RECV:
        if s.in_.val & (s.counter.out == p_nmsgs-1):
          s.state.in_.value = s.STATE_SEND

      elif s.state.out == s.STATE_SEND:
        if s.out.rdy:
          s.state.in_.value = s.STATE_RECV

    @s.combinational
    def state_outputs():
      s.in_.rdy.value     = 0
      s.out.val.value     = 0

      s.counter.in_.value = 0
      s.reg_en.value      = 0

      if s.state.out == s.STATE_RECV:
        s.in_.rdy.value = 1
        s.reg_en.value  = s.in_.val

        if s.in_.val & (s.counter.out == p_nmsgs-1):
          s.counter.in_.value = 0
        else:
          s.counter.in_.value = s.counter.out + s.in_.val

      elif s.state.out == s.STATE_SEND:
        s.out.val.value = 1
        if ~s.out.rdy:
          s.counter.in_.value = s.counter.out

  def line_trace( s ):
    if( s.state.out == s.STATE_SEND ):
      return "({})".format( s.reg_out )
    elif( int(s.counter.out) > 0 ):
      num_dash = (s.reg_out.nbits/4) - ( (s.in_.msg.nbits * int(s.counter.out) )/4 )
      return "({}{})".format( "-" * num_dash, s.reg_out[ s.reg_out.nbits-s.in_.msg.nbits*int(s.counter.out):s.reg_out.nbits ] )
    else:
      return "({})".format( "-" * (s.reg_.in_.nbits/4) )
