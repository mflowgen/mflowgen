#===============================================================================
# ValRdyToReqAck.py
#===============================================================================
# PyMTL Model that receives  a ValRdy message of a certain width, and sends out
# the same message using a ReqAck protocol
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, RegRst

from ifcs       import InReqAckBundle, OutReqAckBundle

class ValRdyToReqAck( Model ):

  def __init__( s, dtype ):

    #-Interface----------------------------------------------------------

    s.in_ = InValRdyBundle ( dtype )
    s.out = OutReqAckBundle( dtype )

    #-States-------------------------------------------------------------

    s.state = Wire( 2 )

    s.STATE_RECV = 0
    s.STATE_HOLD = 1
    s.STATE_SEND = 2
    s.STATE_WAIT = 3

    #-Structural Composition---------------------------------------------

    # Internal Wires

    s.reg_out     = Wire( dtype )
    s.reg_en      = Wire( 1 )
    s.synch_1_out = Wire( 1 )
    s.synch_ack   = Wire( 1 )

    # Input Reg

    s.reg_in = m = RegEn( dtype )
    s.connect_dict({
      m.in_ : s.in_.msg,
      m.en  : s.reg_en,
      m.out : s.reg_out
    })

    # Synchronizer Regs

    s.synch_1 = m = RegRst( 1 )
    s.connect_dict({
      m.in_ : s.out.ack,
      m.out : s.synch_1_out
    })

    s.synch_2 = m = RegRst( 1 )
    s.connect_dict({
      m.in_ : s.synch_1_out,
      m.out : s.synch_ack
    })

    #-Combinational Logic-----------------------------------------------

    @s.combinational
    def combinational_logic():
      s.in_.rdy.value = ( s.state == s.STATE_RECV )
      s.reg_en.value  = s.in_.val & s.in_.rdy
      s.out.msg.value = s.reg_out
      s.out.req.value = ( s.state == s.STATE_SEND )

    #-Sequential Logic---------------------------------------------------

    @s.posedge_clk
    def sequential_logic():
      if( s.reset ):
        s.state.next = s.STATE_RECV
      elif( s.state == s.STATE_RECV ):
        if( s.in_.val ) : s.state.next = s.STATE_HOLD
      elif( s.state == s.STATE_HOLD ):
        s.state.next = s.STATE_SEND
      elif( s.state == s.STATE_SEND ):
        if( s.synch_ack ) : s.state.next = s.STATE_WAIT
      elif( s.state == s.STATE_WAIT ):
        if( ~s.synch_ack ) : s.state.next = s.STATE_RECV

  def line_trace( s ):
    return "({})".format( s.reg_in.out )
