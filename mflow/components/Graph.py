#! /usr/bin/env python
#=========================================================================
# Graph.py
#=========================================================================
#
# Author : Christopher Torng
# Date   : June 2, 2019
#

from __future__ import print_function
from .Edge import Edge
from .Step import Step

from ..utils import get_top_dir

class Graph( object ):

  def __init__( s ):
    s._edges_i = {}
    s._edges_o = {}
    s._steps   = {}

  #-----------------------------------------------------------------------
  # API to help build the graph interactively
  #-----------------------------------------------------------------------

  # ADKs

  def set_adk( s, adk, default=True ):
    if default:
      s.adk = Step( get_top_dir() + '/adks/' + adk, default=False )
    else:
      s.adk = Step( adk, default=False )
    s.add_step( s.adk )

  def get_adk_step( s ):
    return s.adk

  # Steps

  def add_step( s, step ):
    key = step.get_name()
    assert key not in s._steps.keys(), \
      'add_step -- Duplicate step!' \
      'If this is intentional, first change the step name'
    s._steps[ key ] = step

  def get_step( s, step_name ):
    return s._steps[ step_name ]

  def all_steps( s ):
    return s._steps.keys()

  # Edges -- incoming and outgoing adjacency lists

  def get_edges_i( s, step_name ):
    try:
      return s._edges_i[ step_name ]
    except KeyError:
      return []

  def get_edges_o( s, step_name ):
    try:
      return s._edges_o[ step_name ]
    except KeyError:
      return []

  # Quality-of-life utility function

  def dangling_inputs( s ):

    dangling = []

    for step_name in s.all_steps():

      incoming_edges        = s.get_edges_i( step_name )
      incoming_edge_f_names = [ e.get_dst()[1] for e in incoming_edges ]

      inputs = s.get_step( step_name ).all_inputs()

      if inputs:
        for x in inputs:
          if x not in incoming_edge_f_names:
            dangling.append( ( step_name, x ) )

    if dangling:
      for step_name, f_name in dangling:
        msg = 'Dangling input in step "{}": {}'
        msg = msg.format( step_name, f_name )
        print( msg )
    else:
      print( 'No dangling inputs in graph' )

  #-----------------------------------------------------------------------
  # Connect
  #-----------------------------------------------------------------------

  def connect( s, l_handle, r_handle ):

    # Twizzle and figure out which side is the src and which is the dst

    l_step_name, l_direction, l_handle_name = l_handle
    r_step_name, r_direction, r_handle_name = r_handle

    if l_direction == 'inputs':
      assert r_direction == 'outputs', \
        'connect -- Must connect an input to an output'
      src_handle = r_handle
      dst_handle = l_handle
    elif r_direction == 'inputs':
      assert l_direction == 'outputs', \
        'connect -- Must connect an input to an output'
      src_handle = l_handle
      dst_handle = r_handle
    else:
      assert False, \
        'connect -- Must connect an input to an output'

    # Create an edge from src to dst

    src_step_name, src_direction, src_f = src_handle
    dst_step_name, dst_direction, dst_f = dst_handle

    if dst_step_name not in s._edges_i.keys():
      s._edges_i[ dst_step_name ] = []
    if src_step_name not in s._edges_o.keys():
      s._edges_o[ src_step_name ] = []

    src = ( src_step_name, src_f )
    dst = ( dst_step_name, dst_f )
    e   = Edge( src, dst )

    # Add this edge to tracking

    s._edges_i[ dst_step_name ].append( e )
    s._edges_o[ src_step_name ].append( e )

  def connect_by_name( s, src, dst ):

    # Get the step (in case the user provided step names instead)

    if type( src ) != Step:
      src_step = s.get_step( src )
    else:
      src_step = src
    src_step_name = src_step.get_name()
    assert src_step_name in s.all_steps(), \
      'connect_by_name -- ' \
      'Step "{}" not found in graph'.format( src_step_name )

    if type( dst ) != Step:
      dst_step = s.get_step( dst )
    else:
      dst_step = dst
    dst_step_name = dst_step.get_name()
    assert dst_step_name in s.all_steps(), \
      'connect_by_name -- ' \
      'Step "{}" not found in graph'.format( dst_step_name )

    # Find same-name matches between the src output and dst input

    src_outputs = src_step.all_outputs()
    dst_inputs  = dst_step.all_inputs()

    overlap = set( src_outputs ).intersection( set( dst_inputs ) )

    # For all overlaps, connect src to dst

    for name in overlap:
      l_handle = src_step.o( name )
      r_handle = dst_step.i( name )
      s.connect( l_handle, r_handle )

  #-----------------------------------------------------------------------
  # Parameter system
  #-----------------------------------------------------------------------

  def expand_params( s ):
    for step_name in s.all_steps():
      s.get_step( step_name ).expand_params()

  #-----------------------------------------------------------------------
  # Design-space exploration
  #-----------------------------------------------------------------------

  # param_space
  #
  # Spins out new copies of the step across the parameter space.
  #
  # For example, for a graph like this:
  #
  #     +-----+    +-----------+    +-----------+
  #     | foo | -> |    bar    | -> |    baz    |
  #     |     |    | ( p = 1 ) |    |           |
  #     +-----+    +-----------+    +-----------+
  #
  # this call:
  #
  #     s.param_space( 'bar', 'p', [ 1, 2, 3 ] )
  #
  # will be transformed into a graph like this:
  #
  #                 +-----------+    +-----------+
  #             +-> |  bar-p-1  | -> |  baz-p-1  |
  #             |   | ( p = 1 ) |    |           |
  #             |   +-----------+    +-----------+
  #     +-----+ |   +-----------+    +-----------+
  #     | foo | --> |  bar-p-2  | -> |  baz-p-2  |
  #     |     | |   | ( p = 2 ) |    |           |
  #     +-----+ |   +-----------+    +-----------+
  #             |   +-----------+    +-----------+
  #             +-> |  bar-p-3  | -> |  baz-p-3  |
  #                 | ( p = 3 ) |    |           |
  #                 +-----------+    +-----------+
  #
  # Returns a list of (parameterized) steps (i.e., 'bar-p-1', 'bar-p-2',
  # and 'bar-p-3').
  #

  def param_space( s, step, param_name, param_space ):

    # Get the step name (in case the user provided a step object instead)

    if type( step ) != str:
      step_name = step.get_name()
    else:
      step_name = step
      step      = s.get_step( step_name )

    assert step_name in s.all_steps(), \
      'param_space -- ' \
      'Step "{}" not found in graph'.format( step_name )

    # Remove the step and its incoming edges from the graph

    del( s._steps[ step_name ] )

    elist_i = s._param_space_helper_remove_incoming_edges( step_name )

    # Now spin out new copies of the step across the parameter space

    new_steps = []

    for p in param_space:
      p_step = step.clone()
      p_step.set_param( param_name, p )
      p_step.set_name( step_name + '-' + param_name + '-' + str(p) )
      s.add_step( p_step )
      for e in elist_i:
        src_step_name, src_f = e.get_src()
        dst_step_name, dst_f = e.get_dst()
        src_step = s.get_step( src_step_name )
        s.connect( src_step.o( src_f ), p_step.i( dst_f ) )
      new_steps.append( p_step )

    # Get the steps that directly depended on this step

    dep_steps = s._param_space_helper_get_dependent_steps( step_name )

    # For each dependent step, replicate and connect to the new steps

    for dep_step in dep_steps:
      s._param_space_helper( step        = dep_step,
                             old_src     = step,
                             new_srcs    = new_steps,
                             param_name  = param_name,
                             param_space = param_space )

    return new_steps

  def _param_space_helper( s, step, old_src, new_srcs, param_name,
                                                       param_space ):

    step_name = step.get_name()

    # Remove the step and its incoming edges from the graph

    del( s._steps[ step_name ] )

    elist_i = s._param_space_helper_remove_incoming_edges( step_name )

    # Now spin out new copies of the step + attach them to new srcs

    new_steps = []

    for i, p in enumerate( param_space ):
      p_step = step.clone()
      p_step.set_name( step_name + '-' + param_name + '-' + str(p) )
      s.add_step( p_step )
      for e in elist_i:
        src_step_name, src_f = e.get_src()
        dst_step_name, dst_f = e.get_dst()
        if src_step_name == old_src.get_name():
          src_step = new_srcs[i]
        else:
          src_step = s.get_step( src_step_name )
        s.connect( src_step.o( src_f ), p_step.i( dst_f ) )
      new_steps.append( p_step )

    # Get the steps that directly depended on this step

    dep_steps = s._param_space_helper_get_dependent_steps( step_name )

    # For each dependent step, replicate and connect to the new steps

    for dep_step in dep_steps:
      s._param_space_helper( step        = dep_step,
                             old_src     = step,
                             new_srcs    = new_steps,
                             param_name  = param_name,
                             param_space = param_space )

    return new_steps

  def _param_space_helper_remove_incoming_edges( s, step_name ):

    try:
      elist_i = s._edges_i[ step_name ]
      del( s._edges_i[ step_name ] ) # Delete edges in incoming edge list
      for e in elist_i: # Also delete these edges in outgoing edge lists
        src_step_name, src_f = e.get_src()
        src_elist_o = s._edges_o[src_step_name]
        del( src_elist_o[ src_elist_o.index( e ) ] )
    except KeyError:
      elist_i = []

    return elist_i

  def _param_space_helper_get_dependent_steps( s, step_name ):

    dep_steps = set()

    try:
      elist_o = s._edges_o[ step_name ]
    except KeyError:
      elist_o = []

    for e in elist_o:
      dst_step_name, dst_f = e.get_dst()
      dep_steps.add( s.get_step( dst_step_name ) )

    return dep_steps

  #-----------------------------------------------------------------------
  # Ninja helpers
  #-----------------------------------------------------------------------

  def escape_dollars( s ):
    for step_name in s.all_steps():
      s.get_step( step_name ).escape_dollars()

  #-----------------------------------------------------------------------
  # Drawing
  #-----------------------------------------------------------------------

  # plot
  #
  # Dumps a graphviz dot file

  def plot( s, dot_title='', dot_f='graph.dot' ):

    # Templates for generating graphviz dot statements

    graph_template = \
