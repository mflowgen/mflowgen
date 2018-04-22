from pymtl        import *
from pclib.ifcs   import InValRdyBundle, OutValRdyBundle
from pclib.rtl    import Mux, Reg, RegEn, RegRst
from pclib.rtl    import RightLogicalShifter, LeftLogicalShifter, Adder, Subtractor

Q_MUX_SEL_0   = 0
Q_MUX_SEL_LSH = 1

R_MUX_SEL_IN    = 0
R_MUX_SEL_SUB1  = 1
R_MUX_SEL_SUB2  = 2

D_MUX_SEL_IN  = 0
D_MUX_SEL_RSH = 1

from ifcs import MduReqMsg, MduRespMsg

class IntDivRem4Dpath( Model ):

  def __init__( s, nbits ):
    nbitsX2 = nbits * 2

    s.req_msg_a      = InPort  (nbits)
    s.req_msg_b      = InPort  (nbits)
    s.req_msg_opaque = InPort  (3)
    s.resp_result    = OutPort (nbits)
    s.resp_opaque    = OutPort (3)

    # Status signals

    s.sub_negative1 = OutPort( 1 )
    s.sub_negative2 = OutPort( 1 )

    # Control signals (ctrl -> dpath)

    s.quotient_mux_sel  = InPort( 1 )
    s.quotient_reg_en   = InPort( 1 )

    s.remainder_mux_sel = InPort( 2 )
    s.remainder_reg_en  = InPort( 1 )

    s.divisor_mux_sel   = InPort( 1 )

    s.is_signed         = InPort( 1 )
    s.is_div            = InPort( 1 )
    s.buffers_en        = InPort( 1 )

    #---------------------------------------------------------------------
    # Struction composition
    #---------------------------------------------------------------------

    s.a_negate = Wire( nbits )
    s.b_negate = Wire( nbits )

    # If we are doing signed computation, take the two's complement for
    # A, B individually if negative and B is not zero

    @s.combinational
    def comb_negate_if_needed():
      s.a_negate.value = s.req_msg_a
      s.b_negate.value = s.req_msg_b

      if s.is_signed & (s.req_msg_b != 0):
        if s.req_msg_a[nbits-1]:
          s.a_negate.value = ~s.req_msg_a + 1
        if s.req_msg_b[nbits-1]:
          s.b_negate.value = ~s.req_msg_b + 1

    # remainder mux

    s.remainder_mux = m = Mux( nbitsX2, 3 )
    s.connect_pairs(
      m.sel, s.remainder_mux_sel,
      m.in_[R_MUX_SEL_IN][0:nbits], s.a_negate,
      m.in_[R_MUX_SEL_IN][nbits:nbitsX2], 0,
    )

    # remainder reg

    s.remainder_reg = m = RegEn( nbitsX2 )
    s.connect_pairs(
      m.in_, s.remainder_mux.out,
      m.en , s.remainder_reg_en,
    )

    # divisor mux

    s.divisor_mux = m = Mux( nbitsX2, 2 )
    s.connect_pairs(
      m.sel, s.divisor_mux_sel,
      m.in_[D_MUX_SEL_IN][nbits-1:nbitsX2-1], s.b_negate,
      m.in_[D_MUX_SEL_IN][0:nbits-1], 0,
      m.in_[D_MUX_SEL_IN][nbitsX2-1:nbitsX2], 0,
    )

    # divisor reg

    s.divisor_reg = m = Reg( nbitsX2 )
    s.connect( m.in_, s.divisor_mux.out )

    # quotient mux

    s.quotient_mux = m = Mux( nbits, 2 )
    s.connect_pairs(
      m.sel, s.quotient_mux_sel,
      # inputs are connected later
    )

    # quotient reg

    s.quotient_reg = m = RegEn( nbits )
    s.connect_pairs(
      m.in_, s.quotient_mux.out,
      m.en , s.quotient_reg_en,
    )

    # quotient left shifter. The shamt should be 2 bits!

    s.quotient_lsh = m = LeftLogicalShifter( nbits, 2 )
    s.connect_pairs(
      m.in_, s.quotient_reg.out,
      m.shamt, 2,
    )
    @s.combinational
    def comb_quotient_mux_in():
      s.quotient_mux.in_[Q_MUX_SEL_0].value   = 0
      s.quotient_mux.in_[Q_MUX_SEL_LSH].value = s.quotient_lsh.out + \
        concat(~s.sub_negative1, ~s.sub_negative2)
    #---------------------------------------------------------------------
    # Shunning: these components are added during BRGTC2
    #---------------------------------------------------------------------
    # All regs controlled by buffers_en signal are supposed to change
    # value only when the unit accepts a new request
    #
    # Under div/rem, if A and B have different signs, we take the two's
    # complement of quotient.
    # Under div/rem, if A is negative, we take the two's complement of
    # remainder
    # Special case if B is zero

    s.res_rem_negate = Wire(1)
    s.res_quo_negate = Wire(1)

    @s.combinational
    def comb_res_negate_flags():
      s.res_rem_negate.value = s.is_signed & (s.req_msg_b != 0) & s.req_msg_a[nbits-1]
      s.res_quo_negate.value = s.is_signed & (s.req_msg_b != 0) & (s.req_msg_a[nbits-1] ^ s.req_msg_b[nbits-1])

    # res_rem_negate flag reg

    s.res_rem_negate_flag = m = RegEn( 1 )
    s.connect_dict({
      m.en  : s.buffers_en,
      m.in_ : s.res_rem_negate,
    })

    # res_quo_negate flag reg

    s.res_quo_negate_flag = m = RegEn( 1 )
    s.connect_dict({
      m.en  : s.buffers_en,
      m.in_ : s.res_quo_negate,
    })

    # Get two's complements for remainder/quotient that feed into mux

    s.rem_negate = Wire( nbits )
    s.quo_negate = Wire( nbits )
    @s.combinational
    def comb_negate_rem_quo():
      s.rem_negate.value = ~s.remainder_reg.out[0:nbits] + 1
      s.quo_negate.value = ~s.quotient_reg.out + 1

    # res_rem mux

    s.res_rem_mux = m = Mux( nbits, 2 )
    s.connect_dict({
      m.sel    : s.res_rem_negate_flag.out,
      m.in_[0] : s.remainder_reg.out[0:nbits],
      m.in_[1] : s.rem_negate,
    })

    # res_quo mux

    s.res_quo_mux = m = Mux( nbits, 2 )
    s.connect_dict({
      m.sel    : s.res_quo_negate_flag.out,
      m.in_[0] : s.quotient_reg.out,
      m.in_[1] : s.quo_negate,
    })

    # div/rem sel reg -- buffer is_div during calculation

    s.is_div_reg = m = RegEn( 1 )
    s.connect_dict({
      m.en  : s.buffers_en,
      m.in_ : s.is_div,
    })

    # opaque reg -- buffer opaque during calculation

    s.opaque_reg = m = RegEn( 3 )
    s.connect_dict({
      m.en  : s.buffers_en,
      m.in_ : s.req_msg_opaque,
      m.out : s.resp_opaque,
    })

    # div/rem mux

    s.res_divrem_mux = m = Mux( nbits, 2 )
    s.connect_dict({
      m.sel    : s.is_div_reg.out,
      m.in_[0] : s.res_rem_mux.out, # rem
      m.in_[1] : s.res_quo_mux.out,  # div
      m.out    : s.resp_result, # Connect to output port
    })

    #---------------------------------------------------------------------

    # stage 1/2

    s.sub1 = m = Subtractor( nbitsX2 )

    s.connect_pairs(
      m.in0, s.remainder_reg.out,
      m.in1, s.divisor_reg.out,
      m.out, s.remainder_mux.in_[R_MUX_SEL_SUB1],
    )
    s.connect( s.sub_negative1, s.sub1.out[nbitsX2-1] )

    s.remainder_mid_mux = m = Mux( nbitsX2, 2 )
    s.connect_pairs(
      m.in_[0], s.sub1.out,
      m.in_[1], s.remainder_reg.out,
      m.sel, s.sub_negative1,
    )

    s.divisor_rsh1 = m = RightLogicalShifter( nbitsX2, 1 )
    s.connect_pairs(
      m.in_, s.divisor_reg.out,
      m.shamt, 1,
    )

    # stage 2/2

    s.sub2 = m = Subtractor( nbitsX2 )
    s.connect_pairs(
      m.in0, s.remainder_mid_mux.out,
      m.in1, s.divisor_rsh1.out,
      m.out, s.remainder_mux.in_[R_MUX_SEL_SUB2],
    )

    s.connect( s.sub_negative2, s.sub2.out[nbitsX2-1] )

    s.divisor_rsh2 = m = RightLogicalShifter( nbitsX2, 1 )
    s.connect_pairs(
      m.in_, s.divisor_rsh1.out,
      m.out, s.divisor_mux.in_[D_MUX_SEL_RSH],
      m.shamt, 1,
    )

