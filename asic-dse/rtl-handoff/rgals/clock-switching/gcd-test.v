//------------------------------------------------------------------------
// gcd-test
//------------------------------------------------------------------------

module th;

  reg reset     = 1'b0;

  // Dedicated reset for clock dividers to align all divided clocks

  reg reset_clkdivider = 1'b0;

  // Dedicated reset for clock switchers

  reg reset_clkswitcher = 1'b0;

  // Clocks

  reg       clk = 1'b1;
  always #1 clk = ~clk;

  reg switch_val;
  reg switch_msg;

  GcdTop top (
    .clk               ( clk               ),
    .reset             ( reset             ),
    .reset_clkdivider  ( reset_clkdivider  ),
    .reset_clkswitcher ( reset_clkswitcher ),
    .switch_val        ( switch_val        ),
    .switch_msg        ( switch_msg        ),
    .src_done          ( src_done          ),
    .sink_done         ( sink_done         )
  );

  initial begin
    // Enable VPD dumping
    $vcdpluson;
    // Initialize
    switch_val = 1'b0;
    switch_msg = 1'b0;
    // Clock divider reset
    reset     = 1'b1;
    reset_clkdivider = 1'b1;
    reset_clkswitcher = 1'b1;
    $display( "%d: Beginning clock divider reset", $time );
    #10;
    // Come out of reset in the middle of a cycle to try to avoid races
    #5;
    reset_clkdivider = 1'b0;
    $display( "%d: Exiting clock divider reset", $time );
    #5;
    // Clock switcher reset
    reset_clkswitcher = 1'b1;
    $display( "%d: Beginning clock switcher reset", $time );
    #10;
    // Come out of reset in the middle of a cycle to try to avoid races
    #5;
    reset_clkswitcher = 1'b0;
    $display( "%d: Exiting clock switcher reset", $time );
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
      // Pulse the clock switching circuit every N ticks to switch freqs
      if ( $time % 40 == 0 ) begin
        switch_val = 1'b1;
        switch_msg = ~switch_msg;
        #10;
        switch_val = 1'b0;
      end
      else begin
        #10;
      end
    end
    // Done
    $display( "%d: Source and sink are done", $time );
    // Disable VPD dumping
    $vcdplusoff;
    $finish;
  end

endmodule

