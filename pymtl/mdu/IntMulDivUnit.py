#=========================================================================
# Integer Mul/Div Unit for RISC-V
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from IntDivRem4   import IntDivRem4
from IntMulVarLat import IntMulVarLat

from ifcs import MduReqMsg, MduRespMsg

class IntMulDivUnit( Model ):

  # Constructor

  def __init__( s, nbits=32, ntypes=8 ): # default arguments for RV32M

    # Explicit module name

    s.explicit_modulename = "IntMulDivUnit"

    # Interface

    s.req  = InValRdyBundle  ( MduReqMsg(nbits, ntypes) )
    s.resp = OutValRdyBundle ( MduRespMsg(nbits) )

    # s.req.msg.typ:
    # https://github.com/riscv/riscv-isa-sim/blob/master/riscv/insns/mul.h
    # Assume RV32M
    # 0 - mul       hilo=0 low  32 bits of zext64(a)*b
    # 1 - mulh      hilo=1 high 32 bits of sext64(a)*sext64(b)
    # 2 - mulhsu    hilo=1 high 32 bits of sext64(a)*b
    # 3 - mulhu     hilo=1 high 32 bits of zext64(a)*b
    # 4 - div       
    # 5 - divu  
    # 6 - rem       
    # 7 - remu
    # As a result, s.req.msg.typ[2] indicates whether we should call imul or idiv

    # Instantiate arith units

    s.imul = IntMulVarLat( nbits, ntypes )
    s.idiv = IntDivRem4( nbits, ntypes )

    # Req/input side

    s.connect( s.req.msg, s.imul.req.msg )
    s.connect( s.req.msg, s.idiv.req.msg )

    # Might need to add a bypass queue here

    @s.combinational
    def comb_in_val():
      s.imul.req.val.value = s.req.val & ~s.req.msg.typ[2] & s.idiv.req.rdy
      s.idiv.req.val.value = s.req.val & s.req.msg.typ[2]  & s.imul.req.rdy

    @s.combinational
    def comb_in_rdy():
      s.req.rdy.value = s.imul.req.rdy & ~s.req.msg.typ[2]
      s.req.rdy.value = s.idiv.req.rdy &

    # Resp/output side

    s.connect( s.resp.rdy, s.imul.resp.rdy )

    @s.combinational
    def comb_out_rdy():
      if ~s.imul.resp.val & s.idiv.resp.val:

      if s.imul.resp.val:
        s.resp.

    @s.combinational
    def comb_out_val_msg():

      if ~s.imul.resp.val & s.idiv.resp.val:
        s.resp.val.value = 1
      else:
      s.resp.val.value = s.imul.resp.val
      if s.idiv.resp.val & ~s.imul.resp.val:
      if s.imul.resp.val:
        s.resp.msg.value = s.imul.resp.msg
      else:
        s.resp.msg.value = s.idiv.resp.msg

  # Line tracing

  def line_trace( s ):
    if s.req.val and s.req.rdy:
      return "({:>4} -> {})".format( MduReqMsg.type_str[s.req.msg.typ.uint()],
                                   "imul" if s.imul.req.val else "idiv",
                                  )
    return "              "
