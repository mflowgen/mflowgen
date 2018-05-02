//========================================================================
// Verilog Components: Test Memory with Random Delays
//========================================================================
// This is dual-ported test memory that handles a limited subset of
// memory request messages and returns memory response messages.

`ifndef VC_TEST_RAND_DELAY_MEM_2PORTS_V
`define VC_TEST_RAND_DELAY_MEM_2PORTS_V

`include "vc/vc-TestMemory_1i1d.v"
`include "vc/vc-TestRandDelay.v"
`include "vc/vc-trace.v"

module vc_TestRandDelayMemory_1i1d
#(
  parameter p_mem_nbytes = 1048576,
  parameter p_i_nbits = 256,
  parameter p_d_nbits = 32
)(
  input  logic                    clk,
  input  logic                    reset,

  // clears the content of memory

  input  logic                    clear,

  // maximum delay

  input  logic [31:0]             max_delay,

  //======================================================================
  // For core 0
  //======================================================================
  input  logic                        imemreq0_val,
  output logic                        imemreq0_rdy,
  input  [`REQ_NBITS(p_i_nbits)-1:0]  imemreq0_msg,
  output logic                        imemresp0_val,
  input  logic                        imemresp0_rdy,
  output [`RESP_NBITS(p_i_nbits)-1:0] imemresp0_msg,
  input  logic                        dmemreq0_val,
  output logic                        dmemreq0_rdy,
  input  [`REQ_NBITS(p_d_nbits)-1:0]  dmemreq0_msg,
  output logic                        dmemresp0_val,
  input  logic                        dmemresp0_rdy,
  output [`RESP_NBITS(p_d_nbits)-1:0] dmemresp0_msg
);

  //------------------------------------------------------------------------
  // Dual ported test memory
  //------------------------------------------------------------------------

  logic                              mem_imemreq0_val;
  logic                              mem_imemreq0_rdy;
  logic [`REQ_NBITS(p_i_nbits)-1:0]  mem_imemreq0_msg;
  logic                              mem_imemresp0_val;
  logic                              mem_imemresp0_rdy;
  logic [`RESP_NBITS(p_i_nbits)-1:0] mem_imemresp0_msg;
  logic                              mem_dmemreq0_val;
  logic                              mem_dmemreq0_rdy;
  logic [`REQ_NBITS(p_d_nbits)-1:0]  mem_dmemreq0_msg;
  logic                              mem_dmemresp0_val;
  logic                              mem_dmemresp0_rdy;
  logic [`RESP_NBITS(p_d_nbits)-1:0] mem_dmemresp0_msg;

  //------------------------------------------------------------------------
  // Test random delay
  //------------------------------------------------------------------------

  vc_TestRandDelay#(`REQ_NBITS(p_i_nbits)) rand_req_delay_i
  (
    .clk       (clk),
    .reset     (reset),

    // dividing the max delay by two because we have delay for both in and
    // out
    .max_delay (max_delay >> 1),

    .in_val    (imemreq0_val),
    .in_rdy    (imemreq0_rdy),
    .in_msg    (imemreq0_msg),

    .out_val   (mem_imemreq0_val),
    .out_rdy   (mem_imemreq0_rdy),
    .out_msg   (mem_imemreq0_msg)

  );

  vc_TestRandDelay#(`REQ_NBITS(p_d_nbits)) rand_req_delay_d
  (
    .clk       (clk),
    .reset     (reset),

    // dividing the max delay by two because we have delay for both in and
    // out
    .max_delay (max_delay >> 1),

    .in_val    (dmemreq0_val),
    .in_rdy    (dmemreq0_rdy),
    .in_msg    (dmemreq0_msg),

    .out_val   (mem_dmemreq0_val),
    .out_rdy   (mem_dmemreq0_rdy),
    .out_msg   (mem_dmemreq0_msg)

   );

  vc_TestMemory_1i1d
  #(
    .p_mem_nbytes (p_mem_nbytes),
    .p_i_nbits    (p_i_nbits),
    .p_d_nbits    (p_d_nbits)
  )
  mem
  (
    .clk          (clk),
    .reset        (reset),
    .clear        (clear),

    .imemreq0_val  (mem_imemreq0_val),
    .imemreq0_rdy  (mem_imemreq0_rdy),
    .imemreq0_msg  (mem_imemreq0_msg),
    .imemresp0_val (mem_imemresp0_val),
    .imemresp0_rdy (mem_imemresp0_rdy),
    .imemresp0_msg (mem_imemresp0_msg),

    .dmemreq0_val  (mem_dmemreq0_val),
    .dmemreq0_rdy  (mem_dmemreq0_rdy),
    .dmemreq0_msg  (mem_dmemreq0_msg),
    .dmemresp0_val (mem_dmemresp0_val),
    .dmemresp0_rdy (mem_dmemresp0_rdy),
    .dmemresp0_msg (mem_dmemresp0_msg)
  );

  //------------------------------------------------------------------------
  // Test random delay
  //------------------------------------------------------------------------

  vc_TestRandDelay#(`RESP_NBITS(p_i_nbits)) rand_resp_delay_i
  (
    .clk       (clk),
    .reset     (reset),

    // dividing the max delay by two because we have delay for both in and
    // out
    .max_delay (max_delay >> 1),

    .in_val    (mem_imemresp0_val),
    .in_rdy    (mem_imemresp0_rdy),
    .in_msg    (mem_imemresp0_msg),

    .out_val   (imemresp0_val),
    .out_rdy   (imemresp0_rdy),
    .out_msg   (imemresp0_msg)
  );

  vc_TestRandDelay#(`RESP_NBITS(p_d_nbits)) rand_resp_delay_d
  (
    .clk       (clk),
    .reset     (reset),

    // dividing the max delay by two because we have delay for both in and
    // out
    .max_delay (max_delay >> 1),

    .in_val    (mem_dmemresp0_val),
    .in_rdy    (mem_dmemresp0_rdy),
    .in_msg    (mem_dmemresp0_msg),

    .out_val   (dmemresp0_val),
    .out_rdy   (dmemresp0_rdy),
    .out_msg   (dmemresp0_msg)
  );

endmodule

`endif /* VC_TEST_RAND_DELAY_MEM_2PORTS_V */

