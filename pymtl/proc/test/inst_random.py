#=========================================================================
# Random assembly test
#=========================================================================

# point to subtree

import os, sys
cur_dir = os.path.dirname( os.path.realpath(__file__) )
sys.path.append( os.path.join( cur_dir, '..', '..', '..', 'subtrees',
                               'aik49-rasmgen' ) )

from parc.randasm_test.randasm_test_nobranch import gen_test, insert_values
from parc.randasm_test.test_utils            import write_code_to_file
from parc.randasm_test.harness               import run_test
from parc.ProcFL                             import ProcFL

#-------------------------------------------------------------------------
# config from aik49-rasmgen
#-------------------------------------------------------------------------
# The number of instructions total to generate (not counting initial mfc0s,
# initial saves or the blocks of mtc0s used for checking
# n_inst            = 1000
# The number of instructions to generate before generating a verifying block
# n_inst_per_block  = 100
# The base address in memory used for storing the data
# base_address      = 0
# The register that will hold the base address
# base_address_reg  = r1
# The registers that are available to the generated instructions
# reg_range         = (2, 31)
# The range of memory the program works in (NOT USED CURRENTLY)
# mem_range         = (0, 2000)
# Range used for generating random values that are used as data
# val_range         = (1, 40)

def gen_random_asm_test( n_inst=1000, n_inst_per_block=100, base_address=0,
                         base_address_reg='r1', reg_range=(2,31),
                         mem_range=(0,2000), val_range=(1, 40) ):
  # Generate the code
  asm_code, num_msgs = gen_test( n_inst, n_inst_per_block, base_address,
                                 base_address_reg, reg_range, mem_range, val_range )
  # Run the generated code to get the expected register states
  reg_states = run_test(ProcFL, asm_code, num_msgs)
  # Run the generated code to get the expected register states
  asm_code = insert_values( asm_code, reg_states )
  return asm_code

