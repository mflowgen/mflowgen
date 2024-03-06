#=========================================================================
# param_handler.py
#=========================================================================
# Handler for param-related commands
#
# Author : Christopher Torng
# Date   : February 3, 2024
#

import os
import re
import shutil
import subprocess
import sys
import yaml

from datetime       import datetime
from functools      import reduce

from mflowgen.utils import bold, yellow
from mflowgen.utils import read_yaml, write_yaml

#-------------------------------------------------------------------------
# Parameter updates on the command line
#-------------------------------------------------------------------------
# Parameters can be set in the following ways:
#
#     - statically    -- in a node's configure.yml
#     - dynamically   -- in a construct.py at graph construction time
#     - interactively -- via the command line as supported here
#
# On the command line, we want a simple interface to update any node in
# the graph (or to update all nodes). It looks like this:
#
#     % mflowgen param update --step 5 --key clock_period --value 2.0
#     % mflowgen param update  -s 5     -k   clock_period  -v     2.0
#
# Updating all nodes can use the --all flag like this:
#
#     % mflowgen param update --all    --key clock_period --value 2.0
#
# Internally, parameters for the currently elaborated mflowgen graph
# (i.e., after executing mflowgen run) are stored in the hidden metadata
# directory '.mflowgen'. Specifically, parameters are stored in the
# configure.yml and mflowgen-run script for each node. To change a
# parameter on the command line, these are the files we need to modify.
#

