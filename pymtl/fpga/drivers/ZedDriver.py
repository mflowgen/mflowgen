#========================================================================
# ZedDriver.py
#========================================================================
# Top-level module for the ARM core talk to device

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.cl   import InValRdyQueueAdapter, OutValRdyQueueAdapter

from ifcs       import InReqAckBundle, OutReqAckBundle
from adapters   import *

import os, time, Queue, struct

# Hard-coded: read/write streams

xillybus_read  = '/dev/xillybus_read_32'
xillybus_write = '/dev/xillybus_write_32'

class ZedDriver( Model ):

  # Constructor

  def __init__( s ):

    # Interface

    s.in_        = InReqAckBundle  ( 32 )
    s.out        = OutReqAckBundle ( 32 )

    # Asynch Adapters

    s.reqAckToValRdy = m = ReqAckToValRdy( 32 )
    s.connect( m.in_, s.in_ )

    s.valRdyToReqAck = m = ValRdyToReqAck( 32 )
    s.connect( m.out, s.out )

    # Adapters

    s.req_q  = InValRdyQueueAdapter  ( s.reqAckToValRdy.out )
    s.resp_q = OutValRdyQueueAdapter ( s.valRdyToReqAck.in_ )

    # Driver Class for handling communication

    s.driver     = Driver()
    s.driver.open_device()

    s.trace = "--         "

    @s.tick_rtl
    def logic():
      s.req_q.xtick()
      s.resp_q.xtick()

      # read from device
      if s.driver.device_is_opened() and not s.resp_q.full():
          int_data = s.driver.xbus_read()
          if not int_data == None:
            s.trace = "RD {0:08X}".format( int( int_data ) )
            s.resp_q.enq( int_data )

      # write to device
      if s.driver.device_is_opened() and not s.req_q.empty():
          s.req_msg = s.req_q.deq()
          s.trace = "WR {0:08X}".format( s.req_msg.int() )
          s.driver.xbus_write( s.req_msg)

#----FIXME: have to find out a better way to do this--------
  def close( s ):
    print "closing device"
    s.driver.close_device()

  def line_trace( s ):
    trace = s.trace
    s.trace = "--         "
    return trace



class Driver:

  def __init__( s ):
    s.device_opened = False

    s.fd_recv = None
    s.fd_send = None

  def device_is_opened( s ):
    return s.device_opened

  #--Open Xillybus--------------------------------------------------------
  def open_device( s ):

    if not s.device_opened:

      # open xillybus read port
      while s.fd_recv == None:
        try:
          s.fd_recv = os.open( xillybus_read, os.O_RDONLY|os.O_NONBLOCK )
        except OSError as e:
          print "OpenRD: OSError({0}): {1}".format( e.errno, e.strerror )
          time.sleep( 5 )

      # open xillybus write port
      while s.fd_send == None:
        try:
          s.fd_send = os.open( xillybus_write, os.O_WRONLY )
        except OSError as e:
          print "OpenWR: OSError({0}): {1}".format( e.errno, e.strerror )
          time.sleep( 5 )

      s.device_opened = True
      print "xillybus read/write ports opened"

    else:
      print "xillybus read/write ports already open"

  #--Close Xillybus-------------------------------------------------------
  def close_device( s ):

    if s.fd_recv:
      os.close(s.fd_recv)
      s.fd_recv = None
    if s.fd_send:
      os.close(s.fd_send)
      s.fd_send = None

    s.device_opened = False
    print "xillybus read/write ports closed"

  #--Xillybus Read--------------------------------------------------------
  def xbus_read( s ):
      if s.fd_recv != None:
        try:
          resp_msg = os.read( s.fd_recv, 4 )
        except OSError as e:
          #print "RD: OSError({0}): {1}".format( e.errno, e.strerror )
          pass
        else:
          int_data = struct.unpack('<I', resp_msg)
          return int_data[0]
      return None

  #--Xillybus Write-------------------------------------------------------
  def xbus_write( s, msg ):
      if s.fd_send != None:
        bArray = bytearray( 4 )
        bArray[0] = msg >>  0 & 0xFF
        bArray[1] = msg >>  8 & 0xFF
        bArray[2] = msg >> 16 & 0xFF
        bArray[3] = msg >> 24 & 0xFF

        try:
          os.write( s.fd_send, bArray )
        except OSError as e:
          pass
          #print "WR: OSError({0}): {1}".format( e.errno, e.strerror )