class IntDivRem4Ctrl( Model ):

  def __init__( s, nbits, ntypes ):
    s.req_val  = InPort  (1)
    s.req_rdy  = OutPort (1)
    s.req_type = InPort  (clog2(ntypes))
    s.resp_val = OutPort (1)
    s.resp_rdy = InPort  (1)

    # Status signals

    s.sub_negative1 = InPort( 1 )
    s.sub_negative2 = InPort( 1 )
    
    # Control signals

    s.quotient_mux_sel  = OutPort( 1 )
    s.quotient_reg_en   = OutPort( 1 )

    s.remainder_mux_sel = OutPort( 2 )
    s.remainder_reg_en  = OutPort( 1 )

    s.divisor_mux_sel   = OutPort( 1 )

    s.is_div            = OutPort  (1)
    s.buffers_en        = OutPort  (1)
    s.is_signed         = OutPort  (1)

    s.STATE_IDLE = 0
    s.STATE_DONE = 1
    s.STATE_CALC = 1+nbits/2

    s.state = RegRst( 1+clog2(nbits/2), reset_value = s.STATE_IDLE )

    @s.combinational
    def state_transitions():

      curr_state = s.state.out

      s.state.in_.value = s.state.out

      if   curr_state == s.STATE_IDLE:
        if s.req_val and s.req_rdy:
          s.state.in_.value = s.STATE_CALC

      elif curr_state == s.STATE_DONE:
        if s.resp_val and s.resp_rdy:
          s.state.in_.value = s.STATE_IDLE

      else:
        s.state.in_.value = curr_state - 1

    @s.combinational
    def state_outputs():

      curr_state = s.state.out

      s.buffers_en.value = 0
      s.is_div.value     = 0

      if   curr_state == s.STATE_IDLE:
        s.req_rdy.value     = 1
        s.resp_val.value    = 0

        s.remainder_mux_sel.value = R_MUX_SEL_IN
        s.remainder_reg_en.value  = 1

        s.quotient_mux_sel.value  = Q_MUX_SEL_0
        s.quotient_reg_en.value   = 1

        s.divisor_mux_sel.value   = D_MUX_SEL_IN

        s.buffers_en.value        = 1
        s.is_div.value            = (s.req_type[1] == 0) # div/divu = 0b100, 0b101
        s.is_signed.value         = (s.req_type[0] == 0) # div/rem = 0b100, 0b110

      elif curr_state == s.STATE_DONE:
        s.req_rdy.value     = 0
        s.resp_val.value    = 1

        s.quotient_mux_sel.value  = Q_MUX_SEL_0
        s.quotient_reg_en.value   = 0

        s.remainder_mux_sel.value = R_MUX_SEL_IN
        s.remainder_reg_en.value  = 0

        s.divisor_mux_sel.value   = D_MUX_SEL_IN

      else: # calculating
        s.req_rdy.value     = 0
        s.resp_val.value    = 0

        s.remainder_reg_en.value = ~(s.sub_negative1 & s.sub_negative2)
        if s.sub_negative2:
          s.remainder_mux_sel.value = R_MUX_SEL_SUB1
        else:
          s.remainder_mux_sel.value = R_MUX_SEL_SUB2

        s.quotient_reg_en.value   = 1
        s.quotient_mux_sel.value  = Q_MUX_SEL_LSH

        s.divisor_mux_sel.value   = D_MUX_SEL_RSH

