#=========================================================================
# CtrlRegMsg
#=========================================================================
# Control register request and response messages

from pymtl import *

#-------------------------------------------------------------------------
# CtrlRegReqMsg
#-------------------------------------------------------------------------
# Control register request messages can either read or write a control
# register. Read requests include just the read address (register
# specifier). Write requests will include the write address and the data
# to write.
#
# Currently, we use a 4-bit address, so we support 16 control registers.
#
# Message Format:
#
#    1b     4b     32b
#  +------+------+------------+
#  | type | addr |   data     |
#  +------+------+------------+
#

class CtrlRegReqMsg( BitStructDefinition ):

  TYPE_READ  = 0
  TYPE_WRITE = 1

  ID_GO            = 0
  ID_DEBUG         = 1
  ID_MDU_HOSTEN    = 7
  ID_ICACHE_HOSTEN = 8
  ID_DCACHE_HOSTEN = 9

  def __init__( s ):
    s.type_ = BitField( 1  )
    s.addr  = BitField( 4  )
    s.data  = BitField( 32 )

  def __str__( s ):

    if s.type_ == CtrlRegReqMsg.TYPE_READ:
      return "rd:{}:{}".format( s.addr, '        ' )

    elif s.type_ == CtrlRegReqMsg.TYPE_WRITE:
      return "wr:{}:{}".format( s.addr, s.data )

#-------------------------------------------------------------------------
# CtrlRegRespMsg
#-------------------------------------------------------------------------
# Control register response messages can be either read or write
# responses. Read responses include the data that was read, while write
# responses do not include any data.
#
# Message Format:
#
#    1b     32b
#  +------+-----------+
#  | type | data      |
#  +------+-----------+
#

class CtrlRegRespMsg( BitStructDefinition ):

  TYPE_READ  = 0
  TYPE_WRITE = 1

  def __init__( s ):
    s.type_ = BitField( 1  )
    s.data  = BitField( 32 )

  def __str__( s ):

    if s.type_ == CtrlRegRespMsg.TYPE_READ:
      return "rd:{}".format( s.data )

    elif s.type_ == CtrlRegRespMsg.TYPE_WRITE:
      return "wr:{}".format( '        ' )

#-------------------------------------------------------------------------
# Common Messages
#-------------------------------------------------------------------------

class CtrlRegMsg( object ):
  def __init__( s ):
    s.req  = CtrlRegReqMsg ()
    s.resp = CtrlRegRespMsg()

