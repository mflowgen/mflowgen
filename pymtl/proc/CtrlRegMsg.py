#=========================================================================
# CtrlRegMsg
#=========================================================================
# Accelerator request and response messages.

from pymtl import *

#-------------------------------------------------------------------------
# CtrlRegReqMsg
#-------------------------------------------------------------------------
# Control register request messages can be to read or write a control
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
# Control register response messages come from both read and write
# requests. Read responses include the data read, while write responses
# do not include any data.
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

    if s.type_ == CtrlRegReqMsg.TYPE_READ:
      return "rd:{}".format( s.data )

    elif s.type_ == CtrlRegReqMsg.TYPE_WRITE:
      return "wr:{}".format( '        ' )

