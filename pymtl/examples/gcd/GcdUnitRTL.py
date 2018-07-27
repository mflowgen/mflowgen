#=========================================================================
# GCD Unit RTL Model
#=========================================================================

from pymtl       import *
from pclib.ifcs  import InValRdyBundle, OutValRdyBundle, valrdy_to_str
from pclib.rtl   import Mux, RegEn, RegRst
from pclib.rtl   import LtComparator, ZeroComparator, Subtractor

from GcdUnitMsg  import GcdUnitReqMsg

#=========================================================================
# Constants
#=========================================================================

A_MUX_SEL_NBITS = 2
A_MUX_SEL_IN    = 0
A_MUX_SEL_SUB   = 1
A_MUX_SEL_B     = 2
A_MUX_SEL_X     = 0

B_MUX_SEL_NBITS = 1
B_MUX_SEL_A     = 0
B_MUX_SEL_IN    = 1
B_MUX_SEL_X     = 0

#=========================================================================
# GCD Unit RTL Datapath
#=========================================================================

class GcdUnitDpathRTL (Model):

  # Constructor

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.req_msg_a  = InPort  (16)
    s.req_msg_b  = InPort  (16)
    s.resp_msg   = OutPort (16)

    # Control signals (ctrl -> dpath)

    s.a_mux_sel = InPort  (A_MUX_SEL_NBITS)
    s.a_reg_en  = InPort  (1)
    s.b_mux_sel = InPort  (B_MUX_SEL_NBITS)
    s.b_reg_en  = InPort  (1)

    # Status signals (dpath -> ctrl)

    s.is_b_zero = OutPort (1)
    s.is_a_lt_b = OutPort (1)

    #---------------------------------------------------------------------
    # Structural composition
    #---------------------------------------------------------------------

    # A mux

    s.sub_out   = Wire(16)
    s.b_reg_out = Wire(16)

    s.a_mux = m = Mux( 16, 3 )
    s.connect_dict({
      m.sel                  : s.a_mux_sel,
      m.in_[ A_MUX_SEL_IN  ] : s.req_msg_a,
      m.in_[ A_MUX_SEL_SUB ] : s.sub_out,
      m.in_[ A_MUX_SEL_B   ] : s.b_reg_out,
    })

    # A register

    s.a_reg = m = RegEn(16)
    s.connect_dict({
      m.en    : s.a_reg_en,
      m.in_   : s.a_mux.out,
    })

    # B mux

    s.b_mux = m = Mux( 16, 2 )
    s.connect_dict({
      m.sel                 : s.b_mux_sel,
      m.in_[ B_MUX_SEL_A  ] : s.a_reg.out,
      m.in_[ B_MUX_SEL_IN ] : s.req_msg_b,
    })

    # B register

    s.b_reg = m = RegEn(16)
    s.connect_dict({
      m.en    : s.b_reg_en,
      m.in_   : s.b_mux.out,
      m.out   : s.b_reg_out,
    })

    # Zero compare

    s.b_zero = m = ZeroComparator(16)
    s.connect_dict({
      m.in_ : s.b_reg.out,
      m.out : s.is_b_zero,
    })

    # Less-than comparator

    s.a_lt_b = m = LtComparator(16)
    s.connect_dict({
      m.in0 : s.a_reg.out,
      m.in1 : s.b_reg.out,
      m.out : s.is_a_lt_b
    })

    # Subtractor

    s.sub = m = Subtractor(16)
    s.connect_dict({
      m.in0 : s.a_reg.out,
      m.in1 : s.b_reg.out,
      m.out : s.sub_out,
    })

    # connect to output port

    s.connect( s.sub.out, s.resp_msg )

#=========================================================================
# GCD Unit RTL Control
#=========================================================================

