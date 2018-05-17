#=========================================================================
# Chansey_run_test
#=========================================================================
# Includes the run_test needed by the composition

import os
from pymtl import *

# Import designs
from CompChansey.Chansey import Chansey

#=========================================================================
# run_test
#=========================================================================
# 4 core, with 2 memory ports, each with 16B data bitwidth

def run_test( test, dump_vcd, test_verilog,
              src_delay=0, sink_delay=0, mem_stall_prob=0, mem_latency=0,
              only_one_core=False ):

  num_cores       = 4
  cacheline_nbits = 128

  from Chansey_harness import run_test as run

  with open("Chansey_testcase_init.v", "w") as f:
    f.write( "  th_src_max_delay  = {};\n".format( src_delay ) )
    f.write( "  th_sink_max_delay = {};\n".format( sink_delay ) )
    f.write( "  th_mem_max_delay  = {};\n".format( mem_latency ) )

    if test[0]:
      from Chansey_harness import ctrlreg_msgs
      # dump ctrlreg msg

      if isinstance( test[0], list ):
        msgs = ctrlreg_msgs[ "debug" ] + test[0]
      else:
        msgs = ctrlreg_msgs[ "debug" ] + ctrlreg_msgs[ test[0] ]

      for x in msgs[::2]:
        f.write( "  load_src_ctrlreg( 37'h%s );\n" % Bits(37,x) )
      for x in msgs[1::2]:
        f.write( "  load_sink_ctrlreg( 33'h%s );\n" % Bits(33,x) )

    if test[1]:
      asm_msg = test[1]
      from proc.tinyrv2_encoding  import assemble
      import struct

      if callable( asm_msg ):
        asm_msg = asm_msg()
        asm_msg = assemble( asm_msg )

      # dump asm msg
      sections = asm_msg.get_sections()
      for section in sections:

        # For .mngr2proc sections, copy section into mngr2proc src

        if section.name == ".mngr2proc":
          for i in xrange(0,len(section.data),4):
            bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
            for j in xrange(num_cores):
              f.write( "  load_src_proc%d( 32'h%s );\n" % (j, Bits(32,bits)) )

        elif section.name.endswith("_2proc"):
          idx = int( section.name[5:-6], 0 )
          for i in xrange(0,len(section.data),4):
            bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
            f.write( "  load_src_proc%d( 32'h%s );\n" % (idx, Bits(32,bits)) )

        # For .proc2mngr sections, copy section into proc2mngr_ref src

        elif section.name == ".proc2mngr":
          for i in xrange(0,len(section.data),4):
            bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]

            for j in xrange(num_cores):
              f.write( "  load_sink_proc%d( 32'h%s );\n" % (j, Bits(32,bits)) )

        elif section.name.endswith("_2mngr"):
          idx = int( section.name[5:-6], 0 )

          for i in xrange(0,len(section.data),4):
            bits = struct.unpack_from("<I",buffer(section.data,i,4))[0]
            f.write( "  load_sink_proc%d( 32'h%s );\n" % (idx, Bits(32,bits)) )

        # For all other sections, simply copy them into the memory

        else:
          base_addr = section.addr
          length    = len( section.data )
          for j in xrange( length ):
            addr = base_addr + j
            f.write( "  load_mem( %d, 8'h%s );\n" % (addr , Bits(8,section.data[j])) );

          # Assuming all sections come in order, we dump 16 bytes of
          # zeros to protect against x-prop
          base_addr = section.addr + len( section.data )
          for j in xrange( base_addr, base_addr + 64 ):
            f.write( "  load_mem( %d, 8'h%s );\n" % (j , Bits(8, 0)) );

    if test[2]:
      # dump mdumsg
      for x in test[2][::2]:
        f.write( "  load_src_mdu( 70'h%s );\n" % Bits(70,x) )
      for x in test[2][1::2]:
        f.write( "  load_sink_mdu( 35'h%s );\n" % Bits(35,x) )

    # TODO test[3] and [4] for icache/dcache

  if not os.environ.get('PYTEST_DRYRUN'):
    run( Chansey( num_cores ), test, num_cores, cacheline_nbits,
         dump_vcd, test_verilog, src_delay, sink_delay, mem_stall_prob,
         mem_latency, only_one_core=only_one_core )
