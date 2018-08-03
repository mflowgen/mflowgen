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

