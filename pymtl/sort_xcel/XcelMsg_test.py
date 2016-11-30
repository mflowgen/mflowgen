#=========================================================================
# XcelMsg_test
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
  msg.type_ = XcelReqMsg.TYPE_READ
  msg.raddr = 15

  # Verify msg

  assert msg.type_ == 0
  assert msg.raddr == 15

  # Create msg

  msg = XcelReqMsg()
  msg.type_ = XcelReqMsg.TYPE_WRITE
  msg.raddr = 13
  msg.data  = 0xdeadbeef

  # Verify msg

  assert msg.type_ == 1
  assert msg.raddr == 13
  assert msg.data  == 0xdeadbeef

#-------------------------------------------------------------------------
# test_req_str
#-------------------------------------------------------------------------

def test_req_str():

  # Create msg

  msg = XcelReqMsg()
  msg.type_ = XcelReqMsg.TYPE_READ
  msg.raddr = 15

  # Verify string

  assert str(msg) == "rd:0f:        "

  # Create msg

  msg = XcelReqMsg()
  msg.type_ = XcelReqMsg.TYPE_WRITE
  msg.raddr = 13
  msg.data  = 0xdeadbeef

  # Verify string

  assert str(msg) == "wr:0d:deadbeef"

#-------------------------------------------------------------------------
# test_resp_fields
#-------------------------------------------------------------------------

def test_resp_fields():

  # Create msg

  msg = XcelRespMsg()
  msg.type_ = XcelRespMsg.TYPE_READ
  msg.data  = 0xcafecafe

  # Verify msg

  assert msg.type_ == 0
  assert msg.data  == 0xcafecafe

  # Create msg

  msg = XcelRespMsg()
  msg.type_ = XcelRespMsg.TYPE_WRITE
  msg.data  = 0

  # Verify msg

  assert msg.type_ == 1
  assert msg.data  == 0

#-------------------------------------------------------------------------
# test_resp_str
#-------------------------------------------------------------------------

def test_resp_str():

  # Create msg

  msg = XcelRespMsg()
  msg.type_ = XcelRespMsg.TYPE_READ
  msg.data  = 0xcafecafe

  # Verify string

  assert str(msg) == "rd:cafecafe"

  # Create msg

  msg = XcelRespMsg()
  msg.type_ = XcelRespMsg.TYPE_WRITE
  msg.data  = 0

  assert str(msg) == "wr:        "

