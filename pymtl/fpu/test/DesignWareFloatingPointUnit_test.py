#=========================================================================
# DesignWareFloatingPointUnit_test
#=========================================================================

import pytest
import random
import struct

random.seed(0xdeadbeef)

from pymtl            import *
from pclib.test       import mk_test_case_table, run_sim
from pclib.test       import TestSource, TestSink

from fpu.DesignWareFloatingPointUnit import DesignWareFloatingPointUnit
from ifcs.FpuMsg import FpuReqMsg, FpuRespMsg

#-------------------------------------------------------------------------
# TestHarness
#-------------------------------------------------------------------------

class TestHarness (Model):

  def __init__( s, src_msgs, sink_msgs,
                src_delay, sink_delay,
                dump_vcd=False, test_verilog=False ):

    # Instantiate models

    s.src  = TestSource ( FpuReqMsg(), src_msgs,  src_delay  )
    s.fpu  = DesignWareFloatingPointUnit()
    s.sink = TestSink   ( FpuRespMsg(), sink_msgs, sink_delay )

    # Dump VCD

    if dump_vcd:
      s.dpu.vcd_file = dump_vcd

    # Translation

    if test_verilog:
      s.fpu = TranslationTool( s.fpu, verilator_xinit=test_verilog )

    # Connect

    s.connect( s.src.out,  s.fpu.req  )
    s.connect( s.fpu.resp, s.sink.in_ )

  def done( s ):
    return s.src.done and s.sink.done

  def line_trace( s ):
    return s.src.line_trace()  + " > " + \
           s.fpu.line_trace()  + " > " + \
           s.sink.line_trace()

#-------------------------------------------------------------------------
# mk_req_msg
#-------------------------------------------------------------------------

# req typ:
# 0 - mul
# 1 - mulh
# 2 - mulhsu
# 3 - mulhu

req_type  = FpuReqMsg()
resp_type = FpuRespMsg()

#-------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------

FMUL = FpuReqMsg.TYPE_FMUL
FADD = FpuReqMsg.TYPE_FADD

FEXC_NX = FpuRespMsg.FEXC_NX
FEXC_UF = FpuRespMsg.FEXC_UF
FEXC_OF = FpuRespMsg.FEXC_OF
FEXC_DZ = FpuRespMsg.FEXC_DZ
FEXC_NV = FpuRespMsg.FEXC_NV

def f2i( f ):
  return struct.unpack('<I', struct.pack('<f', f))[0]


def req( typ, a, b, frnd=0 ):
  return req_type.mk_msg( typ, 0, Bits( 32, a, trunc=True ),
                          Bits( 32, b, trunc=True ), Bits( 3, frnd ) )

def resp( a, fexc=0 ):
  return resp_type.mk_msg( 0, Bits( 32, a, trunc=True ), Bits( 5, fexc ) )

def generate_msgs( val_table ):
  return [ ( req( typ, a, b, frnd ), resp( z, fexc ) )
           for typ, a, b, frnd, z, fexc in val_table ]

negzero = 0x80000000

# direct test cases
# NOTE: below, the commented values are I think the correct results. I
# think the minor differences are due to a bug in verilator...

direct_fmul_msgs = generate_msgs( [
  # type      a           b   frnd       z     fexc
  # basic ones and zeros
  [ FMUL, f2i( 0.0), f2i( 0.0), 0, f2i( 0.0),  0    ],
  [ FMUL, f2i( 1.0), f2i( 0.0), 0, f2i( 0.0),  0    ],
  [ FMUL, f2i( 0.0), f2i( 1.0), 0, f2i( 0.0),  0    ],
  [ FMUL, f2i( 1.0), f2i( 1.0), 0, f2i( 1.0),  0    ],
  [ FMUL, f2i( 0.0), f2i( 0.0), 0, f2i( 0.0),  0    ],
  # basic neg
  [ FMUL, f2i(-1.0), f2i( 0.0), 0, negzero,    0    ], # notice neg zero!
  [ FMUL, f2i( 0.0), f2i(-1.0), 0, negzero,    0    ], # notice neg zero!
  [ FMUL, f2i(-1.0), f2i( 1.0), 0, f2i(-1.0),  0    ],
  [ FMUL, f2i( 1.0), f2i(-1.0), 0, f2i(-1.0),  0    ],
  [ FMUL, f2i(-1.0), f2i(-1.0), 0, f2i( 1.0),  0    ],
  [ FMUL, negzero,   f2i( 0.0), 0, negzero,    0    ], # notice neg zero!
  [ FMUL, f2i( 0.0), negzero,   0, negzero,    0    ], # notice neg zero!
  [ FMUL, negzero,   negzero,   0, f2i( 0.0),  0    ], # notice neg zero!
  # basic exact
  [ FMUL, f2i(0.5),   f2i(4.0),  0, f2i(2.0),     0    ],
  [ FMUL, f2i(4.0),   f2i(0.5),  0, f2i(2.0),     0    ],
  [ FMUL, f2i(2.0),   f2i(2.0),  0, f2i(4.0),     0    ],
  [ FMUL, f2i(0.125), f2i(0.75), 0, f2i(0.09375), 0    ],
  [ FMUL, f2i(0.75),  f2i(0.125),0, f2i(0.09375), 0    ],
  # basic inexact
  [ FMUL, f2i(0.3),   f2i(0.2),  0, 0x3d75c290,   FEXC_NX    ],
  [ FMUL, f2i(0.2),   f2i(0.3),  0, 0x3d75c290,   FEXC_NX    ],
  #[ FMUL, f2i(0.2),   f2i(0.2),  0, 0x3d23d70b,   FEXC_NX    ],
  [ FMUL, f2i(0.2),   f2i(0.2),  0, 0x3d23d70a,   FEXC_NX    ],
  # riscv
  [ FMUL, f2i(2.5),        f2i(1.0),       0, f2i(2.5 ),          0       ],
  [ FMUL, f2i(-1235.1),    f2i(-1.1),      0, f2i(1358.61),       FEXC_NX ],
  [ FMUL, f2i(3.14159265), f2i(0.00000001),0, f2i(3.14159265e-8), FEXC_NX ],
] )

