//========================================================================
// Verilog Components: Test Source
//========================================================================

`ifndef VC_TEST_SOURCE_V
`define VC_TEST_SOURCE_V

`include "vc/vc-regs.v"
`include "vc/vc-trace.v"

module vc_TestSource
#(
  parameter p_msg_nbits = 1,
  parameter p_num_msgs  = 1024
)(
  input  logic                   clk,
  input  logic                   reset,

  // Source message interface

  output logic                   val,
  input  logic                   rdy,
  output logic [p_msg_nbits-1:0] msg,

  // Goes high once all source msgs has been issued

  output logic                   done
);

  //----------------------------------------------------------------------
  // Local parameters
  //----------------------------------------------------------------------

  // Size of a physical address for the memory in bits

  localparam c_index_nbits = $clog2(p_num_msgs);

  //----------------------------------------------------------------------
  // State
  //----------------------------------------------------------------------

  // Memory which stores messages to send

  logic [p_msg_nbits-1:0] m[p_num_msgs-1:0];

  // Index register pointing to next message to send

  logic                     index_en;
  logic [c_index_nbits-1:0] index_next;
  logic [c_index_nbits-1:0] index;

  vc_EnResetReg#(c_index_nbits,{c_index_nbits{1'b0}}) index_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (index_en),
    .d     (index_next),
    .q     (index)
  );

  // Register reset

  logic reset_reg;
  always @( posedge clk )
    reset_reg <= reset;

  //----------------------------------------------------------------------
  // Combinational logic
  //----------------------------------------------------------------------

  // We use a behavioral hack to easily detect when we have sent all the
  // valid messages in the test source. We used to use this:
  //
  //  assign done = !reset_reg && ( m[index] === {p_msg_nbits{1'bx}} );
  //
  // but Ackerley Tng found an issue with this approach. You can see an
  // example in this journal post:
  //
  //  http://brg.csl.cornell.edu/wiki/alt53-2014-03-08
  //
  // So now we keep the done signal high until the test source is reset.

  always @ ( * ) begin
    if ( reset_reg ) begin
      done <= 1'b0;
    end else begin
      if ( ~done ) begin
        done <= m[index] === {p_msg_nbits{1'bx}};
      end
    end
  end

  // Set the source message appropriately

  assign msg = m[index];

  // Source message interface is valid as long as we are not done

  assign val = !reset_reg && !done;

  // The go signal is high when a message is transferred

  logic go;
  assign go = val && rdy;

  // We bump the index pointer every time we successfully send a message,
  // otherwise the index stays the same.

  assign index_en   = go;
  assign index_next = index + 1'b1;

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

`endif /* VC_TEST_SOURCE_V */

