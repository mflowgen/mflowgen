#=========================================================================
# Integer Mul/Div Unit for RISC-V
#=========================================================================

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle

from IntDivRem4      import IntDivRem4
from IntMulScycle    import IntMulScycle
from IntMulPipelined import IntMulPipelined

from ifcs import MduReqMsg, MduRespMsg

class IntMulDivUnit( Model ):

  # Constructor

  def __init__( s, nbits=32, ntypes=8 ): # default arguments for RV32M

    # Explicit module name

    s.explicit_modulename = "IntMulDivUnit"

    # Interface

    s.req  = InValRdyBundle  ( MduReqMsg(nbits, ntypes) )
    s.resp = OutValRdyBundle ( MduRespMsg(nbits) )

    # s.req.msg.type_:
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
    # As a result, s.req.msg.type_[2] indicates whether we should call imul or idiv

    # Instantiate arith units

    s.imul = IntMulPipelined( nbits, ntypes, nstages=2 )
    s.idiv = IntDivRem4( nbits, ntypes )

    # Req/input side

    s.connect( s.req.msg, s.imul.req.msg )
    s.connect( s.req.msg, s.idiv.req.msg )

    # Might need to add a bypass queue here

    # Set individual unit req.val signal based on msg type

    s.is_div = Wire( 1 ) # 0,1,2,3 -- mul, 4,5,6,7 -- div
    s.connect( s.is_div, s.req.msg.type_[2] )

    @s.combinational
    def comb_in_val():
      s.imul.req.val.value = s.req.val & ~s.is_div
      s.idiv.req.val.value = s.req.val & s.is_div

    # Set mdu req.rdy based on msg type and occupancy of the corresponding unit

    @s.combinational
    def comb_in_rdy():
      if ~s.is_div:
        s.req.rdy.value = s.imul.req.rdy
      else:
        s.req.rdy.value = s.idiv.req.rdy

    # Resp/output side

    # Always prioritize mul requests, so imul is ready if resp is ready
    # If imul doesn't have a valid response, then we set idiv's ready to
    # resp.rdy

    s.connect( s.resp.rdy, s.imul.resp.rdy )

    @s.combinational
    def comb_out_rdy():
      s.idiv.resp.rdy.value = 0

      if ~s.imul.resp.val:
        s.idiv.resp.rdy.value = s.resp.rdy

    # If imul doesn't have a valid response, route idiv's response to resp
    # Otherwise let imul go

    @s.combinational
    def comb_out_val_msg():
      s.resp.val.value = s.imul.resp.val
      s.resp.msg.value = s.imul.resp.msg

      if ~s.imul.resp.val:
        s.resp.val.value = s.idiv.resp.val
        s.resp.msg.value = s.idiv.resp.msg

  # Line tracing

  def line_trace( s ):
    if s.req.val and s.req.rdy:
      return "({:>4} -> {})".format( MduReqMsg.type_str[s.req.msg.type_.uint()],
                                   "imul" if s.imul.req.val else "idiv",
                                  )
    return "              "
