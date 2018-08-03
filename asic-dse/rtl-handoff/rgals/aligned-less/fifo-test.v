//------------------------------------------------------------------------
// fifo-test
//------------------------------------------------------------------------

module th;

  reg reset     = 1'b0;

  // Dedicated reset for clock dividers to align all divided clocks

  reg clk_reset = 1'b0;

  // Clocks

  reg       clk = 1'b1;
  always #1 clk = ~clk;

  FifoTop top (
    .clk       ( clk       ),
    .reset     ( reset     ),
    .clk_reset ( clk_reset ),
    .src_done  ( src_done  ),
    .sink_done ( sink_done )
  );

  initial begin
    // Enable VPD dumping
    $vcdpluson;
    // Clock reset sequence
    reset     = 1'b1;
    clk_reset = 1'b1;
    $display( "%d: Beginning clock reset", $time );
    #10;
    // Come out of clock reset in the middle of a cycle to try to avoid races
    #5;
    clk_reset = 1'b0;
    $display( "%d: Exiting clock reset", $time );
    #5;
    // Reset sequence
    $display( "%d: Beginning reset", $time );
    #50;
    // Come out of reset in the middle of a cycle to try to avoid races
    #5;
    reset     = 1'b0;
    $display( "%d: Exiting reset", $time );
    #5;
    // Wait for src/sink to finish
    while ( !src_done || !sink_done ) begin
      $display( "%d: ... (req val/rdy/msg: %b,%b,%x) (resp val/rdy: %b,%b)",
        $time, top.req_val,  top.req_rdy, top.req_msg,
        top.resp_val, top.resp_rdy );
      if ( $time > 500 ) begin
        $display( "%d: Timeout!", $time );
        $vcdplusoff;
        $finish;
      end
      #10;
    end
    // Done
    $display( "%d: Source and sink are done", $time );
    // Disable VPD dumping
    $vcdplusoff;
    $finish;
  end

endmodule

