#===============================================================================
# ValRdySerializer.py
#===============================================================================
# PyMTL Model that receives a ValRdy message of a certain width, and sends out
# the same payload, broken up into a number of messages of a different width
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, Reg, RegRst, Mux

class ValRdySerializer( Model ):

  def __init__( s, dtype_in=32, dtype_out=8 ):

    #-Parameters---------------------------------------------------------

    p_nmsgs = dtype_in / dtype_out
    if ( dtype_in > p_nmsgs * dtype_out ):
      p_nmsgs += 1

    p_regwidth = p_nmsgs * dtype_out

    #-Interface----------------------------------------------------------

    s.in_ = InValRdyBundle ( dtype_in  )
    s.out = OutValRdyBundle( dtype_out )

    #-Structural Composition---------------------------------------------

    if ( p_nmsgs > 1 ) : s.counter = Reg( clog2(p_nmsgs) )
    else               : s.counter = Reg( 1 )

    # Shunning: I use RegRst to keep the hierarchy for debugging

    s.STATE_IDLE = 0
    s.STATE_SEND = 1

    s.state = RegRst( 1, reset_value = s.STATE_IDLE )

    # Input -> Register

    s.reg_in   = Wire( p_regwidth )
    s.reg_en   = Wire( 1 )
    s.reg_out  = Wire( p_regwidth )

    s.connect( s.reg_in[ 0:dtype_in ], s.in_.msg )
    if ( dtype_in < p_regwidth ):
      s.connect( s.reg_in[ dtype_in:p_regwidth ], 0 )

    s.reg_ = m = RegEn( p_regwidth  )
    s.connect_dict({
      m.in_ : s.reg_in,
      m.en  : s.reg_en,
      m.out : s.reg_out,
    })

    # Mux

    if ( p_nmsgs > 1 ):
      s.mux = m = Mux( dtype_out, p_nmsgs )
      s.connect_dict({
        m.sel : s.counter.out,
        m.out : s.out.msg,
      })
      for port in range( p_nmsgs ):
        s.connect( m.in_[ port ], s.reg_out[ port*dtype_out:(port+1)*dtype_out ] )
    else:
      s.connect( s.out.msg, s.reg_out )

    #-Combinational Logic-----------------------------------------------

    @s.combinational
    def state_transition():
      s.state.in_.value = s.state.out

      if   s.state.out == s.STATE_IDLE:
        if s.in_.val:
          s.state.in_.value = s.STATE_SEND

      elif s.state.out == s.STATE_SEND:
        if s.out.rdy & (s.counter.out == p_nmsgs-1):
          s.state.in_.value = s.STATE_IDLE

    @s.combinational
    def state_outputs():
      s.in_.rdy.value     = 0
      s.out.val.value     = 0

      s.counter.in_.value = 0
      s.reg_en.value      = 0

      if s.state.out == s.STATE_IDLE:
        s.in_.rdy.value = 1
        s.reg_en.value  = 1

      elif s.state.out == s.STATE_SEND:
        s.out.val.value = 1

        if s.out.rdy & (s.counter.out == p_nmsgs-1):
          s.counter.in_.value = 0
        else:
          s.counter.in_.value = s.counter.out + s.out.rdy

  def line_trace( s ):
    if s.counter.out == 0:
      if( s.state.out == s.STATE_SEND ):
        return "({})>{}".format( s.reg_out, s.out.msg )
      else:
        return "({})>{}".format( "-" * (s.reg_out.nbits/4), "-" * (s.out.msg.nbits/4) )
    else:
      num_dash = int(s.counter.out) * s.out.msg.nbits / 4
      return "({}{})>{}".format( s.reg_out[ int(s.counter.out)*s.out.msg.nbits:s.reg_out.nbits ],
                                  "-" * num_dash,  s.out.msg )
