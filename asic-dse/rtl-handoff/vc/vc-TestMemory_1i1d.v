`ifndef VC_TEST_MEM_2PORT_V
`define VC_TEST_MEM_2PORT_V

`include "vc/vc-queues.v"

`define REQ_NBITS(x)   x+$clog2(x/8)+44
`define REQ_TYPE(x)    (x+$clog2(x/8)+43):(x+$clog2(x/8)+40)
`define REQ_OPAQUE(x)  (x+$clog2(x/8)+39):(x+$clog2(x/8)+32)
`define REQ_ADDR(x)    (x+$clog2(x/8)+31):(x+$clog2(x/8))
`define REQ_LEN(x)     (x+$clog2(x/8)-1):x
`define REQ_DATA(x)    (x-1):0

`define RESP_NBITS(x)  x+$clog2(x/8)+14
`define RESP_TYPE(x)   (x+$clog2(x/8)+13):(x+$clog2(x/8)+10)
`define RESP_OPAQUE(x) (x+$clog2(x/8)+9):(x+$clog2(x/8)+2)
`define RESP_TEST(x)   (x+$clog2(x/8)+1):(x+$clog2(x/8))
`define RESP_LEN(x)    (x+$clog2(x/8)-1):x
`define RESP_DATA(x)   (x-1):0

module vc_TestMemory_1i1d
#(
  parameter p_mem_nbytes = 1048576,
  parameter p_i_nbits = 256,
  parameter p_d_nbits = 32
)(
  input  logic         clk,
  input  logic         reset,
  input  logic         clear,

  //======================================================================
  // For core 0
  //======================================================================
  input  logic                        imemreq0_val,
  output logic                        imemreq0_rdy,
  input  [`REQ_NBITS(p_i_nbits)-1:0]  imemreq0_msg,
  output logic                        imemresp0_val,
  input  logic                        imemresp0_rdy,
  output [`RESP_NBITS(p_i_nbits)-1:0] imemresp0_msg,
  input  logic                        dmemreq0_val,
  output logic                        dmemreq0_rdy,
  input  [`REQ_NBITS(p_d_nbits)-1:0]  dmemreq0_msg,
  output logic                        dmemresp0_val,
  input  logic                        dmemresp0_rdy,
  output [`RESP_NBITS(p_d_nbits)-1:0] dmemresp0_msg
);
  //----------------------------------------------------------------------
  // Local parameters
  //----------------------------------------------------------------------
  localparam TYPE_READ       = 0;
  localparam TYPE_WRITE      = 1;
  localparam TYPE_WRITE_INIT = 2;
  localparam TYPE_AMO_ADD    = 3;
  localparam TYPE_AMO_AND    = 4;
  localparam TYPE_AMO_OR     = 5;
  localparam TYPE_AMO_SWAP   = 6;
  localparam TYPE_AMO_MIN    = 7;
  localparam TYPE_AMO_MINU   = 8;
  localparam TYPE_AMO_MAX    = 9;
  localparam TYPE_AMO_MAXU   = 10;
  localparam TYPE_AMO_XOR    = 11;

  //----------------------------------------------------------------------
  // Actual memory array
  //----------------------------------------------------------------------

  logic [7:0] m[p_mem_nbytes-1:0];

  //----------------------------------------------------------------------
  // Handle request and create response
  //----------------------------------------------------------------------

  //======================================================================
  // For core 0
  //======================================================================

  logic                             imemresp0_val_M;
  logic                             imemresp0_rdy_M;
  logic [`RESP_NBITS(p_i_nbits)-1:0] imemresp0_msg_M;

  logic                             dmemresp0_val_M;
  logic                             dmemresp0_rdy_M;
  logic [`RESP_NBITS(p_d_nbits)-1:0] dmemresp0_msg_M;

  assign imemreq0_rdy = imemresp0_rdy_M; // rdy of queue.enq.rdy
  assign dmemreq0_rdy = dmemresp0_rdy_M; // rdy of queue.enq.rdy

  assign imemresp0_val_M = imemreq0_val;
  assign dmemresp0_val_M = dmemreq0_val;

  // Handle case where length is zero which actually represents a full
  // width access.

  // Avoid width mismatch as parameters are integers

  typedef logic [$clog2(p_i_nbits/8):0] TRUNCATE_TO_LEN_i;
  typedef logic [$clog2(p_d_nbits/8):0] TRUNCATE_TO_LEN_d;

  logic [$clog2(p_i_nbits/8):0] imemreq0_msg_len_modified_M;
  assign imemreq0_msg_len_modified_M = (imemreq0_msg[`REQ_LEN(p_i_nbits)] == 0) ? TRUNCATE_TO_LEN_i'((p_i_nbits/8)) : imemreq0_msg[`REQ_LEN(p_i_nbits)];

  logic [$clog2(p_d_nbits/8):0] dmemreq0_msg_len_modified_M;
  assign dmemreq0_msg_len_modified_M = (dmemreq0_msg[`REQ_LEN(p_d_nbits)] == 0) ? TRUNCATE_TO_LEN_d'((p_d_nbits/8)) : dmemreq0_msg[`REQ_LEN(p_d_nbits)];

  // Read the data, little-endian
  integer i0, i1;

  logic [p_i_nbits-1:0] iread0;
  always @(imemreq0_val or imemreq0_msg or imemreq0_msg_len_modified_M) begin
    iread0 = {p_i_nbits{1'bx}};
    if (imemreq0_val)
      for (i0=0; i0<imemreq0_msg_len_modified_M; i0=i0+1)
        iread0[i0*8 +: 8] = m[imemreq0_msg[`REQ_ADDR(p_i_nbits)]+i0];
  end

  assign imemresp0_msg_M[`RESP_TYPE(p_i_nbits)]   = imemreq0_msg[`REQ_TYPE(p_i_nbits)];
  assign imemresp0_msg_M[`RESP_OPAQUE(p_i_nbits)] = imemreq0_msg[`REQ_OPAQUE(p_i_nbits)];
  assign imemresp0_msg_M[`RESP_TEST(p_i_nbits)]   = 2'b0;
  assign imemresp0_msg_M[`RESP_LEN(p_i_nbits)]    = imemreq0_msg[`REQ_LEN(p_i_nbits)];
  assign imemresp0_msg_M[`RESP_DATA(p_i_nbits)]   = iread0;

  logic [p_d_nbits-1:0] dread0;
  always @(dmemreq0_val or dmemreq0_msg or dmemreq0_msg_len_modified_M) begin
    dread0 = {p_d_nbits{1'bx}};
    if (dmemreq0_val)
      for (i1=0; i1<dmemreq0_msg_len_modified_M; i1=i1+1)
        dread0[i1*8 +: 8] = m[dmemreq0_msg[`REQ_ADDR(p_d_nbits)]+i1];
  end
  assign dmemresp0_msg_M[`RESP_TYPE(p_d_nbits)]  = dmemreq0_msg[`REQ_TYPE(p_d_nbits)];
  assign dmemresp0_msg_M[`RESP_OPAQUE(p_d_nbits)] = dmemreq0_msg[`REQ_OPAQUE(p_d_nbits)];
  assign dmemresp0_msg_M[`RESP_TEST(p_d_nbits)]   = 2'b0;
  assign dmemresp0_msg_M[`RESP_LEN(p_d_nbits)]    = dmemreq0_msg[`REQ_LEN(p_d_nbits)];
  assign dmemresp0_msg_M[`RESP_DATA(p_d_nbits)]   = dread0;

  // Write the data if required. This is a sequential always block so
  // that the write happens on the next edge.

  logic iwrite0_en_M;
  assign iwrite0_en_M = imemreq0_val &&
      ( imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_WRITE || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_WRITE_INIT );

  logic dwrite0_en_M;
  assign dwrite0_en_M = dmemreq0_val &&
      ( dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_WRITE || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_WRITE_INIT );

  // Note: amos need to happen once, so we only enable the amo transaction
  // when both val and rdy is high

  logic iamo0_en_M;
  assign iamo0_en_M = imemreq0_val && imemreq0_rdy &&
                                  ( imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_ADD
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_AND
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_OR
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_SWAP
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_MIN
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_MINU
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_MAX
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_MAXU
                                 || imemreq0_msg[`REQ_TYPE(p_i_nbits)] == TYPE_AMO_XOR );
  logic damo0_en_M;
  assign damo0_en_M = dmemreq0_val && dmemreq0_rdy &&
                                  ( dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_ADD
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_AND
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_OR
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_SWAP
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_MIN
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_MINU
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_MAX
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_MAXU
                                 || dmemreq0_msg[`REQ_TYPE(p_d_nbits)] == TYPE_AMO_XOR );

  integer wr0_i;
  integer wr1_i;
  integer wr2_i;
  integer wr3_i;
  logic[31:0] tmp;

  // We use this variable to keep track of whether or not we have already
  // cleared the memory. Otherwise if the clear signal is high for
  // multiple cycles we will do the expensive reset multiple times. We
  // initialize this to one since by default when the simulation starts
  // the memory is already reset to X's.

  integer memory_cleared = 1;

  always @( posedge clk ) begin

    // We clear all of the test memory to X's on mem_clear. As mentioned
    // above, this only happens if we clear a test memory more than once.
    // This is useful when we are reusing a memory for many tests to
    // avoid writes from one test "leaking" into a later test -- this
    // might possible cause a test to pass when it should not because the
    // test is using data from an older test.

    if ( clear ) begin
      if ( !memory_cleared ) begin
        memory_cleared = 1;
        for ( wr0_i = 0; wr0_i < p_mem_nbytes; wr0_i = wr0_i + 1 ) begin
          m[wr0_i] <= {8{1'bx}};
        end
      end
    end

    else if ( !reset ) begin
      memory_cleared = 0;

  //======================================================================
  // For core 0
  //======================================================================

      if ( iwrite0_en_M ) begin
        for ( wr0_i = 0; wr0_i < imemreq0_msg_len_modified_M; wr0_i = wr0_i + 1 ) begin
          tmp = imemreq0_msg[`REQ_DATA(p_i_nbits)]; // iverilog is so dumb
          m[imemreq0_msg[`REQ_ADDR(p_i_nbits)] + wr0_i] <= tmp[ (wr0_i*8) +: 8 ];
        end
      end

      if ( dwrite0_en_M ) begin
        for ( wr1_i = 0; wr1_i < dmemreq0_msg_len_modified_M; wr1_i = wr1_i + 1 ) begin
          tmp = dmemreq0_msg[`REQ_DATA(p_d_nbits)]; // iverilog is so dumb
          m[dmemreq0_msg[`REQ_ADDR(p_d_nbits)] + wr1_i] <= tmp[ (wr1_i*8) +: 8 ];
        end
      end

      if ( iamo0_en_M ) begin
        case ( imemreq0_msg[`REQ_TYPE(p_i_nbits)] )
          TYPE_AMO_ADD : tmp = imemreq0_msg[`REQ_DATA(p_i_nbits)] + iread0;
          TYPE_AMO_AND : tmp = imemreq0_msg[`REQ_DATA(p_i_nbits)] & iread0;
          TYPE_AMO_OR  : tmp = imemreq0_msg[`REQ_DATA(p_i_nbits)] | iread0;
          TYPE_AMO_SWAP: tmp = imemreq0_msg[`REQ_DATA(p_i_nbits)];
          TYPE_AMO_MIN : tmp = ($signed(imemreq0_msg[`REQ_DATA(p_i_nbits)]) < $signed(iread0)) ? imemreq0_msg[`REQ_DATA(p_i_nbits)] : iread0;
          TYPE_AMO_MINU: tmp = (imemreq0_msg[`REQ_DATA(p_i_nbits)] < iread0) ? imemreq0_msg[`REQ_DATA(p_i_nbits)] : iread0;
          TYPE_AMO_MAX : tmp = ($signed(imemreq0_msg[`REQ_DATA(p_i_nbits)]) > $signed(iread0)) ? imemreq0_msg[`REQ_DATA(p_i_nbits)] : iread0;
          TYPE_AMO_MAXU: tmp = (imemreq0_msg[`REQ_DATA(p_i_nbits)] < iread0) ? imemreq0_msg[`REQ_DATA(p_i_nbits)] : iread0;
          TYPE_AMO_XOR : tmp = imemreq0_msg[`REQ_DATA(p_i_nbits)] ^ iread0;
        endcase
        for ( wr2_i = 0; wr2_i < imemreq0_msg_len_modified_M; wr2_i = wr2_i + 1 ) begin
          m[imemreq0_msg[`REQ_ADDR(p_i_nbits)] + wr2_i] <= tmp[ (wr2_i*8) +: 8 ];
        end
      end

      if ( damo0_en_M ) begin
        case ( dmemreq0_msg[`REQ_TYPE(p_d_nbits)] )
          TYPE_AMO_ADD : tmp = dmemreq0_msg[`REQ_DATA(p_d_nbits)] + dread0;
          TYPE_AMO_AND : tmp = dmemreq0_msg[`REQ_DATA(p_d_nbits)] & dread0;
          TYPE_AMO_OR  : tmp = dmemreq0_msg[`REQ_DATA(p_d_nbits)] | dread0;
          TYPE_AMO_SWAP: tmp = dmemreq0_msg[`REQ_DATA(p_d_nbits)] + dread0;
          TYPE_AMO_MIN : tmp = ($signed(dmemreq0_msg[`REQ_DATA(p_d_nbits)]) < $signed(dread0)) ? dmemreq0_msg[`REQ_DATA(p_d_nbits)] : dread0;
          TYPE_AMO_MINU: tmp = (dmemreq0_msg[`REQ_DATA(p_d_nbits)] < dread0) ? dmemreq0_msg[`REQ_DATA(p_d_nbits)] : dread0;
          TYPE_AMO_MAX : tmp = ($signed(dmemreq0_msg[`REQ_DATA(p_d_nbits)]) > $signed(dread0)) ? dmemreq0_msg[`REQ_DATA(p_d_nbits)] : dread0;
          TYPE_AMO_MAXU: tmp = (dmemreq0_msg[`REQ_DATA(p_d_nbits)] < dread0) ? dmemreq0_msg[`REQ_DATA(p_d_nbits)] : dread0;
          TYPE_AMO_XOR : tmp = dmemreq0_msg[`REQ_DATA(p_d_nbits)] ^ dread0;
        endcase
        for ( wr3_i = 0; wr3_i < dmemreq0_msg_len_modified_M; wr3_i = wr3_i + 1 ) begin
          m[dmemreq0_msg[`REQ_ADDR(p_d_nbits)] + wr3_i] <= tmp[ (wr3_i*8) +: 8 ];
        end
      end

    end

  end

  //----------------------------------------------------------------------
  // Memory response buffers
  //----------------------------------------------------------------------
  // We use bypass queues here since in general we want our larger
  // modules to use registered inputs. By using a pipe queues at the
  // inputs and a bypass queue at the output we cut and combinational
  // paths through the test memory (helping to avoid combinational loops)
  // and also preserve our registered input policy.

  //======================================================================
  // For core 0
  //======================================================================

  vc_Queue#(`VC_QUEUE_PIPE,`RESP_NBITS(p_i_nbits),1) imemresp0_queue
  (
    .clk     (clk),
    .reset   (reset),
    .enq_val (imemresp0_val_M),
    .enq_rdy (imemresp0_rdy_M),
    .enq_msg (imemresp0_msg_M),
    .deq_val (imemresp0_val),
    .deq_rdy (imemresp0_rdy),
    .deq_msg (imemresp0_msg)
  );

  vc_Queue#(`VC_QUEUE_PIPE,`RESP_NBITS(p_d_nbits),1) dmemresp0_queue
  (
    .clk     (clk),
    .reset   (reset),
    .enq_val (dmemresp0_val_M),
    .enq_rdy (dmemresp0_rdy_M),
    .enq_msg (dmemresp0_msg_M),
    .deq_val (dmemresp0_val),
    .deq_rdy (dmemresp0_rdy),
    .deq_msg (dmemresp0_msg)
  );

endmodule

`endif /* VC_TEST_MEM_2PORTS_V */

