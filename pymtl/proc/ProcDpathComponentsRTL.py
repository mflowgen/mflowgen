#=========================================================================
# Choose PyMTL or Verilog version
#=========================================================================
# Set this variable to 'pymtl' if you are using PyMTL for your RTL design
# (i.e., your design is in IntMultBasePRTL) or set this variable to
# 'verilog' if you are using Verilog for your RTL design (i.e., your
# design is in IntMulBaseVRTL).

rtl_language = 'pymtl'

#-------------------------------------------------------------------------
# Do not edit below this line
#-------------------------------------------------------------------------

# PyMTL wrappers for the corresponding Verilog RTL models.

from pymtl      import *
import os

class ImmGenVRTL( VerilogModel ):

  # Verilog module setup

  vprefix    = "proc"
  sourcefile = os.path.join( os.path.dirname(__file__), 'ProcDpathComponentsVRTL.v' )

  # Constructor

  def __init__( s ):

    s.imm_type = InPort( 3 )
    s.inst     = InPort( 32 )
    
    s.imm      = OutPort( 32 )

    # Verilog ports

    s.set_ports({
      'imm_type' : s.imm_type,
      'inst'     : s.inst,
      'imm'      : s.imm,
    })

class AluVRTL( VerilogModel ):

  # Verilog module setup

  vprefix    = "proc"
  sourcefile = os.path.join( os.path.dirname(__file__), 'ProcDpathComponentsVRTL.v' )

  # Constructor

  def __init__( s ):

    s.in0      = InPort ( 32 )
    s.in1      = InPort ( 32 )
    s.fn       = InPort ( 4 )

    s.out      = OutPort( 32 )
    s.ops_eq   = OutPort( 1 )
    s.ops_lt   = OutPort( 1 )
    s.ops_ltu  = OutPort( 1 )

    # Verilog ports

    s.set_ports({
      'in0'           : s.in0,
      'in1'           : s.in1,
      'fn'            : s.fn,

      'out'           : s.out,
      'ops_eq'        : s.ops_eq,
      'ops_lt'        : s.ops_lt,
      'ops_ltu'       : s.ops_ltu,
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
  from ProcDpathComponentsPRTL import ImmGenPRTL as ImmGenRTL
  from ProcDpathComponentsPRTL import AluPRTL    as AluRTL
elif rtl_language == 'verilog':
  ImmGenRTL = ImmGenVRTL
  AluRTL    = AluVRTL
else:
  raise Exception("Invalid RTL language!")

