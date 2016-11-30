#=========================================================================
# XcelMsg
#=========================================================================
# Accelerator request and response messages.

from pymtl import *

#-------------------------------------------------------------------------
# XcelReqMsg
#-------------------------------------------------------------------------
# Accelerator request messages can either be to read or write an
# accelerator register. Read requests include just a register specifier,
# while write requests include an accelerator register specifier and the
# actual data to write to the accelerator register.
#
# Message Format:
#
#    1b     5b      32b
#  +------+-------+-----------+
#  | type | raddr | data      |
#  +------+-------+-----------+
#

class XcelReqMsg( BitStructDefinition ):

  TYPE_READ  = 0
  TYPE_WRITE = 1

  def __init__( s ):
    s.type_ = BitField( 1  )
    s.raddr = BitField( 5  )
    s.data  = BitField( 32 )

  def __str__( s ):

    if s.type_ == XcelReqMsg.TYPE_READ:
      return "rd:{}:{}".format( s.raddr, '        ' )

    elif s.type_ == XcelReqMsg.TYPE_WRITE:
      return "wr:{}:{}".format( s.raddr, s.data )

#-------------------------------------------------------------------------
# XcelRespMsg
#-------------------------------------------------------------------------
# Accelerator response messages can either be from a read or write of an
# accelerator register. Read requests include the actual value read from
# the accelerator register, while write requests currently include
# nothing other than the type.
#
# Message Format:
#
#    1b     32b
#  +------+-----------+
#  | type | data      |
#  +------+-----------+
#

class XcelRespMsg( BitStructDefinition ):

  TYPE_READ  = 0
  TYPE_WRITE = 1

  def __init__( s ):
    s.type_ = BitField( 1  )
    s.data  = BitField( 32 )

  def __str__( s ):

    if s.type_ == XcelReqMsg.TYPE_READ:
      return "rd:{}".format( s.data )

    elif s.type_ == XcelReqMsg.TYPE_WRITE:
      return "wr:{}".format( '        ' )

