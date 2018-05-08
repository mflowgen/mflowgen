#=========================================================================
# HostButterfree_mdu_test.py
#=========================================================================

import os
import importlib

import pytest

from pymtl                         import *
from fpga                          import SwShim

from Butterfree_harness            import asm_test
from Butterfree_harness            import TestHarness
from Butterfree_harness            import run_test as run

# Import designs
from CompButterfree.Butterfree     import Butterfree
from CompButterfree.HostButterfree import HostButterfree

# Import new run_test
from HostButterfree_run_test       import run_test as _run_test

#-------------------------------------------------------------------------
# Import original run_test
#-------------------------------------------------------------------------

import Butterfree_run_test

#-------------------------------------------------------------------------
# Override old run_test
#-------------------------------------------------------------------------

Butterfree_run_test.run_test = _run_test

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
