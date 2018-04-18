#===============================================================================
# ValRdySerializer.py
#===============================================================================
# PyMTL Model that receives a ValRdy message of a certain width, and sends out
# the same payload, broken up into a number of messages of a different width
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, Mux

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

    # Internal Wires
    s.reg_in  = Wire( p_regwidth )
    s.reg_out = Wire( p_regwidth )
    s.load    = Wire( 1 )
    s.count   = Wire( 1 )
    if ( p_nmsgs > 1 ) : s.counter = Wire( clog2( p_nmsgs ) )
    else               : s.counter = Wire( 1 )

    # Input -> Register
    s.connect( s.reg_in[ 0:dtype_in ], s.in_.msg )
    if ( dtype_in < p_regwidth ):
      s.connect( s.reg_in[ dtype_in:p_regwidth ], 0 )

    # Register
    s.reg_ = m = RegEn( p_regwidth  )
    s.connect_dict({
      m.in_ : s.reg_in,
      m.en  : s.load,
      m.out : s.reg_out,
    })

    # Mux
    if ( p_nmsgs > 1 ):
      s.mux = m = Mux( dtype_out, p_nmsgs )
      s.connect_dict({
        m.sel : s.counter,
        m.out : s.out.msg,
      })
      for port in range( p_nmsgs ):
        s.connect( s.reg_out[ port*dtype_out:(port+1)*dtype_out ], m.in_[ port ] )
    else:
      s.connect( s.out.msg, s.reg_out )

    #-Combinational Logic-----------------------------------------------

    @s.combinational
    def combinational_logic():
      s.load.value = s.in_.val & s.in_.rdy

    #-Sequential Logic---------------------------------------------------

    @s.posedge_clk
    def sequential_logic():
      if( s.reset ):
        s.in_.rdy.next = 1;
        s.count  .next = 0;
        s.counter.next = 0x0;
        s.out.val.next = 0;
      elif( s.load ):
        s.in_.rdy.next = 0;
        s.count  .next = 1;
        s.counter.next = 0x0;
        s.out.val.next = 1;
      elif( s.out.rdy & (s.counter == p_nmsgs-1) ):
        s.in_.rdy.next = 1;
        s.count  .next = 0;
        s.counter.next = 0x0;
        s.out.val.next = 0;
      elif( s.out.rdy & s.count ):
        s.in_.rdy.next = 0;
        s.count  .next = 1;
        s.counter.next = s.counter + 0x1;
        s.out.val.next = 1;

  def line_trace( s ):
    if( s.counter._uint == 0 ):
      if( s.count ):
        return "({})>{}".format( s.reg_out, s.out.msg )
      else:
        return "({})>{}".format( "-" * (s.reg_out.nbits/4), "-" * (s.out.msg.nbits/4) )
    else:
      num_dash = (s.out.msg.nbits * s.counter._uint)/4
      return "({}{})>{}".format( s.reg_out[ s.out.msg.nbits*s.counter._uint:s.reg_out.nbits ], "-" * num_dash,  s.out.msg )
