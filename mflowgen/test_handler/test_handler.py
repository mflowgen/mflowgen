#=========================================================================
# test_handler.py
#=========================================================================
# Handler for test-related commands
#
# Author : Alex Carsello
# Date   : Oct. 5, 2023
#

import os
import re
import shutil
import subprocess
import sys
import yaml
import importlib.util
import glob

from datetime       import datetime

from mflowgen.utils import bold, yellow
from mflowgen.utils import read_yaml


#-------------------------------------------------------------------------
# Test Management
#-------------------------------------------------------------------------

class TestHandler:

  def __init__( s ):
    s.metadata_dir = '.mflowgen'
  
  #-----------------------------------------------------------------------
  # helpers
  #-----------------------------------------------------------------------

  # get_step_data
  #
  # Gets the step data dict for a given index

  def get_step_data( s, step_index ):
    step_metadata_dir = glob.glob( f"{s.metadata_dir}/{step_index}-*" )
    try:
      step_metadata_dir = step_metadata_dir[0]
      step_data = read_yaml( f"{step_metadata_dir}/configure.yml" )
      return step_data
    except IndexError:
      print( f"Error: {step_index} is not a valid step id in this build directory" )
      sys.exit( 1 )


  #-----------------------------------------------------------------------
  # launch
  #-----------------------------------------------------------------------
  # Dispatch function for commands
  #

  def launch( s, help_, step, attach_points ):

    if help_:
      s.launch_help()
      return

    s.launch_test( step, attach_points )

  #-----------------------------------------------------------------------
  # launch_test
  #-----------------------------------------------------------------------

  def launch_test( s, step, attach_points ):
    yaml_path = './.mflowgen.yml'
    # Get the graph object
    try:
      data = read_yaml( yaml_path )
    except:
      print( 'Error: Must run mflowgen test inside configured build directory' )
      sys.exit( 1 )
    
    # Find specified step directory
    step_under_test = s.get_step_data( step )
    # Get test(s) we need to run
    try:
      tests = step_under_test[ 'tests' ]
    except KeyError:
      print( f"Step {step} has no tests in this graph." )
      return
    
    step_metadata_dirs = glob.glob(f"{s.metadata_dir}/[0-9]*-*")
      
    # Loop over the tests to ensure that each provides a test graph
    # and collect the attach points if they're not provided in the cli args.
    attach_point_tags = set()
    for test in tests:
      try:
        test_graph = test['test_graph']
      except KeyError:
        print(f"Error: No test_graph provided for step {step} test.")
        sys.exit(1)
      # If user didn't provide an attach point arg, we will use the attach
      # points specified in the test, so we store all of the tags we need
      # in a set
      if not attach_points:
        for ap in test['attach_points']:
          attach_point_tags.add( ap )
     
    synth_step = None
    ap_step_dict = {}
    # Find a synth step since we need the sdc from this to run tests
    for step_metadata_dir in step_metadata_dirs:
      step_data = read_yaml( f"{step_metadata_dir}/configure.yml" )
      try:
        step_ap_tags = step_data['attach_point_tags']
      except KeyError:
        continue
      if 'SYNTHESIS' in step_ap_tags:
        synth_step = step_data[ 'build_id' ]
      # If the user didn't provide an attach point arg, find the step that corresponds to
      # Each attach point tag we stored in the previous step
      if not attach_points:
        for ap_tag in attach_point_tags:
          if ap_tag in step_data['attach_point_tags']:
            ap_step_dict[ap_tag] = step_data[ 'build_id' ]

    if not synth_step:
      print( 'Error: Graph must contain at least one step with the SYNTHESIS attach point tag ' \
             'in order for tests to run.' )

    synth_step_data = s.get_step_data( synth_step )
  
    ap_list = attach_points 
    if not ap_list:
      ap_list = list( ap_step_dict.values() )
       
    # Ensure that every attach point is valid
    for attach_point in ap_list:
      ap_data = s.get_step_data( attach_point )
      try:
        ap_outputs = ap_data['outputs']
      except KeyError:
        print(f"Error: Step {attach_point} is not a valid test attach " \
              f"point becase it does not have any outputs.")
        sys.exit(1)
      if 'design.checkpoint' not in ap_outputs:
        print(f"Error: Step {attach_point} is not a valid test attach " \
              f"point because it does not produce an Innovus checkpoint " \
              f"(design.checkpoint)")
        sys.exit(1)

    subprocess.check_call( f"make {synth_step}".split(' ') )    
    for attach_point in ap_list:
      # Make attach point
      subprocess.check_call( f"make {attach_point}".split(' ') )
      # Run the tests at the attach point if attach point provided in CLI or
      # or if no ap CLI arg provided and test specfies this attach point
      ap_step_data = s.get_step_data( attach_point )
      for test in tests:
        run = False
        if attach_points:
          run = True
        else:
          for test_ap in test['attach_points']:
            ap_id = ap_step_dict[test_ap]
            if ap_id == attach_point:
              run = True
        if run:
          print( f"Running test {test['description']} from step {step} at attach point {attach_point}" )
          test_graph_path = test[ 'test_graph' ]
          if not os.path.isabs( test_graph_path ):
            test_graph_path = os.path.abspath( f"{step_under_test['source']}/{test_graph_path}" )
          # First, prepare the test directory
          test_dir_name = f"tests/test-{test['description']}-from-{step}-at-{attach_point}"
          os.makedirs(test_dir_name, exist_ok=True)
          os.chdir(test_dir_name)
         
          # Configure the test build dir
          subprocess.check_call( f"mflowgen run --design {test_graph_path} --subgraph".split(' ') )
          subprocess.check_call( 'make clean-all'.split(' ') )
          # Prepare the inputs
          os.makedirs('inputs', exist_ok=True)
          os.chdir('inputs')
          # Grab design.checkpoint from the attach point step
          os.symlink( f"../../../{ap_step_data['build_dir']}/outputs/design.checkpoint", 'design.checkpoint' )
          # Grab adk (HACK because trying to only use build dir metadata, not the graph obj)
          os.symlink( f"../../../{ap_step_data['build_dir']}/inputs/adk", 'adk' )
          # Grab design.sdc from synth step
          os.symlink( f"../../../{synth_step_data['build_dir']}/outputs/design.sdc", 'design.sdc' )
          # Return to the test build dir
          os.chdir('..')
          # Finally, run the test
          subprocess.check_call( 'make outputs'.split(' ') )
          # Return to the main build dir
          os.chdir('../..')
          


  #-----------------------------------------------------------------------
  # launch_help
  #-----------------------------------------------------------------------

  def launch_help( s ):
    print()
    print( bold( 'Test Options:' ) )
    print()
    print( bold( ' --step :' ),          'The step whose tests you wish to run'                          )
    print( bold( ' --attach_points :' ), 'Comma-separated list of attach points (locations to run test)' )
    print()


