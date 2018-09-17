import pytest
import random

random.seed(0xdeadbeef)

from pymtl               import *
from pclib.test          import mk_test_case_table, run_sim
from pclib.test          import TestSource, TestSink
from vec_cgra.AluPePRTL  import AluPePRTL

class TestHarness (Model):
  def __init__(s, alu, src_msgs, sink_msgs, src_delay, sink_delay,
               config, nports, DataBits, ConfigBits, 
               dump_vcd=False, test_verilog=False ):
    
    # Instantiate models

    s.src_msgs   = src_msgs
    s.sink_msgs  = sink_msgs
    s.src_delay  = src_delay
    s.sink_delay = sink_delay
    s.config     = config

    s.src = [ TestSource (DataBits, s.src_msgs[x], s.src_delay)
              for x in xrange( nports ) ] 
    
    s.sink = [ TestSink (DataBits, s.sink_msgs[x], s.sink_delay)
              for x in xrange( nports ) ] 

    s.alu = alu

    if dump_vcd:
      s.alu.vcd_file = dump_vcd
    
    if test_verilog:
      s.alu = TranslationTool( s.alu )

    for i in xrange( nports):
      s.connect_pairs(
        s.alu.in_[i],  s.src[i].out,
        s.alu.out[i],  s.sink[i].in_,
    )
    
    s.connect(s.alu.config, config)
    
  def done( s ):
    done_flag = 1
    
    src0 = s.config & 0b011
    src1 = (s.config & 0b01100) >> 2
    dest = (s.config & 0b0110000) >> 4
    
    done_flag &= s.src[src0].done and s.src[src1].done and s.sink[dest].done
    return done_flag

  def line_trace( s ):
   in_ = '|'.join( [x.line_trace()  for x in s.src ])
   out = '|'.join( [x.line_trace()  for x in s.sink])
   return in_ + '>' + s.alu.line_trace() + '>' + out

def run_alu_test( alu, src_delay, sink_delay, test_msgs, config,
                  nports = 4, DataBits = 32, ConfigBits = 32,
                  dump_vcd = False, test_verilog = False ):

  src_msgs  = test_msgs[0]
  sink_msgs = test_msgs[1]
  model = TestHarness( alu, src_msgs, sink_msgs, src_delay, sink_delay,
                       config, nports, DataBits, ConfigBits,
                       dump_vcd, test_verilog )

  model.vcd_file     = dump_vcd
  model.test_verilog = test_verilog
  model.elaborate()

  sim  = SimulationTool( model )

  print()

  sim.reset()
  while not model.done() and sim.ncycles < 30:
    sim.print_line_trace()
    sim.cycle()

  sim.cycle()
  sim.cycle()
  sim.cycle()

  if not model.done():
    raise AssertionError("Simulation did not complete!")

def mk_alu_msgs( nports, config, msg_list ):
  src_msgs    = [ [] for x in xrange(nports) ]
  sink_msgs   = [ [] for x in xrange(nports) ]
  for x in msg_list:
    for i in xrange( nports ):
      src_msgs[i].append(Bits(32,x[i]))

    src0 = config & 0b011
    src1 = (config & 0b01100) >> 2
    dest = (config & 0b0110000) >> 4

    res = x[src0] + x[src1]
    sink_msgs[dest].append(Bits(32,res))
  
  return [ src_msgs, sink_msgs ]

def very_basic_test(config):
  nports = 4
  return mk_alu_msgs(nports, config,
#      msg0     msg1    msg2    msg3 
    [( 0x1 ,    0x2,    0x3,    0x4   ),
     ( 0x12345, 0x123,  0xaaa,  0xbbb ),
    ]
   )

test_case_table = mk_test_case_table([
  (                  "msgs                       config    src_delay      sink_delay"),
  [ "basic_012",     very_basic_test(0b0000110), 0b0000110, 0,            0          ],
  [ "basic_012_2_4", very_basic_test(0b0000110), 0b0000110, 2,            4          ],
  [ "basic_321",     very_basic_test(0b0111001), 0b0111001, 0,            0          ],
  [ "basic_321_3_1", very_basic_test(0b0111001), 0b0111001, 3,            1          ],
])

@pytest.mark.parametrize( **test_case_table )
def test(test_params, dump_vcd, test_verilog):
  run_alu_test(AluPePRTL(), test_params.src_delay, test_params.sink_delay, 
               test_params.msgs, test_params.config, 4, 32, 32, dump_vcd, test_verilog)