'''\
digraph {{
label="{title}";
labelloc="t";
fontsize=60;
size="8.5;11";
ratio="fill";
margin=0;
pad=1;
rankdir="TB";
concentrate=true;
splines=polyline;
center=true;
nodesep=1.2;
ranksep=0.8;
{nodes}
{edges}
}}\
'''

    node_template = \
      '{dot_id} [ fontsize=24, width=2, penwidth=2, shape=Mrecord, ' + \
                 'label="{{ {i} | \\n{name}\\n\\n | {o} }}", color=black ];'

    edge_template = \
      '{src_dot_id}:{src_port_id}:s -> {dst_dot_id}:{dst_port_id}:n ' + \
      '[ arrowsize=2, penwidth=2 ];'

    # Helper function

    def dot_format_fix( x ):
      return x.replace( '-', '_' ).replace( '.', '_' )

    # Loop over all steps and generate a graphviz node declaration
    #
    # Each step will become a graphviz "record" shape, which has a special
    # label syntax that dot interprets to extract the ports.
    #
    # Basically, a label "{ <in1> in1_text | foobar | <out1> out1_text }"
    # turns into a three-section node:
    #
    # - the input with dot ID "in1"
    # - the name "foobar"
    # - the output with dot ID "out1"
    #

    dot_nodes = []

    for step_name in s.all_steps():
      step     = s.get_step( step_name )
      port_str = '<{dot_port_id}> {label}'

      i_port_strs = []
      o_port_strs = []

      for _input in sorted( step.all_inputs() ):
        dot_port_id = dot_format_fix( 'i_' + _input )
        i_port_strs.append( \
          port_str.format( dot_port_id=dot_port_id, label=_input ) )

      for _output in sorted( step.all_outputs() ):
        dot_port_id = dot_format_fix( 'o_' + _output )
        o_port_strs.append( \
          port_str.format( dot_port_id=dot_port_id, label=_output ) )

      node_cfg           = {}
      node_cfg['dot_id'] = dot_format_fix( step_name )
      node_cfg['name']   = '\n' + step_name + '\n\n'
      node_cfg['i']      = '{ ' + ' | '.join( i_port_strs ) + ' }'
      node_cfg['o']      = '{ ' + ' | '.join( o_port_strs ) + ' }'

      dot_nodes.append( node_template.format( **node_cfg ) )

    # Loop over all edges and generate graphviz edge commands
    #
    # A command like "foo -> bar" will draw an edge from foo to bar.
    #

    dot_edges = []

    for elist in s._edges_i.values():
      for e in elist:
        src_step_name, src_f = e.get_src()
        dst_step_name, dst_f = e.get_dst()

        e_cfg                = {}
        e_cfg['src_dot_id']  = dot_format_fix( src_step_name )
        e_cfg['src_port_id'] = dot_format_fix( 'o_' + src_f  )
        e_cfg['dst_dot_id']  = dot_format_fix( dst_step_name )
        e_cfg['dst_port_id'] = dot_format_fix( 'i_' + dst_f  )

        dot_edges.append( edge_template.format( **e_cfg ) )

    # Write out the graphviz dot graph file

    with open( dot_f, 'w' ) as fd:
      graph_cfg = {}
      graph_cfg['title'] = dot_title
      graph_cfg['nodes'] = '\n'.join( dot_nodes )
      graph_cfg['edges'] = '\n'.join( dot_edges )
      fd.write( graph_template.format( **graph_cfg ) )

  #-----------------------------------------------------------------------
  # Graph traversal order
  #-----------------------------------------------------------------------

  def topological_sort( s ):

    order = []

    # Make a deep copy of the edges (destructive algorithm)

    edges_deep_copy = {}
    for step_name, elist in s._edges_i.items():
      edges_deep_copy[ step_name ] = list(elist)
    edges = edges_deep_copy

    # Consider all steps in the graph

    steps = set( s.all_steps() )

    # Topological sort

    while( steps ):

      steps_with_deps    = set( edges.keys() )
      steps_without_deps = steps.difference( steps_with_deps )

      order.extend( steps_without_deps )
      steps = steps_with_deps

      keys_to_delete = []
      for step_name, elist in edges.items():
        idx_to_delete = []
        for i, e in enumerate( elist ):
          if e.get_src()[0] in order:
            idx_to_delete.append( i )
        for i in reversed( idx_to_delete ):
          del( elist[i] )
        if elist == []:
          keys_to_delete.append( step_name )

      for k in keys_to_delete:
        del( edges[k] )

    return order


