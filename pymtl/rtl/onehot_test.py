#==============================================================================
# ConfigManger_test.py
#==============================================================================

from pymtl      import *
from pclib.test import TestVectorSimulator
from onehot     import Mux, Demux

#------------------------------------------------------------------------------
# test_Mux
#------------------------------------------------------------------------------
def test_Mux( dump_vcd, test_verilog ):

  nports     = 2
  data_nbits = 16

  # Define test input and output functions

  def tv_in( model, test_vector ):
    model.sel   .value = test_vector[0]
    model.in_[0].value = test_vector[1]
    model.in_[1].value = test_vector[2]

  def tv_out( model, test_vector ):
    assert model.out == test_vector[3]

  # Select and elaborate the model under test

  model = Mux( nports, dtype = data_nbits )
  model.vcd_file = dump_vcd
  if test_verilog:
    model = TranslationTool( model )
  model.elaborate()

  # Define the test vectors
  test_vectors = [
    # sel  in[0]   in[1]   out
    [ 0b00, 0x1111, 0x2222, 0x0000 ],
    [ 0b01, 0x1111, 0x2222, 0x1111 ],
    [ 0b10, 0x1111, 0x2222, 0x2222 ],
    [ 0b00, 0x1111, 0x2222, 0x0000 ],
  ]

  # Create the simulator and configure it
  sim = TestVectorSimulator( model, test_vectors, tv_in, tv_out )

  # Run the simulator
  sim.run_test()

#------------------------------------------------------------------------------
# test_Demux
#------------------------------------------------------------------------------
def test_Demux( dump_vcd, test_verilog ):

  nports     = 2
  data_nbits = 16

  # Define test input and output functions

  def tv_in( model, test_vector ):
    model.sel.value = test_vector[0]
    model.in_.value = test_vector[1]

  def tv_out( model, test_vector ):
    assert model.out[0] == test_vector[2]
    assert model.out[1] == test_vector[3]

  # Select and elaborate the model under test

  model = Demux( nports, dtype = data_nbits )
  model.vcd_file = dump_vcd
  if test_verilog:
    model = TranslationTool( model )
  model.elaborate()

  # Define the test vectors
  test_vectors = [
    # sel  in_      out[0]  out[1]
    [ 0b00, 0x3333, 0x0000, 0x0000 ],
    [ 0b01, 0x1111, 0x1111, 0x0000 ],
    [ 0b10, 0x2222, 0x0000, 0x2222 ],
    [ 0b00, 0x1111, 0x0000, 0x0000 ],
  ]

  # Create the simulator and configure it
  sim = TestVectorSimulator( model, test_vectors, tv_in, tv_out )

  # Run the simulator
  sim.run_test()
