#=========================================================================
# Single-cycle Multiplier
#=========================================================================
# This multiplier is designed to work with RV32M's mul/mulh/mulhsu/mulhu

# TODO add a bypass queue at response side to cut the long rdy path

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.rtl  import RegEn, RegEnRst, SingleElementBypassQueue
from ifcs import MduMsg, MduReqMsg

# 0 - mul       hilo=0 low  32 bits of zext64(a)*b
# 1 - mulh      hilo=1 high 32 bits of sext64(a)*sext64(b)
# 2 - mulhsu    hilo=1 high 32 bits of sext64(a)*b
# 3 - mulhu     hilo=1 high 32 bits of zext64(a)*b

class IntMulScycle( Model ):

  def __init__( s, nbits, ntypes ):

    nbitsx2 = nbits*2

    s.explicit_modulename = "IntMulScycle"

    # Interface

    s.ifc_type = MduMsg(nbits, ntypes)

    s.req      = InValRdyBundle  ( s.ifc_type.req )
    s.resp     = OutValRdyBundle ( s.ifc_type.resp )

    # Add a bypass queue at response side to cut the rdy path

    s.resp_q = SingleElementBypassQueue( s.ifc_type.resp )
    s.connect( s.resp_q.deq, s.resp )

    # The req goes into the first register to follow the registered-input
    # convention

    s.reg_req_val = RegEnRst( 1, reset_value = 0 )
    s.reg_req_msg = RegEn( s.ifc_type.req )

    s.connect_pairs(
      s.req.val, s.reg_req_val.in_,
      s.req.msg, s.reg_req_msg.in_,
    )

    # Pass reg_req_val and msg.opaque to bypass queue's enq
    # msg.result will be calculated

    s.resp_result = Wire( nbits )

    s.connect( s.reg_req_val.out,        s.resp_q.enq.val )
    s.connect( s.reg_req_msg.out.opaque, s.resp_q.enq.msg.opaque )
    s.connect( s.resp_result,            s.resp_q.enq.msg.result )

    # The enq ready signal propagates everywhere

    s.connect_pairs(
      s.resp_q.enq.rdy, s.req.rdy,
      s.resp_q.enq.rdy, s.reg_req_val.en,
      s.resp_q.enq.rdy, s.reg_req_msg.en,
    )

    #---------------------------------------------------------------------

    # Let's calculate resp_result based on the registered request

    s.typ = Wire( clog2(ntypes) )
    s.opa = Wire( nbits )
    s.opb = Wire( nbits )
    s.connect( s.reg_req_msg.out.type_, s.typ )
    s.connect( s.reg_req_msg.out.op_a,  s.opa )
    s.connect( s.reg_req_msg.out.op_b,  s.opb )

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
    return str(s.req) + " > [" + str(s.reg_req_val.out) + "] > " + str(s.resp)
