//=========================================================================
// Processor Simulator Harness
//=========================================================================

`include "vc/vc-TestRandDelayMemory_1i1d.v"
`include "vc/vc-TestRandDelaySource.v"
`include "vc/vc-TestRandDelaySink.v"

module SimHarness
#(
  parameter p_mem_nbytes  = 1 << 28 // size of physical memory in bytes
)(
  input  logic        clk,
  input  logic        reset,
  input  logic        clear,
  input  logic [31:0] mem_max_delay,
  output logic        stats_en
);

  // Signals related to host
  logic        L0_disable;
  logic [69:0] host_mdureq0_msg;
  logic        host_mdureq0_rdy;
  logic        host_mdureq0_val;
  logic [34:0] host_mduresp0_msg;
  logic        host_mduresp0_rdy;
  logic        host_mduresp0_val;

  logic        stats0_en;
  logic        commit_inst0;
  logic [31:0] mngr2proc0_msg;
  logic        mngr2proc0_val;
  logic        mngr2proc0_rdy;
  logic [31:0] proc2mngr0_msg;
  logic        proc2mngr0_val;
  logic        proc2mngr0_rdy;

  logic        imemreq0_val;
  logic        imemreq0_rdy;
  logic [`REQ_NBITS(256)-1:0] imemreq0_msg;
  logic        imemresp0_val;
  logic        imemresp0_rdy;
  logic [`RESP_NBITS(256)-1:0] imemresp0_msg;
  logic        dmemreq0_val;
  logic        dmemreq0_rdy;
  logic [`REQ_NBITS(32)-1:0] dmemreq0_msg;
  logic        dmemresp0_val;
  logic        dmemresp0_rdy;
  logic [`RESP_NBITS(32)-1:0] dmemresp0_msg;

  assign stats_en  = stats0_en;
  assign proc2mngr0_rdy = 1;

  ProcL0Mdu dut
  (
    .clk           (clk),
    .reset         (reset),

    .L0_disable       (0),
    .mdu_host_en      (0),
    .host_mdureq_val  (host_mdureq0_val),
    .host_mdureq_rdy  (host_mdureq0_rdy),
    .host_mdureq_msg  (host_mdureq0_msg),
    .host_mduresp_val (host_mduresp0_val),
    .host_mduresp_rdy (host_mduresp0_rdy),
    .host_mduresp_msg (host_mduresp0_msg),

    .stats_en      (stats0_en),
    .commit_inst   (commit_inst0),

    .mngr2proc_msg (mngr2proc0_msg),
    .mngr2proc_val (mngr2proc0_val),
    .mngr2proc_rdy (mngr2proc0_rdy),

    .proc2mngr_msg (proc2mngr0_msg),
    .proc2mngr_val (proc2mngr0_val),
    .proc2mngr_rdy (proc2mngr0_rdy),

    .imemreq_val   (imemreq0_val),
    .imemreq_rdy   (imemreq0_rdy),
    .imemreq_msg   (imemreq0_msg),

    .imemresp_val  (imemresp0_val),
    .imemresp_rdy  (imemresp0_rdy),
    .imemresp_msg  (imemresp0_msg),

    .dmemreq_val   (dmemreq0_val),
    .dmemreq_rdy   (dmemreq0_rdy),
    .dmemreq_msg   (dmemreq0_msg),

    .dmemresp_val  (dmemresp0_val),
    .dmemresp_rdy  (dmemresp0_rdy),
    .dmemresp_msg  (dmemresp0_msg)
  );

  vc_TestRandDelayMemory_1i1d #(
    .p_mem_nbytes (p_mem_nbytes),
    .p_i_nbits    (256),
    .p_d_nbits    (32)
  )
  mem
  (
    .clk          (clk),
    .reset        (reset),
    .clear        (clear),

    .max_delay    (mem_max_delay),

    .imemreq0_val  (imemreq0_val),
    .imemreq0_rdy  (imemreq0_rdy),
    .imemreq0_msg  (imemreq0_msg),

    .imemresp0_val (imemresp0_val),
    .imemresp0_rdy (imemresp0_rdy),
    .imemresp0_msg (imemresp0_msg),

    .dmemreq0_val  (dmemreq0_val),
    .dmemreq0_rdy  (dmemreq0_rdy),
    .dmemreq0_msg  (dmemreq0_msg),

    .dmemresp0_val (dmemresp0_val),
    .dmemresp0_rdy (dmemresp0_rdy),
    .dmemresp0_msg (dmemresp0_msg)
  );

endmodule

//------------------------------------------------------------------------
// Simulation driver
//------------------------------------------------------------------------

module top;

  logic clk = 1'b1;
  always #5 clk = ~clk;

  //----------------------------------------------------------------------
  // Instantiate the harness
  //----------------------------------------------------------------------

  logic        th_reset;
  logic        th_clear;
  logic [31:0] th_mem_max_delay;
  logic        th_stats_en;
  logic        th_done;

  integer      max_cycles;
  integer      stats_en = 0;

  SimHarness#(1<<28) th // 256MB
  (
    .clk            (clk),
    .reset          (th_reset),
    .clear          (th_clear),
    .stats_en       (th_stats_en),
    .mem_max_delay  (th_mem_max_delay)
  );

  logic [799:0] vmh_name;


  initial begin
    if ( !$value$plusargs( "vmh=%s", vmh_name ) ) begin
      $display( "" );
      $display( "    [BRG] ERROR: No executable specified" );
      $display( "" );
      $finish(1);
    end

    if ( !$value$plusargs( "max-cycles=%d", max_cycles ) ) begin
      max_cycles = 1000000;
    end

    if ( !$value$plusargs( "mem-latency=%d", th_mem_max_delay ) ) begin
      th_mem_max_delay = 0;
    end

    if ( $test$plusargs( "stats" ) ) begin
      stats_en = 1;
    end

    if ( $test$plusargs( "help" ) ) begin
      $display( "" );
      $display( " ProcL0Mdu_sim.v [options]" );
      $display( "" );
      $display( "   +help                 : this message" );
      $display( "   +vmh=<executable>     : path of vmh file" );
      $display( "   +mem-latency=<int>    : set memory latency" );
      $display( "   +max-cycles=<int>     : max cycles to wait until done" );
      $display( "   +stats                : display statistics" );
      $display( "" );
      $finish;
    end

  end
  //----------------------------------------------------------------------
  // Drive the simulation
  //----------------------------------------------------------------------

  // number of instructions and cycles for stats

  integer num_insts  = 0;
  integer num_cycles = 0;
  integer total_insts  = 0;
  integer total_cycles = 0;

  integer fh;

  integer msg_type;
  integer msg_xtra;
  integer app_print;
  integer app_print_type;
  integer app_fail_xtra;
  integer app_fail_xtra_count;
  integer app_fail_xtra_msgs[7:0];
  logic done = 1'b0;

  initial begin
    $vcdpluson;
    th_clear = 1'b0;
    th_reset = 1'b0;
    #3;  th_clear = 1'b1;
    #20; th_clear = 1'b0;
    #2;  th_reset = 1'b1;
    #20; th_reset = 1'b0;
    #5;

    // This part is to read a VMH file and dump it into test memory

    fh = $fopen ( vmh_name, "r" );
    if ( !fh ) begin
      $display( "" );
      $display( " ERROR: Could not open vmh file (%s)", vmh_name );
      $display( "" );
      $finish;
    end
    $fclose( fh );

    $readmemh( vmh_name, th.mem.mem.m );

    while ( !done && total_cycles < max_cycles ) begin

      total_cycles = total_cycles + 1;
      total_insts  = total_insts + th.commit_inst0;

      if ( th_stats_en ) begin // we count the stats when stats_en is high
        num_cycles = num_cycles + 1;
        num_insts  = num_insts + th.commit_inst0;
      end

      // we have a failure when the processor sends non-zero value
      if ( th.proc2mngr0_val && th.proc2mngr0_rdy ) begin
        msg_type = th.proc2mngr0_msg[31:16];
        msg_xtra = th.proc2mngr0_msg[15:0];

        if (app_fail_xtra) begin
          app_fail_xtra_msgs[ app_fail_xtra_count ] = th.proc2mngr0_msg;
          app_fail_xtra_count = app_fail_xtra_count + 1;
          if (app_fail_xtra_count == 3) begin
            $display("");
            $display("  [ FAILED ] dest[%d] != ref[%d] (%d != %d)",
                      app_fail_xtra_msgs[0], app_fail_xtra_msgs[0],
                      app_fail_xtra_msgs[1], app_fail_xtra_msgs[2] );
            $display("");
            $finish;
          end
        end

        // Then we check if we are doing a print

        else if (app_print) begin

          // Print int
          if (app_print_type == 0) begin
            $write("%d", th.proc2mngr0_msg);
            app_print = 0;
          end
          if (app_print_type == 1) begin
            $write("%c", th.proc2mngr0_msg);
            app_print = 0;
          end
          if (app_print_type == 2) begin
            if (th.proc2mngr0_msg > 0)
              $write("%c", th.proc2mngr0_msg);
            else
              app_print = 0;
          end
        end

        // Message is from an assembly test

        else if (msg_type == 0) begin
          if (msg_xtra == 0) begin
            $display("");
            $display("  [ passed ]");
            $display("");
            done = 1;
          end
          else begin
            $display("");
            $display("  [ FAILED ] error on line %d", msg_xtra);
            $display("");
            // VCS doesn't support finish_and_return
            //$finish_and_return(1);
            $finish;
          end
        end

        // Message is from a bmark

        else if (msg_type == 1) begin
          if (msg_xtra == 0)
            done = 1;
          else
            // VCS doesn't support finish_and_return
            //$finish_and_return(msg_xtra);
            $finish;
        end

        // Message is from a bmark

        else if (msg_type == 2) begin
          if (msg_xtra == 0)
          begin
            $display("");
            $display("  [ passed ]");
            $display("");
            done = 1;
          end
          else begin
            app_fail_xtra = 1;
            app_fail_xtra_count = 0;
          end
        end

        // Message is from print

        else if (msg_type == 3) begin
          app_print = 1;
          app_print_type = msg_xtra;
          if (app_print_type<0 || app_print_type>2) begin
            $display("ERROR: received unrecognized app print type!");
            // VCS doesn't support finish_and_return
            //$finish_and_return(1);
            $finish;
          end
        end
      end
      #10;
    end
    $vcdplusoff;

    // Check that the simulation actually finished

    if ( !done ) begin
      $display( "" );
      $display( " ERROR: Simulation did not finish in time. Maybe increase" );
      $display( " the simulation time limit using the +max-cycles=<int>" );
      $display( " command line parameter?" );
      $display( "" );
      $finish;
    end

    // Output stats

    if ( stats_en ) begin
      $display( "---------- Stats_en Region ----------" );
      $display( "num_cycles           = %d", num_cycles );
      $display( "total_committed_inst = %d", num_insts );
      $display( "total_cpi            = %f", num_cycles/(1.0*num_insts) );
    end

    $display( "--------------------------------------------");
    $display( "Total_cycles: %d cycles", total_cycles );
    $display( "Total insts:  %d insts", total_insts );
    $display( "" );

    // Finish simulation

    $finish;

  end

endmodule
