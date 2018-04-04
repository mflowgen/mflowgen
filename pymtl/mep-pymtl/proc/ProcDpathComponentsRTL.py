#=========================================================================
# ProcDpathComponentsRTL.py
#=========================================================================

from pymtl import *

#-------------------------------------------------------------------------
# Branch target calculation module
#-------------------------------------------------------------------------

class BranchTargetCalcRTL( Model ):

  # Interface

  def __init__( s ):

    s.pc_plus4  = InPort ( 32 )
    s.imm_sext  = InPort ( 32 )

    s.br_target = OutPort( 32 )

  # Combinational logic

    @s.combinational
    def comb_logic():

      s.br_target.value = s.pc_plus4 + ( s.imm_sext << 2 )

#-------------------------------------------------------------------------
# Jump target calculation module
#-------------------------------------------------------------------------

class JumpTargetCalcRTL( Model ):

  # Interface

  def __init__( s ):

    s.pc_plus4   = InPort ( 32 )
    s.imm_target = InPort ( 26 )

    s.j_target   = OutPort( 32 )

    # Combinational logic

    @s.combinational
    def comb_logic():
      s.j_target.value = concat( s.pc_plus4[26:32], s.imm_target << 2 )

#-------------------------------------------------------------------------
# ALU
#-------------------------------------------------------------------------

class AluRTL( Model ):

  # Interface

  def __init__( s ):

    s.in0      = InPort ( 32 )
    s.in1      = InPort ( 32 )
    s.fn       = InPort ( 4 )

    s.out      = OutPort( 32 )
    s.ops_eq   = OutPort( 1 )
    s.op0_zero = OutPort( 1 )
    s.op0_neg  = OutPort( 1 )

  # Combinational Logic

    s.ones  = Wire( 32 )
    s.mask  = Wire( 32 )
    s.sign  = Wire( 1 )
    s.diff  = Wire( 32 )

    # Temporaries

    s.tmp_a = Wire( 33 )
    s.tmp_b = Wire( 64 )

    @s.combinational
    def comb_logic():

      if   s.fn ==  0: s.out.value = s.in0 + s.in1       # ADD
      elif s.fn == 11: s.out.value = s.in0               # CP OP0
      elif s.fn == 12: s.out.value = s.in1               # CP OP1

      #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
      # Add more ALU functions
      #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

      elif s.fn ==  1: s.out.value = s.in0 - s.in1       # SUB
      elif s.fn ==  2: s.out.value = s.in1 << s.in0[0:5] # SLL
      elif s.fn ==  3: s.out.value = s.in0 | s.in1       # OR

      elif s.fn ==  4:                                   # SLT
        s.tmp_a.value = sext( s.in0, 33 ) - sext( s.in1, 33 )
        s.out.value   = s.tmp_a[32]

      elif s.fn ==  5: s.out.value = s.in0 < s.in1       # SLTU
      elif s.fn ==  6: s.out.value = s.in0 & s.in1       # AND
      elif s.fn ==  7: s.out.value = s.in0 ^ s.in1       # XOR
      elif s.fn ==  8: s.out.value = ~( s.in0 | s.in1 )  # NOR
      elif s.fn ==  9: s.out.value = s.in1 >> s.in0[0:5] # SRL

      elif s.fn == 10:                                   # SRA
        s.tmp_b.value = sext( s.in1, 64 ) >> s.in0[0:5]
        s.out.value   = s.tmp_b[0:32]

      #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

      else:            s.out.value = 0                   # Unknown

      s.ops_eq.value = ( s.in0 == s.in1 )

      #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
      # Add more ALU functions
      # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

      s.op0_zero.value = ( s.in0 == 0 )

      s.op0_neg.value = ( s.in0[31] == 1 )

      # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
