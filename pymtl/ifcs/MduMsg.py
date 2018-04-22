from pymtl import *

class MduReqMsg( BitStructDefinition ):

  TYPE_MUL    = 0
  TYPE_MULH   = 1
  TYPE_MULHSU = 2
  TYPE_MULHU  = 3
  TYPE_DIV    = 4
  TYPE_DIVU   = 5
  TYPE_REM    = 6
  TYPE_REMU   = 7

  type_str = {
    TYPE_MUL   : "mul ",
    TYPE_MULH  : "mulh",
    TYPE_MULHSU: "mhsu",
    TYPE_MULHU : "mhu ",
    TYPE_DIV   : "div ",
    TYPE_DIVU  : "divu",
    TYPE_REM   : "rem ",
    TYPE_REMU  : "remu",
  }

  def __init__( s, nbits, ntypes ):
    s.type_  = BitField( clog2(ntypes) )
    s.opaque = BitField( 3 ) # Hard-code at most 8 requesters
    s.op_a   = BitField( nbits )
    s.op_b   = BitField( nbits )

  def mk_msg( s, typ, opq, a, b ):
    msg        = s()
    msg.type_  = typ
    msg.opaque = opq
    msg.op_a    = a
    msg.op_b    = b
    return msg

  def __str__( s ):
    return "{}:{}:{}:{}".format( MduReqMsg.type_str[int(s.type_)], s.opaque, s.op_a, s.op_b )

class MduRespMsg( BitStructDefinition ):

  def __init__( s, nbits ):
    s.opaque = BitField( 3 ) # Hard-code at most 8 requesters
    s.result = BitField( nbits )

  def mk_msg( s, opq, res ):
    msg        = s()
    msg.opaque = opq
    msg.result = res
    return msg

  def __str__( s ):
    return "{}:{}".format( s.opaque, s.result )
