#=========================================================================
# jal
#=========================================================================

import random

from pymtl import *
from proc.test.inst_utils import gen_nops

#-------------------------------------------------------------------------
# gen_basic_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """

    # Use r3 to track the control flow pattern
    addi  x3, x0, 0     # 0x0200
                        #
    nop                 # 0x0204
    nop                 # 0x0208
    nop                 # 0x020c
    nop                 # 0x0210
    nop                 # 0x0214
    nop                 # 0x0218
    nop                 # 0x021c
    nop                 # 0x0220
                        #
    jal   x1, label_a   # 0x0224
    addi  x3, x3, 0b01  # 0x0228

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
    csrw  proc2mngr, x1 > 0x0228 

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3 > 0b10

  """
#-------------------------------------------------------------------------
# gen_link_dep_test
#-------------------------------------------------------------------------
# Expected link address has to be hard coded based on the number of bytes
# in each generated test. Not great, but the best we can do for now.
#
# Currently we have to hard code the expected link address. Not sure if
# there is a cleaner way to do this.

# We currently need the id to create labels unique to this test. We might
# eventually allow local labels (e.g., 1f, 1b) as in gas.

gen_jal_link_dep_id = 0

def gen_jal_link_dep_test( num_nops, link_addr ):

  global gen_jal_link_dep_id

  # Create unique labels

  id_a = "label_{}".format( gen_jal_link_dep_id + 1 )
  gen_jal_link_dep_id += 1

  return """

    # Use x3 to track the control flow pattern
    addi  x3, x0, 0

    jal   x1, {id_a}
    addi  x3, x3, 0b01

