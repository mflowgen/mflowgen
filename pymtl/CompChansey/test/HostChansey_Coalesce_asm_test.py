#=========================================================================
# HostChansey_Coalesce_asm_test.py
#=========================================================================

import os
import importlib

import pytest

from pymtl                   import *
from fpga                    import SwShim

from Chansey_harness         import asm_test
from Chansey_harness         import TestHarness
from Chansey_harness         import run_test as run

# Import designs
from CompChansey.Chansey     import Chansey
from CompChansey.HostChansey import HostChansey

# Import new run_test
from HostChansey_Coalesce_run_test    import run_test as _run_test

#-------------------------------------------------------------------------
# Import original run_test
#-------------------------------------------------------------------------

import Chansey_run_test

#-------------------------------------------------------------------------
# Override old run_test
#-------------------------------------------------------------------------

Chansey_run_test.run_test = _run_test

#-------------------------------------------------------------------------
# Import test cases automatically
#-------------------------------------------------------------------------
# We inpsect current file name and import the python file with the same
# name ignoring the Host prefix

# Get currect Python file name
filename = os.path.basename(__file__).rsplit('.', 1)[0]

if filename.startswith('Host'): filename = filename[len('Host'):]

filename = filename.replace( '_Coalesce', '' )

# Get Host filename
module = importlib.import_module('.' + filename, __package__)

for func in dir(module):
  if not func in globals():
    globals()[func] = getattr(module, func)
