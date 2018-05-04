`include "vc/vc-TestRandDelaySource.v"
`include "vc/vc-TestRandDelaySink.v"

module TestHarness
(
  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] src_max_delay,
  input  logic [31:0] mem_max_delay,
  input  logic [31:0] sink_max_delay,
  output logic        done
);

  logic [31:0] req_msg;
  logic        req_val;
  logic        req_rdy;
  logic [15:0] resp_msg;
  logic        resp_val;
  logic        resp_rdy;

  SwShim_0x32a7578b0a6f3a5a swshim
  (
    .clk       (clk),
    .reset     (reset),

    .req_val   (req_val),
    .req_rdy   (req_rdy),
    .req_msg   (req_msg),

    .resp_val  (resp_val),
    .resp_rdy  (resp_rdy),
    .resp_msg  (resp_msg)
  );

  vc_TestRandDelaySource
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  src0
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (src_max_delay),
    .val       (req_val),
    .rdy       (req_rdy),
    .msg       (req_msg),
    .done      (src0_done)
  );

  vc_TestRandDelaySink
  #(
    .p_msg_nbits(32),
    .p_num_msgs (1000)
  )
  sink0
  (
    .clk       (clk),
    .reset     (reset),
    .max_delay (sink_max_delay),
    .val       (resp_val),
    .rdy       (resp_rdy),
    .msg       (resp_msg),
    .done      (sink0_done)
  );

  assign done = src0_done && sink0_done;

  `VC_TRACE_BEGIN
  begin
    src0.line_trace( trace_str );
    vc_trace.append_str( trace_str, " | " );
    sink0.line_trace( trace_str );
  end
  `VC_TRACE_END

endmodule

module top;

  logic clk = 1'b1;
  always #5 clk = ~clk;

  logic        th_reset;
  logic [31:0] th_src_max_delay;
  logic [31:0] th_sink_max_delay;
  logic        th_done;

  logic [31:0] th_src0_idx;
  logic [31:0] th_sink0_idx;

  TestHarness#(1<<28) th // 256MB
  (
    .clk            (clk),
    .reset          (th_reset),
    .src_max_delay  (th_src_max_delay),
    .mem_max_delay  (th_mem_max_delay),
    .sink_max_delay (th_sink_max_delay),
    .done           (th_done)
  );

  // Shunning: Helper tasks for loading/unloading messages to src/sink/memory

  task load_src0
  (
    input logic [31:0] msg
  );
  begin
    th.src0.src.m[th_src0_idx] = msg;
    th_src0_idx = th_src0_idx + 1;
    th.src0.src.m[th_src0_idx] = 32'hxxxxxxxx;
  end
  endtask

  task load_sink0
  (
    input logic [31:0] msg
  );
  begin
    th.sink0.sink.m[th_sink0_idx] = msg;
    th_sink0_idx = th_sink0_idx + 1;
    th.sink0.sink.m[th_sink0_idx] = 32'hxxxxxxxx;
  end
  endtask

  logic [799:0] test_name;

  `include "HostGcdUnit_all_tests.v"

  initial begin
    if ( !$value$plusargs( "test=%s", test_name ) ) begin
      $display( "" );
      $display( "    [BRG] ERROR: No test specified" );
      $display( "" );
      $finish(1);
    end
  end

  //----------------------------------------------------------------------
  // Drive the simulation
  //----------------------------------------------------------------------

  integer total_cycles = 0;

  initial begin
    $vcdpluson;
    #2;  th_reset = 1'b1;
    #20; th_reset = 1'b0;
    #8;

    th_src0_idx = 0;
    th_sink0_idx = 0;

    // call the dispatch function in the generated all_tests.v

    HostGcdUnit_testcase_dispatch( test_name );

    while ( !th_done && total_cycles < 2000 ) begin
      #10;
      total_cycles = total_cycles + 1;
      th.display_trace();
    end
    $vcdplusoff;
    // Check that the simulation actually finished

    if ( !th_done ) begin
      $display( "" );
      $display( "    [BRG] ERROR: Test did not finish in 2000 cycles." );
      $display( "" );
      $finish(1);
    end


    if ( th_done ) begin
      $display( "" );
      $display( "    [BRG] Passed test in %d cycles ", total_cycles );
      $display( "" );
      $finish(0);
    end

  end

endmodule