class ParamHandler:

  def __init__( s ):

    # Valid commands

    s.commands = [
      'update',
      'help',
    ]

  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for commands
  #

  def launch( s, args, help_, key, value, step, all_ ):

    if help_ and not args:
      s.launch_help()
      return

    try:
      command = args[0]
      assert command in s.commands # valid commands only
    except Exception as e:
      print( 'param: Unrecognized commands (see "mflowgen param help")' )
      sys.exit( 1 )

    try:
      assert len( args ) <= 1 # no further positional args are allowed
    except Exception as e:
      print()
      print( 'param: Unrecognized positional args' )
      # Allow this exception to pass, but force set the "help" flag so
      # users can see what they should be doing instead.
      help_ = True

    if   command == 'update' : s.launch_update( help_, key, value, step, all_ )
    else                     : s.launch_help()

  #-----------------------------------------------------------------------
  # launch_update
  #-----------------------------------------------------------------------
  # Internally, this command does the following:
  #
  # - Updates the configure.yml for the step given by --step
  # - Sets "parameters[key] = value"
  # - If --all is given, we update all nodes in the graph
  #

  def launch_update( s, help_, key, value, step, all_ ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen param update',
                                  '--key/-k <str>',
                                  '--value/-v <str>',
                                  '[--step/-s <int>]',
                                  '[--all]'                              )
      print()
      print( bold( 'Example:' ), 'mflowgen param update',
                                  '--key clock_period --value 2.0',
                                  '--all'                                )
      print()
      print( 'Updates a parameter for the given step in the build graph.')
      print( 'The parameter update is only applied if the key is defined')
      print( 'and exists for that step. The --all option applies the'    )
      print( 'update to all nodes in the currently configured build.'    )
      print()
      print( 'Parameters in list form must be updated in the format of'  )
      print( 'a comma-separated string.'                                 )
      print()
      print( 'If you call "mflowgen run" again, these interactive'       )
      print( 'parameter updates are not preserved and must be run again.')
      print()

    if help_ or not key or not value or not (step is not None or all_):
      print_help()
      return

    # Make sure that we are inside an mflowgen build directory

    build_path   = os.getcwd()
    metadata_dir = os.path.join( build_path, '.mflowgen' )

    try:
      assert os.path.exists( metadata_dir )
    except AssertionError:
      # Metadata not found... print a useful message with directions
      print()
      print( 'Please make sure you are in an mflowgen build directory.' )
      print()
      sys.exit( 1 )

    # Grab the metadata directories for all nodes

    subdirs = \
      [ _ for _ in os.listdir( metadata_dir ) if
          os.path.isdir( os.path.join( metadata_dir, _ ) ) ]

    subdirs = [ _ for _ in subdirs if '-' in _ ] # must have a dash number

    # Sort alphanumerically

    subdirs = sorted( subdirs, key=lambda x: int(x.split('-')[0]) )

    # Assemble the list of nodes we should update
    #
    # - If the --all flag was given, keep this full list
    # - If a specific step was given, filter down to that one

    if all_:
      to_update = subdirs
    else:
      to_update = [ _ for _ in subdirs if _.startswith( str(step)+'-' ) ]

    # Make sure we have nodes left to update

    if not to_update and all_:
      print()
      print( bold( 'Error:' ), 'There are no nodes to update' )
      print()
    elif not to_update and step:
      print()
      print( bold( 'Error:' ), 'Could not find step',
              '"{}" in the current build'.format( step ) )
      print()

    # Template string

    node_str_len = reduce( lambda x, y: max(x,y),
                     map( lambda x: len(x), to_update ) )

    template_str = \
        bold( ' - Update: ' ) + \
        ' {node:{node_str_len}} -- ' + \
        bold( ' params["{k}"] = "{v}" ' ) + \
        ' ( was "{old}" )'

    # Loop over all nodes and update them with the new param

    print()

    for subdir in to_update:

      subdir_id   = subdir.split('-')[0]            # step number
      subdir_name = '-'.join(subdir.split('-')[1:]) # step name

      # Paths to metadata files

      config_yaml_path = \
          os.path.join( metadata_dir, subdir, 'configure.yml' )

      mflowgen_run_path = \
          os.path.join( metadata_dir, subdir, 'mflowgen-run' )

      mflowgen_debug_path = \
          os.path.join( metadata_dir, subdir, 'mflowgen-debug' )

      # Read YAML

      try:
        data = read_yaml( config_yaml_path )
      except Exception as e:
        print()
        print( bold( 'Error:' ), 'Metadata is corrupt for step',
                '"{}"'.format( subdir_id ) )
        print()
        raise

      # Print a notice if this parameter does not exist

      try:
        assert key in data['parameters']
      except Exception as e:
        #print( bold( ' - No Change:' ),
        #  '"{id_}-{node}" has no parameter "{k}"'.format(
        #  id_=subdir_id, node=subdir_name, k=key ) )
        continue

      # Update the parameter

      old_value = data['parameters'][key]
      data['parameters'][key] = value
      print( template_str.format( node = subdir_id+'-'+subdir_name,
                                  node_str_len = node_str_len,
                                  k = key, v = value, old = old_value ) )

      # Commit the changes -- Write YAML and update mflowgen-run/debug

      try:

        # configure.yml

        write_yaml(
          data = data,
          path = config_yaml_path
        )

        # mflowgen-run and mflowgen-debug-- swap the param value

        for f_path in [ mflowgen_run_path, mflowgen_debug_path ]:
          if os.path.exists( f_path ):
            with open( f_path, 'r' ) as f:
              f_lines = f.readlines()
            key_str    = 'export {k}='.format( k=key )
            export_str = 'export {k}={v}\n'.format( k=key, v=value )
            f_lines = [ _ if key_str not in _ else export_str
                          for _ in f_lines ]
            with open( f_path, 'w' ) as f:
              f.write( ''.join( f_lines ) )

      except Exception as e:
        print( bold( 'Error:' ), 'Metadata is corrupt for step',
                '"{}"'.format( subdir_id ) )


    print()

  #-----------------------------------------------------------------------
  # launch_help
  #-----------------------------------------------------------------------

  def launch_help( s ):
    print()
    print( bold( 'Param Commands' ) )
    print()
    print( bold( ' - update :' ), 'Update parameter in current build'    )
    print()
    print( 'Run any command with -h to see more details'                 )
    print()



