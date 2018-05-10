#=========================================================================
# HostAerodactyl_test
#=========================================================================

import os
import importlib

import pytest

from pymtl import *

#-------------------------------------------------------------------------
# Import all _test that matches the file name
#-------------------------------------------------------------------------

# Get filename and directory
filename = os.path.basename(__file__).rsplit('.', 1)[0]
dirname  = os.path.dirname(os.path.realpath(__file__))

# Get base design name
design_name = filename.rsplit('_', 1)

# Checks
assert design_name[-1] == 'test'

# List all files in current directory
for root, dirs, files in os.walk(dirname):

  # Loop over all files in the dorectoy
  for f in files:

    mod_name = f.rsplit('.', 1)[0]

    load_mod  = mod_name.endswith(design_name[-1])
    load_mod &= mod_name.startswith('_'.join(design_name[:-1]))
    load_mod &= (mod_name != filename)

    if load_mod:

      # Load the module
      f_path = os.path.join(root, f)

      module = importlib.import_module(mod_name)

      for func in dir(module):
        # If there is no conflict, load the module to globals
        if not func in globals():
          globals()[func] = getattr(module, func)
