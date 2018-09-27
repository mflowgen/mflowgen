import pytest
import random
import struct

random.seed(0xdeadbeef)

from pymtl               import *
from pclib.test          import mk_test_case_table, run_sim
from pclib.test          import TestSource, TestSink, TestMemory
from pclib.ifcs          import MemMsg16B, MemMsg4B
from vec_cgra.LdPePRTL   import LdPePRTL

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):
  def __init__(s, ld, src_msgs, sink_msgs, src_delay, sink_delay,
               nports, DataBits, ConfigBits, MemBits,
               stall_prob, latency,
               dump_vcd=False, test_verilog=False ):
    
    # Instantiate models

    s.src_msgs   = src_msgs
    s.sink_msgs  = sink_msgs
    s.src_delay  = src_delay
    s.sink_delay = sink_delay

    s.config_src  = TestSource (ConfigBits, s.src_msgs, s.src_delay)
    
    s.sink = [ TestSink (DataBits, s.sink_msgs[x], s.sink_delay)
              for x in xrange( nports ) ] 

    if MemBits == 128:
      s.mem = TestMemory (MemMsg16B(), 1, stall_prob, latency, 2**20 )
    elif MemBits == 32:
      s.mem = TestMemory (MemMsg4B(), 1, stall_prob, latency, 2**20 )

    s.ld  = ld

    if dump_vcd:
      s.ld.vcd_file = dump_vcd
    
    if test_verilog:
      s.ld = TranslationTool( s.ld )

    for i in xrange( nports):
      s.connect_pairs(
        s.ld.out[i],  s.sink[i].in_,
    )
    
    s.connect_pairs( 
      s.ld.config, s.config_src.out.msg,
      s.ld.go,     s.config_src.out.val,
      s.ld.idle,   s.config_src.out.rdy,
      )
    
    s.connect( s.ld.memreq,  s.mem.reqs[0]  )
    s.connect( s.ld.memresp, s.mem.resps[0] )

  def done( s ):
    
    dest_sel = (s.config_src.out.msg >> 52) & 0b11
    
    done_flag = s.sink[dest_sel].done
    return done_flag

  def line_trace( s ):
   out = '|'.join( [x.line_trace()  for x in s.sink])
   return s.config_src.line_trace() + '>' + s.ld.line_trace() + '>' + out


# memory data
data  = [ 0x33, 0x02, 0x77, 0x04, 0x99, 0x06, 0x07, 0x08 ]



def run_ld_test( ld, test_params, dump_vcd = False, test_verilog = False ):

  data_bytes = struct.pack("<{}I".format(len(data)),*data)

  src_msgs  = test_params.msgs[0]
  sink_msgs = test_params.msgs[1]
  
  nports = 4
  DataBits = 32
  ConfigBits = 64

  model = TestHarness( ld, src_msgs, sink_msgs, test_params.src, test_params.sink,
                       nports, DataBits, ConfigBits, test_params.membits,
                       test_params.stall, test_params.lat,
                       dump_vcd, test_verilog )

  model.vcd_file     = dump_vcd
  model.test_verilog = test_verilog
  model.elaborate()
  
  model.mem.write_mem( 0x1000, data_bytes )

  sim  = SimulationTool( model )

  print()

  sim.reset()
  while not model.done() and sim.ncycles < 300:
    sim.print_line_trace()
    sim.cycle()

  sim.cycle()
  sim.cycle()
  sim.cycle()

  if not model.done():
    raise AssertionError("Simulation did not complete!")

def mk_config( out_sel, cnt, stride, base_addr ):
  msg = Bits( 64 )
  msg[0:32]  = Bits( 32, base_addr, trunc=True )
  msg[32:42] = Bits( 10, stride, trunc=True )
  msg[42:52] = Bits( 10, cnt, trunc=True )
  msg[52:54] = Bits( 2, out_sel, trunc=True )
  return msg

def mk_ld_msgs( nports, out_sel, cnt, stride, base_addr ):
  src_msgs    = []
  sink_msgs   = [ [] for x in xrange(nports) ]
  
  src_msgs.append(mk_config(out_sel, cnt, stride, base_addr))
  
  for i in xrange( cnt ):
    idx = (base_addr - 0x1000)/4 + i*stride
    res = data[idx]
    sink_msgs[out_sel].append(Bits(32,res))
  
  return [ src_msgs, sink_msgs ]

def basic_test(out_sel, cnt, stride, base_addr):
  nports = 4
  return mk_ld_msgs( nports, out_sel, cnt, stride, base_addr )

  
test_case_table = mk_test_case_table([
  (                  "msgs                          membits src   sink  stall lat"),
#  [ "basic_32_0",     basic_test(2, 2, 1, 0x1000),  32,    0,    0,     0,    0   ],
  [ "basic_32_1",     basic_test(2, 4, 1, 0x1008),  32,    2,    4,     0,    0   ],
#  [ "basic_32_2",     basic_test(1, 8, 1, 0x1000),  32,    0,    0,     0.5,  4   ],
#  [ "basic_32_3",     basic_test(1, 4, 2, 0x1000),  32,    3,    1,     0.5,  4   ],
#  [ "basic_128_0",    basic_test(2, 2, 1, 0x1000),  128,    0,    0,     0,    0   ],
#  [ "basic_128_1",    basic_test(2, 4, 1, 0x1010),  128,    2,    4,     0,    0   ],
#  [ "basic_128_2",    basic_test(1, 4, 1, 0x1000),  128,    0,    0,     0.5,  4   ],
#  [ "basic_128_3",    basic_test(1, 8, 1, 0x1000),  128,    3,    1,     0.5,  4   ],
])

@pytest.mark.parametrize( **test_case_table )
def test(test_params, dump_vcd, test_verilog):
  run_ld_test(LdPePRTL(MemBits = test_params.membits), test_params, dump_vcd, test_verilog)
