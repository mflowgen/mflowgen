#=========================================================================
# Integer Multiplier Variable Latency RTL Model with High/Low selection
#=========================================================================
# This multiplier is designed to work with RV32M's mul/mulh/mulhsu/mulhu

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import Mux, Reg, RegEn, RegRst
from pclib.rtl  import RightLogicalShifter, LeftLogicalShifter, Adder
from pclib.rtl  import ZeroComparator

from ifcs import MduReqMsg, MduRespMsg

#=========================================================================
# Constants
#=========================================================================

A_MUX_SEL_NBITS      = 2
A_MUX_SEL_LSH        = 0
A_MUX_SEL_LD         = 1
A_MUX_SEL_SEXT       = 2
A_MUX_SEL_X          = 0

B_MUX_SEL_NBITS      = 1
B_MUX_SEL_RSH        = 0
B_MUX_SEL_LD         = 1
B_MUX_SEL_X          = 0

RESULT_MUX_SEL_NBITS = 2
RESULT_MUX_SEL_ADD   = 0
RESULT_MUX_SEL_0     = 1
RESULT_MUX_SEL_MULH  = 2
RESULT_MUX_SEL_X     = 0

ADD_MUX_SEL_NBITS    = 1
ADD_MUX_SEL_ADD      = 0
ADD_MUX_SEL_RESULT   = 1
ADD_MUX_SEL_X        = 0

class IntMulVarLatCalcShamt( Model ):

  # Constructor

  def __init__( s ):

    s.in_ = InPort  (8)
    s.out = OutPort (4)

    @s.combinational
    def block():

      if   s.in_    == 0: s.out.value = 8
      elif s.in_[0] == 1: s.out.value = 1
      elif s.in_[1] == 1: s.out.value = 1
      elif s.in_[2] == 1: s.out.value = 2
      elif s.in_[3] == 1: s.out.value = 3
      elif s.in_[4] == 1: s.out.value = 4
      elif s.in_[5] == 1: s.out.value = 5
      elif s.in_[6] == 1: s.out.value = 6
      elif s.in_[7] == 1: s.out.value = 7
      else:               s.out.value = 0

  # Line tracing

  def line_trace( s ):
    return "{}(){}".format( s.in_, s.out )

#=========================================================================
# Integer Multiplier Fixed Latency Datapath
#=========================================================================

