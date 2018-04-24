#=========================================================================
# Choose PyMTL or Verilog version
#=========================================================================
# Set this variable to 'pymtl' if you are using PyMTL for your RTL design
# (i.e., your design is in IntMulAltPRTL) or set this variable to
# 'verilog' if you are using Verilog for your RTL design (i.e., your
# design is in IntMulAltVRTL).

rtl_language = 'pymtl'

#-------------------------------------------------------------------------
# Do not edit below this line
#-------------------------------------------------------------------------
# This is the PyMTL wrapper for the corresponding Verilog RTL model.

from pymtl import *

class SramVRTL( VerilogModel ):

  # Verilog module setup

  vprefix    = "sram"
  vlinetrace = False

  # Constructor

  def __init__( s, num_bits = 32, num_words = 256 ):

    addr_width = clog2( num_words )      # address width
    nbytes     = int( num_bits + 7 ) / 8 # $ceil(num_bits/8)

    #---------------------------------------------------------------------
    # Interface
    #---------------------------------------------------------------------

    s.port0_val   = InPort ( 1 )
    s.port0_type  = InPort ( 1 )
    s.port0_idx   = InPort ( addr_width )
    s.port0_wdata = InPort ( num_bits )
    s.port0_wben  = InPort ( nbytes )
    s.port0_rdata = OutPort( num_bits )

    #---------------------------------------------------------------------
    # Verilog import setup
    #---------------------------------------------------------------------
    # Verilog parameters
    s.set_params({
      'p_data_nbits'  : num_bits,
      'p_num_entries' : num_words
    })

    # Verilog ports
    s.set_ports({
      'clk'           : s.clk,
      'reset'         : s.reset,
      'port0_val'     : s.port0_val,
      'port0_type'    : s.port0_type,
      'port0_idx'     : s.port0_idx,
      'port0_wdata'   : s.port0_wdata,
      'port0_rdata'   : s.port0_rdata,
      'port0_wben'    : s.port0_wben
    })

# See if the course staff want to force testing a specific RTL language
# for their own testing.

import sys
if hasattr( sys, '_called_from_test' ):

  import pytest
  if pytest.config.getoption('prtl'):
    rtl_language = 'pymtl'
  elif pytest.config.getoption('vrtl'):
    rtl_language = 'verilog'

# Import the appropriate version based on the rtl_language variable

if rtl_language == 'pymtl':
  from SramPRTL import SramPRTL as SramRTL
elif rtl_language == 'verilog':
  SramRTL = SramVRTL

else:
  raise Exception("Invalid RTL language!")
