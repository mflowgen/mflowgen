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
# actual data to write to the accelerator register. It aslo contains the
# acceleraor id
#
# Message Format:
#
#    8b       1b     5b      32b         11b
#  +--------+------+-------+-----------+-----------+
#  | opaque | type | raddr | data      | accel-id  |
#  +--------+------+-------+-----------+-----------+
#

class XcelReqMsg( BitStructDefinition ):

  TYPE_READ  = 0
  TYPE_WRITE = 1

  def __init__( s ):
    s.opaque = BitField( 8  )
    s.type_  = BitField( 1  )
    s.raddr  = BitField( 5  )
    s.data   = BitField( 32 )
    s.id     = BitField( 11 )

  def mk_msg( s, opaque, type_, raddr, data, id ):

    msg = s()
    msg.opaque = opaque
    msg.type_  = type_
    msg.raddr  = raddr
    msg.data   = data
    msg.id     = id

    return msg

  def __str__( s ):

    if s.type_ == XcelReqMsg.TYPE_READ:
      return "{}:rd:{}:{}:{}".format( s.opaque, s.raddr, '        ', s.id )

    elif s.type_ == XcelReqMsg.TYPE_WRITE:
      return "{}:wr:{}:{}:{}".format( s.opaque, s.raddr, s.data, s.id )

#-------------------------------------------------------------------------
# XcelRespMsg
#-------------------------------------------------------------------------
# Accelerator response messages can either be from a read or write of an
# accelerator register. Read requests include the actual value read from
# the accelerator register, while write requests currently include
# nothing other than the type. It also contains the accelerator id.
#
# Message Format:
#
#    8b       1b     32b         11b
#  +--------+------+-----------+-----------+
#  | opaque | type | data      | accel-id  |
#  +--------+------+-----------+-----------+
#

class XcelRespMsg( BitStructDefinition ):

  TYPE_READ  = 0
  TYPE_WRITE = 1

  def __init__( s ):
    s.opaque = BitField( 8  )
    s.type_  = BitField( 1  )
    s.data   = BitField( 32 )
    s.id     = BitField( 11 )

  def mk_msg( s, opaque, type_, data, id ):

    msg = s()
    msg.opaque = opaque
    msg.type_  = type_
    msg.data   = data
    msg.id     = id

    return msg

  def __str__( s ):

    if s.type_ == XcelReqMsg.TYPE_READ:
      return "{}:rd:{}:{}".format( s.opaque, s.data, s.id )

    elif s.type_ == XcelReqMsg.TYPE_WRITE:
      return "{}:wr:{}:{}".format( s.opaque, '        ', s.id )

#-------------------------------------------------------------------------
# XcelMsg
#-------------------------------------------------------------------------

class XcelMsg( object ):
  def __init__( s ):
    s.req  = XcelReqMsg()
    s.resp = XcelRespMsg()