{id_a}:
    {nops}
    csrw  proc2mngr, x1 > {link_addr}
    addi  x3, x3, 0b10

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3 > 0b10

  """.format(
    nops = gen_nops(num_nops),
    **locals()
  )

gen_jal_template_id = 0

def gen_jal_test(
  num_nops
):

  # Determine the expected control flow pattern

  control_flow_pattern = 0b101100100

  # Create unique labels

  global gen_jal_template_id
  id_a = "label_{}".format( gen_jal_template_id + 1 )
  id_b = "label_{}".format( gen_jal_template_id + 2 )
  id_c = "label_{}".format( gen_jal_template_id + 3 )
  gen_jal_template_id += 3

  return """
    # x3 will track the control flow pattern
    addi  x3, x0, 0                             # 0x0200
                                                # 
    jal x4, {id_b}                 # j -.       # 0x0204
    addi  x3, x3, 0b000000001      #    |       # 0x0208
                                   #    |       #
    {nops}                         #    |       # 0x0208 + 4*num_nops
                                   #    |       #
    addi  x3, x3, 0b000000010      #    |       # 0x20c + 4*num_nops
{id_a}:                            # <--+-.     #
    addi  x3, x3, 0b000000100      #    | |     # 0x210 + 4*num_nops
                                   #    | |     #
    jal x6, {id_c}                 # j -+-+-.   # 0x214 + 4*num_nops
    addi  x3, x3, 0b000001000      #    | | |   # 0x218 + 4*num_nops
                                   #    | | |   #
    {nops}                         #    | | |   # 0x218 + 2*4*num_nops 
                                   #    | | |   #
    addi  x3, x3, 0b000010000      #    | | |   # 0x21c + 2*4*num_nops
{id_b}:                            # <--' | |   # 
    addi  x3, x3, 0b000100000      #      | |   # 0x220 + 2*4*num_nops
                                   #      | |   #
    {nops}                         #      | |   # 0x220 + 3*4*num_nops
                                   #      | |   #
    addi  x3, x3, 0b001000000      #      | |   # 0x224 + 3*4*num_nops
    jal x5, {id_a}                 # j ---' |   # 0x228 + 3*4*num_nops
    addi  x3, x3, 0b010000000      #        |   # 0x22c + 3*4*num_nops
                                   #        |
{id_c}:                            # <------'   #
    addi  x3, x3, 0b100000000      #            #
    csrw  proc2mngr, x4 > {ret_a} 
    csrw  proc2mngr, x5 > {ret_b}
    csrw  proc2mngr, x6 > {ret_c}               #
    # Check the control flow pattern
    csrw  proc2mngr, x3 > {control_flow_pattern}
  """.format(
    nops = gen_nops(num_nops),
    ret_a = 0x208,
    ret_b = 0x22c + (4 * 3 * (num_nops)),
    ret_c = 0x218 + (4 * (num_nops)),
    **locals()
  )

def gen_link_dep_test():
  return [
    gen_jal_link_dep_test( 5, 0x0208 ),
    gen_jal_link_dep_test( 4, 0x0234 ),
    gen_jal_link_dep_test( 3, 0x025c ),
    gen_jal_link_dep_test( 2, 0x0280 ),
    gen_jal_link_dep_test( 1, 0x02a0 ),
    gen_jal_link_dep_test( 0, 0x02bc ),
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
    # Use x3 to track the control flow pattern   #
    addi  x3, x0, 0                              # 0x00000200
                                                 #
    jal   x1, label_a       # j -.               # 0x00000204
    addi  x3, x3, 0b000001  #    |               # 0x00000208
                            #    |               #
  label_b:                  # <--+-.             #
    addi  x3, x3, 0b000010  #    | |             # 0x0000020c
    addi  x5, x1,  0        #    | |             # 0x00000210
    jal   x1, label_c       # j -+-+-.           # 0x00000214
    addi  x1, x3, 0b000100  #    | | |           # 0x00000218
                            #    | | |           #
  label_a:                  # <--' | |           #
    addi  x3, x3, 0b001000  #      | |           # 0x0000021c
    addi  x4, x1, 0         #      | |           # 0x00000220
    jal   x1, label_b       # j ---' |           # 0x00000224
    addi  x3, x3, 0b010000  #        |           # 0x00000228
                            #        |           #
  label_c:                  # <------'           #
    addi  x3, x3, 0b100000  #                    # 0x0000022c
    addi  x6, x1, 0         #                    # 0x00000230

    # Only the second bit should be set if jump was taken
    csrw  proc2mngr, x3 > 0b101010

    # Check the link addresses
    csrw  proc2mngr, x4 > 0x00000208
    csrw  proc2mngr, x5 > 0x00000228
    csrw  proc2mngr, x6 > 0x00000218

  """

#-------------------------------------------------------------------------
# gen_back_to_back_test
#-------------------------------------------------------------------------
# Performs a series of backwards jal instructions and checks that the 
# correct link address is saved for a subset of these jumps.

