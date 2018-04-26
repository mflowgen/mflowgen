#=========================================================================
# DW_fp_mult_test
#=========================================================================

import pytest
import struct

from pymtl       import *
from pclib.test  import run_test_vector_sim
from DW_fp_mult  import DW_fp_mult

#-------------------------------------------------------------------------
# helpers
#-------------------------------------------------------------------------

def fp2int( f ):
  return struct.unpack('<I', struct.pack('<f', f))[0]

#-------------------------------------------------------------------------
# test_basic
#-------------------------------------------------------------------------

def test_basic( dump_vcd, test_verilog ):
  run_test_vector_sim( DW_fp_mult(), [
    ('a            b            rnd z            status'),
    [ fp2int(0.5), fp2int(4.0), 0,  fp2int(2.0), 0      ],
    [ fp2int(4.0), fp2int(0.5), 0,  fp2int(2.0), 0      ],
    [ fp2int(2.0), fp2int(2.0), 0,  fp2int(4.0), 0      ],
  ], dump_vcd, test_verilog )

