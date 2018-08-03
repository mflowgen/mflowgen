//------------------------------------------------------------------------
// ClockSwitcher
//------------------------------------------------------------------------

module ClockSwitcher
(
  input  wire clk1,
  input  wire clk2,
  input  wire reset,
  input  wire switch_val, // Send switch_msg
  output wire switch_rdy, // Send switch_msg
  input  wire switch_msg, // The switch_msg becomes clk_sel
  output wire clk_out
);

  assign switch_rdy = 1'b1;

  // Clock select register
  //
  // FIXME: currently asynchronously resetting this. Maybe there is
  // a better way to get clk_sel to reset, but it is posedge triggered by
  // clk_out, which depends on clk_sel...

  reg clk_sel;

  always @ ( posedge clk_out or posedge reset ) begin
    if ( reset ) begin
      clk_sel <= 1'b0;
    end
    else if ( switch_val & switch_rdy ) begin
      clk_sel <= switch_msg;
    end
  end

  // Glitch-free clock selection
  //
  // Read these for details:
  //
  // - https://www.eetimes.com/document.asp?doc_id=1202359
  // - https://ieeexplore.ieee.org/xpls/icp.jsp?arnumber=6674704
  // - https://patents.google.com/patent/US5357146A/en
  //
  // The scheme is to pass the mux select through negative edge-triggered
  // flops. This guarantees that any state changes happen when clocks are
  // low, preventing glitches. The flops also have feedback which works to
  // deselect the current clock before the new clock is selected.
  //
  // Two stages of flops could be used as brute-force synchronizers if
  // needed, but in our case because our clock sources are coming from
  // dividers and our select is registered in one of the two domains,
  // there is no need to synchronize.
  //
  // - clk_sel == 1'b0 : select clk1
  // - clk_sel == 1'b1 : select clk2

  reg clk1_select;
  reg clk2_select;

  always @ ( negedge clk1 ) begin
    if ( reset ) begin
      clk1_select <= 1'b0;
    end
    else begin
      clk1_select <= ~clk_sel & ~clk2_select;
    end
  end

  always @ ( negedge clk2 ) begin
    if ( reset ) begin
      clk2_select <= 1'b0;
    end
    else begin
      clk2_select <= clk_sel & ~clk1_select;
    end
  end

  // Output clock

  assign clk_out = ( clk1 & clk1_select ) | ( clk2 & clk2_select );

endmodule

