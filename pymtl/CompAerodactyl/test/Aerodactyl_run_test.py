#=========================================================================
# Aerodactyl_run_test
#=========================================================================
# Includes the run_test needed by the composition

from pymtl import *

# Import designs
from CompAerodactyl.Aerodactyl import Aerodactyl

#=========================================================================
# run_test
#=========================================================================
# 4 core, with 2 memory ports, each with 16B data bitwidth

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0 ):

  num_cores       = 4
  cacheline_nbits = 128

  from Aerodactyl_harness import run_test as run

  run( Aerodactyl( num_cores ), test, num_cores, cacheline_nbits,
       dump_vcd, test_verilog, src_delay, sink_delay, mem_stall_prob, mem_latency )
