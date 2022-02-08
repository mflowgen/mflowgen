#=========================================================================
# run_handler
#=========================================================================
# Primary handler for generating build system files for a given graph
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

import importlib
import os
import sys
import yaml

from mflowgen.core.build_orchestrator import BuildOrchestrator
from mflowgen.backends                import MakeBackend, NinjaBackend
from mflowgen.utils                   import bold
from mflowgen.utils                   import read_yaml, write_yaml

class RunHandler:

  def __init__( s ):
    pass

  #-----------------------------------------------------------------------
  # helpers
  #-----------------------------------------------------------------------

  # find_construct_path
  #
  # Locate the construct script
  #
  # - If --update is given, use the saved path
  # - Otherwise..
  #   - Read from the .mflowgen.yml metadata in the design directory
  #   - If it does not exist, then use "construct.py" as default
  #

  def find_construct_path( s, design, update ):

    # Check for --update first

    if update:
      try:
        data = read_yaml( '.mflowgen.yml' ) # get metadata
        construct_path = data['construct']
      except Exception:
        print()
        print( bold( 'Error:' ), 'No pre-existing build in current',
                                    'directory for running --update' )
        print()
        sys.exit( 1 )
      return construct_path

    # Find a construct python file that describes the flow
    #
    # The --design argument can be used in two ways to point to the python
    # file with the flow graph:
    #
    # 1. Directly provide the path to the python file
    # 2. Provide the path to the directory that contains the flow graph
    #
    # With the second option, if the flow graph is not the default
    # (i.e., "construct.py" in the top level of the given directory), then
    # a .mflowgen.yml file should describe where within the directory to
    # find the flow graph and it should look like this:
    #
    #     construct: path/within/directory/to/construct.py
    #

    if not os.path.exists( os.path.dirname( design ) ):
      print()
      print( bold( 'Error:' ), 'Directory not found at path',
                                      '"{}"'.format( design ) )
      print()
      sys.exit( 1 )

    # Option 1 -- Construct path directly provided

    if design.endswith('.py'):

      construct_path = design

    # Option 2 -- Construct path pointing within a directory

    else:

      yaml_path = os.path.abspath( design + '/.mflowgen.yml' )

      if not os.path.exists( yaml_path ):
        construct_path = design + '/construct.py'
      else:

        data = read_yaml( yaml_path )

        try:
          construct_path = data['construct']
        except KeyError:
          raise KeyError(
            'YAML file "{}" must have key "construct"'.format( yaml_path ) )

        if not construct_path.startswith( '/' ): # check if absolute path
          construct_path = design + '/' + construct_path

    # Check that this file exists

    construct_path = os.path.abspath( construct_path )

    if not os.path.exists( construct_path ):
      raise ValueError(
        'Construct script not found at "{}"'.format( construct_path ) )

    return construct_path

  # save_construct_path
  #
  # Save the path to the construct script for future use of --update
  #

  def save_construct_path( s, construct_path ):
    yaml_path = '.mflowgen.yml'
    try:
      data = read_yaml( yaml_path )
    except Exception:
      data = {}
    data['construct'] = construct_path
    write_yaml( data = data, path = yaml_path )

  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for commands
  #

  def launch( s, help_, design, update=False, backend='make' ):

    # Check that this design directory exists

    if not design and not update:
      print( ' Error: argument --design required',
                               'unless using --update or --demo' )
      sys.exit( 1 )

    s.launch_run( design, update, backend )

  #-----------------------------------------------------------------------
  # launch_run
  #-----------------------------------------------------------------------
  # Generates the backend build files (e.g., the Makefile) from the python
  # graph description.
  #

  def launch_run( s, design, update, backend ):

    # Find the construct script (and check for --update) and save the path
    # to the construct script for future use of --update

    construct_path = s.find_construct_path( design, update )
    s.save_construct_path( construct_path )

    # Import the graph for this design

    c_dirname  = os.path.dirname( construct_path )
    c_basename = os.path.splitext( os.path.basename( construct_path ) )[0]

    sys.path.append( c_dirname )

    try:
      construct = importlib.import_module( c_basename )
    except ModuleNotFoundError:
      print()
      print( bold( 'Error:' ), 'Could not open construct script at',
                                      '"{}"'.format( construct_path ) )
      print()
      sys.exit( 1 )

    try:
      construct.construct
    except AttributeError:
      print()
      print( bold( 'Error:' ), 'No module named "construct" in',
                                      '"{}"'.format( construct_path ) )
      print()
      sys.exit( 1 )

    # Construct the graph

    g = construct.construct()

    # Generate the build files (e.g., Makefile) for the selected backend
    # build system

    if backend == 'make':
      backend_cls = MakeBackend
    elif backend == 'ninja':
      backend_cls = NinjaBackend

    b = BuildOrchestrator( g, backend_cls )
    b.build()

    # Done

    list_target   = backend + " list"
    status_target = backend + " status"

    print( "Targets: run \"" + list_target   + "\" and \""
                             + status_target + "\"" )
    print()


