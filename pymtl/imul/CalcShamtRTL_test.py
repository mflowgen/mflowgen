#=========================================================================
# CalcShamtRTL_test
#=========================================================================

from pymtl        import *
from pclib.test   import run_test_vector_sim
from CalcShamtRTL import CalcShamtRTL

#-------------------------------------------------------------------------
# test_basic
#-------------------------------------------------------------------------

def test_basic( dump_vcd, test_verilog ):
  run_test_vector_sim( CalcShamtRTL(), [
    ('in_   out*'),
    [ 0x10, 4    ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_single_one
#-------------------------------------------------------------------------

def test_single_one( dump_vcd, test_verilog ):
  run_test_vector_sim( CalcShamtRTL(), [
    ('in_         out*'),
    [ 0x00000000, 8    ],
    [ 0x00000001, 1    ],
    [ 0x00000002, 1    ],
    [ 0x00000004, 2    ],
    [ 0x00000008, 3    ],
    [ 0x00000010, 4    ],
    [ 0x00000020, 5    ],
    [ 0x00000040, 6    ],
    [ 0x00000080, 7    ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_multiple_ones
#-------------------------------------------------------------------------

def test_multiple_ones( dump_vcd, test_verilog ):
  run_test_vector_sim( CalcShamtRTL(), [
    ('in_         out*'),
    [ 0x00000011, 1    ],
    [ 0x00000012, 1    ],
    [ 0x00000014, 2    ],
    [ 0x00000018, 3    ],
    [ 0x00000010, 4    ],
    [ 0x00000010, 4    ],
  ], dump_vcd, test_verilog )

