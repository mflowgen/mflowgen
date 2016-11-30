#=========================================================================
# jal
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl import *
from inst_utils import *

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    # Use r3 to track the control flow pattern
    addiu r3, r0, 0     # 0x0000
                        #
    nop                 # 0x0004
    nop                 # 0x0008
    nop                 # 0x000c
    nop                 # 0x0010
    nop                 # 0x0014
    nop                 # 0x0018
    nop                 # 0x001c
    nop                 # 0x0020
                        #
    jal   label_a       # 0x0024
    addiu r3, r3, 0b01  # 0x0028

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

  label_a:
    addiu r3, r3, 0b10

    # Check the link address
    mtc0  r31, proc2mngr > 0x0028

    # Only the second bit should be set if jump was taken
    mtc0  r3,  proc2mngr > 0b10

  """

# ''' LAB TASK ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
# Define additional directed and random test cases.
# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

#-------------------------------------------------------------------------
# gen_link_byp_test
#-------------------------------------------------------------------------
# Expected link address has to be hard coded based on the number of bytes
# in each generated test. Not great, but the best we can do for now.

def gen_link_byp_test():
  return [
    gen_jal_link_byp_test( 5, 0x0008 ),
    gen_jal_link_byp_test( 4, 0x0034 ),
    gen_jal_link_byp_test( 3, 0x005c ),
    gen_jal_link_byp_test( 2, 0x0080 ),
    gen_jal_link_byp_test( 1, 0x00a0 ),
    gen_jal_link_byp_test( 0, 0x00bc ),
  ]

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
                                                 # PC
    # Use r3 to track the control flow pattern   #
    addiu r3, r0, 0                              # 0x00000000
                                                 #
    jal   label_a           # j -.               # 0x00000004
    addiu r3, r3, 0b000001  #    |               # 0x00000008
                            #    |               #
  label_b:                  # <--+-.             #
    addiu r3, r3, 0b000010  #    | |             # 0x0000000c
    addiu r5, r31, 0        #    | |             # 0x00000010
    jal   label_c           # j -+-+-.           # 0x00000014
    addiu r3, r3, 0b000100  #    | | |           # 0x00000018
                            #    | | |           #
  label_a:                  # <--' | |           #
    addiu r3, r3, 0b001000  #      | |           # 0x0000001c
    addiu r4, r31, 0        #      | |           # 0x00000020
    jal   label_b           # j ---' |           # 0x00000024
    addiu r3, r3, 0b010000  #        |           # 0x00000028
                            #        |           #
  label_c:                  # <------'           #
    addiu r3, r3, 0b100000  #                    # 0x000012c
    addiu r6, r31, 0        #                    # 0x0000130

    # Only the second bit should be set if jump was taken
    mtc0  r3, proc2mngr > 0b101010

    # Check the link addresses
    mtc0  r4, proc2mngr > 0x00000008
    mtc0  r5, proc2mngr > 0x00000028
    mtc0  r6, proc2mngr > 0x00000018

  """

# '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
