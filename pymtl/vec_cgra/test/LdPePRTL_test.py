import pytest
import random
import struct

random.seed(0xdeadbeef)

from pymtl               import *
from pclib.test          import mk_test_case_table, run_sim
from pclib.test          import TestSource, TestSink, TestMemory
from pclib.ifcs          import MemMsg4B
from vec_cgra.LdPePRTL   import LdPePRTL

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):
  def __init__(s, ld, src_msgs, sink_msgs, src_delay, sink_delay,
               config, nports, DataBits, ConfigBits, 
               stall_prob, latency,
               dump_vcd=False, test_verilog=False ):
    
    # Instantiate models

    s.src_msgs   = src_msgs
    s.sink_msgs  = sink_msgs
    s.src_delay  = src_delay
    s.sink_delay = sink_delay
    s.config     = config

    s.src  = [ TestSource (DataBits, s.src_msgs[x], s.src_delay)
              for x in xrange( nports ) ] 
    
    s.sink = [ TestSink (DataBits, s.sink_msgs[x], s.sink_delay)
              for x in xrange( nports ) ] 

    s.mem = TestMemory (MemMsg4B(), 1, stall_prob, latency, 2**20 )

    s.ld  = ld

    if dump_vcd:
      s.ld.vcd_file = dump_vcd
    
    if test_verilog:
      s.ld = TranslationTool( s.ld )

    for i in xrange( nports):
      s.connect_pairs(
        s.ld.in_[i],  s.src[i].out,
        s.ld.out[i],  s.sink[i].in_,
    )
    
    s.connect( s.ld.config, config )
    
    s.connect( s.ld.memreq,  s.mem.reqs[0]  )
    s.connect( s.ld.memresp, s.mem.resps[0] )

  def done( s ):
    done_flag = 1
    
    in_sel   = s.config & 0b011
    dest_sel = (s.config & 0b01100) >> 2
    
    done_flag &= s.src[in_sel].done and s.sink[dest_sel].done
    return done_flag

  def line_trace( s ):
   in_ = '|'.join( [x.line_trace()  for x in s.src ])
   out = '|'.join( [x.line_trace()  for x in s.sink])
   return in_ + '>' + s.ld.line_trace() + '>' + out

def run_ld_test( ld, test_params, dump_vcd = False, test_verilog = False ):

  data = test_params.data
  data_bytes = struct.pack("<{}I".format(len(data)),*data)

  src_msgs  = test_params.msgs[0]
  sink_msgs = test_params.msgs[1]
  
  nports = 4
  DataBits = 32
  ConfigBits = 32

  model = TestHarness( ld, src_msgs, sink_msgs, test_params.src, test_params.sink,
                       test_params.config, nports, DataBits, ConfigBits,
                       test_params.stall, test_params.lat,
                       dump_vcd, test_verilog )

  model.vcd_file     = dump_vcd
  model.test_verilog = test_verilog
  model.elaborate()
  
  model.mem.write_mem( 0x1000, data_bytes )

  sim  = SimulationTool( model )

  print()

  sim.reset()
  while not model.done() and sim.ncycles < 100:
    sim.print_line_trace()
    sim.cycle()

  sim.cycle()
  sim.cycle()
  sim.cycle()

  if not model.done():
    raise AssertionError("Simulation did not complete!")

def mk_ld_msgs( nports, config, data, msg_list ):
  src_msgs    = [ [] for x in xrange(nports) ]
  sink_msgs   = [ [] for x in xrange(nports) ]
  for x in msg_list:
    for i in xrange( nports ):
      src_msgs[i].append(Bits(32,x[i]))

    src  = config & 0b011
    dest = (config & 0b01100) >> 2
    idx  = (x[src] - 0x1000) / 4
    res = data[idx]
    sink_msgs[dest].append(Bits(32,res))
  
  return [ src_msgs, sink_msgs ]

def basic_test(config, data):
  nports = 4
  return mk_ld_msgs(nports, config, data,
#      msg0     msg1    msg2    msg3 
    [( 0x1000,  0x1004, 0x1008, 0x100c   ),
#     ( 0x1010,  0x1000, 0x100c, 0x1014   ),
    ]
   )

basic  = [ 0x33, 0x02, 0x77, 0x04, 0x99, 0x06, 0x07, 0x08 ]
  
test_case_table = mk_test_case_table([
  (                  "msgs                         data   config     src   sink  stall lat"),
  [ "basic_012",     basic_test(0b0000110, basic), basic, 0b0000110, 0,    0,     0,    0   ],
  [ "basic_012_2_4", basic_test(0b0000110, basic), basic, 0b0000110, 2,    4,     0,    0   ],
  [ "basic_321",     basic_test(0b0111001, basic), basic, 0b0111001, 0,    0,     0.5,  4   ],
  [ "basic_321_3_1", basic_test(0b0111001, basic), basic, 0b0111001, 3,    1,     0.5,  4   ],
])

@pytest.mark.parametrize( **test_case_table )
def test(test_params, dump_vcd, test_verilog):
  run_ld_test(LdPePRTL(), test_params, dump_vcd, test_verilog)
