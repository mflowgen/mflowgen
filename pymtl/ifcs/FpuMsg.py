from pymtl import *

class FpuReqMsg( BitStructDefinition ):

  TYPE_FMUL    = 0
  TYPE_FADD    = 1
  NUM_TYPES    = 2

  FRND_NE = 0b000  # Round to nearest, ties to even
  FRND_TZ = 0b001  # Round towards zero
  FRND_DN = 0b010  # Round down (neg inf)
  FRND_UP = 0b011  # Round up (pos inf)
  FRND_MM = 0b100  # Round to nearest, ties to max magnitude

  type_str = {
    TYPE_FMUL  : "fmul",
    TYPE_FADD  : "fadd",
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
