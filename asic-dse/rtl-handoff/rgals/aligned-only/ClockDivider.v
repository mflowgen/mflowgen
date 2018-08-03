//------------------------------------------------------------------------
// ClockDivider
//------------------------------------------------------------------------

module ClockDivider
#(
  parameter p_divideby = 3
)(
  input  wire clk,
  input  wire clk_reset,
  output wire clk_divided
);

  localparam p_counter_bits = $clog2(p_divideby);

  reg [p_counter_bits-1:0] counter;

  always @ ( posedge clk ) begin
    if ( clk_reset ) begin
      counter <= '0;
    end
    else begin
      if ( counter == p_divideby - 1'b1 ) begin
        counter <= '0;
      end
      else begin
        counter <= counter + 1'b1;
      end
    end
  end

  // Align all divided clocks to the first edge after reset

  assign clk_divided = ( counter == 32'd1 );

endmodule

