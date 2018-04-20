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

  def __init__( s, nbits, ntypes ):
    s.typ = BitField( clog2(ntypes) )
    s.opa = BitField( nbits )
    s.opb = BitField( nbits )

  def mk_msg( s, typ, a, b ):
    msg     = s()
    msg.typ = typ
    msg.opa = a
    msg.opb = b
    return msg

  def __str__( s ):
    return "[{}]{}:{}".format( s.typ, s.opa, s.opb )
