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

class RunHandler:

  def __init__( s ):
    pass

  def launch( s, help_, demo, design, backend ):

    # Check that this design directory exists

    if not design:
      if not demo:
        print( ' Error: argument --design required',
                                 'unless using --demo' )
        sys.exit( 1 )

    if not os.path.exists( design ):
      raise ValueError(
        'Directory not found at path "{}"'.format( design ) )

    s.launch_run( demo, design, backend )

  def launch_run( s, demo, design, backend ):

    # construct_path -- Locate the construct script
    #
    # - Read the .mflowgen.yml metadata in the design directory
    # - If it does not exist, then use the default path of "construct.py"
    #

    yaml_path = os.path.abspath( design + '/.mflowgen.yml' )

    if not os.path.exists( yaml_path ):
      construct_path = design + '/construct.py'
    else:

      with open( yaml_path ) as fd:
        try:
          data = yaml.load( fd, Loader=yaml.FullLoader )
        except AttributeError:
          # PyYAML for python2 does not have FullLoader
          data = yaml.load( fd )

      try:
        construct_path = data['construct']
      except KeyError:
        raise KeyError(
          'YAML file "{}" must have key "construct"'.format( yaml_path ) )

      if not construct_path.startswith( '/' ): # check if absolute path
        construct_path = design + '/' + construct_path

      construct_path = os.path.abspath( construct_path )

      if not os.path.exists( construct_path ):
        raise ValueError(
          'Construct script not found at "{}"'.format( construct_path ) )

    # Import the graph for this design

    c_dirname  = os.path.dirname( construct_path )
    c_basename = os.path.splitext( os.path.basename( construct_path ) )[0]

    sys.path.append( c_dirname )

    try:
      construct = importlib.import_module( c_basename )
    except ImportError:
      raise ImportError( 'No module named construct in "{}"'.format(
                           construct_path ) )

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


