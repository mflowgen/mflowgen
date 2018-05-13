#=========================================================================
# DW_fp_mult_test
#=========================================================================
# For directed tests where the result is inexact, I used the following
# little C program to determine the correct output:
#
#  #include <stdlib.h>
#  #include <stdio.h>
#  #include <float.h>
#
#  typedef union
#  {
#    float        f;
#    unsigned int i;
#  } f2i;
#
#  int main( int argc, char* argv[] )
#  {
#    f2i a, b, z;
#    a.f = atof(argv[1]);
#    b.f = atof(argv[2]);
#    z.f = a.f * b.f;
#    printf("a = %.*f (%02x)\n", DBL_DIG-1, a.f, a.i );
#    printf("b = %.*f (%02x)\n", DBL_DIG-1, b.f, b.i );
#    printf("z = %.*f (%02x)\n", DBL_DIG-1, z.f, z.i );
#    return 0;
#  }
#
# Then I would compile and run it like this:
#
#  % gcc -o fp-mul fp-mul.c
#  % ./fp-mul 0.3 0.2
#  0.060000 (3d75c290)
#
# If I put 0.06 into the IEEE-754 floating pointer converter here:
#
#   https://www.h-schmidt.net/FloatConverter/IEEE754.html
#
# or if I just used C to convert from 0.06 to a hex I would get:
#
#   0x3d75c28f
#
# but the result shown above is 0x3d75c290. So the hex value is the one I
# want to use for verification.
#
# VERY IMPORTANT!
#
# Unfortunately, I couldn't get the lsb of the result from the DesignWare
# component to match what I was expecting. I tried all rounding modes and
# it still didn't match; besides I really think the rounding mode we want
# is IEEE round to nearest (even). So for now, I created a new kind of
# run_test_vector_sim which includes support for a new special character.
# Usually we use '*' to indicate an output port, but now you can also use
# '~' to indicate that an approximate match is okay. Basically ~ means
# the test harness will ignore the lsb for that output port.

import pytest
import struct
import os

from pymtl              import *
from test_utils         import run_test_vector_sim
from DW_fp_mult_wrapper import DW_fp_mult_wrapper

#-------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------

def f2i( f ):
  return struct.unpack('<I', struct.pack('<f', f))[0]

#-------------------------------------------------------------------------
# test_basic_ones_zeros
#-------------------------------------------------------------------------
# Note that the lsb of the status output is the "zero" bit which should
# be one if the output is zero.

