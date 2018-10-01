#=========================================================================
# GcdUnitMsg
#=========================================================================

from pymtl import *

#-------------------------------------------------------------------------
# GcdUnitReqMsg
#-------------------------------------------------------------------------
# BitStruct designed to hold two operands for a multiply

class GcdUnitReqMsg( BitStructDefinition ):

  def __init__( s ):
    s.a = BitField(16)
    s.b = BitField(16)

  def mk_msg( s, a, b ):
    msg   = s()
    msg.a = a
    msg.b = b
    return msg

  def __str__( s ):
    return "{}:{}".format( s.a, s.b )