class IntMulVarLatDpath( Model ):

  def __init__( s, nbits ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.req_msg_a      = InPort  (nbits)
    s.req_msg_b      = InPort  (nbits)
    s.req_msg_opaque = InPort  (3)
    s.resp_result    = OutPort (nbits)
    s.resp_opaque    = OutPort (3)

    # Control signals (ctrl -> dpath)

    s.a_mux_sel      = InPort  (A_MUX_SEL_NBITS)
    s.b_mux_sel      = InPort  (B_MUX_SEL_NBITS)
    s.result_mux_sel = InPort  (RESULT_MUX_SEL_NBITS)
    s.result_reg_en  = InPort  (1)
    s.add_mux_sel    = InPort  (ADD_MUX_SEL_NBITS)

    s.is_hi          = InPort  (1)
    s.buffers_en     = InPort  (1)

    # Status signals (dpath -> ctrl)

    s.b_lsb          = OutPort (1)
    s.is_b_zero      = OutPort (1)

    #---------------------------------------------------------------------
    # Struction composition
    #---------------------------------------------------------------------

    # B mux

    s.rshifter_out = Wire( nbits )

    s.b_mux = m = Mux( nbits, 2 )
    s.connect_dict({
      m.sel                : s.b_mux_sel,
      m.in_[B_MUX_SEL_RSH] : s.rshifter_out,
      m.in_[B_MUX_SEL_LD]  : s.req_msg_b,
    })

    # B register

    s.b_reg = m = Reg( nbits )
    s.connect_dict({
      m.in_ : s.b_mux.out,
    })

    # B zero comparator

    s.b_zero_cmp = m = ZeroComparator( nbits )
    s.connect_dict({
      m.in_ : s.b_reg.out,
      m.out : s.is_b_zero,
    })

    # Calculate shift amount

    s.calc_shamt = m = IntMulVarLatCalcShamt()
    s.connect_dict({
      m.in_ : s.b_reg.out[0:8],
    })

    # Right shifter

    s.rshifter = m = RightLogicalShifter(nbits,4)
    s.connect_dict({
      m.in_   : s.b_reg.out,
      m.shamt : s.calc_shamt.out,
      m.out   : s.rshifter_out,
    })

    # A mux

    s.lshifter_out = Wire( nbits*2 )

    s.a_mux = m = Mux( nbits*2, 3 )

    s.opa_sext = Wire( nbits*2 )

    @s.combinational
    def comb_opa_sext():
      s.opa_sext.value = sext( s.req_msg_a, 64 )

    s.connect_dict({
      m.sel                              : s.a_mux_sel,
      m.in_[A_MUX_SEL_LSH]               : s.lshifter_out,
      m.in_[A_MUX_SEL_LD][0:nbits]       : s.req_msg_a,
      m.in_[A_MUX_SEL_LD][nbits:nbits*2] : 0,
      m.in_[A_MUX_SEL_SEXT]              : s.opa_sext,
    })

    # A register

    s.a_reg = m = Reg( nbits*2 )
    s.connect_dict({
      m.in_ : s.a_mux.out,
    })

    # Left shifter

    s.lshifter = m = LeftLogicalShifter( nbits*2,4 )
    s.connect_dict({
      m.in_   : s.a_reg.out,
      m.shamt : s.calc_shamt.out,
      m.out   : s.lshifter_out,
    })

    # Result mux

    # If B is negative, I add (~A+1) to high 32 bit of A, just because
    # A*sext64(B) will be A*0xffffffffB = A*(0xffffffff00000000) + A*B
    # = ( (~A+1)<<32 ) + A*B

    s.a_mulh_negate = Wire( nbits*2 )
    @s.combinational
    def comb_a_mulh_negate():
      s.a_mulh_negate.value = 0
      # Why can't I use nbits ???
      if s.req_msg_b[nbits-1]:
        s.a_mulh_negate[nbits:].value = ~s.req_msg_a + 1

    s.add_mux_out = Wire( nbits*2 )

    s.result_mux = m = Mux( nbits*2, 3 )
    s.connect_dict({
      m.sel                     : s.result_mux_sel,
      m.in_[RESULT_MUX_SEL_ADD] : s.add_mux_out,
      m.in_[RESULT_MUX_SEL_0]   : 0,
      m.in_[RESULT_MUX_SEL_MULH]: s.a_mulh_negate,
    })

    # Result register

    s.result_reg = m = RegEn( nbits*2 )
    s.connect_dict({
      m.en  : s.result_reg_en,
      m.in_ : s.result_mux.out,
    })

    # Adder

    s.add = m = Adder( nbits*2 )
    s.connect_dict({
      m.in0 : s.a_reg.out,
      m.in1 : s.result_reg.out,
      m.cin : 0
    })

    # Add mux

    s.add_mux = m = Mux( nbits*2, 2 )
    s.connect_dict({
      m.sel                     : s.add_mux_sel,
      m.in_[ADD_MUX_SEL_ADD]    : s.add.out,
      m.in_[ADD_MUX_SEL_RESULT] : s.result_reg.out,
      m.out                     : s.add_mux_out
    })

    #---------------------------------------------------------------------
    # Shunning: these three components are added during BRGTC2
    #---------------------------------------------------------------------
    # All regs controlled by buffers_en signal are supposed to change
    # value only when the unit accepts a new request

    # hi/lo sel reg -- buffer is_hi during calculation

    s.is_hi_reg = m = RegEn( 1 )
    s.connect_dict({
      m.en  : s.buffers_en,
      m.in_ : s.is_hi,
    })

    # opaque reg -- buffer opaque during calculation

    s.opaque_reg = m = RegEn( 3 )
    s.connect_dict({
      m.en  : s.buffers_en,
      m.in_ : s.req_msg_opaque,
      m.out : s.resp_opaque,
    })

    # hi/lo mux

    s.res_hilo_mux = m = Mux( nbits, 2 )
    s.connect_dict({
      m.sel    : s.is_hi_reg.out,
      m.in_[0] : s.result_reg.out[0:nbits],       # lo
      m.in_[1] : s.result_reg.out[nbits:nbits*2], # hi
      m.out    : s.resp_result, # Connect to output port
    })

    #---------------------------------------------------------------------

    # Status signals

    s.connect( s.b_lsb, s.b_reg.out[0] )

#=========================================================================
# Integer Multiplier Fixed Latency Control
#=========================================================================
# 0 - mul       hilo=0 low  32 bits of zext64(a)*b
# 1 - mulh      hilo=1 high 32 bits of sext64(a)*sext64(b)
# 2 - mulhsu    hilo=1 high 32 bits of sext64(a)*b
# 3 - mulhu     hilo=1 high 32 bits of zext64(a)*b

class IntMulVarLatCtrl( Model ):

  def __init__( s, ntypes ):

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.req_val        = InPort  (1)
    s.req_rdy        = OutPort (1)
    s.req_type       = InPort  (clog2(ntypes))

    s.resp_val       = OutPort (1)
    s.resp_rdy       = InPort  (1)

    # Control signals (ctrl -> dpath)

    s.a_mux_sel      = OutPort (A_MUX_SEL_NBITS)
    s.b_mux_sel      = OutPort (B_MUX_SEL_NBITS)
    s.result_mux_sel = OutPort (RESULT_MUX_SEL_NBITS)
    s.result_reg_en  = OutPort (1)
    s.add_mux_sel    = OutPort (ADD_MUX_SEL_NBITS)
    s.is_hi          = OutPort (1)
    s.buffers_en     = OutPort (1)

    # Status signals (dpath -> ctrl)

    s.b_lsb          = InPort  (1)
    s.is_b_zero      = InPort  (1)

    # State element

    s.STATE_NBITS = 2
    s.STATE_IDLE  = 0
    s.STATE_CALC  = 1
    s.STATE_DONE  = 2

    s.state = RegRst( s.STATE_NBITS, reset_value = s.STATE_IDLE )

    #---------------------------------------------------------------------
    # State transitions
    #---------------------------------------------------------------------

    @s.combinational
    def state_transitions():

      curr_state = s.state.out
      next_state = s.state.out

      # Transistions out of IDLE state

      if ( s.state.out == s.STATE_IDLE ):
        if ( s.req_val and s.req_rdy ):
          next_state = s.STATE_CALC

      # Transistions out of CALC state

      if ( s.state.out == s.STATE_CALC ):
        if s.is_b_zero:
          next_state = s.STATE_DONE

      # Transistions out of DONE state

      if ( s.state.out == s.STATE_DONE ):
        if ( s.resp_val and s.resp_rdy ):
          next_state = s.STATE_IDLE

      s.state.in_.value = next_state

    #---------------------------------------------------------------------
    # State outputs
    #---------------------------------------------------------------------

    s.do_sh_add = Wire(1)
    s.do_sh     = Wire(1)

    @s.combinational
    def state_outputs():

      current_state = s.state.out

      # Initialize all control signals

      s.do_sh_add.value      = 0
      s.do_sh.value          = 0

      s.req_rdy.value        = 0
      s.resp_val.value       = 0

      s.a_mux_sel.value      = 0
      s.b_mux_sel.value      = 0
      s.result_mux_sel.value = 0
      s.result_reg_en.value  = 0
      s.add_mux_sel.value    = 0

      s.result_mux_sel.value = 0
      s.buffers_en.value     = 0
      s.is_hi.value          = 0

      # In IDLE state we simply wait for inputs to arrive and latch them

      if current_state == s.STATE_IDLE:

        s.req_rdy.value        = 1
        s.resp_val.value       = 0

        if s.req_type == MduReqMsg.TYPE_MULHSU or s.req_type == MduReqMsg.TYPE_MULH:
          s.a_mux_sel.value = A_MUX_SEL_SEXT
        else:
          s.a_mux_sel.value = A_MUX_SEL_LD

        s.b_mux_sel.value      = B_MUX_SEL_LD

        if s.req_type == MduReqMsg.TYPE_MULH:
          s.result_mux_sel.value = RESULT_MUX_SEL_MULH
        else:
          s.result_mux_sel.value = RESULT_MUX_SEL_0

        s.result_reg_en.value  = 1
        s.buffers_en.value     = 1
        s.is_hi.value          = (s.req_type != 0)
        s.add_mux_sel.value    = ADD_MUX_SEL_X

      # In CALC state we iteratively add/shift to caculate mult

      elif current_state == s.STATE_CALC:

        s.do_sh_add.value      = (s.b_lsb == 1) # do shift and add
        s.do_sh.value          = (s.b_lsb == 0) # do shift but no add

        s.req_rdy.value        = 0
        s.resp_val.value       = 0

        s.a_mux_sel.value      = A_MUX_SEL_LSH
        s.b_mux_sel.value      = B_MUX_SEL_RSH
        s.result_mux_sel.value = RESULT_MUX_SEL_ADD
        s.result_reg_en.value  = 1
        if s.do_sh_add:
          s.add_mux_sel.value  = ADD_MUX_SEL_ADD
        else:
          s.add_mux_sel.value  = ADD_MUX_SEL_RESULT

      # In DONE state we simply wait for output transition to occur

      elif current_state == s.STATE_DONE:

        s.req_rdy.value        = 0
        s.resp_val.value       = 1

        s.a_mux_sel.value      = A_MUX_SEL_X
        s.b_mux_sel.value      = B_MUX_SEL_X
        s.result_mux_sel.value = RESULT_MUX_SEL_X
        s.result_reg_en.value  = 0
        s.add_mux_sel.value    = ADD_MUX_SEL_X

#=========================================================================
# Integer Multiplier Variable Latency
#=========================================================================

class IntMulVarLat( Model ):

  # Constructor

  def __init__( s, nbits, ntypes ):

    # Interface

    s.req   = InValRdyBundle  ( MduReqMsg(nbits, ntypes) )
    s.resp  = OutValRdyBundle ( MduRespMsg(nbits) )

    # Instantiate datapath and control

    s.dpath = IntMulVarLatDpath( nbits )
    s.ctrl  = IntMulVarLatCtrl( ntypes )

    # Connect input interface to dpath/ctrl

    s.connect( s.req.msg.op_a,   s.dpath.req_msg_a      )
    s.connect( s.req.msg.op_b,   s.dpath.req_msg_b      )
    s.connect( s.req.msg.opaque, s.dpath.req_msg_opaque )
    s.connect( s.req.msg.type_,  s.ctrl.req_type        )
    s.connect( s.req.val,        s.ctrl.req_val         )
    s.connect( s.req.rdy,        s.ctrl.req_rdy         )

    # Connect dpath/ctrl to output interface

    s.connect( s.dpath.resp_result, s.resp.msg.result )
    s.connect( s.dpath.resp_opaque, s.resp.msg.opaque )
    s.connect( s.ctrl.resp_val,     s.resp.val )
    s.connect( s.ctrl.resp_rdy,     s.resp.rdy )

    # Connect status/control signals

    s.connect_auto( s.dpath, s.ctrl )

  # Line tracing

  def line_trace( s ):

    if s.ctrl.state.out == s.ctrl.STATE_IDLE:
      line_trace_str = "I "

    elif s.ctrl.state.out == s.ctrl.STATE_CALC:
      if s.ctrl.do_sh_add:
        line_trace_str = "C+"
      elif s.ctrl.do_sh:
        line_trace_str = "C "
      else:
        line_trace_str = "C?"

    elif s.ctrl.state.out == s.ctrl.STATE_DONE:
      line_trace_str = "D "

    return "({} {} {} {})".format(
      s.dpath.a_reg.out,
      s.dpath.b_reg.out,
      s.dpath.result_reg.out,
      line_trace_str,
    )