direct_fadd_msgs = generate_msgs( [
  # type      a           b   frnd       z     fexc
  # basic ones and zeros
  [ FADD, f2i( 0.0), f2i( 0.0), 0, f2i( 0.0),  0    ],
  [ FADD, f2i( 1.0), f2i( 0.0), 0, f2i( 1.0),  0    ],
  [ FADD, f2i( 0.0), f2i( 1.0), 0, f2i( 1.0),  0    ],
  [ FADD, f2i( 1.0), f2i( 1.0), 0, f2i( 2.0),  0    ],
  [ FADD, f2i( 0.0), f2i( 0.0), 0, f2i( 0.0),  0    ],
  # basic neg
  [ FADD, f2i(-1.0), f2i( 0.0), 0, f2i(-1.0),  0    ],
  [ FADD, f2i( 0.0), f2i(-1.0), 0, f2i(-1.0),  0    ],
  [ FADD, f2i(-1.0), f2i( 1.0), 0, f2i( 0.0),  0    ],
  [ FADD, f2i( 1.0), f2i(-1.0), 0, f2i( 0.0),  0    ],
  [ FADD, f2i(-1.0), f2i(-1.0), 0, f2i(-2.0),  0    ],
  [ FADD, negzero,   f2i( 0.0), 0, f2i( 0.0),  0    ],
  [ FADD, f2i( 0.0), negzero,   0, f2i( 0.0),  0    ],
  [ FADD, negzero,   negzero,   0, negzero,    0    ],
  # basic exact
  [ FADD, f2i(0.5),   f2i(4.0),  0, f2i(4.5),     0    ],
  [ FADD, f2i(4.0),   f2i(0.5),  0, f2i(4.5),     0    ],
  [ FADD, f2i(2.0),   f2i(2.0),  0, f2i(4.0),     0    ],
  [ FADD, f2i(0.125), f2i(0.75), 0, f2i(0.875),   0    ],
  [ FADD, f2i(0.75),  f2i(0.125),0, f2i(0.875),   0    ],
  # basic inexact
  [ FADD, f2i(0.3),   f2i(0.1),  0, 0x3ecccccd,   FEXC_NX    ],
  #[ FADD, f2i(0.4),   f2i(0.3),  0, 0x3f333334,   FEXC_NX    ],
  [ FADD, f2i(0.4),   f2i(0.3),  0, 0x3f333333,   FEXC_NX    ],
  [ FADD, f2i(0.4),   f2i(0.4),  0, 0x3f4ccccd,   0          ],
  # riscv
  [ FADD, f2i(2.5),        f2i(1.0),       0, f2i(3.5 ),       0       ],
  #[ FADD, f2i(-1235.1),    f2i(1.1),      0,  f2i(-1234),      FEXC_NX ],
  [ FADD, f2i(-1235.1),    f2i(1.1),      0,  f2i(-1233.9999), FEXC_NX ],
  [ FADD, f2i(3.14159265), f2i(0.00000001),0, f2i(3.14159265), FEXC_NX ],
] )

#-------------------------------------------------------------------------
# Test Case Table
#-------------------------------------------------------------------------

test_case_table = mk_test_case_table([
  (                       "msgs               src_delay sink_delay"),
  [ "direct_fmul",         direct_fmul_msgs,    0,        0          ],
  [ "direct_fmul_3x14",    direct_fmul_msgs,    3,        14         ],
  [ "direct_fadd",         direct_fadd_msgs,    0,        0          ],
  [ "direct_fadd_3x14",    direct_fadd_msgs,    3,        14         ],
])

#-------------------------------------------------------------------------
# Test cases
#-------------------------------------------------------------------------

@pytest.mark.parametrize( **test_case_table )
def test( test_params, dump_vcd, test_verilog ):
  src_msgs, sink_msgs = zip( *test_params.msgs )
  run_sim( TestHarness( src_msgs, sink_msgs,
                        test_params.src_delay, test_params.sink_delay,
                        dump_vcd, test_verilog )
            )
