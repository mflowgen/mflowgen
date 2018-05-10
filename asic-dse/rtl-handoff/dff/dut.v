module dut (
  input clk,
  input d,
  output q
);

DFFQ_X3M_A9PP140TS_C30 foo (
  .D  (d),
  .Q  (q),
  .CK (clk)
);

endmodule
