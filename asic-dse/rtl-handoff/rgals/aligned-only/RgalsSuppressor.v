//------------------------------------------------------------------------
// RgalsSuppressor
//------------------------------------------------------------------------

module RgalsSuppressor
#(
  parameter p_clk_left_foo  = 3,
  parameter p_clk_right_foo = 5,
  parameter p_data_width    = 1
)(
  input  wire                    clk_left,
  input  wire                    clk_right,
  input  wire                    clk_reset,
  input  wire [p_data_width-1:0] from_left,
  output wire [p_data_width-1:0] to_right,
  input  wire [p_data_width-1:0] from_right,
  output wire [p_data_width-1:0] to_left
);

  // The RGALS suppressor counter has to reset to zero and begin counting
  // precisely aligned with the divided clocks. However, in order to reset
  // synchronously to zero, it needs to be clocked somehow before the
  // divided clocks are even generated.
  //
  // FIXME: for now, this will just be asynchronously reset

  // Left counter is responsible for deciding in the left clock domain
  // which cycle is safe to transmit data

  reg [31:0] counter_left;

  always @ ( posedge clk_left or posedge clk_reset ) begin
    if ( clk_reset ) begin
      counter_left <= '0;
    end
    else begin
      if ( counter_left == p_clk_left_foo - 1'b1 ) begin
        counter_left <= '0;
      end
      else begin
        counter_left <= counter_left + 1'b1;
      end
    end
  end

  wire suppress_from_left = ( counter_left != 32'd0 );

  // Right counter is responsible for deciding in the right clock domain
  // which cycle is safe to transmit data

  reg [31:0] counter_right;

  always @ ( posedge clk_right or posedge clk_reset ) begin
    if ( clk_reset ) begin
      counter_right <= '0;
    end
    else begin
      if ( counter_right == p_clk_right_foo - 1'b1 ) begin
        counter_right <= '0;
      end
      else begin
        counter_right <= counter_right + 1'b1;
      end
    end
  end

  wire suppress_from_right = ( counter_right != 32'd0 );

  // The transaction is only permitted if the cycle is safe for both the
  // left and right clock domains (i.e., if there are no suppression
  // signals from either domain.

  wire suppress = suppress_from_left || suppress_from_right;

  // If suppressed, send zeroes, otherwise allow the data to pass through

  assign to_right   = ( suppress ) ? '0 : from_left;
  assign to_left    = ( suppress ) ? '0 : from_right;

endmodule

