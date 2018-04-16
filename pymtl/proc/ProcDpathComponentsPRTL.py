#=========================================================================
# ProcDpathComponentsPRTL.py
#=========================================================================

from pymtl            import *
from TinyRV2InstPRTL  import *
from pclib.rtl        import arith

#-------------------------------------------------------------------------
# Generate intermediate (imm) based on type
#-------------------------------------------------------------------------

class ImmGenPRTL( Model ):

  # Interface

  def __init__( s ):

    s.imm_type = InPort( 3 )
    s.inst     = InPort( 32 )
    s.imm      = OutPort( 32 )

    s.tmp12 = Wire( 12 )
    s.tmp7  = Wire( 7 )
    s.tmp1  = Wire( 1 )

    @s.combinational
    def comb_logic():
      # Always sext!

      if   s.imm_type == 0: # I-type

        # Shunning: Nasty but this is for translation to work. I did
        # create a PR in the past to handle this.
        # See https://github.com/cornell-brg/pymtl/pull/158

        s.tmp12.value = s.inst[ I_IMM ]

        s.imm.value = concat( sext( s.tmp12, 32 ) )

      elif s.imm_type == 2: # B-type

        s.tmp1.value = s.inst[ B_IMM3 ]

        s.imm.value = concat( sext( s.tmp1, 20 ),
                                    s.inst[ B_IMM2 ],
                                    s.inst[ B_IMM1 ],
                                    s.inst[ B_IMM0 ],
                                    Bits( 1, 0 ) )

      #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
      # Add more immediate types
      #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

      elif s.imm_type == 1: # S-type

        s.tmp7.value = s.inst[ S_IMM1 ]

        s.imm.value = concat( sext( s.tmp7, 27 ),
                                    s.inst[ S_IMM0 ] )

      elif s.imm_type == 3: # U-type

        s.imm.value = concat(       s.inst[ U_IMM ],
                                    Bits( 12, 0 ) )

      elif s.imm_type == 4: # J-type

        s.tmp1.value = s.inst[ J_IMM3 ]

        s.imm.value = concat( sext( s.tmp1, 12 ),
                                    s.inst[ J_IMM2 ],
                                    s.inst[ J_IMM1 ],
                                    s.inst[ J_IMM0 ],
                                    Bits( 1, 0 ) )

      #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

      else:
        s.imm.value = 0

#-------------------------------------------------------------------------
# ALU
#-------------------------------------------------------------------------

class AluPRTL( Model ):

  # Interface

  def __init__( s ):

    s.in0      = InPort ( 32 )
    s.in1      = InPort ( 32 )
    s.fn       = InPort ( 4 )

    s.out      = OutPort( 32 )
    s.ops_eq   = OutPort( 1 )
    s.ops_lt   = OutPort( 1 )
    s.ops_ltu  = OutPort( 1 )

  # Combinational Logic

    s.tmp_a = Wire( 33 )
    s.tmp_b = Wire( 64 )

    @s.combinational
    def comb_logic():

      s.tmp_a.value = 0
      s.tmp_b.value = 0

      if   s.fn ==  0: s.out.value = s.in0 + s.in1       # ADD
      elif s.fn == 11: s.out.value = s.in0               # CP OP0
      elif s.fn == 12: s.out.value = s.in1               # CP OP1

      #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
      # Add more ALU functions
      #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

      elif s.fn ==  1: s.out.value = s.in0 - s.in1       # SUB
      elif s.fn ==  2: s.out.value = s.in0 << s.in1[0:5] # SLL
      elif s.fn ==  3: s.out.value = s.in0 | s.in1       # OR

      elif s.fn ==  4:                                   # SLT
        s.tmp_a.value = sext( s.in0, 33 ) - sext( s.in1, 33 )
        s.out.value   = s.tmp_a[32]

      elif s.fn ==  5: s.out.value = s.in0 < s.in1       # SLTU
      elif s.fn ==  6: s.out.value = s.in0 & s.in1       # AND
      elif s.fn ==  7: s.out.value = s.in0 ^ s.in1       # XOR
      elif s.fn ==  8: s.out.value = ~( s.in0 | s.in1 )  # NOR
      elif s.fn ==  9: s.out.value = s.in0 >> (s.in1[0:5]) # SRL

      elif s.fn == 10:                                   # SRA
        s.tmp_b.value = sext( s.in0, 64 ) >> s.in1[0:5]
        s.out.value   = s.tmp_b[0:32]

      elif s.fn == 13:                                   # ADDZ for clearing LSB
        s.tmp_b.value = s.in0 + s.in1
        s.out[0].value = 0
        s.out.value[1:32] = s.tmp_b[1:32]
        

      #'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

      else:            s.out.value = 0                   # Unknown

      s.ops_eq.value = ( s.in0 == s.in1 )

      #''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''
      # Add more ALU functions
      # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

      s.ops_lt.value  = s.tmp_a[32]
      s.ops_ltu.value = ( s.in0 < s.in1 )

      # ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
