#=========================================================================
# assertion_helpers.py
#=========================================================================
# Helper functions for assertions
#
# Author : Maxwell Strange
# Date   : July 10, 2020
#

from glob import glob

# Checks output of verify_drc command for any shorts...
def get_shorts():

  # Read verify_drc report...
  with open( glob('logs/*verify_drc.log')[0] ) as fd:
    lines = fd.readlines()

  # Looking for SHORT: with Regular Wire and not Routing Blockage
  shorts_lines = [ l for l in lines if 'SHORT:' in l and 'Regular Wire' in l and 'Routing Blockage' not in l ]
  return shorts_lines

