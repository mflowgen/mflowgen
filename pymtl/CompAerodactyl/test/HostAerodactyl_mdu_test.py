#=========================================================================
# HostAerodactyl_mdu_test.py
#=========================================================================

import os
import importlib

import pytest

from pymtl                         import *
from fpga                          import SwShim

from Aerodactyl_harness            import asm_test
from Aerodactyl_harness            import TestHarness
from Aerodactyl_harness            import run_test as run

# Import designs
from CompAerodactyl.Aerodactyl     import Aerodactyl
from CompAerodactyl.HostAerodactyl import HostAerodactyl

# Import new run_test
from HostAerodactyl_run_test       import run_test as _run_test

#-------------------------------------------------------------------------
# Import original run_test
#-------------------------------------------------------------------------

import Aerodactyl_run_test

#-------------------------------------------------------------------------
# Override old run_test
#-------------------------------------------------------------------------

Aerodactyl_run_test.run_test = _run_test

#-------------------------------------------------------------------------
# Import test cases automatically
#-------------------------------------------------------------------------
# We inpsect current file name and import the python file with the same
# name ignoring the Host prefix

# Get currect Python file name
filename = os.path.basename(__file__).rsplit('.', 1)[0]

if filename.startswith('Host'): filename = filename[4:]

# Get Host filename
module = importlib.import_module(filename)

for func in dir(module):
  if not func in globals():
    globals()[func] = getattr(module, func)
