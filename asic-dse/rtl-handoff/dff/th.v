module th;

reg clk = 1'b0;
always #5 clk = ~clk;

reg d = 1'b0;

dut mydut(
  .clk (clk),
  .d   (d),
  .q   (q)
);

initial begin
  $display( "%d: (d, q) is (%b, %b)", $time, d, q );
  #5;
  d = 1'b1;
  #20;
  $display( "%d: (d, q) is (%b, %b)", $time, d, q );
  $finish;
end

endmodule