#=========================================================================
# Integer Divider with Radix of 4 (process 2 bits in 1 cycle)
#=========================================================================

class IntDivRem4( Model ):

  # Constructor

  def __init__( s, nbits, ntypes ):

    # Interface

    s.req   = InValRdyBundle  ( MduReqMsg(nbits, ntypes) )
    s.resp  = OutValRdyBundle ( MduRespMsg(nbits) )

    # Instantiate datapath and control

    s.dpath = IntDivRem4Dpath( nbits )
    s.ctrl  = IntDivRem4Ctrl( nbits, ntypes )

    # Connect input interface to dpath/ctrl

    s.connect( s.req.msg.op_a,   s.dpath.req_msg_a      )
    s.connect( s.req.msg.op_b,   s.dpath.req_msg_b      )
    s.connect( s.req.msg.opaque, s.dpath.req_msg_opaque )
    s.connect( s.req.msg.type_,  s.ctrl.req_type        )
    s.connect( s.req.val,        s.ctrl.req_val  )
    s.connect( s.req.rdy,        s.ctrl.req_rdy  )

    # Connect dpath/ctrl to output interface

    s.connect( s.dpath.resp_result, s.resp.msg.result )
    s.connect( s.dpath.resp_opaque, s.resp.msg.opaque )
    s.connect( s.ctrl.resp_val,  s.resp.val )
    s.connect( s.ctrl.resp_rdy,  s.resp.rdy )

    # Connect status/control signals

    s.connect_auto( s.dpath, s.ctrl )

  # Line tracing

  def line_trace( s ):
    return "Rem:{} Quo:{} Div:{}".format( s.dpath.remainder_reg.out,
            s.dpath.quotient_reg.out, s.dpath.divisor_reg.out )

