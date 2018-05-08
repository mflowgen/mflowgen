#=========================================================================
# inst_bloom
#=========================================================================

import random

# Fix the random seed so results are reproducible
random.seed(0xdeadbeef)

from pymtl import *
from proc.test.inst_utils import *

# Bloom Filter Accelerator registers and values:
# Reg 0 (CSR 0x7e0): STATUS
#                    STATUS_DISABLED    0
#                    STATUS_ENABLED_R   1
#                    STATUS_ENABLED_W   2
#                    STATUS_ENABLED_RW  3
#                    STATUS_EXCEPTION   4
#
# This register controls the status of the unit. When it is disabled, the
# bloom filter does not insert additional items into the bloom filter.
# ENABLED_R/_W/_RW inserts the addresses of the memory requests on the
# snooped port (only reads, only writes, or reads and writes
# respectively). When the snooped protocol cannot accept a message, the
# accelerator goes into the exception state.
#
# Reg 1 (CSR 0x7e1): CHECK_VALUE
#                    CHECK_VALUE_DONE   0
#
# When CHECK_VALUE is set to a value other than CHECK_VALUE_DONE, that
# value is searched in the bloom filter. This register then changes back
# to CHECK_VALUE. The result of the check is written to the CHECK_RESULT
# register.
#
# Reg 2 (CSR 0x7e2): CHECK_RESULT
#                    CHECK_RESULT_INV   0
#                    CHECK_RESULT_YES   1
#                    CHECK_RESULT_NO    2
#
# This register contains the result of a check as initiated by the
# CHECK_VALUE register. The CHECK_RESULT_INV indicates the invalid state,
# and while the bloom filter hasn't finished checking the value, this is
# the value this register contains. Once the bloom filter finishes
# checking, this register will contain the respective value whether the
# CHECK_VALUE value was in the bloom filter or not. Once this register is
# read, the value goes back to CHECK_RESULT_INV.
#
# Reg 3 (CSR 0x7e3): CLEAR
#                    CLEAR_DONE         0
#                    CLEAR_REQUESTED    1
#
# This register can be used to request clearing of the bloom filter. It is
# set back to CLEAR_DONE when clearing is done.

#-------------------------------------------------------------------------
# gen_basic_asm_test
#-------------------------------------------------------------------------

def gen_basic_test():
  return """
    csrr x1, mngr2proc < 0x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw 0x7e0, x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrr x2, 0x7e0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw proc2mngr, x2 > 0x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # Clear the bloom filter.
    csrw 0x7e3, x1
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # Check an address in the bloom filter; shouldn't exist.
    csrr x2, mngr2proc < 0x2000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw 0x7e1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrr x3, 0x7e2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # Expect not to exist.
    csrw proc2mngr, x3 > 0x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # Now do a load from that address.
    lw x3, 0(x2)
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrw 0x7e1, x2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    csrr x3, 0x7e2
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    # Expect to find this in the filter now.
    csrw proc2mngr, x3 > 0x1
  """

#-------------------------------------------------------------------------
# gen_bypass_asm_test
#-------------------------------------------------------------------------

def gen_bypass_test():
  return """

    csrr x2, mngr2proc < 0x1
    {nops_3}
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    {nops_3}
    csrw proc2mngr, x3 > 0x1

    csrr x2, mngr2proc < 0x2
    {nops_2}
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    {nops_2}
    csrw proc2mngr, x3 > 0x2

    csrr x2, mngr2proc < 0x3
    {nops_1}
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    {nops_1}
    csrw proc2mngr, x3 > 0x3

    csrr x2, mngr2proc < 0x0
    csrw 0x7e0, x2
    csrr x3, 0x7e0
    csrw proc2mngr, x3 > 0x0

  """.format(
    nops_3=gen_nops(3),
    nops_2=gen_nops(2),
    nops_1=gen_nops(1)
  )

#-------------------------------------------------------------------------
# gen_basic2_test
#-------------------------------------------------------------------------
# Same as basic, but without the nops.

