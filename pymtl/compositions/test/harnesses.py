#=========================================================================
# A collection of Test/SimHarnesses for different Proc/Cache/Net compositions
#=========================================================================

import struct

from pymtl      import *
from pclib.ifcs import InValRdyBundle, OutValRdyBundle
from pclib.test import TestSource, TestSink

# BRGTC2 custom TestMemory modified for RISC-V 32

from test import TestMemory

# BRGTC2 custom MemMsg modified for RISC-V 32

from ifcs import MemMsg

from proc.SparseMemoryImage       import SparseMemoryImage
from proc.tinyrv2_encoding        import assemble

#=========================================================================
# Harness for Proc+Cache+Net composition to simulate a benchmark
#=========================================================================
# This harness doesn't have test source/sink

class SimHarness( Model ):

  def __init__( s, model, dump_vcd, test_verilog,
                num_cores=1, mem_stall=False, data_nbits=128 ):

    num_memports = 2   # 1 dmem, 1 imem

    # Instantiate models

    s.model = model

    # Dump VCD

    if dump_vcd:
      s.model.vcd_file = dump_vcd
      if hasattr(s.model, 'inner'):
        s.model.inner.vcd_file = dump_vcd

    # Verilog translation

    if test_verilog:
      s.model = TranslationTool( s.model )

    if mem_stall:
      s.mem = TestMemory( MemMsg(8,32,data_nbits), num_memports, 0.5, 3 )
    else:
      s.mem = TestMemory( MemMsg(8,32,data_nbits), num_memports )

    # Connect memory ports

    s.connect( s.model.imemreq,   s.mem.reqs[0]     )
    s.connect( s.model.imemresp,  s.mem.resps[0]    )
    
    s.connect( s.model.dmemreq,   s.mem.reqs[1]     )
    s.connect( s.model.dmemresp,  s.mem.resps[1]    )

    # Bring stats_en, commit_inst, and proc2mngr up to the top level
    # Also brings all statistic ports up
    # About prog2mngr interface: Note simulator only gets output, so we
    # don't need to worry about the mngr2proc interface. The simulator
    # will monitor this interface for handling various message types.

    s.proc2mngr     = OutValRdyBundle( 32 )

    if num_cores == 1:
      s.connect( s.model.proc2mngr,    s.proc2mngr )
    else:
      s.connect( s.model.proc2mngr[0], s.proc2mngr )

    s.stats_en      = OutPort(1)
    s.commit_inst   = OutPort( num_cores )
    s.icache_miss   = OutPort( num_cores )
    s.icache_access = OutPort( num_cores )
    s.dcache_miss   = OutPort( num_cores )
    s.dcache_access = OutPort( num_cores )

    s.connect( s.model.stats_en,  s.stats_en )

    s.connect( s.model.commit_inst,   s.commit_inst   )
    s.connect( s.model.icache_miss,   s.icache_miss   )
    s.connect( s.model.icache_access, s.icache_access )
    s.connect( s.model.dcache_miss,   s.dcache_miss   )
    s.connect( s.model.dcache_access, s.dcache_access )

  # load memory image

  def load( self, mem_image ):
    sections = mem_image.get_sections()
    for section in sections:
      start_addr = section.addr
      stop_addr  = section.addr + len(section.data)
      self.mem.mem[start_addr:stop_addr] = section.data

  #-----------------------------------------------------------------------
  # line trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    return ("- " if s.model.stats_en else "  ") + \
           s.model.line_trace() + " | " + \
           s.mem.line_trace()

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

class TestHarness( Model ):

  #-----------------------------------------------------------------------
  # constructor
  #-----------------------------------------------------------------------

  def __init__( s, model, dump_vcd, test_verilog, num_cores, cacheline_nbits,
                src_delay, sink_delay, mem_stall_prob, mem_latency ):

    num_memports = 2   # 1 dmem, 1 imem

    s.num_cores = num_cores

    s.src    = TestSource[num_cores]( 32, [], src_delay  )
    s.sink   = TestSink  [num_cores]( 32, [], sink_delay )
    s.model  = model

    if test_verilog:
      s.model = TranslationTool( s.model )

    s.mem    = TestMemory( MemMsg(8,32,cacheline_nbits), num_memports,
                           mem_stall_prob, mem_latency )

    # Composition <-> Memory

    s.connect( s.model.imemreq,  s.mem.reqs[0]     )
    s.connect( s.model.imemresp, s.mem.resps[0]    )
    s.connect( s.model.dmemreq,  s.mem.reqs[1]     )
    s.connect( s.model.dmemresp, s.mem.resps[1]    )

    # Processor <-> Proc/Mngr

    if num_cores == 1:  # Single-core system
      s.connect( s.model.mngr2proc, s.src[0].out  )
      s.connect( s.model.proc2mngr, s.sink[0].in_ )
    else:
      for i in xrange(num_cores):
        s.connect( s.model.mngr2proc[i], s.src[i].out  )
        s.connect( s.model.proc2mngr[i], s.sink[i].in_ )

    # Dump VCD

    if dump_vcd:
      s.model.vcd_file = dump_vcd
      if hasattr(s.model, 'inner'):
        s.model.inner.vcd_file = dump_vcd

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
          for i in xrange(self.num_cores):
            self.src[i].src.msgs.append( Bits(32,bits) )

      elif section.name.endswith("_2proc"):
        idx = int( section.name[5:-6], 0 )

        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.src[idx].src.msgs.append( Bits(32,bits) )

      # For .proc2mngr sections, copy section into proc2mngr_ref src

      elif section.name == ".proc2mngr":
        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]

          for i in xrange(self.num_cores):
            self.sink[i].sink.msgs.append( Bits(32,bits) )

      elif section.name.endswith("_2mngr"):
        idx = int( section.name[5:-6], 0 )

        for i in xrange(0,len(section.data),4):
          bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
          self.sink[idx].sink.msgs.append( Bits(32,bits) )

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
    return reduce( lambda x,y : x and y,
                  [x.done for x in s.src]+[x.done for x in s.sink] )

  #-----------------------------------------------------------------------
  # line_trace
  #-----------------------------------------------------------------------

  def line_trace( s ):
    src_trace  = "|".join( [x.line_trace() for x in s.src]  )
    sink_trace = "|".join( [x.line_trace() for x in s.sink] )
    return src_trace + " >" + \
           ("- " if s.model.stats_en else "  ") + \
           s.model.line_trace() + "|" + \
           s.mem.line_trace()  + " > " + \
           sink_trace

#=========================================================================
# run_test
#=========================================================================

def run_test( model, gen_test, num_cores, cacheline_nbits=128,
              dump_vcd=None, test_verilog=False, src_delay=0, sink_delay=0,
              mem_stall_prob=0, mem_latency=0, max_cycles=20000 ):

  # Instantiate and elaborate the model

  model = TestHarness( model, dump_vcd, test_verilog, num_cores,
                       src_delay, sink_delay, mem_stall_prob, mem_latency, cacheline_nbits )

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
