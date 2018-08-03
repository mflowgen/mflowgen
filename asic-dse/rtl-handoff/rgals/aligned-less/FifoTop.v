//------------------------------------------------------------------------
// FifoTop
//------------------------------------------------------------------------
// I took GcdTop and modified the source and sink messages to match FIFO
// functionality instead of gcd functionality.

module FifoTop (
  input  wire clk,
  input  wire reset,
  input  wire clk_reset,
  output wire src_done,
  output wire sink_done
);

  localparam p_clk1div = 3;
  localparam p_clk2div = 8;

  // Clock dividers

  wire clk1;
  wire clk2;

  ClockDivider #( p_clk1div ) clk_div_1 (
    .clk         ( clk       ),
    .clk_reset   ( clk_reset ),
    .clk_divided ( clk1      )
  );

  ClockDivider #( p_clk2div ) clk_div_2 (
    .clk         ( clk       ),
    .clk_reset   ( clk_reset ),
    .clk_divided ( clk2      )
  );

  // GcdSource

  wire          src_val;
  wire          src_rdy;
  wire [  31:0] src_msg;

  GcdSource src (
    .clk      ( clk1     ),
    .reset    ( reset    ),
    .req_val  ( src_val  ),
    .req_rdy  ( src_rdy  ),
    .req_msg  ( src_msg  ),
    .done     ( src_done )
  );

  wire          req_val;
  wire          req_rdy;
  wire [  31:0] req_msg;

  assign req_val = src_val;
  assign src_rdy = req_rdy;
  assign req_msg = src_msg;

  // GcdSink

  wire          sink_val;
  wire          sink_rdy;
  wire [  15:0] sink_msg;

  GcdSink sink (
    .clk       ( clk2      ),
    .reset     ( reset     ),
    .resp_val  ( sink_val  ),
    .resp_rdy  ( sink_rdy  ),
    .resp_msg  ( sink_msg  ),
    .done      ( sink_done )
  );

  wire          resp_val;
  wire          resp_rdy;
  wire [  15:0] resp_msg;

  assign sink_val = resp_val;
  assign resp_rdy = sink_rdy;
  assign sink_msg = resp_msg;

  // Bisynchronous NormalQueue

  BisynchronousNormalQueue #(16,2) fifo
  (
    .w_clk ( clk1     ),
    .r_clk ( clk2     ),
    .reset ( reset    ),
    .w_val ( req_val  ),
    .w_rdy ( req_rdy  ),
    .w_msg ( req_msg[0+:16] ),
    .r_val ( resp_val ),
    .r_rdy ( resp_rdy ),
    .r_msg ( resp_msg )
  );

endmodule

//------------------------------------------------------------------------
// ClockDivider
//------------------------------------------------------------------------

