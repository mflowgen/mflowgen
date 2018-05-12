//========================================================================
// Verilog Components: Test Sink with Random Delays
//========================================================================

`ifndef VC_TEST_RAND_DELAY_SINK_V
`define VC_TEST_RAND_DELAY_SINK_V

`include "vc/vc-TestSink.v"
`include "vc/vc-TestRandDelay.v"
`include "vc/vc-trace.v"

module vc_TestRandDelaySink
#(
  parameter p_msg_nbits = 1,
  parameter p_num_msgs  = 1024
)(
  input  logic                   clk,
  input  logic                   reset,

  // Max delay input

  input  logic [31:0]            max_delay,

  // Sink message interface

  input  logic                   val,
  output logic                   rdy,
  input  logic [p_msg_nbits-1:0] msg,

  // Goes high once all sink data has been received

  output logic                   done,

  // Goes high if we recieved any wrong sink data

  output logic                   failed
);

  //----------------------------------------------------------------------
  // Test random delay
  //----------------------------------------------------------------------

  logic                   sink_val;
  logic                   sink_rdy;
  logic [p_msg_nbits-1:0] sink_msg;

  vc_TestRandDelay#(p_msg_nbits) rand_delay
  (
    .clk       (clk),
    .reset     (reset),

    .max_delay (max_delay),

    .in_val    (val),
    .in_rdy    (rdy),
    .in_msg    (msg),

    .out_val   (sink_val),
    .out_rdy   (sink_rdy),
    .out_msg   (sink_msg)
  );

  //----------------------------------------------------------------------
  // Test sink
  //----------------------------------------------------------------------

  vc_TestSink#(p_msg_nbits,p_num_msgs) sink
  (
    .clk        (clk),
    .reset      (reset),

    .val        (sink_val),
    .rdy        (sink_rdy),
    .msg        (sink_msg),

    .done       (done),

    .failed     (failed)
  );

  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  logic [`VC_TRACE_NBITS_TO_NCHARS(p_msg_nbits)*8-1:0] msg_str;

  `VC_TRACE_BEGIN
  begin
    $sformat( msg_str, "%x", msg );
    vc_trace.append_val_rdy_str( trace_str, val, rdy, msg_str );
  end
  `VC_TRACE_END

endmodule

`endif /* VC_TEST_RAND_DELAY_SINK */

