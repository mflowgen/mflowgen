`include "stdcells.v"
`include "IntDivRem4.vcs.v"

//------------------------------------------------------------------------
// Simulation driver
//------------------------------------------------------------------------
// Currently only 64-bit is supported

module top;

  //----------------------------------------------------------------------
  // Process command line flags
  //----------------------------------------------------------------------

  parameter nbits = 64;
  integer ncycles;
  integer num_inputs;

  initial begin

    if ( !$value$plusargs( "cycle=%d", ncycles ) ) begin
      ncycles = 100;
    end

    if ( $test$plusargs( "help" ) ) begin
      $display( "" );
      $display( " idiv-sim [options]" );
      $display( "" );
      $display( "   +help                 : this message" );
      $display( "   +cycle=<int>          : number of cycles to simulate" );
      $display( "" );
      $finish;
    end

  end

  //----------------------------------------------------------------------
  // Generate clock
  //----------------------------------------------------------------------

  logic clk = 1;
  always #5 clk = ~clk;

  //----------------------------------------------------------------------
  // Instantiate the harness
  //----------------------------------------------------------------------

  logic reset = 1'b1;

  logic [nbits*2-1:0] inp[100000:0];
  logic [nbits*2-1:0] oup[100000:0];

  task init
  (
    input [15:0] i,
    input [nbits*2-1:0] a,
    input [nbits*2-1:0] b
  );
  begin
    inp[i] = a;
    oup[i] = b;
  end
  endtask

  //----------------------------------------------------------------------
  // Drive the simulation
  //----------------------------------------------------------------------
  logic               req_val;
  logic               req_rdy;
  logic [nbits*2-1:0] req_msg;
  logic               resp_val;
  logic               resp_rdy;
  logic [nbits*2-1:0] resp_msg;

  // I remove the 64 and rely on the default parameter of IntDivRem4 to be
  // compatible with Chisel-generated verilog which is not parameterized.
  IntDivRem4 idiv
  (
    .clk       (clk),
    .reset     (reset),

    .req_msg   (req_msg),
    .req_val   (req_val),
    .req_rdy   (req_rdy),

    .resp_msg  (resp_msg),
    .resp_val  (resp_val),
    .resp_rdy  (resp_rdy)
  );

  logic [nbits*2-1:0] ans;

  integer passed = 0;
  integer cycle;

  initial begin

    #1;
    num_inputs = 20;
    init( 0, 128'h4d000000000003ac74fa0000, 128'hc360000000036fa0000 );
    init( 1, 128'h280000000000000000758a5ff1000000, 128'h758a5ff1000000 );
    init( 2, 128'haa0000000000000007f4e3c93000, 128'h7f4e3c93000 );
    init( 3, 128'h208000000013b5d9208800, 128'h9b41c10000000000200800 );
    init( 4, 128'h5c0000be8ce94640000000, 128'h2123a3011640000000000100000 );
    init( 5, 128'h9200000000000006879482e000, 128'hb000000419482e000 );
    init( 6, 128'h57193bb5aec0000000, 128'h4a3fe1a40bc5260000000000000016 );
    init( 7, 128'h5c000000000000000259fcd47e00000, 128'h259fcd47e00000 );
    init( 8, 128'hac00000001efb8868800000, 128'h2e1d1270000000005400000 );
    init( 9, 128'h690000002a6a3d87c0000, 128'h67696c910000000000047000 );
    init( 10, 128'h2000004101fdac0000000, 128'h2080fed60000000000000000000 );
    init( 11, 128'h4c0000000000000000269fad2e00, 128'h269fad2e00 );
    init( 12, 128'h18000000000002dcc5db8800000, 128'h1e880000005db8800000 );
    init( 13, 128'h220000000000016ea2265a00, 128'hac80000000012265a00 );
    init( 14, 128'h6000000000000000125b2da830, 128'h125b2da830 );
    init( 15, 128'h9000000003f5b1bfc40000000, 128'h70a1f8d0000000740000000 );
    init( 16, 128'hc2000000000000000005d088d1d6, 128'h5d088d1d6 );
    init( 17, 128'h7400000065404b09000, 128'hdf7367cd00000000000001c0 );
    init( 18, 128'h1d0000000000bd6cd17a4000000, 128'h6882a000000f7a4000000 );
    init( 19, 128'h17c00000058d9c6fd00000000, 128'h3bdb78940000000150000000 );

    // Reset signal

         reset = 1'b1;
    #2000; reset = 1'b0;

    // Run the simulation

    cycle = 0;

    while (cycle < ncycles) begin
      req_val = 1;
      resp_rdy = 1;
      req_msg = inp[ cycle % num_inputs ];

      if (req_rdy)
        ans = oup[cycle % num_inputs];

      #10;

      if (resp_val) begin
        if (resp_msg != ans) begin
          $display("Test failed! ans: %x != ref: %x", resp_msg, ans);
          $finish;
        end
        passed += 1;
      end

      cycle += 1;

    end

    $write( "[%d passed] idiv", passed );
    $finish;

  end

endmodule


