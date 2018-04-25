#=========================================================================
# csr: csrr mngr2proc/numcores/coreid and csrw proc2mngr/stats_en
#=========================================================================

import random

from pymtl import *
from proc.test.inst_csr import gen_basic_test, gen_bypass_test, \
                                    gen_value_test, gen_random_test
#-------------------------------------------------------------------------
# num_cores and core_id tests; turn on -s to see stats_on/off trace
#-------------------------------------------------------------------------

def gen_multicore_test( num_cores=4 ):

  numcores_str = str(num_cores)
  coreid_str = "{{{}}}".format( ",".join( map(lambda x:str(x),range(num_cores)) ) )

  return """
    # Turn on stats here
    addi x1, x0, 1
    csrw stats_en, x1

    # Example of using a list of values
    csrr x2, mngr2proc < {{1,2,3,4}}
    csrw proc2mngr, x2 > {{1,2,3,4}}

    # Check numcores/coreid
    csrr x2, numcores
    csrw proc2mngr, x2 > {}
    csrr x2, coreid
    csrw proc2mngr, x2 > {}

    # Turn off stats here
    csrw stats_en, x0
    nop
    nop
    # dummy
    addi x1, x0, 1
    csrw proc2mngr, x1 > 1
    nop
    nop
    nop
  """.format( numcores_str, coreid_str )
  
