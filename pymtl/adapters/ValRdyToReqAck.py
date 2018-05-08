#===============================================================================
# ValRdyToReqAck.py
#===============================================================================
# PyMTL Model that receives  a ValRdy message of a certain width, and sends out
# the same message using a ReqAck protocol
# Author: Taylor Pritchard (tjp79)
#
# Shunning: I rewrite the state transition logic
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

    # Shunning: I use RegRst to keep the hierarchy for debugging

    s.STATE_RECV = 0
    s.STATE_HOLD = 1
    s.STATE_SEND = 2
    s.STATE_WAIT = 3

    s.state = RegRst( 2, reset_value = s.STATE_RECV )

    #-Structural Composition---------------------------------------------

    # Internal Wires

    s.reg_out     = Wire( dtype )
    s.reg_en      = Wire( 1 )
    s.synch_ack   = Wire( 1 )

    # Input Reg

    s.reg_in = m = RegEn( dtype )
    s.connect_dict({
      m.in_ : s.in_.msg,
      m.en  : s.reg_en,
      m.out : s.reg_out
    })

    # Synchronizer Regs

    s.synch_1 = RegRst( 1, reset_value = 0 )
    s.synch_2 = RegRst( 1, reset_value = 0 )

    s.connect_pairs(
      s.out.ack,     s.synch_1.in_,
      s.synch_1.out, s.synch_2.in_,
      s.synch_2.out, s.synch_ack,
    )

    #-Combinational Logic-----------------------------------------------

    @s.combinational
    def state_transition():
      s.state.in_.value = s.state.out

      if   s.state.out == s.STATE_RECV:
        if s.in_.val:
          s.state.in_.value = s.STATE_HOLD

      elif s.state.out == s.STATE_HOLD:
        s.state.in_.value = s.STATE_SEND

      elif s.state.out == s.STATE_SEND:
        if s.synch_ack:
          s.state.in_.value = s.STATE_WAIT

      elif s.state.out == s.STATE_WAIT:
        if ~s.synch_ack:
          s.state.in_.value = s.STATE_RECV

    @s.combinational
    def state_output():
      s.in_.rdy.value = ( s.state.out == s.STATE_RECV )
      s.reg_en.value  = s.in_.val & s.in_.rdy
      s.out.msg.value = s.reg_out
      s.out.req.value = ( s.state.out == s.STATE_SEND )

  def line_trace( s ):
    return "({})".format( s.reg_in.out )
