#=========================================================================
# assertion_helpers.py
#=========================================================================
# Functions for dumping assertion checking scripts
#
# Author : Christopher Torng
# Date   : March 13, 2020
#

import os
import re
import stat

from mflowgen.utils import read_yaml

#-------------------------------------------------------------------------
# template_pytest_file
#-------------------------------------------------------------------------

# Insert this into the template_pytest_file if we assume that users did
# not pip install mflowgen and are just running out of the repo.
#
# #-------------------------------------------------------------------------
# # temporary -- until mflowgen is available as an install
# #-------------------------------------------------------------------------
# # Find mflowgen repo so we can import classes from it
#
# import os
#
# def get_top_dir( flag='.MFLOWGEN_TOP', relative=True ):
#   try:
#     return os.environ[ 'MFLOWGEN_HOME' ]
#   except KeyError:
#     tmp = os.getcwd()
#     while tmp != '/':
#       tmp = os.path.dirname( tmp )
#       if flag in os.listdir( tmp ):
#         break
#
#     if not relative:
#       return tmp
#     else:
#       return os.path.relpath( tmp, os.getcwd() )
#
# import sys
# sys.path.insert( 0, get_top_dir() )
#
# #-------------------------------------------------------------------------

template_pytest_file='''\
#! /usr/bin/env mflowgen-python
#-------------------------------------------------------------------------
# mflowgen-check-{check_type}.py
#-------------------------------------------------------------------------
# Generated: {gen}

import pytest
import sys

from mflowgen.assertions import File, Tool

RED   = '\033[31m'
GREEN = '\033[92m'
END   = '\033[0m'

{tests}

def main():

  print()
  print( GREEN + '    > Checking {check_type} for step "{step}"' + END )
  print()

  files        = [ __file__, {pyfiles} ]
  exit_status  = []

  for f in files:

    # Options for short clean printout:
    #
    # - q         : quiet and short
    # - rA        : print one line per pass/fail test in the short test
    #             :   summary info
    # - tb=short  : shorter traceback printout
    # - color=yes : color
    #

    pytest_args = [ '-q', '-rA', '--disable-warnings',
                    '--tb=short', '--color=yes', '--noconftest', f ]
    print( 'pytest ' + ' '.join( pytest_args ) )
    status = pytest.main( pytest_args )
    exit_status.append( status )
    print()

  # Exit with an error if any test has failed

  if any( exit_status ):
    sys.exit( 1 )

if __name__ == '__main__':
  main()

'''

#-------------------------------------------------------------------------
# template_pytest_str
#-------------------------------------------------------------------------

template_pytest_str = '''
def test_{name}():
{code}
'''

# Version with custom AssertionError handling
#
# In this version, the assertion error is replaced with the Python
# statement that the user wrote (code_oneline). This helps because we are
# generating the pytest functions, and the user does not know what
# "test_5" does. The idea here is to make clear at least which test has
# failed.

# template_pytest_str = '''
# def test_{name}():
#   try:
# {code}
#   except AssertionError as e:
#     e.args = ( RED + """ {code_oneline} """ + END, )
#     raise
# '''

#-------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------

# sanitize
#
# Replace any odd characters with underscores
#

def sanitize( x ):
  out = x.lower()
  out = re.sub( r'[^\w]', '_', x.lower() )
  return out

# indent
#
# Indents all text by two spaces
#

def indent( text, spaces=2 ):
  out = '\n'.join( [ ' '*spaces + l for l in text.splitlines() ] )
  return out

# improve_assert_messages
#
# Indents all text by two spaces
#

def improve_assert_messages( entry ):
  out = '\n'.join( [ ' '*spaces + l for l in entry.splitlines() ] )
  return out

#-------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------

# dump_assertion_check_scripts
#
# Given a directory with a configure.yml containing preconditions and
# postconditions, generates two python files that pytest can target to run
# all preconditions and all postconditions.
#
# Expected yaml contents:
#
#     preconditions:
#       - assert File( 'inputs/adk'             )  # Python: Assert exists
#       - assert File( 'inputs/design.v'        )  # Python: Assert exists
#       - assert File( 'inputs/constraints.tcl' )  # Python: Assert exists
#       - pytest: test_foo.py                      # Custom tests
#
#     postconditions:
#       - assert File( 'outputs/design.v'   )      # Python: Assert exists
#       - assert File( 'outputs/design.sdc' )      # Python: Assert exists
#       - |                                        # (YAML multiline mark)
#         import math                              # Python: Multiline
#         assert math.pi > 3.00                    #         statements
#

def dump_assertion_check_scripts( step_name, dir_name ):

  yaml_path = dir_name + '/configure.yml'
  data      = read_yaml( yaml_path )

  # Look at both preconditions and postconditions

  assertion_types = [ 'preconditions', 'postconditions' ]

  for t in assertion_types:

    # If no pre/post conditions are defined, continue

    try:
      data[t]
    except KeyError:
      continue

    if not data[t]:
      continue

    # Each entry in the list specifies Python statement(s) that represent
    # a single test. We aggregate all the tests into the "tests_str"
    # string and dump it into the script all at once. We also collect any
    # explicit pytest scripts into the "pyfiles" list.

    tests_str = ''
    pyfiles   = []

    for i, entry in enumerate( data[t] ):

      # If the entry specifies a pytest file, grab it

      if type( entry ) == dict:

        try:
          pyfile = "'{}'".format( entry['pytest'] )
        except KeyError:
          msg = '\nUnsupported assertion of type "dict" ' + \
                'in step "{}". '.format( step_name ) + \
                'If there is a colon in this assertion, you must ' + \
                'put quotes around the entire string ' + \
                'and properly escape the special characters inside ' + \
                'with YAML syntax:\n\n- {}\n'.format( entry )
          print( msg )
          raise

        pyfiles.append( pyfile )

      # Otherwise, treat it as normal Python and wrap it up as a function
      # that pytest can run

      else:

        try:
          compile( entry, '', 'exec' ) # make sure it compiles as Python

        except Exception as e: # if it does not compile, complain nicely
          print()
          print( 'Exception in {} #{} for step {}'.format( t[:-1], i,
                                                           step_name ) )
          print()
          print( '    >>> ' + entry )
          print()
          raise e

        # Generate a function that pytest can run
        #
        # - Wrap the test in a try except to rewrite the Assertion message
        #

        nchars    = 0 # first N chars of entry appear in the function name
        func_name = str(i) + '_' + sanitize( entry[:nchars] )

        code         = indent(entry, 4)
        #code_oneline = '  ->  '.join( entry.splitlines() )

        tests_str += template_pytest_str.format(
            name         = func_name,
            code         = code )

    # Dump the pytest functions to file by filling in a template

    fpath = dir_name + '/mflowgen-check-'+t+'.py'

    with open( fpath, 'w' ) as fd:
      fd.write( template_pytest_file.format(
                  step       = step_name,
                  tests      = tests_str,
                  check_type = t,
                  gen        = os.path.abspath( __file__ ).rstrip('c'),
                  pyfiles    = ', '.join( pyfiles ) ) )

    # Make it executable

    os.chmod( fpath, os.stat( fpath ).st_mode | stat.S_IEXEC )


