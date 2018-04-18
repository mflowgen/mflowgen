#========================================================================
# driver.py
#========================================================================
# Python script to test ARM-FPGA communication

import os, time, binascii, Queue, struct

xillybus_read  = '/dev/xillybus_read_32'
xillybus_write = '/dev/xillybus_write_32'

class fpga_driver:

  def __init__( s ):
    s.device_opened = False

    s.fd_recv = None
    s.fd_send = None

  #--Open Xillybus--------------------------------------------------------
  def open_device( s ):

    # open xillybus read port
    while s.fd_recv == None:
      try:
        s.fd_recv = os.open( xillybus_read, os.O_RDONLY|os.O_NONBLOCK )
      except OSError as e:
        print "OSError({0}): {1}".format( e.errno, e.strerror )
        time.sleep( 5 )

    # open xillybus write port
    while s.fd_send == None:
      try:
        s.fd_send = os.open( xillybus_write, os.O_WRONLY )
      except OSError as e:
        print "OSError({0}): {1}".format( e.errno, e.strerror )
        time.sleep( 5 )

    print "xillybus read/write ports opened"

  #--Close Xillybus-------------------------------------------------------
  def close_device( s ):

    if s.fd_recv:
      os.close(s.fd_recv)
      s.fd_recv = None
    if s.fd_send:
      os.close(s.fd_send)
      s.fd_send = None


    print "xillybus read/write ports closed"

  #--Xillybus Read--------------------------------------------------------
  def xbus_read( s ):
      if s.fd_recv != None:
        try:
          resp_msg = os.read( s.fd_recv, 4 )
        except OSError as e:
          print "RD1-OSError({0}): {1}".format( e.errno, e.strerror )
        else:
          #hex_data = binascii.hexlify( resp_msg[:4] )
          #int_data = int( hex_data, 16 )
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
          print "WR-OSError({0}): {1}".format( e.errno, e.strerror )
