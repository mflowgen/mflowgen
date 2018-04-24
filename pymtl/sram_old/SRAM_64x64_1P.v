//========================================================================
// 64 bits x 64 words SRAM
//========================================================================

`ifndef SRAM_64x64_1P
`define SRAM_64x64_1P

`include "sram/SramGenericVRTL.v"

module SRAM_64x64_1P
(
  input         CE1,
  input         WEB1,
  input         OEB1,
  input         CSB1,
  input  [5:0]  A1,
  input  [63:0] I1,
  output [63:0] O1,
  input  [7:0]  WBM1
);

  sram_SramGenericVRTL
  #(
    .p_data_nbits  (64),
    .p_num_entries (64)
  )
  sram_generic
  (
    .CE1  (CE1),
    .A1   (A1),
    .WEB1 (WEB1),
    .WBM1 (WBM1),
    .OEB1 (OEB1),
    .CSB1 (CSB1),
    .I1   (I1),
    .O1   (O1)
  );

endmodule

`endif /* SRAM_64x64_1P */

