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

class IntDivRem4Dpath( Model ):

  def __init__( s, nbits ):
    nbitsX2 = nbits * 2

    s.req_msg  = InPort (nbitsX2)
    s.resp_msg = OutPort(nbitsX2)

    # Status signals

    s.sub_negative1 = OutPort( 1 )
    s.sub_negative2 = OutPort( 1 )

    # Control signals (ctrl -> dpath)

    s.quotient_mux_sel  = InPort( 1 )
    s.quotient_reg_en   = InPort( 1 )

    s.remainder_mux_sel = InPort( 2 )
    s.remainder_reg_en  = InPort( 1 )

    s.divisor_mux_sel   = InPort( 1 )

    # Dpath components

    s.remainder_mux = m = Mux( nbitsX2, 3 )
    s.connect_pairs(
      m.sel, s.remainder_mux_sel,
      m.in_[R_MUX_SEL_IN][0:nbits], s.req_msg[0:nbits],
      m.in_[R_MUX_SEL_IN][nbits:nbitsX2], 0,
    )
    # @s.update
    # def up_remainder_mux_in0():
      # s.remainder_mux.in_[R_MUX_SEL_IN] = dtypex2()
      # s.remainder_mux.in_[R_MUX_SEL_IN][0:nbits] = s.req_msg[0:nbits]

    s.remainder_reg = m = RegEn( nbitsX2 )
    s.connect_pairs(
      m.in_, s.remainder_mux.out,
      m.en , s.remainder_reg_en,
    )
    # lower bits of resp_msg save the remainder
    s.connect( s.resp_msg[0:nbits], s.remainder_reg.out[0:nbits] )

    s.divisor_mux = m = Mux( nbitsX2, 2 )
    s.connect_pairs(
      m.sel, s.divisor_mux_sel,
      m.in_[D_MUX_SEL_IN][nbits-1:nbitsX2-1], s.req_msg[nbits:nbitsX2],
      m.in_[D_MUX_SEL_IN][0:nbits-1], 0,
      m.in_[D_MUX_SEL_IN][nbitsX2-1:nbitsX2], 0,
    )
    # @s.update
    # def up_divisor_mux_in0():
      # s.divisor_mux.in_[D_MUX_SEL_IN] = dtypex2()
      # s.divisor_mux.in_[D_MUX_SEL_IN][nbits-1:nbitsx2-1] = s.req_msg[nbits:nbitsx2]

    s.divisor_reg = m = Reg( nbitsX2 )
    s.connect( m.in_, s.divisor_mux.out )

    s.quotient_mux = m = Mux( nbits, 2 )
    s.connect_pairs(
      m.sel, s.quotient_mux_sel,
      m.in_[Q_MUX_SEL_0], 0,
    )

    s.quotient_reg = m = RegEn( nbits )
    s.connect_pairs(
      m.in_, s.quotient_mux.out,
      m.en , s.quotient_reg_en,
      # higher bits of resp_msg save the quotient
      m.out, s.resp_msg[nbits:nbitsX2],
    )

    # shamt should be 2 bits!
    s.quotient_lsh = m = LeftLogicalShifter( nbits, 2 )
    s.connect_pairs(
      m.in_, s.quotient_reg.out,
      m.shamt, 2,
    )

    @s.combinational
    def comb_quotient_inc():
      s.quotient_mux.in_[Q_MUX_SEL_LSH].value = s.quotient_lsh.out + \
        concat(~s.sub_negative1, ~s.sub_negative2)

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

  def __init__( s, nbits ):
    s.req_val  = InPort  (1)
    s.req_rdy  = OutPort (1)
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

    s.STATE_IDLE = 0
    s.STATE_DONE = 1
    s.STATE_CALC = 1+nbits/2

    s.state = RegRst( 1+clog2(nbits/2), reset_value = s.STATE_IDLE )

    @s.combinational
    def state_transitions():

      curr_state = s.state.out

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

      if   curr_state == s.STATE_IDLE:
        s.req_rdy.value     = 1
        s.resp_val.value    = 0

        s.remainder_mux_sel.value = R_MUX_SEL_IN
        s.remainder_reg_en.value  = 1

        s.quotient_mux_sel.value  = Q_MUX_SEL_0
        s.quotient_reg_en.value   = 1

        s.divisor_mux_sel.value   = D_MUX_SEL_IN

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

class IntDivRem4( Model ):

  # Constructor

  def __init__( s, nbits ):

    # Interface

    s.req    = InValRdyBundle  ( nbits*2 )
    s.resp   = OutValRdyBundle ( nbits*2 )

    # Instantiate datapath and control

    s.dpath = IntDivRem4Dpath( nbits )
    s.ctrl  = IntDivRem4Ctrl( nbits )

    # Connect input interface to dpath/ctrl

    s.connect( s.req.msg, s.dpath.req_msg )
    s.connect( s.req.val, s.ctrl.req_val  )
    s.connect( s.req.rdy, s.ctrl.req_rdy  )

    # Connect dpath/ctrl to output interface

    s.connect( s.dpath.resp_msg, s.resp.msg )
    s.connect( s.ctrl.resp_val,  s.resp.val )
    s.connect( s.ctrl.resp_rdy,  s.resp.rdy )

    # Connect status/control signals

    s.connect_auto( s.dpath, s.ctrl )

  # Line tracing

  def line_trace( s ):
    return "Rem:{} Quo:{} Div:{}".format( s.dpath.remainder_reg.out,
            s.dpath.quotient_reg.out, s.dpath.divisor_reg.out )