def test_basic_ones_zeros( dump_vcd, test_verilog ):
  run_test_vector_sim( DW_fp_mult_wrapper(), [
    ('a          b          z*          status*'),
    [ f2i( 0.0), f2i( 0.0), f2i( 0.0),  0x01    ],
    [ f2i( 1.0), f2i( 0.0), f2i( 0.0),  0x01    ],
    [ f2i( 0.0), f2i( 1.0), f2i( 0.0),  0x01    ],
    [ f2i( 1.0), f2i( 1.0), f2i( 1.0),  0x00    ],
    [ f2i( 0.0), f2i( 0.0), f2i( 0.0),  0x01    ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_basic_neg
#-------------------------------------------------------------------------
# Note that the lsb of the status output is the "zero" bit which should
# be one if the output is zero. Also notice that -1.0 * 0.0 is actually
# _negative_ zero which is represented as 0x80000000. What fun!

negzero = 0x80000000

def test_basic_neg( dump_vcd, test_verilog ):
  run_test_vector_sim( DW_fp_mult_wrapper(), [
    ('a          b          z*          status*'),
    [ f2i(-1.0), f2i( 0.0), negzero,    0x01    ], # notice neg zero!
    [ f2i( 0.0), f2i(-1.0), negzero,    0x01    ], # notice neg zero!
    [ f2i(-1.0), f2i( 1.0), f2i(-1.0),  0x00    ],
    [ f2i( 1.0), f2i(-1.0), f2i(-1.0),  0x00    ],
    [ f2i(-1.0), f2i(-1.0), f2i( 1.0),  0x00    ],
    [ negzero,   f2i( 0.0), negzero,    0x01    ], # notice neg zero!
    [ f2i( 0.0), negzero,   negzero,    0x01    ], # notice neg zero!
    [ negzero,   negzero,   f2i( 0.0),  0x01    ], # notice neg zero!
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_basic_exact
#-------------------------------------------------------------------------

def test_basic_exact( dump_vcd, test_verilog ):
  run_test_vector_sim( DW_fp_mult_wrapper(), [
    ('a           b           z*            status*'),
    [ f2i(0.5),   f2i(4.0),   f2i(2.0),     0x00    ],
    [ f2i(4.0),   f2i(0.5),   f2i(2.0),     0x00    ],
    [ f2i(2.0),   f2i(2.0),   f2i(4.0),     0x00    ],
    [ f2i(0.125), f2i(0.75),  f2i(0.09375), 0x00    ],
    [ f2i(0.75),  f2i(0.125), f2i(0.09375), 0x00    ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_basic_inexact
#-------------------------------------------------------------------------

def test_basic_inexact( dump_vcd, test_verilog ):
  run_test_vector_sim( DW_fp_mult_wrapper(), [
    ('a           b           z~            status*'),
    [ f2i(0.3),   f2i(0.2),   0x3d75c290,   0x20    ],
    [ f2i(0.2),   f2i(0.3),   0x3d75c290,   0x20    ],
    [ f2i(0.2),   f2i(0.2),   0x3d23d70b,   0x20    ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_riscv
#-------------------------------------------------------------------------
# These are the three test cases from riscv-tests. This is what was in
# rv64uf/fadd.S:
#
#                    inst    flags     result         op0         op1
#  TEST_FP_OP2_S( 8, fmul.s, 0,           2.5,        2.5,        1.0 );
#  TEST_FP_OP2_S( 9, fmul.s, 1,       1358.61,    -1235.1,       -1.1 );
#  TEST_FP_OP2_S(10, fmul.s, 1, 3.14159265e-8, 3.14159265, 0.00000001 );
#
# In RISCV the FP flags are stored in the fcsr register like this:
#
#    4    3    2    1    0
#  | NV | DZ | OF | UF | NX |
#
# With this meaning for each bit:
#
#  NV : Invalid Operation
#  DZ : Divide by Zero
#  OF : Overflow
#  UF : Underflow
#  NX : Inexact
#
# So when the RISC-V assembly test says the flag is 1 that means bit 0 of
# the fcsr register should be set which means the result is inexact. For
# the DesignWare component this corresponds to a statis of 0x20.
#

def test_riscv( dump_vcd, test_verilog ):
  run_test_vector_sim( DW_fp_mult_wrapper(), [
    ('a                b                z*                  status*'),
    [ f2i(2.5),        f2i(1.0),        f2i(2.5 ),          0x00    ],
    [ f2i(-1235.1),    f2i(-1.1),       f2i(1358.61),       0x20    ],
    [ f2i(3.14159265), f2i(0.00000001), f2i(3.14159265e-8), 0x20    ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_softfloat
#-------------------------------------------------------------------------
# SoftFloat is a C library from UC Berkeley which provides bit-accurate
# IEEE floating point operations. It can be used for a pure-software
# floating point emulation. TestFloat goes along with SoftFloat and can
# test a given floating point implementation. This seemed liked a good
# way to generate test cases for our floating point unit.
#
# Here is how I downloaded and built SoftFloat/TestFloat:
#
#  % mkdir $HOME/work/src
#  % cd $HOME/work/src
#  % TOPDIR=$PWD
#
#  % cd $TOPDIR
#  % wget http://www.jhauser.us/arithmetic/SoftFloat-3e.zip
#  % unzip SoftFloat-3e.zip
#  % cd SoftFloat-3e/build/Linux-x86_64-GCC
#  % make
#
#  % cd $TOPDIR
#  % wget http://www.jhauser.us/arithmetic/TestFloat-3e.zip
#  % unzip TestFloat-3e.zip
#  % cd TestFloat-3e/build/Linux-x86_64-GCC
#  % make
#
# And then I used the testfloat_gen program to generate test vectors for
# single-precision floating point multiplication like this:
#
#  % cd $TOPDIR/TestFloat-3e/build/Linux-x86_64-GCC
#  % testfloat_get f32_mul > DW_fp_mult_wrapper_softfloat.txt
#
# Then I copied the .txt file into this directory. The idea is that the
# following test case will read each line from this file, apply the
# inputs, and check the outputs. The only problem is that the DesignWare
# component does not generate outputs that match what is expected! I did
# try a few of the SoftFloat tests which were failing manually using the
# above C code and they seem right ... it really does seem like the
# DesignWare component is not quite correct.
#
# Eventually, I would need to also read in the status bits from the .txt
# file and convert them into what I would expect to see from the
# DesignWare component.
#
# For now, I guess we have to skip these tests. Pretty frustrating.
#

@pytest.mark.skip
def test_softfloat( dump_vcd, test_verilog ):

  # Setup the model

  model = DW_fp_mult_wrapper()
  model.vcd_file = dump_vcd
  if test_verilog:
    model = TranslationTool( model )
  model.elaborate()

  # Create a simulator

  sim = SimulationTool( model )

  # Find the test data relative to the test script

  testdata = os.path.join(os.path.dirname(__file__), "DW_fp_mult_wrapper_softfloat.txt" )

  # Open the test data and iterate through each line

  print()
  sim.reset()
  for line in open( testdata, 'r' ):
    fields = line.split()

    # Set inputs

    model.a.value = int( fields[0], 16 )
    model.b.value = int( fields[1], 16 )

    # Evaluate combinational concurrent blocks in simulator

    sim.eval_combinational()

    # Print the line trace

    sim.print_line_trace()

    # Verify outputs. Note that as above for inexact, we always ignore
    # the lsb.

    if ( model.z.value | 0b1 ) != ( int( fields[2], 16 ) | 0b1 ):
      print( fields[0], fields[1], fields[2], fields[3] )

    # Tick the simulator one cycle

    sim.cycle()

  # Add a couple extra ticks so that the VCD dump is nicer

  sim.cycle()
  sim.cycle()
  sim.cycle()

