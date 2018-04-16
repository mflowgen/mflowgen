#=========================================================================
# jalr
#=========================================================================

import random

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    # Use r3 to track the control flow pattern
    addi  x3, x0, 0           # 0x0200
                              #
    lui x1,      %hi[label_a] # 0x0204
    addi x1, x1, %lo[label_a] # 0x0208
                              #
    nop                       # 0x020c
    nop                       # 0x0210
    nop                       # 0x0214
    nop                       # 0x0218
    nop                       # 0x021c
    nop                       # 0x0220
    nop                       # 0x0224
    nop                       # 0x0228
                              #
    jalr  x31, x1, 0          # 0x022c
    addi  x3, x3, 0b01        # 0x0230

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

  label_a:
    addi  x3, x3, 0b10

    # Check the link address
    csrw  proc2mngr, x31 > 0x0230

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3  > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_link_dep_test
#-------------------------------------------------------------------------
# Tests the situation where rd and rs1 are the same. Ensures that the update
# to rd occurs in the same order.

def gen_eq_src_dest_test():
  return """

    # Use r3 to track the control flow pattern
    addi  x3, x0, 0           # 0x0200
                              #
    lui x1,      %hi[label_a] # 0x0204
    addi x1, x1, %lo[label_a] # 0x0208
                              #
    nop                       # 0x020c
    nop                       # 0x0210
    nop                       # 0x0214
    nop                       # 0x0218
    nop                       # 0x021c
    nop                       # 0x0220
    nop                       # 0x0224
    nop                       # 0x0228
                              #
    jalr  x1, x1, 1           # 0x022c
    nop
    addi  x3, x3, 0b01        # 0x0230

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

  label_a:
    addi  x3, x3, 0b10

    # Check the link address
    csrw  proc2mngr, x1  > 0x0230

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3  > 0b10

  """

def gen_link_dep_test():
  return  """
    # Use x3 to track the control flow pattern
    addi  x3, x0, 0           # 0x0200
                              #
    lui x1,      %hi[label_a] # 0x0204
    addi x1, x1, %lo[label_a] # 0x0208
                              #
    nop                       # 0x020c
    nop                       # 0x0210
    nop                       # 0x0214
    nop                       # 0x0218
    nop                       # 0x021c
    nop                       # 0x0220
    nop                       # 0x0224
    nop                       # 0x0228
                              #
    jalr  x1, x1, 0           # 0x022c
    addi  x3, x3, 0b01        # 0x0230
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
  label_a:
    addi  x3, x3, 0b10
    # Check the link address
    csrw  proc2mngr, x1 > 0x0230
    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3  > 0b10
  """

#-------------------------------------------------------------------------
# gen_jump_test
#-------------------------------------------------------------------------
# Currently we have to hard code the expected values for the link
# address. Maybe our assembler should support the la pseudo instruction?
# Maybe our assembler should support the la pseudo instruction? Not sure
# if that would help since we need to put the expected value in the
# proc2mgnr queue.

def gen_jump_test():
  return """

    # Use x3 to track the control flow pattern      #
    addi  x3, x0, 0                                 # 0x00000200
                                                    #
    lui   x9,     %hi[label_a] #                    # 0x00000204
    addi  x9, x9, %lo[label_a] #                    # 0x00000208
    jalr  x31, x9              # j -.               # 0x0000020c
    addi  x3, x3, 0b000001     #    |               # 0x00000210
                               #    |               #
  label_b:                     # <--+-.             #
    addi  x3, x3, 0b000010     #    | |             # 0x00000214
    addi  x5, x31, 0           #    | |             # 0x00000218
    lui   x9,     %hi[label_c] #    | |             # 0x0000021c
    addi  x9, x9, %lo[label_c] #    | |             # 0x00000220
    jalr  x31, x9              # j -+-+-.           # 0x00000224
    addi  x3, x3, 0b000100     #    | | |           # 0x00000228
                               #    | | |           #
  label_a:                     # <--' | |           #
    addi  x3, x3, 0b001000     #      | |           # 0x0000022c
    addi  x4, x31, 0           #      | |           # 0x00000230
    lui   x9,     %hi[label_b] #      | |           # 0x00000234
    addi  x9, x9, %lo[label_b] #      | |           # 0x00000238
    jalr  x31, x9              # j ---' |           # 0x0000023c
    addi  x3, x3, 0b010000     #        |           # 0x00000240
                               #        |           #
  label_c:                     # <------'           #
    addi  x3, x3, 0b100000     #                    # 0x00000244
    addi  x6, x31, 0           #                    # 0x00000248

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3 > 0b101010

    # Check the link addresses
    csrw  proc2mngr, x4 > 0x00000210
    csrw  proc2mngr, x5 > 0x00000240
    csrw  proc2mngr, x6 > 0x00000228

  """

#-------------------------------------------------------------------------
# gen_lsb_test
#-------------------------------------------------------------------------
# Tests the situation where the target address has a 1 in the lsb by 
# loading register rs1 with such a value. The hardware should clear 
# the lowest bit of the calculated target address and jump to label a. 

def gen_lsb_test():
  return """

    # Use r3 to track the control flow pattern
    addi  x3, x0, 0          # 0x0200
                             #
    lui x1,     %hi[label_a] # 0x0204
    ori x1, x1, %lo[label_a] # 0x0208
    ori x1, x1, 0x1                    
    
    nop                      # 0x0210
    nop                      # 0x0214
    nop                      # 0x0218
    nop                      # 0x021c
    nop                      # 0x0220
    nop                      # 0x0224
    nop                      # 0x0228
    
    jalr  x4, x1, 0          # 0x022c
    addi  x3, x3, 0b01       # 0x0230

    nop
    nop
    nop

  label_a:
    addi  x3, x3, 0b10

    # Check the link address
    csrw  proc2mngr, x4 > 0x0230

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3  > 0b10

  """

#-------------------------------------------------------------------------
# gen_value_tests
#-------------------------------------------------------------------------
# Uses the gen_jalr_template defined in test_utils to vary the number of 
# nops between jal instructions. Tests include two forward jumps and one
# backwards jump.

def gen_value_test_0():
  return [
    gen_jalr_test(   0  ),
  ]

def gen_value_test_1():
  return [
    gen_jalr_test(   1  ),
  ]

def gen_value_test_2():
  return [
    gen_jalr_test(   10  ),
  ]

def gen_value_test_3():
  return [
    gen_jalr_test(   100 ),
  ]

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
