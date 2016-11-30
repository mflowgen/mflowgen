#=========================================================================
# XcelMsg_test.py
#=========================================================================
# Test suite for accelerator request and response messages.

from pymtl   import *
from XcelMsg import XcelReqMsg, XcelRespMsg

#-------------------------------------------------------------------------
# test_req_fields
#-------------------------------------------------------------------------

def test_req_fields():

  # Create msg

  msg = XcelReqMsg()
  msg.opaque = 143
  msg.type_  = XcelReqMsg.TYPE_READ
  msg.raddr  = 15
  msg.id     = 20

  # Verify msg

  assert msg.opaque == 143
  assert msg.type_  == 0
  assert msg.raddr  == 15
  assert msg.id     == 20

  # Create msg

  msg = XcelReqMsg()
  msg.opaque = 255
  msg.type_  = XcelReqMsg.TYPE_WRITE
  msg.raddr  = 13
  msg.data   = 0xdeadbeef
  msg.id     = 31

  # Verify msg

  assert msg.opaque == 255
  assert msg.type_  == 1
  assert msg.raddr  == 13
  assert msg.data   == 0xdeadbeef
  assert msg.id     == 31

#-------------------------------------------------------------------------
# test_req_str
#-------------------------------------------------------------------------

def test_req_str():

  # Create msg

  msg = XcelReqMsg()
  msg.opaque = 22
  msg.type_  = XcelReqMsg.TYPE_READ
  msg.raddr  = 15
  msg.id     = 8

  # Verify string

  assert str(msg) == "16:rd:0f:        :008"

  # Create msg

  msg = XcelReqMsg()
  msg.opaque = 1
  msg.type_  = XcelReqMsg.TYPE_WRITE
  msg.raddr  = 13
  msg.data   = 0xdeadbeef
  msg.id     = 4

  # Verify string

  assert str(msg) == "01:wr:0d:deadbeef:004"

#-------------------------------------------------------------------------
# test_resp_fields
#-------------------------------------------------------------------------

def test_resp_fields():

  # Create msg

  msg = XcelRespMsg()
  msg.opaque = 12
  msg.type_  = XcelRespMsg.TYPE_READ
  msg.data   = 0xcafecafe
  msg.id     = 15

  # Verify msg

  assert msg.opaque == 12
  assert msg.type_  == 0
  assert msg.data   == 0xcafecafe
  assert msg.id     == 15

  # Create msg

  msg = XcelRespMsg()
  msg.opaque = 255
  msg.type_  = XcelRespMsg.TYPE_WRITE
  msg.data   = 0
  msg.id     = 1

  # Verify msg

  assert msg.opaque == 255
  assert msg.type_  == 1
  assert msg.data   == 0
  assert msg.id     == 1

#-------------------------------------------------------------------------
# test_resp_str
#-------------------------------------------------------------------------

def test_resp_str():

  # Create msg

  msg = XcelRespMsg()
  msg.opaque = 53
  msg.type_  = XcelRespMsg.TYPE_READ
  msg.data   = 0xcafecafe
  msg.id     = 2

  # Verify string

  assert str(msg) == "35:rd:cafecafe:002"

  # Create msg

  msg = XcelRespMsg()
  msg.opaque = 209
  msg.type_  = XcelRespMsg.TYPE_WRITE
  msg.data   = 0
  msg.id     = 3

  assert str(msg) == "d1:wr:        :003"

