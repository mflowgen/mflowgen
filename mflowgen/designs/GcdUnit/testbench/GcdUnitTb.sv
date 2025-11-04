`define CLK_PERIOD 20
`define ASSIGNMENT_DELAY 5
`define FINISH_TIME 2000000
`define NUM_TEST_VECTORS 100

module GcdUnitTb;
  
  localparam ADDR_WIDTH = $clog2(`NUM_TEST_VECTORS);
 
  reg clk;
  reg reset;
  reg [ADDR_WIDTH - 1 : 0] a_b_addr_r;
  reg [ADDR_WIDTH - 1 : 0] c_addr_r;
  wire a_b_rdy_w;
  wire [15 : 0] c_w;
  wire c_rdy_w;

  reg [16 + 16 + 16 - 1 : 0] test_vectors [`NUM_TEST_VECTORS - 1 : 0];

  always #(`CLK_PERIOD/2) clk =~clk;
  
  GcdUnit GcdUnit_inst
  (
    .clk(clk),
    .req_msg(test_vectors[a_b_addr_r][31:0]),
    .req_rdy(a_b_rdy_w),
    .req_val(a_b_rdy_w),
    .reset(reset),
    .resp_msg(c_w),
    .resp_rdy(1'b1),
    .resp_val(c_rdy_w)
  );

  initial begin
    $readmemh("inputs/test_vectors.txt", test_vectors);
    clk <= 0;
    reset <= 1;
    a_b_addr_r <= 0;
    c_addr_r <= 0;
    #(10*`CLK_PERIOD) reset <= 0;
  end

  always @ (posedge clk) begin
    if (!reset && a_b_rdy_w) begin
      a_b_addr_r <= # `ASSIGNMENT_DELAY (a_b_addr_r + 1); // Don't change the inputs right after the clock edge because that will cause problems in gate level simulation
    end

    if (c_rdy_w) begin
      $display("got c = %d, expected c = %d", c_w, test_vectors[c_addr_r][48 - 1 : 32]);
      assert(c_w == test_vectors[c_addr_r][48 - 1 : 32]);
      c_addr_r <= c_addr_r + 1;
      if (c_addr_r == `NUM_TEST_VECTORS - 1) $finish;
    end
  end

  initial begin
    $vcdplusfile("dump.vcd");
    $vcdplusmemon();
    $vcdpluson(0, GcdUnitTb);
    #(`FINISH_TIME);
    $finish(2);
  end

endmodule 
