`ifdef BRG_GL_TESTING
  `include "stdcells.v"
  `include "IntMulDivUnit.vcs.v"
`else
  `include "IntMulDivUnit.v"
`endif

//------------------------------------------------------------------------
// Simulation driver
//------------------------------------------------------------------------
// Currently only 64-bit is supported

module top;

  //----------------------------------------------------------------------
  // Process command line flags
  //----------------------------------------------------------------------

  parameter req_nbits = 70;
  parameter resp_nbits = 35;
  integer ncycles;
  integer num_inputs;

  initial begin

    if ( !$value$plusargs( "cycle=%d", ncycles ) ) begin
      ncycles = 100;
    end

    if ( $test$plusargs( "help" ) ) begin
      $display( "" );
      $display( " mdu-tb [options]" );
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

  logic [req_nbits-1:0] inp[100000:0];
  logic [resp_nbits-1:0] oup[100000:0];

  task init
  (
    input [15:0] i,
    input [req_nbits-1:0] a,
    input [resp_nbits-1:0] b
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
  logic [req_nbits-1:0] req_msg;
  logic               resp_val;
  logic               resp_rdy;
  logic [resp_nbits-1:0] resp_msg;

  // I remove the 64 and rely on the default parameter of IntDivRem4 to be
  // compatible with Chisel-generated verilog which is not parameterized.
  IntMulDivUnit mdu
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

  integer passed = 0;
  integer cycle;
  integer current_test_case;

  initial begin

    #1;
    `include "../../../pymtl/build/mdu_test_cases.v"

    // Reset signal

          reset = 1'b1;
    #200; reset = 1'b0;

    // Run the simulation

    cycle = 0;
    current_test_case = 0;

    while (cycle < ncycles) begin
      req_val = 1;
      resp_rdy = 1;
      req_msg = inp[ current_test_case ];

      #10;

      if (resp_val & resp_rdy) begin
        if (resp_msg != oup[current_test_case]) begin
          $display("Test failed! ans: %x != ref: %x", resp_msg, oup[current_test_case]);
          $finish;
        end
        passed += 1;
        current_test_case = (current_test_case + 1) % num_inputs;
      end

      cycle += 1;

    end

    $write( "[%d passed] mdu", passed );
    $finish;

  end

endmodule


