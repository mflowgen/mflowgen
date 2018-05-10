#=========================================================================
# conftest
#=========================================================================

import pytest
import random

def pytest_addoption(parser):

  parser.addoption( "--dump-vcd", action="store_true",
                    help="dump vcd for each test" )

  parser.addoption( "--dump-asm", action="store_true",
                    help="dump asm file for each test" )

  parser.addoption( "--dump-bin", action="store_true",
                    help="dump binary file for each test" )

  parser.addoption( "--test-verilog", action="store",
                    default='', nargs='?', const='zeros',
                    choices=[ '', 'zeros', 'ones', 'rand' ],
                    help="run verilog translation" )

  parser.addoption( "--prtl", action="store_true",
                    help="use PRTL implementations" )

  parser.addoption( "--vrtl", action="store_true",
                    help="use VRTL implementations" )

  parser.addoption( "--tech_node", action="store",
                    help="specify technology node for hard IPs" )

@pytest.fixture(autouse=True)
def fix_randseed():
  """Set the random seed prior to each test case."""
  random.seed(0xdeadbeef)

@pytest.fixture()
def dump_vcd(request):
  """Dump VCD for each test."""
  if request.config.option.dump_vcd:
    test_module = request.module.__name__
    test_name   = request.node.name
    return '{}.{}.vcd'.format( test_module, test_name )
  else:
    return ''

@pytest.fixture()
def dump_asm(request):
  """Dump Assembly File for each test."""
  return request.config.option.dump_asm

@pytest.fixture()
def dump_bin(request):
  """Dump Binary File for each test."""
  return request.config.option.dump_bin

@pytest.fixture
def test_verilog(request):
  """Test Verilog translation rather than python."""
  return request.config.option.test_verilog

@pytest.fixture
def tech_node(request):
  """Specified technology node for hard IPs (e.g., SRAMs)."""
  return request.config.option.tech_node

def pytest_cmdline_preparse(config, args):
  """Don't write *.pyc and __pycache__ files."""
  import sys
  sys.dont_write_bytecode = True

def pytest_runtest_setup(item):
  test_verilog = item.config.option.test_verilog
  if test_verilog and 'test_verilog' not in item.funcargnames:
    pytest.skip("ignoring non-Verilog tests")

def pytest_report_header(config):
  if config.option.prtl:
    return "forcing RTL language to be pymtl"
  elif config.option.vrtl:
    return "forcing RTL language to be verilog"

# From:
# https://pytest.org/latest/example/simple.html#detect-if-running-from-within-a-pytest-run

def pytest_configure(config):
  import sys
  sys._called_from_test = True

def pytest_unconfigure(config):
  import sys
  del sys._called_from_test
