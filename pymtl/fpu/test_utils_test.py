#=========================================================================
# test_utils_test.py
#=========================================================================

from pymtl      import *
from test_utils import run_test_vector_sim
from pclib.rtl  import Mux

#-------------------------------------------------------------------------
# test_mux2_exact
#-------------------------------------------------------------------------
# Here the actual output must match exactly with the expected value.

def test_mux2_exact( dump_vcd, test_verilog ):
  run_test_vector_sim( Mux(8,2), [
    ('in_[0]      in_[1]      sel out*'      ),
    [ 0b01010101, 0b10101010, 0,  0b01010101 ],
    [ 0b01010101, 0b10101010, 1,  0b10101010 ],
    [ 0b11001100, 0b00110011, 0,  0b11001100 ],
    [ 0b11110000, 0b00001111, 0,  0b11110000 ],
    [ 0b11001100, 0b00110011, 1,  0b00110011 ],
    [ 0b11110000, 0b00001111, 1,  0b00001111 ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_mux2_approx1
#-------------------------------------------------------------------------
# Here the actual output can differ in the lsb, but for these tests they
# actually do still match.

def test_mux2_approx1( dump_vcd, test_verilog ):
  run_test_vector_sim( Mux(8,2), [
    ('in_[0]      in_[1]      sel out~'      ),
    [ 0b01010101, 0b10101010, 0,  0b01010101 ],
    [ 0b01010101, 0b10101010, 1,  0b10101010 ],
    [ 0b11001100, 0b00110011, 0,  0b11001100 ],
    [ 0b11110000, 0b00001111, 0,  0b11110000 ],
    [ 0b11001100, 0b00110011, 1,  0b00110011 ],
    [ 0b11110000, 0b00001111, 1,  0b00001111 ],
  ], dump_vcd, test_verilog )

#-------------------------------------------------------------------------
# test_mux2_approx2
#-------------------------------------------------------------------------
# Here the actual output can differ in the lsb, and in these tests they
# differe in the lsb.

def test_mux2_approx2( dump_vcd, test_verilog ):
  run_test_vector_sim( Mux(8,2), [
    ('in_[0]      in_[1]      sel out~'      ),
    [ 0b01010101, 0b10101010, 0,  0b01010100 ],
    [ 0b01010101, 0b10101010, 1,  0b10101011 ],
    [ 0b11001100, 0b00110011, 0,  0b11001101 ],
    [ 0b11110000, 0b00001111, 0,  0b11110001 ],
    [ 0b11001100, 0b00110011, 1,  0b00110010 ],
    [ 0b11110000, 0b00001111, 1,  0b00001110 ],
  ], dump_vcd, test_verilog )

  
