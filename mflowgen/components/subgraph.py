#=========================================================================
# subgraph.py
#=========================================================================
# Author : Alex Carsello
# Date   : July 18, 2023
#

import copy
import importlib.util
import os
import sys
import yaml

from mflowgen.utils import get_top_dir, read_yaml, write_yaml
from mflowgen.components.step import Step
from mflowgen.core.run import RunHandler as rh

class Subgraph(Step):

  def __init__( s, graph_path, design_name ):
    
    # Get the construct.py file path

    construct_path = rh.find_construct_path( graph_path, False )

    # Import the graph for this design (copied from RunHandler)

    c_dirname  = os.path.dirname( construct_path )
    c_basename = os.path.splitext( os.path.basename( construct_path ) )[0]

    mod_spec = importlib.util.spec_from_file_location(c_basename, construct_path)
    subgraph_construct_mod = importlib.util.module_from_spec(mod_spec)
    try:
      mod_spec.loader.exec_module(subgraph_construct_mod)
    except ModuleNotFoundError:
      print()
      print( bold( 'Error:' ), 'Could not open construct script at',
                                      '"{}"'.format( construct_path ) )
      print()
      sys.exit( 1 )

    try:
      subgraph_construct_mod.construct
    except AttributeError:
      print()
      print( bold( 'Error:' ), 'No module named "construct" in',
                                      '"{}"'.format( construct_path ) )
      print()
      sys.exit( 1 )

    # Construct the graph
    s._graph = subgraph_construct_mod.construct()

    # Generate step data

    data = {}
    data['name'] = design_name
    data['inputs'] = s._graph.all_inputs()
    data['outputs'] = s._graph.all_outputs()
    data['commands'] = [ \
      f"mflowgen run --subgraph --design {construct_path}",
      'make outputs',
      'mkdir -p outputs',
      'cd outputs',
      'output_dir=$(find ../ -type d -regex "^../[0-9]+-outputs/outputs")'
    ]

    data['postconditions'] = []
    for output in s._graph.all_outputs():
      data['commands'].append(f"ln -sf $output_dir/{output} .")
      data['postconditions'].append(f"assert File( 'outputs/{output}' )")

    data['source'] = c_dirname
    
    super().__init__(data)
  
  #-----------------------------------------------------------------------
  # get_graph
  #-----------------------------------------------------------------------

  # Returns underlying graph object used to create Subgraph Step.
  def get_graph( s ):
    return s._graph