def gen_back_to_back_test():
  return """
    csrr  x3, mngr2proc < 1                                                             
    jal   x4, a0                                     # 0x204                     
    # send zero if fail                              
    csrw  proc2mngr, x0      # don't expect a value  # 0x208
    y0:
    csrw  proc2mngr, x3 > 1                          # 0x20c
    jal   x7, z0                                     # 0x210
    h0:
    jal   x0, y0                                     # 0x214
    g0:
    jal   x0, h0
    f0:
    jal   x0, g0
    e0:
    jal   x0, f0
    d0:
    jal   x0, e0
    c0:
    jal   x0, d0
    b0:
    jal   x6, c0                                    # 0x210 + 4*7
    a0:
    jal   x5, b0                                    # 0x210 + 4*8
    z0:
    jal   x8, a1                                    # 0x210 + 4*9
    # send zero if fail
    csrw  proc2mngr, x0      # don't expect a value # 0x214 + 4*9
    y1:
    csrw  proc2mngr, x3 > 1                         # 0x218 + 4*9
    jal   x11, z1                                   # 0x21c + 4*9
    h1:
    jal   x10, y1                                   # 0x21c + 4*10
    g1: 
    jal   x0, h1
    f1:
    jal   x0, g1
    e1:
    jal   x0, f1
    d1:
    jal   x0, e1
    c1:
    jal   x0, d1
    b1:
    jal   x0, c1
    a1:
    jal   x9, b1                                    # 0x21c + 4*17
    z1:
    jal   x12, a2                                   # 0x21c + 4*18
    # send zero if fail
    csrw  proc2mngr, x0      # don't expect a value # 0x220 + 4*18  
    y2:
    csrw  proc2mngr, x3 > 1                         # 0x224 + 4*18
    jal   x15, z2                                   # 0x228 + 4*18 
    h2:
    jal   x14, y2                                   
    g2:
    jal   x0, h2
    f2:
    jal   x0, g2
    e2:
    jal   x0, f2
    d2:
    jal   x0, e2
    c2:
    jal   x0, d2
    b2:
    jal   x0, c2
    a2:
    jal   x13, b2
    z2:
    jal   x16, y3                                   # 0x228 + 4*27
    # send zero if fail
    csrw  proc2mngr, x0      # don't expect a value # 0x22c + 4*27 
    y3:
    csrw proc2mngr, x3 > 1
    csrw proc2mngr, x4  > {addr_4}
    csrw proc2mngr, x5  > {addr_5}
    csrw proc2mngr, x6  > {addr_6}
    csrw proc2mngr, x7  > {addr_7}
    csrw proc2mngr, x8  > {addr_8}
    csrw proc2mngr, x9  > {addr_9}  
    csrw proc2mngr, x10 > {addr_10}
    csrw proc2mngr, x11 > {addr_11}
    csrw proc2mngr, x12 > {addr_12}
    csrw proc2mngr, x13 > {addr_13}
    csrw proc2mngr, x14 > {addr_14}
    csrw proc2mngr, x15 > {addr_15}
    csrw proc2mngr, x16 > {addr_16}
    nop
    nop
    nop
    nop
    nop
    nop
  """.format(addr_4 = 0x208, 
             addr_5 = 0x210 + 4*9, 
	     addr_6 = 0x210 + 4*8, 
             addr_7 = 0x214, 
             addr_8 = 0x214 + 4*9,
             addr_9 = 0x21c + 4*18,
             addr_10 = 0x21c + 4*11,
             addr_11 = 0x21c + 4*10 ,
             addr_12 = 0x220 + 4*18, 
             addr_13 = 0x228 + 4*27,
             addr_14 = 0x228 + 4*20,
             addr_15 = 0x228 + 4*19,
             addr_16 = 0x22c + 4*27,
             **locals()
  )

#-----------------------------------------------------------------------
# gen_jal_stall_test
#-----------------------------------------------------------------------
# Test that a stalling jump does not originate a squash while it is
# stalled. Squashing while stalled will send the squash signal again
# Squash signal in D should look something like this:
# assign osquash_D = val_D && !stall_D && osquash_j_D;
# Needs to not be stalling, otherwise front of the pipeline will
# keep getting squashed and fetch more instructions

def gen_jal_stall_test():
  return """
    csrr x5, mngr2proc < 15
    csrr x6, mngr2proc < 15
    addi x3, x0, 0
    addi x4, x0, 0
    # multiply will stall jump command
    mul x5, x5, x6
    jal  x1, label_a
    # this addition should be squashed
    addi x4, x3, 1
    label_a:
    addi x4, x4, 1
    addi x3, x3, 2    
    csrw proc2mngr, x5 > 225
    csrw proc2mngr, x4 > 1
    csrw proc2mngr, x3 > 2    
  """
  
#-------------------------------------------------------------------------
# gen_value_tests
#-------------------------------------------------------------------------
# Uses the gen_jal_template defined in test_utils to vary the number of 
# nops between jal instructions. Tests include two forward jumps and one
# backwards jump.

def gen_value_test_0():
  return [
    gen_jal_test(   0  ),
  ]

def gen_value_test_1():
  return [
    gen_jal_test(   1  ),
  ]

def gen_value_test_2():
  return [
    gen_jal_test(   10  ),
  ]

def gen_value_test_3():
  return [
    gen_jal_test(   255 ),
  ]
