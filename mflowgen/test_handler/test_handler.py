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
import glob

from datetime       import datetime

from mflowgen.utils import bold, red, yellow, green
from mflowgen.utils import read_yaml
from mflowgen.components import Subgraph


#-------------------------------------------------------------------------
# Test Management
#-------------------------------------------------------------------------

class TestHandler:

  def __init__( s ):
    s.metadata_dir = '.mflowgen'
    s.commands = [
      'run',
      'list',
      'status',
      'help'
    ]

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

  def launch( s, args, help_, step, attach_points, unit ):

    if help_ and not args:
      s.launch_help()
      return

    try:
      command = args[0]
      assert command in s.commands # valid commands only
    except Exception as e:
      print( 'test: Unrecognized commands (see "mflowgen test help")' )
      sys.exit( 1 )

    if command == 'run'      : s.launch_run( help_, step, attach_points, unit )
    elif command == 'list'   : s.launch_list( help_ )
    elif command == 'status' : s.launch_status( help_ )
    else                     : s.launch_help()

  #-----------------------------------------------------------------------
  # launch_test
  #-----------------------------------------------------------------------

  def launch_run( s, help_, step, attach_points, unit ):

    # Help message

    def print_help():
      print()
      print( bold( 'Usage:' ), 'mflowgen test run --step <step id> --attach_points <attach point ids>' )
      print( bold( 'Example:' ), 'mflowgen test run --step 4 --attach_points 7,8'                      )
      print()

    if help_ or not step:
      print_help()
      return

    if unit:
      s.launch_unit_test( step )

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
    # Get design_name and clock_period param values from synth_step
    design_name = synth_step_data['parameters']['design_name']
    clock_period = synth_step_data['parameters']['clock_period']

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
          test_dir_name = f"integration-tests/test-{test['description']}-from-{step}-at-{attach_point}"
          os.makedirs(test_dir_name, exist_ok=True)
          os.chdir(test_dir_name)

          # Configure the test build dir
          subprocess.check_call( f"mflowgen run --design {test_graph_path} --subgraph --graph_args {{'design_name':'{design_name}','clock_period':{clock_period}}}".split(' ') )
          subprocess.check_call( 'make clean-all'.split(' ') )
          # Prepare the inputs
          os.makedirs('inputs', exist_ok=True)
          os.chdir('inputs')

          # Get the test's inputs from its graph
          test_graph = Subgraph( test_graph_path, 'test', design_name=design_name, clock_period=clock_period ).get_graph()
          test_inputs = test_graph.all_inputs()
          ap_step_dir = f"../../../{ap_step_data['build_dir']}"
          synth_step_dir = f"../../../{synth_step_data['build_dir']}"

          # Connect each test input to something in the graph
          for test_input in test_inputs:
            # Some special cases
            # ADK connection
            if test_input == 'adk':
              # Grab adk (HACK because trying to only use build dir metadata, not the graph obj)
              os.symlink( f"{ap_step_dir}/inputs/adk", 'adk' )
            # sdc from synth is frequently needed to open innovus design checkpoints
            elif test_input == 'design.sdc':
              # Grab design.sdc from synth step
              os.symlink( f"{synth_step_dir}/outputs/design.sdc", 'design.sdc' )
            # End special cases
            # If the input we need is one of attach point's outputs, connect it
            elif test_input in ap_step_data['outputs']:
              os.symlink( f"{ap_step_dir}/outputs/{test_input}", test_input )
            # If we get to this point, the attach point isn't compatible with the test so we can't run it
            else:
              print( f"Error: Test {test['description']} from step {step} is not compatible with attach point {attach_point} " \
                     f"because there is no way to connect test input {test_input}." )
              sys.exit(1)

          # Return to the test build dir
          os.chdir('..')
          # Finally, run the test
          subprocess.check_call( 'make outputs'.split(' ') )
          # Create symink to test outputs for easy access
          output_dir = glob.glob( '[0-9]*-outputs/outputs' )[0]
          os.symlink( output_dir, 'test_outputs' )
          # Return to the main build dir
          os.chdir('../..')

  #-----------------------------------------------------------------------
  # launch_unit_test
  #-----------------------------------------------------------------------

  def launch_unit_test( s, step ):
    yaml_path = './.mflowgen.yml'
    # Get the graph object
    try:
      data = read_yaml( yaml_path )
    except:
      print( 'Error: Must run mflowgen test inside configured build directory' )
      sys.exit( 1 )

    # Find specified step directory
    step_under_test = s.get_step_data( step )
    print( f"Running unit test for step {step}: {step_under_test['name']}" )
    # Get test(s) we need to run
    try:
      tests = step_under_test[ 'tests' ]
    except KeyError:
      print( f"Error: Step {step} has no tests in this graph." )
      print(step_under_test)
      sys.exit(1)

    for test in tests:
      # Get the path to the unit test graph
      unit_test_graph_path = test[ 'unit_test_graph' ]
      if not os.path.isabs( unit_test_graph_path ):
        unit_test_graph_path = os.path.abspath( f"{step_under_test['source']}/{unit_test_graph_path}" )

      # Make a build dir to run the unit test
      test_dir_name = f"unit-tests/test-{test['description']}-from-{step}"
      os.makedirs(test_dir_name, exist_ok=True)
      os.chdir(test_dir_name)

      # Configure the test build dir to run the unit_test_graph
      subprocess.check_call( f"mflowgen run --design {unit_test_graph_path}".split(' ') )
      subprocess.check_call( 'make clean-all'.split(' ') )

      # Get the step under test's build id in the unit test graph
      step_metadata_dirs = glob.glob(f"{s.metadata_dir}/[0-9]*-*")

      for step_metadata_dir in step_metadata_dirs:
        step_data = read_yaml( f"{step_metadata_dir}/configure.yml" )
        if step_under_test['name'] == step_data['name']:
          unit_test_step_id = step_data['build_id']
          break

      try:
        unit_test_step_id
      except NameError:
        print( f"Error: Step under test {step_under_test['name']} is not present in its unit test graph" )
        sys.exit(1)

      # Run normal mflowgen test command on this step in this unit test graph
      subprocess.check_call( f"mflowgen test run --step {unit_test_step_id}".split(' ') )
      # Return to initial graph dir
      os.chdir('../..')


  #-----------------------------------------------------------------------
  # launch_help
  #-----------------------------------------------------------------------

  def launch_help( s ):
    print()
    print( bold( 'Test Commands:' ) )
    print()
    print( bold( ' -- run :'    ), 'Run the tests of a specified step within this build directory' )
    print( bold( ' -- list :'   ), 'List the tests available to run within this build directory'    )
    print( bold( ' -- status :' ), 'Shows whether the available tests have passed/failed'           )
    print()
    print( 'Run any command with -h to see more details' )
    print()

  #-----------------------------------------------------------------------
  # launch_list
  #-----------------------------------------------------------------------

  def launch_list( s, help_ ):
    print()
    print( bold( 'Tests:' ) )
    print()
    step_metadata_dirs = glob.glob(f"{s.metadata_dir}/[0-9]*-*")
    # Iterate over steps
    for step_metadata_dir in step_metadata_dirs:
      # At each step grab each test's description
      step_data = read_yaml( f"{step_metadata_dir}/configure.yml" )
      if 'tests' in step_data:
        step_build_dir = step_data['build_dir']
        print(f" - {step_build_dir}:")
        for test in step_data['tests']:
          print( f"   - {test['description']}" )

    print()

  #-----------------------------------------------------------------------
  # launch_status
  #-----------------------------------------------------------------------

  def launch_status( s, help_ ):
    print()
    print( bold( 'Test statuses:' ) )
    print()
    step_metadata_dirs = glob.glob(f"{s.metadata_dir}/[0-9]*-*")
    ap_dict = read_yaml(f"{s.metadata_dir}/attach_points_dict.yml")
    # Iterate over steps
    for step_metadata_dir in step_metadata_dirs:
      # At each step grab each test's description
      step_data = read_yaml( f"{step_metadata_dir}/configure.yml" )
      if 'tests' in step_data:
        step_build_dir = step_data['build_dir']
        step_build_id = step_data['build_id']
        print(f" - {step_build_dir}:")
        for test in step_data['tests']:
          print( f"   - {test['description']}" )
          for ap in test['attach_points']:
            for ap_step in ap_dict[ap]:
              ap_build_id = ap_step.split('-')[0]
              test_outputs_dir = f"integration-tests/test-{test['description']}-from-{step_build_id}-at-{ap_build_id}/test_outputs"
              test_result_file = f"{test_outputs_dir}/result"
              if not os.path.exists(test_result_file):
                status = yellow('Not run')
              else:
                with open(test_result_file) as f:
                  result_line = f.readline().strip('\n')
                if "PASS" in result_line:
                  status = green('PASS')
                else:
                  status = red('FAIL')
              print( f"     - {ap}: {status}" )
    print()


