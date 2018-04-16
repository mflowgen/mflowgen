#=========================================================================
# test_harness
#=========================================================================
# Includes a test harness that composes a processor, src/sink, and test
# memory, and a run_test function.

import struct

from pymtl import *

from pclib.ifcs import MemMsg4B
from pclib.test import TestSource, TestSink
from pclib.test import TestMemory

from proc.NullXcelRTL      import NullXcelRTL
from proc.tinyrv2_encoding import assemble

#=========================================================================
# TestHarness
#=========================================================================
# Use this with pytest parameterize so that the name of the function that
# generates the assembly test ends up as part of the actual test case
# name. Here is an example:
#
#  @pytest.mark.parametrize( "name,gen_test", [
#    asm_test( gen_basic_test  ),
#    asm_test( gen_bypass_test ),
#    asm_test( gen_value_test  ),
#  ])
#  def test( name, gen_test ):
#    run_test( ProcXFL, gen_test )
#

def asm_test( func ):
  name = func.__name__
  if name.startswith("gen_"):
    name = name[4:]
  if name.endswith("_test"):
    name = name[:-5]

  return (name,func)

#=========================================================================
# TestHarness
#=========================================================================

class TestHarness (Model):

  #-----------------------------------------------------------------------
  # constructor
  #-----------------------------------------------------------------------

  def __init__( s, ProcModel, dump_vcd,
                src_delay, sink_delay,
                mem_stall_prob, mem_latency, test_verilog=False ):

    s.src    = TestSource    ( 32, [], src_delay  )
    s.sink   = TestSink      ( 32, [], sink_delay )
    s.proc   = ProcModel     ()
    s.xcel   = NullXcelRTL   ()
    s.mem    = TestMemory    ( MemMsg4B(), 2, mem_stall_prob, mem_latency )

    # Dump VCD

    if dump_vcd:
      s.proc.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.proc = TranslationTool( s.proc )

    # Processor <-> Proc/Mngr

    s.connect( s.proc.mngr2proc, s.src.out         )
    s.connect( s.proc.proc2mngr, s.sink.in_        )

    # Processor <-> Xcel

    s.connect( s.proc.xcelreq,   s.xcel.xcelreq    )
    s.connect( s.proc.xcelresp,  s.xcel.xcelresp   )

    # Processor <-> Memory

    s.connect( s.proc.imemreq,   s.mem.reqs[0]     )
    s.connect( s.proc.imemresp,  s.mem.resps[0]    )
    s.connect( s.proc.dmemreq,   s.mem.reqs[1]     )
    s.connect( s.proc.dmemresp,  s.mem.resps[1]    )

    # Starting F16 we turn core_id into input ports to
    # enable module reusability. In the past it was passed as arguments.

    s.connect( s.proc.core_id, 0 )

  #-----------------------------------------------------------------------
  # load
  #-----------------------------------------------------------------------

  def load( self, mem_image ):

    # Iterate over the sections

    sections = mem_image.get_sections()
    for section in sections:

      # For .mngr2proc sections, copy section into mngr2proc src

      if section.name == ".mngr2proc":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.src.src.msgs.append( Bits(32,bits) )

      # For .proc2mngr sections, copy section into proc2mngr_ref src

      elif section.name == ".proc2mngr":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.sink.sink.msgs.append( Bits(32,bits) )

      # For all other sections, simply copy them into the memory

      else:
        start_addr = section.addr
        stop_addr  = section.addr + len(section.data)
        self.mem.mem[start_addr:stop_addr] = section.data

  #-----------------------------------------------------------------------
  # cleanup
  #-----------------------------------------------------------------------

  def cleanup( s ):
    del s.mem.mem[:]

  #-----------------------------------------------------------------------
  # done
  #-----------------------------------------------------------------------

  def done( s ):
    return s.src.done and s.sink.done

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return s.src.line_trace()  + " >" + \
           ("- " if s.proc.stats_en else "  ") + \
           s.proc.line_trace() + "|" + \
           s.xcel.line_trace() + "|" + \
           s.mem.line_trace()  + " > " + \
           s.sink.line_trace()

#=========================================================================
# run_test
#=========================================================================

def run_test( ProcModel, gen_test,
              dump_vcd=None, test_verilog=False,
              src_delay=0, sink_delay=0,
              mem_stall_prob=0, mem_latency=0,
              max_cycles=10000 ):

  # Instantiate and elaborate the model

  model = TestHarness( ProcModel, dump_vcd,
                       src_delay, sink_delay,
                       mem_stall_prob, mem_latency, test_verilog )

  model.vcd_file = dump_vcd
  model.elaborate()

  # Assemble the test program

  mem_image = assemble( gen_test() )

  # Load the program into the model

  model.load( mem_image )

  # Create a simulator using the simulation tool

  sim = SimulationTool( model )

  # Run the simulation

  print()

  sim.reset()
  while not model.done() and sim.ncycles < max_cycles:
    sim.print_line_trace()
    sim.cycle()

  # print the very last line trace after the last tick

  sim.print_line_trace()

  # Force a test failure if we timed out

  assert sim.ncycles < max_cycles

  # Add a couple extra ticks so that the VCD dump is nicer

  sim.cycle()
  sim.cycle()
  sim.cycle()

  model.cleanup()

