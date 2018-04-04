#=========================================================================
# XcelMemMsg
#=========================================================================
# Contains memory request and response messages.

from pymtl import *

import math

#-------------------------------------------------------------------------
# XMemReqMsg
#-------------------------------------------------------------------------
# Memory request messages can either be for a read or write. Read
# requests include an address and the number of bytes to read, while
# write requests include an address, the number of bytes to write, and
# the actual data to write.
#
# Message Format:
#
#    3b    opaque_nbits  addr_nbits    calc  data_nbits
#  +------+-------------+------------+------+------------+
#  | type | opaque      | addr       | len  | data       |
#  +------+-------------+------------+------+------------+
#
#    type:
#         0 = READ
#         1 = WRITE
#         2 = AMO_OR
#         3 = AMO_ADD
#         4 = AMO_AND
#         5 = AMO_XCHG
#         6 = AMO_MIN
#
# The message type is parameterized by the number of bits in the opaque
# field, address field, and data field. Note that the size of the length
# field is calculated from the number of bits in the data field, and
# that the length field is expressed in _bytes_. If the value of the
# length field is zero, then the read or write should be for the full
# width of the data field.
#
# For example, if the opaque field is 8 bits, the address is 32 bits and
# the data is also 32 bits, then the message format is as follows:
#
#   76  74 73     66 65    34 33  32 31    0
#  +------+---------+--------+------+-------+
#  | type | opaque  | addr   | len  | data  |
#  +------+---------+--------+------+-------+
#
# The length field is two bits. A length value of one means read or write
# a single byte, a length value of two means read or write two bytes, and
# so on. A length value of zero means read or write all four bytes. Note
# that not all memories will necessarily support any alignment and/or any
# value for the length field.
#
# The opaque field is reserved for use by a specific implementation. All
# memories should guarantee that every response includes the opaque
# field corresponding to the request that generated the response.

class XMemReqMsg( BitStructDefinition ):

  TYPE_READ     = 0
  TYPE_WRITE    = 1
  TYPE_AMO_OR   = 2
  TYPE_AMO_ADD  = 3
  TYPE_AMO_AND  = 4
  TYPE_AMO_XCHG = 5
  TYPE_AMO_MIN  = 6

  def __init__( s, opaque_nbits, addr_nbits, data_nbits ):

    s.type_nbits   = 3
    s.opaque_nbits = opaque_nbits
    s.addr_nbits   = addr_nbits
    s.len_nbits    = int( math.ceil( math.log( data_nbits/8, 2) ) )
    s.data_nbits   = data_nbits

    s.type_  = BitField( s.type_nbits   )
    s.opaque = BitField( s.opaque_nbits )
    s.addr   = BitField( s.addr_nbits   )
    s.len    = BitField( s.len_nbits    )
    s.data   = BitField( s.data_nbits   )

  def mk_msg( s, type_, opaque, addr, len_, data ):

    msg        = s()
    msg.type_  = type_
    msg.opaque = opaque
    msg.addr   = addr
    msg.len    = len_
    msg.data   = data

    return msg

  def mk_rd( s, opaque, addr, len_ ):

    msg        = s()
    msg.opaque = opaque
    msg.type_  = XMemReqMsg.TYPE_READ
    msg.addr   = addr
    msg.len    = len_
    msg.data   = 0

    return msg

  def mk_wr( s, opaque, addr, len_, data ):

    msg        = s()
    msg.opaque = opaque
    msg.type_  = XMemReqMsg.TYPE_WRITE
    msg.addr   = addr
    msg.len    = len_
    msg.data   = data

    return msg

  def unpck( s, msg ):
    req       = s()
    req.value = msg
    return req

  def __str__( s ):

    if s.type_ == XMemReqMsg.TYPE_READ:
      return "rd:{}:{}:{}".format( s.opaque, s.addr, ' '*(s.data.nbits/4) )

    elif s.type_ == XMemReqMsg.TYPE_WRITE:
      return "wr:{}:{}:{}".format( s.opaque, s.addr, s.data )

#-------------------------------------------------------------------------
# XMemRespMsg
#-------------------------------------------------------------------------
# Memory response messages can either be for a read or write. Read
# responses include the actual data and the number of bytes, while write
# responses currently include nothing other than the type.
#
# Message Format:
#
#    3b    opaque_nbits  calc   data_nbits
#  +------+-------------+------+-----------+
#  | type | opaque      | len  | data      |
#  +------+-------------+------+-----------+
#
# The message type is parameterized by the number of bits in the opaque
# field and data field. Note that the size of the length field is
# caclulated from the number of bits in the data field, and that the
# length field is expressed in _bytes_. If the value of the length field
# is zero, then the read or write should be for the full width of the
# data field.
#
# For example, if the opaque field is 8 bits and the data is 32 bits,
# then the message format is as follows:
#
#   44  42 41      34 33  32 31    0
#  +------+----------+------+-------+
#  | type | opaque   | len  | data  |
#  +------+----------+------+-------+
#
# The length field is two bits. A length value of one means one byte was
# read, a length value of two means two bytes were read, and so on. A
# length value of zero means all four bytes were read. Note that not all
# memories will necessarily support any alignment and/or any value for
# the length field.
#
# The opaque field is reserved for use by a specific implementation. All
# memories should guarantee that every response includes the opaque
# field corresponding to the request that generated the response.

class XMemRespMsg( BitStructDefinition ):

  TYPE_READ     = 0
  TYPE_WRITE    = 1
  TYPE_AMO_OR   = 2
  TYPE_AMO_ADD  = 3
  TYPE_AMO_AND  = 4
  TYPE_AMO_XCHG = 5
  TYPE_AMO_MIN  = 6

  def __init__( s, opaque_nbits, data_nbits ):

    s.type_nbits   = 3
    s.opaque_nbits = opaque_nbits
    s.len_nbits    = int( math.ceil( math.log( data_nbits/8, 2) ) )
    s.data_nbits   = data_nbits

    s.type_  = BitField( s.type_nbits   )
    s.opaque = BitField( s.opaque_nbits )
    s.len    = BitField( s.len_nbits    )
    s.data   = BitField( s.data_nbits   )

  def mk_msg( s, type_, opaque, len_, data ):

    msg        = s()
    msg.type_  = type_
    msg.opaque = opaque
    msg.len    = len_
    msg.data   = data

    return msg

  # What exactly is this method for? -cbatten

  def unpck( s, msg ):

    resp = s()
    resp.value = msg
    return resp

  def __str__( s ):

    if s.type_ == XMemRespMsg.TYPE_READ:
      return "rd:{}:{}".format( s.opaque, s.data )

    elif s.type_ == XMemRespMsg.TYPE_WRITE:
      return "wr:{}:{}".format( s.opaque, ' '*(s.data.nbits/4) )

#-------------------------------------------------------------------------
# XMemMsg
#-------------------------------------------------------------------------
# Single class that contains both the memory request and response types.
# This simplifies parameterizing models both both message types since (1)
# we can specifcy the address and data nbits in a single step, and (2) we
# can pass a single object into the parameterized model.

class XMemMsg( object ):
  def __init__( s, opaque_nbits, addr_nbits, data_nbits ):
    s.req  = XMemReqMsg ( opaque_nbits, addr_nbits, data_nbits )
    s.resp = XMemRespMsg( opaque_nbits, data_nbits             )
