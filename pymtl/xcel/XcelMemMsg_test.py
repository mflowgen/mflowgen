#=========================================================================
# MemMsg_test
#=========================================================================
# Test suite for the memory messages

from pymtl      import *
from XcelMemMsg import XMemReqMsg, XMemRespMsg

#-------------------------------------------------------------------------
# test_req_fields
#-------------------------------------------------------------------------

def test_req_fields():

  # Create msg

  msg        = XMemReqMsg(8,16,40)
  msg.type_  = XMemReqMsg.TYPE_READ
  msg.opaque = 0x88
  msg.addr   = 0x1000
  msg.len    = 3

  # Verify msg

  assert msg.type_  == 0
  assert msg.opaque == 0x88
  assert msg.addr   == 0x1000
  assert msg.len    == 3

  # Create msg

  msg        = XMemReqMsg(8,16,40)
  msg.type_  = XMemReqMsg.TYPE_WRITE
  msg.opaque = 0x49
  msg.addr   = 0x2000
  msg.len    = 4
  msg.data   = 0xdeadbeef

  # Verify msg

  assert msg.type_  == 1
  assert msg.opaque == 0x49
  assert msg.addr   == 0x2000
  assert msg.len    == 4
  assert msg.data   == 0xdeadbeef

#-------------------------------------------------------------------------
# test_req_str
#-------------------------------------------------------------------------

def test_req_str():

  # Create msg

  msg        = XMemReqMsg(8,16,40)
  msg.type_  = XMemReqMsg.TYPE_READ
  msg.opaque = 0x88
  msg.addr   = 0x1000
  msg.len    = 3

  # Verify string

  assert str(msg) == "rd:88:1000:          "

  # Create msg

  msg        = XMemReqMsg(8,16,40)
  msg.type_  = XMemReqMsg.TYPE_WRITE
  msg.opaque = 0x49
  msg.addr   = 0x2000
  msg.len    = 4
  msg.data   = 0xdeadbeef

  # Verify string

  assert str(msg) == "wr:49:2000:00deadbeef"

#-------------------------------------------------------------------------
# test_resp_fields
#-------------------------------------------------------------------------

def test_resp_fields():

  # Create msg

  msg        = XMemRespMsg(8,40)
  msg.type_  = XMemRespMsg.TYPE_READ
  msg.opaque = 0x22
  msg.len    = 3
  msg.data   = 0x0000adbeef

  # Verify msg

  assert msg.type_  == 0
  assert msg.opaque == 0x22
  assert msg.len    == 3
  assert msg.data   == 0x0000adbeef

  # Create msg

  msg        = XMemRespMsg(8,40)
  msg.type_  = XMemRespMsg.TYPE_WRITE
  msg.opaque = 0x10
  msg.len    = 0
  msg.data   = 0

  # Verify msg

  assert msg.type_  == 1
  assert msg.opaque == 0x10
  assert msg.len    == 0
  assert msg.data   == 0

#-------------------------------------------------------------------------
# test_resp_str
#-------------------------------------------------------------------------

def test_resp_str():

  # Create msg

  msg        = XMemRespMsg(8,40)
  msg.type_  = XMemRespMsg.TYPE_READ
  msg.opaque = 0x22
  msg.len    = 3
  msg.data   = 0x0000adbeef

  # Verify string

  assert str(msg) == "rd:22:0000adbeef"

  # Create msg

  msg        = XMemRespMsg(8,40)
  msg.type_  = XMemRespMsg.TYPE_WRITE
  msg.opaque = 0x10
  msg.len    = 0
  msg.data   = 0

  # Verify string

  assert str(msg) == "wr:10:          "