module ClockDivider
#(
  parameter p_divideby = 3
)(
  input  wire clk,
  input  wire clk_reset,
  output wire clk_divided
);

  reg [31:0] counter;

  always @ ( posedge clk ) begin
    if ( clk_reset ) begin
      counter <= '0;
    end
    else begin
      if ( counter == p_divideby - 1'b1 ) begin
        counter <= '0;
      end
      else begin
        counter <= counter + 1'b1;
      end
    end
  end

  // Align all divided clocks to the first edge after reset

  assign clk_divided = ( counter == 32'd1 );

endmodule

//------------------------------------------------------------------------
// GcdSource
//------------------------------------------------------------------------

module GcdSource
(
  input  wire        clk,
  input  wire        reset,
  output wire        req_val,
  input  wire        req_rdy,
  output wire [31:0] req_msg,
  output wire        done
);

  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  reg [2:0] state;

  // State transitions

  localparam REQ0 = 3'd0;
  localparam REQ1 = 3'd1;
  localparam REQ2 = 3'd2;
  localparam REQ3 = 3'd3;
  localparam DONE = 3'd4;

  always @ ( posedge clk ) begin
    if ( reset ) begin
      state <= REQ0;
    end
    // Transition to REQ1 is message is sent
    else if ( state == REQ0 ) begin
      if ( req_val && req_rdy ) begin
        state <= REQ1;
        $display( "%d: Request handshake!", $time );
      end
    end
    // Transition to REQ2 is message is sent
    else if ( state == REQ1 ) begin
      if ( req_val && req_rdy ) begin
        state <= REQ2;
        $display( "%d: Request handshake!", $time );
      end
    end
    // Transition to REQ3 is message is sent
    else if ( state == REQ2 ) begin
      if ( req_val && req_rdy ) begin
        state <= REQ3;
        $display( "%d: Request handshake!", $time );
      end
    end
    // Transition to DONE is message is sent
    else if ( state == REQ3 ) begin
      if ( req_val && req_rdy ) begin
        state <= DONE;
        $display( "%d: Request handshake!", $time );
      end
    end
    // DONE state stays DONE forever
    else if ( state == DONE ) begin
    end
    // Default to REQ0
    else begin
      state <= REQ0;
    end
  end

  // Request control

  assign req_val =  ( state == REQ0 )
                 || ( state == REQ1 )
                 || ( state == REQ2 )
                 || ( state == REQ3 );

  // Done signal

  assign done = ( state == DONE );

  //---------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  // Memory for request packets

  reg [31:0] mem [3:0];

  always @ ( posedge clk ) begin
    if ( reset ) begin
      mem[0] <= { 16'd00, 16'd10 };
      mem[1] <= { 16'd00, 16'd13 };
      mem[2] <= { 16'd00, 16'd18 };
      mem[3] <= { 16'd00, 16'd21 };
    end
  end

  // Request message

  assign req_msg = ( state == REQ0 ) ? mem[0]
                 : ( state == REQ1 ) ? mem[1]
                 : ( state == REQ2 ) ? mem[2]
                 : ( state == REQ3 ) ? mem[3]
                 :                     32'd0;

endmodule

//------------------------------------------------------------------------
// GcdSink
//------------------------------------------------------------------------

module GcdSink
(
  input  wire        clk,
  input  wire        reset,
  input  wire        resp_val,
  output wire        resp_rdy,
  input  wire [15:0] resp_msg,
  output wire        done
);

  // Memory for response packets

  reg [15:0] mem [3:0];

  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  reg [2:0] state;

  // State transitions

  localparam RESP0 = 3'd0;
  localparam RESP1 = 3'd1;
  localparam RESP2 = 3'd2;
  localparam RESP3 = 3'd3;
  localparam DONE  = 3'd4;

  always @ ( posedge clk ) begin
    if ( reset ) begin
      state <= RESP0;
    end
    // Transition to RESP1 is message is sent
    else if ( state == RESP0 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= RESP1;
        if ( resp_msg == mem[0] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[0] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[0] );
        end
      end
    end
    // Transition to RESP2 is message is sent
    else if ( state == RESP1 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= RESP2;
        if ( resp_msg == mem[1] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[1] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[1] );
        end
      end
    end
    // Transition to RESP3 is message is sent
    else if ( state == RESP2 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= RESP3;
        if ( resp_msg == mem[2] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[2] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[2] );
        end
      end
    end
    // Transition to DONE is message is sent
    else if ( state == RESP3 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= DONE;
        if ( resp_msg == mem[3] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[3] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[3] );
        end
      end
    end
    // DONE state stays DONE forever
    else if ( state == DONE ) begin
    end
    // Default to RESP0
    else begin
      state <= RESP0;
    end
  end

  // Response control -- always ready

  assign resp_rdy = 1'b1;

  // Done signal

  assign done = ( state == DONE );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  always @ ( posedge clk ) begin
    if ( reset ) begin
      mem[0] <= { 16'd10 };
      mem[1] <= { 16'd13 };
      mem[2] <= { 16'd18 };
      mem[3] <= { 16'd21 };
    end
  end

endmodule

//------------------------------------------------------------------------
// BisynchronousNormalQueue
//------------------------------------------------------------------------
// A bisynchronous normal queue built to interface between two clock
// domains. This queue does not have brute-force synchronizers and gray
// code counters, so it is not an asynchronous fifo. It is meant to be
// used with the help of static timing analysis tools (e.g., as is enabled
// by using a ratiochronous design methodology).
//
// Note: This implementation only supports numbers of entries that are
// powers of 2.
//
// This queue uses read and write pointers that have an extra bit to
// differentiate full and empty conditions. The two pointers are initially
// reset so that they are equal (e.g., resetting both to 0 works), and
// this indicates an empty queue. Subsequent writes then bump the write
// pointer, while subsequent reads bump the read pointer and eventually
// "catch up" to the write pointer. The queue is full when the write
// pointer has incremented "full circle" such that the read and write
// pointers are now equal again, except for having different MSBs.
//
// Date   : August 3, 2018
// Author : Christopher Torng

module BisynchronousNormalQueue
#(
  parameter p_data_width  = 32,
  parameter p_num_entries = 8           // Only supports powers of 2!
)(
  input  wire                    w_clk, // Write clock
  input  wire                    r_clk, // Read clock
  input  wire                    reset,
  input  wire                    w_val,
  output wire                    w_rdy,
  input  wire [p_data_width-1:0] w_msg,
  output wire                    r_val,
  input  wire                    r_rdy,
  output wire [p_data_width-1:0] r_msg
);

  localparam p_num_entries_bits = $clog2( p_num_entries );

  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  // Go signals

  wire w_go = w_val & w_rdy;
  wire r_go = r_val & r_rdy;

  // Read and write pointers, including the extra wrap bit

  reg  [p_num_entries_bits:0] w_ptr_with_wrapbit;
  reg  [p_num_entries_bits:0] r_ptr_with_wrapbit;

  // Convenience wires to separate the wrap bits from the actual pointers

  wire [p_num_entries_bits-1:0] w_ptr;
  wire                          w_ptr_wrapbit;

  wire [p_num_entries_bits-1:0] r_ptr;
  wire                          r_ptr_wrapbit;

  assign w_ptr         = w_ptr_with_wrapbit[0+:p_num_entries_bits];
  assign w_ptr_wrapbit = w_ptr_with_wrapbit[p_num_entries_bits];

  assign r_ptr         = r_ptr_with_wrapbit[0+:p_num_entries_bits];
  assign r_ptr_wrapbit = r_ptr_with_wrapbit[p_num_entries_bits];

  // Write pointer update, clocked with the write clock

  always @ ( posedge w_clk ) begin
    if ( reset ) begin
      w_ptr_with_wrapbit <= '0;
    end
    else if ( w_go ) begin
      w_ptr_with_wrapbit <= w_ptr_with_wrapbit + 1'b1;
    end
  end

  // Read pointer update, clocked with the read clock

  always @ ( posedge r_clk ) begin
    if ( reset ) begin
      r_ptr_with_wrapbit <= '0;
    end
    else if ( r_go ) begin
      r_ptr_with_wrapbit <= r_ptr_with_wrapbit + 1'b1;
    end
  end

  // full
  //
  // The queue is full when the read and write pointers are equal but have
  // different wrap bits (i.e., different MSBs). This indicates that we
  // have enqueued "num_entries" messages and cannot store any more.
  //
  // Note -- this queue implementation only works if "num_entries" is
  // a power of two, since we have assumed here that equal pointers
  // indicates a full queue,

  wire full = ( w_ptr == r_ptr ) && ( w_ptr_wrapbit != r_ptr_wrapbit );

  // empty
  //
  // The queue is empty when the full-length pointers (including wrap
  // bits) are equal.

  wire empty = ( w_ptr_with_wrapbit == r_ptr_with_wrapbit );

  // Set output control signals
  //
  // - w_rdy: We are ready to write if the queue has space, i.e., not full
  // - r_val: Data is valid for read if the queue is not empty

  assign w_rdy = !full;
  assign r_val = !empty;

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  // Internal memory

  reg [p_data_width-1:0] mem [p_num_entries-1:0];

  // Writes, clocked with the write clock

  always @ ( posedge w_clk ) begin
    if ( w_go ) begin
      mem[ w_ptr ] <= w_msg;
    end
  end

  // Reads are synchronous with the read clock

  assign r_msg = mem[ r_ptr ];

endmodule

