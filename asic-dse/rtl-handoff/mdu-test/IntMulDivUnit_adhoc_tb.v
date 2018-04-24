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
      ncycles = 10000;
    end

    if ( $test$plusargs( "help" ) ) begin
      $display( "" );
      $display( " mdu-tb [options]" );
      $display( "" );
      $display( "   +help                 : this message" );
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

  logic [req_nbits-1:0] inp[999:0];
  logic [resp_nbits-1:0] oup[999:0];

  logic [999:0] all_seen; // at most 999 different messages

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
  integer to_send, received;
  integer seen, mark, i;

  always @(posedge clk) begin
    resp_rdy = 1; // $urandom % 2
    if (req_val & req_rdy)
      to_send += 1;

    req_val = 0;
    req_msg = 0;
    if (to_send < num_inputs ) begin
      req_val = 1; // $urandom % 2
      req_msg = inp[ to_send ];
    end

  end

  initial begin

    #1;
    `include "../../../pymtl/build/mdu_test_cases.v"

    num_inputs = 88;

    // Reset signal

         reset = 1'b1;
    #20; reset = 1'b0;

    // Run the simulation

    cycle = 0;
    to_send  = 0;
    received = 0;
    all_seen = 0;

    req_val  = 0;
    resp_rdy = 0;

    while (cycle < ncycles && received < num_inputs) begin
      // Doing stuff in the loop iteration doesn't make the expecting
      // effects because we want to set req_val or check resp_rdy at the
      // beginning of the clock cycle. After #10 all combinational logics
      // are already fired.
      #10;
      if (resp_val & resp_rdy) begin
        received += 1;
        seen = 0; // whether there is a response in the whole list
        mark = 0; // whether an unmarked response is marked

        for (i=0; i<num_inputs; i+=1)
          if (resp_msg == oup[i]) begin
            seen = 1;
            if ( !all_seen[i] ) begin
              // this response hasn't been marked, mark it and break
              all_seen[i] = 1;
              mark = 1;
              passed += 1;
              break;
            end
          end

        if (!seen) begin
          $display("Test failed! ans %x is not found in response messages", resp_msg);
          $finish;
        end
        else if (!mark) begin
          $display("Test failed! ans %x arrives twice", resp_msg);
          $finish;
        end
      end
      cycle += 1;
      $display("%d: val %d rdy %d req %x | val %d rdy %d resp %x", cycle, req_val, req_rdy, req_msg, resp_val, resp_rdy, resp_msg);
    end

    if (cycle == ncycles) begin
      $display( "This test has been running for %d cycles without end. Please debug. %d/%d", ncycles, passed, num_inputs );
      $finish;
    end
    else begin
      $display( "[%d passed in %d cycles] mdu", passed, cycle );
      $finish;
    end

  end

endmodule


