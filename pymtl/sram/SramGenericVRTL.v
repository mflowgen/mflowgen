//========================================================================
// Generic Parameterized SRAM
//========================================================================
// This is meant to be instantiated within a carefully named outer module
// so the outer module corresponds to an SRAM generated with the
// CACTI-based memory compiler.

`ifndef SRAM_SRAM_GENERIC_V
`define SRAM_SRAM_GENERIC_V

module sram_SramGenericVRTL
#(
  parameter p_data_nbits  = 1,
  parameter p_num_entries = 2,

  // Local constants not meant to be set from outside the module
  parameter c_addr_nbits  = $clog2(p_num_entries),
  parameter c_data_nbytes = (p_data_nbits+7)/8 // $ceil(p_data_nbits/8)
)(
  input  logic                      CE1,  // clk
  input  logic                      WEB1, // bar( write en )
  input  logic                      OEB1, // bar( out en )
  input  logic                      CSB1, // bar( whole SRAM en )
  input  logic [c_addr_nbits-1:0]   A1,   // address
  input  logic [p_data_nbits-1:0]   I1,   // write data
  output logic [p_data_nbits-1:0]   O1,   // read data
  input  logic [c_data_nbytes-1:0]  WBM1  // byte write en
);

  logic [p_data_nbits-1:0] mem[p_num_entries-1:0];

  logic [p_data_nbits-1:0] data_out1;
  logic [p_data_nbits-1:0] wdata1;

  always @( posedge CE1 ) begin

    // Read path

    if ( ~CSB1 && WEB1 )
      data_out1 <= mem[A1];
    else
      data_out1 <= {p_data_nbits{1'bx}};

  end

  // Write path

  genvar i;
  generate
    for ( i = 0; i < c_data_nbytes; i = i + 1 )
    begin : write
      always @( posedge CE1 ) begin
        if ( ~CSB1 && ~WEB1 && WBM1[i] )
          mem[A1][ (i+1)*8-1 : i*8 ] <= I1[ (i+1)*8-1 : i*8 ];
      end
    end
  endgenerate

  assign O1 = OEB1 ? {p_data_nbits{1'bz}} : data_out1;

endmodule

`endif /* SRAM_SRAM_GENERIC_V */
