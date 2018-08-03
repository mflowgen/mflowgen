//------------------------------------------------------------------------
// fifo-test
//------------------------------------------------------------------------

module th;

  reg reset     = 1'b0;

  // Clocks

  reg       clk = 1'b1;
  always #1 clk = ~clk;

  // Fifo

  reg         w_val;
  wire        w_rdy;
  reg  [31:0] w_msg;
  wire        r_val;
  reg         r_rdy;
  wire [31:0] r_msg;

  BisynchronousNormalQueue #(32, 2) fifo
  (
    .w_clk ( clk   ),
    .r_clk ( clk   ),
    .reset ( reset ),
    .w_val ( w_val ),
    .w_rdy ( w_rdy ),
    .w_msg ( w_msg ),
    .r_val ( r_val ),
    .r_rdy ( r_rdy ),
    .r_msg ( r_msg )
  );

  initial begin
    // Enable VPD dumping
    $vcdpluson;
    // Initialize regs
    w_val = 1'b0;
    r_rdy = 1'b0;
    #10;
    $display( "%d: Beginning reset", $time );
    reset = 1'b1;
    // Come out of reset in the middle of a cycle to try to avoid races
    #5;
    reset = 1'b0;
    $display( "%d: Exiting reset", $time );
    #5;
    // Offset signals into the middle of a cycle to try to avoid races
    #1;
    // Send a message
    w_val = 1'b1;
    w_msg = 32'd5;
    $display( "%d: --- Sending a message (%d)", $time, w_msg );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    #2;
    w_val = 1'b1;
    w_msg = 32'hf;
    if ( r_val != 1'b1 || r_msg != 32'd5 ) begin
      $display( "%d: --- INCORRECT READ MSG", $time );
    end
    if ( fifo.mem[0] != 32'd5 ) begin
      $display( "%d: --- INCORRECT MEM[0]", $time );
    end
    $display( "%d: --- Sending a message (%d)", $time, w_msg );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    #2;
    w_val = 1'b1;
    w_msg = 32'ha;
    if ( fifo.mem[0] != 32'd5 ) begin
      $display( "%d: --- INCORRECT MEM[0]", $time );
    end
    if ( fifo.mem[1] != 32'hf ) begin
      $display( "%d: --- INCORRECT MEM[1]", $time );
    end
    $display( "%d: --- Sending a message (%d)", $time, w_msg );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    #2;
    w_val = 1'b0;
    w_msg = 32'hf;
    $display( "%d: --- Stopped sending", $time );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    // Waiting a long time
    $display( "%d: --- Waiting a long time", $time );
    #100;
    // Receive a message
    #2;
    r_rdy = 1'b1;
    if ( r_val != 1'b1 || r_msg != 32'd5 ) begin
      $display( "%d: --- INCORRECT READ MSG", $time );
    end
    $display( "%d: --- Reading a message (%d)", $time, r_msg );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    #2;
    r_rdy = 1'b1;
    if ( r_val != 1'b1 || r_msg != 32'hf ) begin
      $display( "%d: --- INCORRECT READ MSG", $time );
    end
    $display( "%d: --- Reading a message (%d)", $time, r_msg );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    #2;
    r_rdy = 1'b0;
    $display( "%d: --- Stopped reading", $time );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    // Trying to read for a long time
    r_rdy = 1'b1;
    $display( "%d: --- Trying to read for a long time", $time );
    #100;
    // Try to read and write at the same time
    w_val = 1'b1;
    w_msg = 32'd3;
    r_rdy = 1'b1;
    #2;
    if ( r_val != 1'b1 || r_msg != 32'd3 ) begin
      $display( "%d: --- INCORRECT READ MSG", $time );
    end
    w_val = 1'b0;
    #10;
    // Done
    $display( "%d: Done", $time );
    $display( "%d: Poke mem[0] has (%d)", $time, fifo.mem[0] );
    $display( "%d: Poke mem[1] has (%d)", $time, fifo.mem[1] );
    $display( "%d: Poke mem[2] has (%d)", $time, fifo.mem[2] );
    $display( "%d: Poke w_rdy  has (%d)", $time, w_rdy );
    $display( "%d: Poke r_val  has (%d)", $time, r_val );
    $display( "%d: Poke w_ptr  has (%b)", $time, fifo.w_ptr_with_wrapbit );
    $display( "%d: Poke r_ptr  has (%b)", $time, fifo.r_ptr_with_wrapbit );
    // Disable VPD dumping
    $vcdplusoff;
    $finish;
  end

endmodule

