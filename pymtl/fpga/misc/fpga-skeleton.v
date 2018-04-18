//========================================================================
// ex-gcd-fpga-design.v
//========================================================================
// Top-level module for the design that would be synthesized on the fpga
// Asha: Commented out the debug scope section

`include "fpga-xfifo.v"
`include "fpga-valrdy-xfifo-adapters.v"
`include "ex-gcd-GcdUnit.v"
`include "vc-ClockDivider.v"
`include "vc-sync.v"
`include "vc-ValRdyToAsynchReqAckAdapter.v"
`include "vc-AsynchReqAckToValRdyAdapter.v"

module fpga_design
(
  // CLK/RST

  input         clk,
  input         reset,

  // Input Data

  input         xillybus_write_wren,
  input  [31:0] xillybus_write_data,
  output        xillybus_write_full,

  // Output Data

  input         xillybus_read_rden,
  output        xillybus_read_valid,
  output        xillybus_read_empty,
  output [31:0] xillybus_read_data,

  // Scope ports

  output        divided_clk,          // Divided clock
  output        sync_reset,           // Reset sync to slow clock
  output        dut_read_rden,        // RD_EN of input XFIFO
  output        dut_write_wren,       // WR_EN of output XFIFO
  output        dut_in_val,           // val for msg from ARM core to DUT
  output        dut_in_rdy,           // rdy for msg from ARM core to DUT
  output        dut_out_val,          // val for msg from DUT to ARM core
  output        dut_out_rdy           // rdy for msg from DUT to ARM core

);

  //----------------------------------------------------------------------
  // wire declarations
  //----------------------------------------------------------------------

  // input-xfifo <-> xfifo2valrdy-deq-adapter

  wire        dut_read_valid;
  wire [31:0] dut_read_data;

  // xfifo2valrdy-deq-adapter <-> dut

  wire [31:0] dut_in_data;

  // dut <-> valrdy2xfifo-enq-adapter

  wire [31:0] dut_out_data;

  // valrdy2xfifo-enq-adapter <-> out-xfifo

  wire        dut_write_full;
  wire [31:0] dut_write_data;


  // Section to be un-commented if they are removed from scope ports

  //  wire        divided_clk;
  //  wire        sync_reset;
  //  wire        dut_read_rden;
  //  wire        dut_in_val;
  //  wire        dut_in_rdy;
  //  wire        dut_out_val;
  //  wire        dut_out_rdy;
  //  wire        dut_write_wren;

  //----------------------------------------------------------------------
  // Clock Divider and Reset synchronizer
  //----------------------------------------------------------------------

  vc_ClockDivider#( .divisor (4) ) clock_divider
  (
    .reset      (1'b0),
    .input_clk  (clk),
    .output_clk (divided_clk) // 25 MHz clock
  );

  // Reset synchronizer - Setting reset value of reg to 1 to avoid
  // VC_ASSERT issues.
  // Reference - http://www.xilinx.com/itp/xilinx10/books/docs/qst/qst.pdf

  vc_sync#( 1,1 ) reset_sync
  (
    .clk    (divided_clk),
    .reset  (1'b0),
    .in     (reset),
    .out    (sync_reset)
  );

  //----------------------------------------------------------------------
  // input FIFO
  //----------------------------------------------------------------------

  fpga_xfifo
  #(
    .DATA_SZ(32),
    .ENTRIES(4)
  )
  input_xfifo
  (
   .clk   (clk),
   .srst  (reset),

   .din   (xillybus_write_data),
   .wr_en (xillybus_write_wren),
   .full  (xillybus_write_full),
  
   .rd_en (dut_read_rden),
   .dout  (dut_read_data),
   .valid (dut_read_valid)
  );

  //----------------------------------------------------------------------
  // Dequeue to ValRdy 
  //----------------------------------------------------------------------

  wire [31:0] xfifo_deq_out_data;
  wire        xfifo_deq_out_val;
  wire        xfifo_deq_out_rdy;

  xfifo2valrdy_deq#(32) xfifo2valrdy_deq_adapter
  (
    .clk   (clk),
    .reset (reset),

    .valid (dut_read_valid),
    .dout  (dut_read_data),
    .rd_en (dut_read_rden),

    .val   (xfifo_deq_out_val),
    .rdy   (xfifo_deq_out_rdy),
    .data  (xfifo_deq_out_data)
  );

  //----------------------------------------------------------------------
  // Asynch ValRdy to ReqAck
  //----------------------------------------------------------------------
  
  wire [31:0] dut_in_asynch_msg;
  wire        dut_in_asynch_req;
  wire        dut_in_asynch_ack;
  wire        dut_in_asynch_ack_sync;
 
  vc_ValRdyToAsynchReqAckAdapter
  #(
    .message_size(32),
    .send_delay  (1)
  )
  dut_in_valrdy_to_asynch
  (
    .clk      (clk),
    .reset    (reset),

    .in_val   (xfifo_deq_out_val),
    .in_msg   (xfifo_deq_out_data),
    .in_rdy   (xfifo_deq_out_rdy),

    .out_req  (dut_in_asynch_req),
    .out_msg  (dut_in_asynch_msg),
    .out_ack  (dut_in_asynch_ack_sync)
  );

  vc_sync input_ack_sync
  (
    .clk   (clk),
    .reset (reset),
    .in    (dut_in_asynch_ack),
    .out   (dut_in_asynch_ack_sync)
  );

  //----------------------------------------------------------------------
  // Device Under Test
  //----------------------------------------------------------------------

  wire [31:0] dut_out_asynch_msg;
  wire        dut_out_asynch_req;
  wire        dut_out_asynch_ack;

  FpgaDut u0 //FIXME message size 32
  (
    .clk      (divided_clk),
    .reset    (sync_reset),

    .in__req  (dut_in_asynch_req),
    .in__msg  (dut_in_asynch_msg),
    .in__ack  (dut_in_asynch_ack),

    .out_req  (dut_out_asynch_req),
    .out_msg  (dut_out_asynch_msg),
    .out_ack  (dut_out_asynch_ack)
  );

  //----------------------------------------------------------------------
  // Asynch ValRdy to ReqAck
  //----------------------------------------------------------------------
     
  wire        dut_out_asynch_req_sync;

  wire [31:0] xfifo_enq_in_data;
  wire        xfifo_enq_in_val;
  wire        xfifo_enq_in_rdy;
 
  vc_sync output_req_sync
  (
    .clk   (clk),
    .reset (reset),
    .in    (dut_out_asynch_req),
    .out   (dut_out_asynch_req_sync)
  );

 vc_AsynchReqAckToValRdyAdapter
 #(
    .message_size(32)
  )
  dut_out_asynch_to_valrdy
  (
    .clk      (clk),
    .reset    (reset),

    .in_req   (dut_out_asynch_req),
    .in_msg   (dut_out_asynch_msg),
    .in_ack   (dut_out_asynch_ack),

    .out_val  (xfifo_enq_in_val),
    .out_msg  (xfifo_enq_in_data),
    .out_rdy  (xfifo_enq_in_rdy)
  );

  //----------------------------------------------------------------------
  // ValRdy to Enqueue 
  //----------------------------------------------------------------------
  
  valrdy2xfifo_enq#(32) valrdy2xfifo_enq_adapter
  (
    .val   (xfifo_enq_in_val),
    .data  (xfifo_enq_in_data),
    .rdy   (xfifo_enq_in_rdy),

    .wr_en (dut_write_wren),
    .din   (dut_write_data),
    .full  (dut_write_full)
  );

  //----------------------------------------------------------------------
  // output FIFO
  //----------------------------------------------------------------------

  fpga_xfifo
  #(
    .DATA_SZ(32),
    .ENTRIES(4)
  )
  output_xfifo
  (
   .clk   (clk),
   .srst  (reset),

   .din   (dut_write_data),
   .wr_en (dut_write_wren),
   .full  (dut_write_full),

   .rd_en (xillybus_read_rden),
   .dout  (xillybus_read_data),
   .valid (xillybus_read_valid),
   .empty (xillybus_read_empty)
  );

  //----------------------------------------------------------------------
  // Debug Scope
  //----------------------------------------------------------------------
  // hooking up the gcd val-rdy input and output ports to the debug scope

/*  `ifdef XILINX_FPGA_DEBUG

  wire [(2*32)-1:0] scope_input_msgs;
  wire [1:0]        scope_input_vals;
  wire [1:0]        scope_input_rdys;

  // NOTE: This design ignores the scope_input_rdy signals. Val-rdy
  // messages _may_ be dropped. For designs where the scope should not drop
  // out the val-rdy packets the design will be more intrusive

  // hook input ports to scope 0
  assign scope_input_msgs[31:0]  = dut_in_data;
  assign scope_input_vals[0]     = dut_in_val && dut_in_rdy;

  // hook input ports to scope 1
  assign scope_input_msgs[63:32] = gcd_result;
  assign scope_input_vals[1]     = dut_out_val && dut_out_rdy;

  fpga_DebugScope
  #(
    .p_num_inputs (2),
    .p_max_nbits  (32)
  )
  debug_scope
  (
    .clk               (clk),
    .reset             (reset),
    .scope_input_msgs  (scope_input_msgs),
    .scope_input_vals  (scope_input_vals),
    .scope_input_rdys  (scope_input_rdys),
    .scope_output_din  (xillybus_debug_din),
    .scope_output_wren (xillybus_debug_wren),
    .scope_output_full (xillybus_debug_full)
  );
  `endif*/
endmodule
