config brg_config;
  design testinglib.top;                     // Testbench uses testing library (RTL)
  default liblist testinglib work;           // Library priority
  instance top.th.dut.dut liblist designlib; // Chip uses separate library (RTL or GL)
endconfig
