//========================================================================
// XcelMsg : Accelerator message type
//========================================================================

`ifndef PROC_XCEL_MSG_V
`define PROC_XCEL_MSG_V

`include "vc/trace.v"

//-------------------------------------------------------------------------
// XcelReqMsg
//-------------------------------------------------------------------------
// Accelerator request messages can either be to read or write an
// accelerator register. Read requests include just a register specifier,
// while write requests include an accelerator register specifier and the
// actual data to write to the accelerator register.
//
// Message Format:
//
//    1b     5b      32b
//  +------+-------+-----------+
//  | type | raddr | data      |
//  +------+-------+-----------+
//

typedef struct packed {
  logic [0:0]  type_;
  logic [4:0]  raddr;
  logic [31:0] data;
} XcelReqMsg;

// xcel request type values
`define XcelReqMsg_TYPE_READ     1'd0
`define XcelReqMsg_TYPE_WRITE    1'd1

//-------------------------------------------------------------------------
// XcelRespMsg
//-------------------------------------------------------------------------
// Accelerator response messages can either be from a read or write of an
// accelerator register. Read requests include the actual value read from
// the accelerator register, while write requests currently include
// nothing other than the type.
//
// Message Format:
//
//    1b     32b
//  +------+-----------+
//  | type | data      |
//  +------+-----------+
//
typedef struct packed {
  logic [0:0]  type_;
  logic [31:0] data;
} XcelRespMsg;

`define XcelRespMsg_TYPE_READ     1'd0
`define XcelRespMsg_TYPE_WRITE    1'd1

`endif /* PROC_XCEL_MSG_V */

