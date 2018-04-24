#=========================================================================
# CtrlRegMsg_test
#=========================================================================
# Test suite for control register request and response messages

from pymtl      import *
from CtrlRegMsg import CtrlRegReqMsg, CtrlRegRespMsg

#-------------------------------------------------------------------------
# test_req_fields
#-------------------------------------------------------------------------

def test_req_fields():

  # Create msg

  msg = CtrlRegReqMsg()
  msg.type_ = CtrlRegReqMsg.TYPE_READ
  msg.addr  = 15

  # Verify msg

  assert msg.type_ == 0
  assert msg.addr  == 15

  # Create msg

  msg = CtrlRegReqMsg()
  msg.type_ = CtrlRegReqMsg.TYPE_WRITE
  msg.addr  = 13
  msg.data  = 0xdeadbeef

  # Verify msg

  assert msg.type_ == 1
  assert msg.addr  == 13
  assert msg.data  == 0xdeadbeef

#-------------------------------------------------------------------------
# test_req_str
#-------------------------------------------------------------------------

def test_req_str():

  # Create msg

  msg = CtrlRegReqMsg()
  msg.type_ = CtrlRegReqMsg.TYPE_READ
  msg.addr  = 15

  # Verify string

  assert str(msg) == "rd:f:        "

  # Create msg

  msg = CtrlRegReqMsg()
  msg.type_ = CtrlRegReqMsg.TYPE_WRITE
  msg.addr  = 13
  msg.data  = 0xdeadbeef

  # Verify string

  assert str(msg) == "wr:d:deadbeef"

#-------------------------------------------------------------------------
# test_resp_fields
#-------------------------------------------------------------------------

def test_resp_fields():

  # Create msg

  msg = CtrlRegRespMsg()
  msg.type_ = CtrlRegRespMsg.TYPE_READ
  msg.data  = 0xcafecafe

  # Verify msg

  assert msg.type_ == 0
  assert msg.data  == 0xcafecafe

  # Create msg

  msg = CtrlRegRespMsg()
  msg.type_ = CtrlRegRespMsg.TYPE_WRITE
  msg.data  = 0

  # Verify msg

  assert msg.type_ == 1
  assert msg.data  == 0

#-------------------------------------------------------------------------
# test_resp_str
#-------------------------------------------------------------------------

def test_resp_str():

  # Create msg

  msg = CtrlRegRespMsg()
  msg.type_ = CtrlRegRespMsg.TYPE_READ
  msg.data  = 0xcafecafe

  # Verify string

  assert str(msg) == "rd:cafecafe"

  # Create msg

  msg = CtrlRegRespMsg()
  msg.type_ = CtrlRegRespMsg.TYPE_WRITE
  msg.data  = 0

  assert str(msg) == "wr:        "

