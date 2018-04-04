#=========================================================================
# CalcShamtVRTL
#=========================================================================

from pymtl import *

class CalcShamtVRTL( VerilogModel ):

  # Verilog module setup

  vprefix = "lab1_imul"

  # Constructor

  def __init__( s ):

    # Interface

    s.in_ = InPort  (8)
    s.out = OutPort (4)

    # Verilog ports

    s.set_ports({
      'in':  s.in_,
      'out': s.out,
    })