class GcdUnitCtrlRTL (Model):

  def __init__( s ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.req_val    = InPort  (1)
    s.req_rdy    = OutPort (1)

    s.resp_val   = OutPort (1)
    s.resp_rdy   = InPort  (1)

    # Control signals (ctrl -> dpath)

    s.a_mux_sel = OutPort (A_MUX_SEL_NBITS)
    s.a_reg_en  = OutPort (1)
    s.b_mux_sel = OutPort (1)
    s.b_reg_en  = OutPort (1)

    # Status signals (dpath -> ctrl)

    s.is_b_zero = InPort  (B_MUX_SEL_NBITS)
    s.is_a_lt_b = InPort  (1)

    # State element

    s.STATE_IDLE = 0
    s.STATE_CALC = 1
    s.STATE_DONE = 2

    s.state = RegRst( 2, reset_value = s.STATE_IDLE )

    #---------------------------------------------------------------------
    # State Transition Logic
    #---------------------------------------------------------------------

    @s.combinational
    def state_transitions():

      curr_state = s.state.out
      next_state = s.state.out

      # Transitions out of IDLE state

      if ( curr_state == s.STATE_IDLE ):
        if ( s.req_val and s.req_rdy ):
          next_state = s.STATE_CALC

      # Transitions out of CALC state

      if ( curr_state == s.STATE_CALC ):
        if ( not s.is_a_lt_b and s.is_b_zero ):
          next_state = s.STATE_DONE

      # Transitions out of DONE state

      if ( curr_state == s.STATE_DONE ):
        if ( s.resp_val and s.resp_rdy ):
          next_state = s.STATE_IDLE

      s.state.in_.value = next_state

    #---------------------------------------------------------------------
    # State Output Logic
    #---------------------------------------------------------------------

    s.do_swap = Wire(1)
    s.do_sub  = Wire(1)

    @s.combinational
    def state_outputs():

      current_state = s.state.out

      # Avoid latches

      s.do_swap.value   = 0
      s.do_sub .value   = 0

      s.req_rdy.value   = 0
      s.resp_val.value  = 0
      s.a_mux_sel.value = 0
      s.a_reg_en.value  = 0
      s.b_mux_sel.value = 0
      s.b_reg_en.value  = 0

      # In IDLE state we simply wait for inputs to arrive and latch them

      if current_state == s.STATE_IDLE:
        s.req_rdy.value   = 1
        s.resp_val.value  = 0
        s.a_mux_sel.value = A_MUX_SEL_IN
        s.a_reg_en.value  = 1
        s.b_mux_sel.value = B_MUX_SEL_IN
        s.b_reg_en.value  = 1

      # In CALC state we iteratively swap/sub to calculate GCD

      elif current_state == s.STATE_CALC:

        s.do_swap.value = s.is_a_lt_b
        s.do_sub.value  = ~s.is_b_zero

        s.req_rdy.value   = 0
        s.resp_val.value  = 0
        s.a_mux_sel.value = A_MUX_SEL_B if s.do_swap else A_MUX_SEL_SUB
        s.a_reg_en.value  = 1
        s.b_mux_sel.value = B_MUX_SEL_A
        s.b_reg_en.value  = s.do_swap

      # In DONE state we simply wait for output transaction to occur

      elif current_state == s.STATE_DONE:
        s.req_rdy.value   = 0
        s.resp_val.value  = 1
        s.a_mux_sel.value = A_MUX_SEL_X
        s.a_reg_en.value  = 0
        s.b_mux_sel.value = B_MUX_SEL_X
        s.b_reg_en.value  = 0

#=========================================================================
# GCD Unit RTL Model
#=========================================================================

class GcdUnitRTL (Model):

  # Constructor

  def __init__( s ):

    # using explict module name

    s.explicit_modulename = 'GcdUnit'

    # Interface

    s.req   = InValRdyBundle  ( GcdUnitReqMsg() )
    s.resp  = OutValRdyBundle ( Bits(16)        )

    # Instantiate datapath and control

    s.dpath = GcdUnitDpathRTL()
    s.ctrl  = GcdUnitCtrlRTL()

    # Connect input interface to dpath/ctrl

    s.connect( s.req.msg.a,       s.dpath.req_msg_a )
    s.connect( s.req.msg.b,       s.dpath.req_msg_b )

    s.connect( s.req.val,         s.ctrl.req_val    )
    s.connect( s.req.rdy,         s.ctrl.req_rdy    )

    # Connect dpath/ctrl to output interface

    s.connect( s.dpath.resp_msg,  s.resp.msg        )
    s.connect( s.ctrl.resp_val,   s.resp.val        )
    s.connect( s.ctrl.resp_rdy,   s.resp.rdy        )

    # Connect status/control signals

    s.connect_auto( s.dpath, s.ctrl )

  # Line tracing

  def line_trace( s ):

    state_str = "? "
    if s.ctrl.state.out == s.ctrl.STATE_IDLE:
      state_str = "I "
    if s.ctrl.state.out == s.ctrl.STATE_CALC:
      if s.ctrl.do_swap:
        state_str = "Cs"
      elif s.ctrl.do_sub:
        state_str = "C-"
      else:
        state_str = "C "
    if s.ctrl.state.out == s.ctrl.STATE_DONE:
      state_str = "D "

    return "{}({} {} {}){}".format(
      s.req,
      s.dpath.a_reg.out,
      s.dpath.b_reg.out,
      state_str,
      s.resp
    )

