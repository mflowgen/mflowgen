#=========================================================================
# mock_handler.py
#=========================================================================
# Sets up a mock graph to "unit test" a step in an mflowgen environment
#
# Author : Christopher Torng
# Date   : March 17, 2020
#

import os
import shutil
import sys

from mflowgen.core  import RunHandler
from mflowgen.utils import bold

class MockHandler:

  def __init__( s ):

    # Valid commands

    s.commands = [
      'init',
      'help',
    ]


  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for commands

  def launch( s, args, help_, path ):

    if help_ and not args:
      s.launch_help()
      return

    try:
      command = args[0]
      assert command in s.commands # valid commands only
    except Exception as e:
      print( 'mock: Unrecognized commands (see "mflowgen mock help")' )
      sys.exit( 1 )

    try:
      assert len( args ) <= 1 # no further positional args are allowed
    except Exception as e:
      print()
      print( 'mock: Unrecognized positional args' )
      # Allow this exception to pass, but force set the "help" flag so
      # users can see what they should be doing instead.
      help_ = True

    if   command == 'init' : s.launch_init( help_, path )
    else                   : s.launch_help()


  #-----------------------------------------------------------------------
  # launch_init
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Reads a step configure.yml
  # - Copies in a template construct.py and fills it in with step info
  # - Launches "mflowgen run" on the mock graph to create the environment
  #

  def launch_init( s, help_, path ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen mock init',
                                  '--path/-p <path/to/step/dir>'       )
      print()
      print( bold( 'Example:' )                                        )
      print()
      print( '  % cd mflowgen/steps'                                   )
      print( '  % mkdir build && cd build'                             )
      print( '  % mflowgen mock init --path ../synopsys-dc-synthesis'  )
      print()
      print( 'Creates a mock-up graph to help develop a modular step.' )
      print( 'The mock-up contains the "design-under-test" node and a' )
      print( '"push" node that connects to the inputs. You can place'  )
      print( 'inputs to your step in this node with full access to'    )
      print( 'normal build targets (e.g., make status) to make sure'   )
      print( 'your step works.'                                        )
      print()

    if help_ or not path:
      print_help()
      return

    # Make sure we are not building while nested inside the step itself
    #
    # This will lead to a possibly infinite recursive copy
    #

    try:
      assert os.path.abspath( path ) not in os.path.abspath( '.' )
    except AssertionError:
      print()
      print( bold( 'Error:' ), 'Nesting a mock build within the target'  )
      print( 'directory given by --path is currently not allowed.'       )
      print()
      sys.exit( 1 )

    # Make sure the given path points to a step with a configure.yml

    try:
      assert os.path.exists( path + '/configure.yml' )
    except AssertionError:
      print()
      print( bold( 'Error:' ), 'Option --path must point to a directory' )
      print( 'that has a step configuration file "configure.yml"'        )
      print()
      sys.exit( 1 )

    # Copy the construct.py template and mock-push step to the current
    # directory

    mock_src_dir = os.path.dirname( __file__ )

    construct_template = 'construct.py.template'
    mock_push_template = 'mock-push'

    construct_template_dst = './' + construct_template
    mock_push_template_dst = './' + mock_push_template

    try:
      os.remove       ( construct_template_dst ) # force replace
    except FileNotFoundError:
      pass
    try:
      shutil.rmtree   ( mock_push_template_dst ) # force replace
    except FileNotFoundError:
      pass

    try:
      shutil.copy2    ( src = mock_src_dir + '/' + construct_template,
                        dst = construct_template_dst )
      shutil.copytree ( src = mock_src_dir + '/' + mock_push_template,
                        dst = mock_push_template_dst )
    except Exception as e:
      print( bold( 'Error:' ), 'Failed to copy from mflowgen src' )
      raise

    # Fill in the construct.py template for the given step

    with open( 'construct.py', 'w' ) as f1:
      with open( construct_template_dst ) as f2:
        text = f2.read()
      f1.write( text.format( path=path ) )

    # Launch mflowgen run on the mock graph

    RunHandler().launch( help_   = False,
                         design  = '.' )

  #-----------------------------------------------------------------------
  # launch_help
  #-----------------------------------------------------------------------

  def launch_help( s ):
    print()
    print( bold( 'Mock Commands' ) )
    print()
    print( bold( ' - init :' ), 'Initialize a mock-up for a step'        )
    print()
    print( 'Run any command with -h to see more details'                 )
    print()


