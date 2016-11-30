#=========================================================================
# CalcShamtPRTL
#=========================================================================
# Looking at least significant eight bits, calculate how many bits we
# want to shift.

from pymtl import *

class CalcShamtPRTL( Model ):

  # Constructor

  def __init__( s ):

    s.in_ = InPort  (8)
    s.out = OutPort (4)

    @s.combinational
    def block():

      if   s.in_    == 0: s.out.value = 8
      elif s.in_[0] == 1: s.out.value = 1
      elif s.in_[1] == 1: s.out.value = 1
      elif s.in_[2] == 1: s.out.value = 2
      elif s.in_[3] == 1: s.out.value = 3
      elif s.in_[4] == 1: s.out.value = 4
      elif s.in_[5] == 1: s.out.value = 5
      elif s.in_[6] == 1: s.out.value = 6
      elif s.in_[7] == 1: s.out.value = 7

  # Line tracing

  def line_trace( s ):
    return "{}(){}".format( s.in_, s.out )

