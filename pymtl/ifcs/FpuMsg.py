from pymtl import *

class FpuReqMsg( BitStructDefinition ):

  TYPE_FMUL    = 0
  TYPE_FADD    = 1
  TYPE_FSUB    = 2
  TYPE_FDIV    = 3
  TYPE_FMIN    = 4
  TYPE_FMAX    = 5
  TYPE_FI2F    = 6
  TYPE_FF2I    = 7
  TYPE_FCEQ    = 8
  TYPE_FCLT    = 9
  TYPE_FCLE    = 10
  NUM_TYPES    = 11

  FRND_NE = 0b000  # Round to nearest, ties to even
  FRND_TZ = 0b001  # Round towards zero
  FRND_DN = 0b010  # Round down (neg inf)
  FRND_UP = 0b011  # Round up (pos inf)
  FRND_MM = 0b100  # Round to nearest, ties to max magnitude

  type_str = {
    TYPE_FMUL  : "fmul",
    TYPE_FADD  : "fadd",
    TYPE_FSUB  : "fsub",
    TYPE_FDIV  : "fdiv",
    TYPE_FMIN  : "fmin",
    TYPE_FMAX  : "fmax",
    TYPE_FI2F  : "fi2f",
    TYPE_FF2I  : "ff2i",
    TYPE_FCEQ  : "fceq",
    TYPE_FCLT  : "fclt",
    TYPE_FCLE  : "fcle",
  }

  def __init__( s ):
    s.type_  = BitField( clog2(FpuReqMsg.NUM_TYPES) )
    s.opaque = BitField( 3 ) # Hard-code at most 8 requesters
    s.op_a   = BitField( 32 )
    s.op_b   = BitField( 32 )
    s.frnd   = BitField( 3 )

  def mk_msg( s, typ, opq, a, b, frnd ):
    msg         = s()
    msg.type_   = typ
    msg.opaque  = opq
    msg.op_a    = a
    msg.op_b    = b
    msg.frnd    = frnd
    return msg

  def __str__( s ):
    return "{}:{}:{}:{}:{}".format( FpuReqMsg.type_str[int(s.type_)],
                                    s.opaque, s.frnd, s.op_a, s.op_b )

class FpuRespMsg( BitStructDefinition ):

  FEXC_NX = 0b00001  # Inexact
  FEXC_UF = 0b00010  # Underflow
  FEXC_OF = 0b00100  # Overflow
  FEXC_DZ = 0b01000  # Divide by zero
  FEXC_NV = 0b10000  # Invalid operation

  def __init__( s ):
    s.opaque = BitField( 3 ) # Hard-code at most 8 requesters
    s.result = BitField( 32 )
    s.fexc   = BitField( 5 )

  def mk_msg( s, opq, res, fexc ):
    msg        = s()
    msg.opaque = opq
    msg.result = res
    msg.fexc   = fexc
    return msg

  def __str__( s ):
    return "{}:{}:{}".format( s.opaque, s.fexc, s.result )

class FpuMsg( object ):
  def __init__( s, nbits, ntypes ):
    s.req  = FpuReqMsg ( nbits, ntypes )
    s.resp = FpuRespMsg( nbits )
