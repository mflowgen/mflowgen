#===============================================================================
# ReqAckToValRdy.py
#===============================================================================
# PyMTL Model that receives  a ReqAck message of a certain width, and sends out
# the same message using a ValRdy protocol
# Author: Taylor Pritchard (tjp79)
#-------------------------------------------------------------------------------

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, RegRst

from ifcs       import InReqAckBundle, OutReqAckBundle

class ReqAckToValRdy( Model ):

  def __init__( s, dtype ):

    #-Interface----------------------------------------------------------

    s.in_ = InReqAckBundle ( dtype )
    s.out = OutValRdyBundle( dtype )

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
    s.in_req      = Wire( 1 )

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
      m.in_ : s.in_.req,
      m.out : s.synch_1_out
    })

    s.synch_2 = m = RegRst( 1 )
    s.connect_dict({
      m.in_ : s.synch_1_out,
      m.out : s.in_req
    })

    #-Combinational Logic-----------------------------------------------

    @s.combinational
    def combinational_logic():
      s.in_.ack.value = ( s.state == s.STATE_WAIT )
      s.reg_en.value  = s.in_req and ( s.state == s.STATE_RECV )
      s.out.msg.value = s.reg_out
      s.out.val.value = ( s.state == s.STATE_SEND )

    #-Sequential Logic---------------------------------------------------

    @s.posedge_clk
    def sequential_logic():
      if( s.reset ):
        s.state.next = s.STATE_RECV
      elif( s.state == s.STATE_RECV ):
        if( s.in_req ) : s.state.next = s.STATE_WAIT
      elif( s.state == s.STATE_WAIT ):
        if( ~s.in_req ) : s.state.next = s.STATE_SEND
      elif( s.state == s.STATE_SEND ):
        if( s.out.rdy ) : s.state.next = s.STATE_HOLD
      elif( s.state == s.STATE_HOLD ):
        s.state.next = s.STATE_RECV

  def line_trace( s ):
    return "({})".format( s.reg_in.out )