def gen_basic2_test():
  return """
    csrr x1, mngr2proc < 0x1
    csrw 0x7e0, x1
    csrr x2, 0x7e0
    csrw proc2mngr, x2 > 0x1
    # Clear the bloom filter.
    csrw 0x7e3, x1
    # Check an address in the bloom filter; shouldn't exist.
    csrr x2, mngr2proc < 0x2000
    csrw 0x7e1, x2
    # Loop over until it's resolved.
  chk1:
    csrr x3, 0x7e2
    beq  x3, x0, chk1
    # Expect not to exist.
    csrw proc2mngr, x3 > 0x2
    # Now do a load from that address.
    lw x3, 0(x2)
    csrw 0x7e1, x2
  chk2:
    csrr x3, 0x7e2
    beq  x3, x0, chk2
    # Expect to find this in the filter now.
    csrw proc2mngr, x3 > 0x1
  """

#-------------------------------------------------------------------------
# gen_steam_test
#-------------------------------------------------------------------------

def gen_stream_test():
  min_addr = 0x2000
  max_addr = 0x2400
  num_mem_accesses = 20
  num_check = 8
  # Generate random memory accesses.
  random.seed( 0xdeadbeef )
  mem_accesses = [ ( random.choice(["r", "w"]),
                     random.randrange(min_addr, max_addr, 4) ) for i in
                     xrange( num_mem_accesses ) ]

  header = """
  header:
  """.format( min_addr )

  # Build the steam.
  stream = "\n  stream:\n"

  for access_type, addr in mem_accesses:
    stream += "    {} x{}, 0x{:x}(x2)\n".format( "lw" if access_type == "r" else "sw",
                                                 random.randint( 10, 16 ),
                                                 addr - min_addr )

  stream += "    jalr x0, x5, 0\n"

  check_dict = {}
  for check_type in ["r", "w", "rw", "d"]:
    check = "\n  check_{}:\n".format( check_type )

    for i in xrange( num_check ):
      # We randomly check a value that's in the memory stream or not.
      # Since rw case can cause a lot of false positives, only check
      # values that are in the filter.
      if check_type == "rw" or random.choice([True, False]):
        # In the memory stream.
        access_type, addr = random.choice( mem_accesses )
        exp_value = 1 if access_type in check_type else 2
      else:
        addr = random.randrange(min_addr, max_addr, 4)
        while ("r", addr) in mem_accesses or ("w", addr) in mem_accesses:
          addr = random.randrange(min_addr, max_addr, 4)
        exp_value = 2

      check += """
    csrr x4, mngr2proc < 0x{addr:x}
    csrw 0x7e1, x4
  chk_{check_type}_{i}:
    csrr x6, 0x7e2
    beq  x6, x0, chk_{check_type}_{i}
    csrw proc2mngr, x6 > {exp_value}
      """.format( **locals() )

    check_dict[ check_type ] = check

  code = """
    csrr x1, mngr2proc < 0x1
    # Clear the bloom filter.
    csrw 0x7e3, x1
    # Enable for reads only.
    csrw 0x7e0, x1
    csrr x2, mngr2proc < 0x{min_addr:x}
    beq  x0, x0, cont
  {stream}
  cont:
    jal x5, stream
  {check_dict[r]}
    # Reset the filter and change the mode to rw.
    csrr x1, mngr2proc < 0x1
    csrw 0x7e3, x1
    csrr x1, mngr2proc < 0x3
    csrw 0x7e0, x1
    jal x5, stream
  {check_dict[rw]}
    # Reset the filter and change the mode to w.
    csrr x1, mngr2proc < 0x1
    csrw 0x7e3, x1
    csrr x1, mngr2proc < 0x2
    csrw 0x7e0, x1
    jal x5, stream
  {check_dict[w]}
    # Reset the filter and change the mode to disabled.
    csrr x1, mngr2proc < 0x1
    csrw 0x7e3, x1
    csrr x1, mngr2proc < 0x0
    csrw 0x7e0, x1
    jal x5, stream
  {check_dict[d]}
  """.format( **locals() )

  print code
  return code


