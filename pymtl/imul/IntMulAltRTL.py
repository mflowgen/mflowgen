#=========================================================================
# Choose PyMTL or Verilog version
#=========================================================================
# Set this variable to 'pymtl' if you are using PyMTL for your RTL design
# (i.e., your design is in IntMultAltPRTL) or set this variable to
# 'verilog' if you are using Verilog for your RTL design (i.e., your
# design is in IntMulAltVRTL).

rtl_language = 'pymtl'

#-------------------------------------------------------------------------
# Do not edit below this line
#-------------------------------------------------------------------------

# See if the course staff want to force testing a specific RTL language
# for their own testing.

import sys
if hasattr( sys, '_called_from_test' ):

  import pytest
  if pytest.config.getoption('prtl'):
    rtl_language = 'pymtl'
  elif pytest.config.getoption('vrtl'):
    rtl_language = 'verilog'

# Import the appropriate version based on the rtl_language variable

if rtl_language == 'pymtl':
  from IntMulAltPRTL import IntMulAltPRTL as IntMulAltRTL
elif rtl_language == 'verilog':
  from IntMulAltVRTL import IntMulAltVRTL as IntMulAltRTL
else:
  raise Exception("Invalid RTL language!")

