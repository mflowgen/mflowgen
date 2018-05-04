#=========================================================================
# Pipelined Multiplier used for Register retiming
#=========================================================================
# This multiplier is designed to work with RV32M's mul/mulh/mulhsu/mulhu

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, RegEnRst
from ifcs import MduMsg, MduReqMsg

# 0 - mul       hilo=0 low  32 bits of zext64(a)*b
# 1 - mulh      hilo=1 high 32 bits of sext64(a)*sext64(b)
# 2 - mulhsu    hilo=1 high 32 bits of sext64(a)*b
# 3 - mulhu     hilo=1 high 32 bits of zext64(a)*b

class IntMulPipelined( Model ):

  def __init__( s, nbits, ntypes, nstages=8 ):

    # Should at least have two stages!

    assert nstages >= 2
    nbitsx2 = nbits*2

    s.explicit_modulename = "IntMulPipelined_{}Stage".format( nstages )

    # Interface

    s.ifc_type = MduMsg(nbits, ntypes)

    s.req      = InValRdyBundle  ( s.ifc_type.req )
    s.resp     = OutValRdyBundle ( s.ifc_type.resp )

    # Add amount of stages for register retiming
    # Shunning: The design I'm doing here guarantees registered input.
    #           Since we resort to register retiming, all the work are
    #           done between the first register and the second register.
    #           A four-stage multiplier would have the first stage
    #           register the input, and the remaining three stages hold
    #           output

    s.reg_req_val = RegEnRst( 1, reset_value = 0 )
    s.reg_req_msg = RegEn( s.ifc_type.req )

    # The req goes into the first register

    s.connect_pairs(
      s.req.val, s.reg_req_val.in_,
      s.req.msg, s.reg_req_msg.in_,
    )

    s.regs_resp_val = RegEnRst[ nstages-1 ]( 1 )
    s.regs_resp_msg = RegEn   [ nstages-1 ]( s.ifc_type.resp )

    # Pass reg_req_val and msg.opaque to the first reg_resp
    # msg.result will be calculated

    s.connect( s.reg_req_val.out,        s.regs_resp_val[0].in_ )
    s.connect( s.reg_req_msg.out.opaque, s.regs_resp_msg[0].in_.opaque )

    # Connect all intermediate response registers

    for i in xrange(1, nstages-1):
      s.connect_pairs(
        s.regs_resp_val[ i-1 ].out, s.regs_resp_val[ i ].in_,
        s.regs_resp_msg[ i-1 ].out, s.regs_resp_msg[ i ].in_,
      )

    # The response goes out from the last register

    s.connect_pairs(
      s.regs_resp_val[ nstages-2 ].out, s.resp.val,
      s.regs_resp_msg[ nstages-2 ].out, s.resp.msg,
    )

    # The response ready signal propagates everywhere

    s.connect_pairs(
      s.resp.rdy, s.req.rdy,
      s.resp.rdy, s.reg_req_val.en,
      s.resp.rdy, s.reg_req_msg.en,
    )
    for i in xrange(nstages-1):
      s.connect_pairs(
        s.resp.rdy, s.regs_resp_val[i].en,
        s.resp.rdy, s.regs_resp_msg[i].en,
      )

    #---------------------------------------------------------------------

    # Let's calculate regs_resp_msg[0].in_ based on reg_req_msg.out

    s.typ = Wire( clog2(ntypes) )
    s.opa = Wire( nbits )
    s.opb = Wire( nbits )
    s.connect( s.reg_req_msg.out.type_, s.typ )
    s.connect( s.reg_req_msg.out.op_a,  s.opa )
    s.connect( s.reg_req_msg.out.op_b,  s.opb )

    s.resp_result = Wire( nbits )
    s.connect( s.resp_result, s.regs_resp_msg[0].in_.result )

    # Sign-extend opa under MULH/MULHSU

    s.ext_opa = Wire( nbitsx2 )

    @s.combinational
    def comb_opa():
      if s.typ == MduReqMsg.TYPE_MULHSU or s.typ == MduReqMsg.TYPE_MULH:
        s.ext_opa.value = sext( s.opa, nbitsx2 )
      else:
        s.ext_opa.value = zext( s.opa, nbitsx2 )

    # If B is negative, I add (~A+1) to high 32 bit of A, just because
    # A*sext64(B) will be A*0xffffffffB = A*(0xffffffff00000000) + A*B
    # = ( (~A+1)<<32 ) + A*B. Note that the A should be the original A

    s.a_mulh_negate = Wire( nbits*2 )
    s.mul_result    = Wire( nbits*3 )

    @s.combinational
    def comb_a_mulh_negate():
      s.a_mulh_negate[0:nbits].value = 0
      s.a_mulh_negate[nbits:].value  = ~s.opa + 1

    @s.combinational
    def comb_multiply():
      if s.typ == MduReqMsg.TYPE_MULH and s.opb[nbits-1]:
        s.mul_result.value = s.ext_opa * s.opb + s.a_mulh_negate
      else:
        s.mul_result.value = s.ext_opa * s.opb

    @s.combinational
    def comb_select_hilo():
      if s.typ == MduReqMsg.TYPE_MUL:
        s.resp_result.value = s.mul_result[0:nbits]
      else:
        s.resp_result.value = s.mul_result[nbits:nbitsx2]

  # Line tracing

  def line_trace( s ):
    val_str = str(s.reg_req_val.out) + "".join([ str(x.out) for x in s.regs_resp_val ])
    return str(s.req) + " > [" + val_str + "] > " + str(s.resp)
