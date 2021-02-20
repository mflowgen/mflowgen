#=========================================================================
# graph.py
#=========================================================================
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os
import inspect

from mflowgen.components.step import Step
from mflowgen.components.edge import Edge
from mflowgen.utils           import get_top_dir
from mflowgen.utils           import ParseNodes

class Graph:
  """Graph of nodes and edges (i.e., :py:mod:`Step` and :py:mod:`Edge`)."""

  def __init__( s ):

    s._edges_i = {}
    s._edges_o = {}
    s._steps   = {}
    s._todo    = {}   ;# Connections waiting to be made
    s._extnodes= [] ;# list of extension nodes

    # System paths to search for ADKs (i.e., analogous to python sys.path)
    #
    # The contents of the environment variable "MFLOWGEN_PATH" are
    # appended to sys path (i.e., analagous to how PYTHONPATH works)
    #

    s.sys_path = [
      get_top_dir() + '/adks',
    ]

    try:
      s.sys_path.extend( os.environ['MFLOWGEN_PATH'].split(':') )
    except KeyError:
      pass

  #-----------------------------------------------------------------------
  # API to help build the graph interactively
  #-----------------------------------------------------------------------

  # set_adk

  def set_adk( s, adk ):
    """Sets the ASIC design kit.

    Searches the paths in "Graph.sys_path" for ADKs (analagous to python
    sys.path).

    Args:
      adk: A string representing the subdirectory name of the ADK
    """

    # Search for adk steps

    for p in s.sys_path:
      adk_path = p + '/' + adk
      try:
        s.adk_step = Step( adk_path, default=False )
      except:
        pass

    try:
      s.adk_step
    except AttributeError:
      raise OSError( 'Could not find adk "{}" in system paths: {}'.format(
        adk, s.sys_path ) )

    # Add the adk step to the graph

    s.add_step( s.adk_step )

  # get_adk_step

  def get_adk_step( s ):
    """Gets the Step object representing the ASIC design kit.

    Returns:
      The Step object that was constructed from the currently set ADK.
    """
    return s.adk_step

  # add_step

  def add_step( s, step ):
    """Adds a Step to the graph as a node.

    The name of the new Step cannot conflict with any steps that already
    exist in the graph. This method fails an assertion if given a
    duplicate step name.

    Args:
      step: A Step object
    """
    key = step.get_name()
    assert key not in s._steps.keys(), \
      'add_step -- Duplicate step "{}", ' \
      'if this is intentional, first change the step name'.format( key )
    s._steps[ key ] = step

  def get_step( s, step_name ):
    """Gets the Step object with the given name.

    Args:
      step_name: A string representing the name of the step from :py:meth:`Step.get_name`
    """
    return s._steps[ step_name ]

  def all_steps( s ):
    return s._steps.keys()

  # Edges -- incoming and outgoing adjacency lists
  # Sort them for better debuggability / repeatability / causality

  def sort_edges( s, edge_list ):
    edge_list.sort(key=lambda x: x.src)
    return edge_list

  def get_edges_i( s, step_name ):
    try:
      return s.sort_edges(s._edges_i[ step_name ])
    except KeyError:
      return []

  def get_edges_o( s, step_name ):
    try:
      return s.sort_edges(s._edges_0[ step_name ])
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

  def update_params( s, params ):
    """Updates parameters for all steps in the graph.

    Calls :py:meth:`Step.update_params` for each step in the graph with the
    given parameter dictionary.

    Args:
      params: A dict of parameter names (strings) and values
    """

    for step_name in s.all_steps():
      s.get_step( step_name ).update_params( params )

  def expand_params( s ):
    for step_name in s.all_steps():
      s.get_step( step_name ).expand_params()

  #-----------------------------------------------------------------------
  # Metadata
  #-----------------------------------------------------------------------

  def dump_metadata_to_steps( s, build_dirs, build_ids ):

    for step_name in s.all_steps():

      edges_i = {}
      edges_o = {}

      try:
        for e in s._edges_i[ step_name ]:
          f = e.get_dst()[1]
          edge = { 'f'    : e.get_src()[1],
                   'step' : build_dirs[ e.get_src()[0] ] }
          try:
            edges_i[f].append( edge )
          except KeyError:
            edges_i[f] = [ edge ]
      except KeyError:
        pass

      try:
        for e in s._edges_o[ step_name ]:
          f = e.get_src()[1]
          edge = { 'f'    : e.get_dst()[1],
                   'step' : build_dirs[ e.get_dst()[0] ] }
          try:
            edges_o[f].append( edge )
          except KeyError:
            edges_o[f] = [ edge ]
      except KeyError:
        pass

      data = {
        'build_dir' : build_dirs [ step_name ],
        'build_id'  : build_ids  [ step_name ],
        'edges_i'   : edges_i,
        'edges_o'   : edges_o,
      }

      s.get_step( step_name ).update_metadata( data )

  #-----------------------------------------------------------------------
  # Design-space exploration
  #-----------------------------------------------------------------------

  # param_space

  def param_space( s, step, param_name, param_space ):
    """Spins out new copies of the step across the parameter space.

    For example, for a graph like this::

        +-----+    +-----------+    +-----------+
        | foo | -> |    bar    | -> |    baz    |
        |     |    | ( p = 1 ) |    |           |
        +-----+    +-----------+    +-----------+

    this call:

    .. code-block:: python

        g = Graph()
        (...)
        g.param_space( 'bar', 'p', [ 1, 2, 3 ] )

    will be transformed into a graph like this::

                    +-----------+    +-----------+
                +-> |  bar-p-1  | -> |  baz-p-1  |
                |   | ( p = 1 ) |    |           |
                |   +-----------+    +-----------+
        +-----+ |   +-----------+    +-----------+
        | foo | --> |  bar-p-2  | -> |  baz-p-2  |
        |     | |   | ( p = 2 ) |    |           |
        +-----+ |   +-----------+    +-----------+
                |   +-----------+    +-----------+
                +-> |  bar-p-3  | -> |  baz-p-3  |
                    | ( p = 3 ) |    |           |
                    +-----------+    +-----------+

    Args:
      step        : A string for the step name targeted for expansion
      param_name  : A string for the parameter name
      param_space : A list of parameter values to expand to

    Returns:
      A list of (parameterized) steps (i.e., 'bar-p-1', 'bar-p-2', and
      'bar-p-3').
    """

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
    #
    # Start from this:
    #
    #     +-----+    +-----------+    +-----------+
    #     | foo | -> |    bar    | -> |    baz    |
    #     |     |    |           |    |           |
    #     +-----+    +-----------+    +-----------+
    #
    # End like this:
    #
    #                 +-----------+
    #             +-> |  bar-p-1  |
    #             |   | ( p = 1 ) |        +-----------+
    #             |   +-----------+     -- |    baz    |
    #     +-----+ |   +-----------+        |           |
    #     | foo | --> |  bar-p-2  |        +-----------+
    #     |     | |   | ( p = 2 ) |
    #     +-----+ |   +-----------+
    #             |   +-----------+
    #             +-> |  bar-p-3  |
    #                 | ( p = 3 ) |
    #                 +-----------+
    #

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

    # Build a dict to map (removed) base steps to their expanded steps

    new_src_map = { step_name : new_steps }

    # Recurse on downstream nodes
    #
    # We traverse down the graph in _topological_ sort order to handle
    # cases where downstream nodes depend on multiple previous nodes. For
    # example:
    #
    #         +---+    +---+    +---+
    #         | A | -> | B | -> | C |
    #         +---+    +---+    +---+
    #           |               ^
    #            \_____________/
    #
    # On each node expansion, we are breaking the incoming edges of that
    # node, removing the node from the graph, stamping out three
    # parameterized versions of the node, and reconnecting the incoming
    # edges.
    #
    # The natural expansion order is A, B, C (i.e., topological sort
    # order). If we use non-topological sort order, then the solution is
    # less clean.
    #

    dep_steps = s._param_space_helper_get_dependent_steps( step_name )
    dep_steps = s.topological_sort( seed_steps=dep_steps )

    # For each dependent step, replicate and connect to the graph

    visited = set()

    for dep_step in dep_steps:
      s._param_space_helper( step_name   = dep_step,
                             new_src_map = new_src_map,
                             visited     = visited,
                             param_name  = param_name,
                             param_space = param_space )

    return new_steps

  # _param_space_helper
  #
  # Take the dependent step (i.e., baz), replicate the step across the
  # parameter space, and then connect to the frontier of new_srcs (i.e.,
  # bar-p-1, bar-p-2, bar-p-3).
  #
  # Start from this:
  #
  #                 +-----------+
  #             +-> |  bar-p-1  |
  #             |   | ( p = 1 ) |        +-----------+
  #             |   +-----------+     -- |    baz    |
  #     +-----+ |   +-----------+        |           |
  #     | foo | --> |  bar-p-2  |        +-----------+
  #     |     | |   | ( p = 2 ) |
  #     +-----+ |   +-----------+
  #             |   +-----------+
  #             +-> |  bar-p-3  |
  #                 | ( p = 3 ) |
  #                 +-----------+
  #
  # End like this:
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

  def _param_space_helper( s, step_name, new_src_map, visited,
                                         param_name,  param_space ):

    if step_name in visited:
      return
    else:
      visited.add( step_name )

    step = s.get_step( step_name )

    # Remove the step and its incoming edges from the graph

    del( s._steps[ step_name ] )

    elist_i = s._param_space_helper_remove_incoming_edges( step_name )

    # Now spin out new copies of the step + attach them to new srcs

    new_steps = []

    for i, p in enumerate( param_space ):
      p_step = step.clone()
      p_step.set_name( step_name + '-' + param_name + '-' + str(p) )
      # Propagate the new parameter value to downstream nodes
      try:
        p_step.set_param( param_name, p )
      # If the parameter cannot be accessed, do nothing to the parameter
      except KeyError:
        pass
      s.add_step( p_step )
      for e in elist_i:
        src_step_name, src_f = e.get_src()
        dst_step_name, dst_f = e.get_dst()
        if src_step_name in new_src_map.keys():
          src_step = new_src_map[src_step_name][i]
        else:
          src_step = s.get_step( src_step_name )
        s.connect( src_step.o( src_f ), p_step.i( dst_f ) )
      new_steps.append( p_step )

    # Build a dict to map (removed) base steps to their expanded steps

    new_src_map.update( { step_name : new_steps } )

    # Recurse on downstream nodes

    dep_steps = s._param_space_helper_get_dependent_steps( step_name )
    dep_steps = s.topological_sort( seed_steps=dep_steps )

    # For each dependent step, replicate and connect to the new steps

    for dep_step in dep_steps:
      s._param_space_helper( step_name   = dep_step,
                             new_src_map = new_src_map,
                             visited     = visited,
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
      dep_steps.add( dst_step_name )

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

    # Use ordered list for repeatability

    stepname_list = list(s.all_steps()); stepname_list.sort()
    for step_name in stepname_list:

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

    # Gather all the input edges and sort them for repeatable results

    elist = []
    for edges in s._edges_i.values():
      elist = elist + edges
    s.sort_edges(elist)

    # Build dot-graph edges

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

  def topological_sort( s, seed_steps=False ):

    order = []

    # Make a deep copy of the edges (destructive algorithm)

    edges_deep_copy = {}
    for step_name, elist in s._edges_i.items():
      edges_deep_copy[ step_name ] = list(elist)
    edges = edges_deep_copy

    # Consider all steps in the graph, or if there are seed steps then
    # only consider that subgraph (with incoming dangling edges removed)

    if type( seed_steps ) != set:
      steps = set( s.all_steps() )
    else:
      steps = set( seed_steps )
      # If there are no steps, just return an empty list
      if not steps:
        return []
      # Delete any edges directed to nodes not in the subgraph
      steps_with_edges_i = list( edges.keys() )
      for k in steps_with_edges_i:
        if k not in seed_steps:
          del( edges[k] )
      # Delete any incoming edges from src nodes not in the subgraph
      keys_to_delete = []
      for step_name, elist in edges.items():
        idx_to_delete = []
        for i, e in enumerate( elist ):
          if e.get_src()[0] not in seed_steps:
            idx_to_delete.append( i )
        for i in reversed( idx_to_delete ):
          del( elist[i] )
        if elist == []:
          keys_to_delete.append( step_name )
      for k in keys_to_delete:
        del( edges[k] )

    # Topological sort

    while( steps ):

      steps_with_deps    = set( edges.keys() )
      steps_without_deps = steps.difference( steps_with_deps )

      assert steps_without_deps, \
        'topological_sort -- Could not find a valid sort for ' \
        '{}'.format( steps )

      order.extend( sorted( steps_without_deps ) ) # sort for determinacy
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

  #-----------------------------------------------------------------------
  # SR playspace
  #-----------------------------------------------------------------------

  def add_custom_steps(self, nodelist_string, DBG=0 ):
    '''
    # Add custom steps
    #
    # EXAMPLE:
    #     g.add_custom_steps("rtl - ../common/rtl -> synth")
    #
    # does this:
    #     rtl = Step( this_dir + '/../common/rtl' )
    #     g.add_step( rtl )
    #     g.connect_by_name( rtl, synth )
    #
    # BIGGER EXAMPLE:
    #   g.add_custom_steps("""
    #     rtl                - ../common/rtl          -> synth
    #     constraints        -    constraints         -> synth iflow
    #     custom_dc_scripts  -    custom-dc-scripts   -> iflow
    #     testbench          - ../common/testbench    -> post_pnr_power
    #     application        - ../common/application  -> post_pnr_power testbench
    #     post_pnr_power     - ../common/tile-post-pnr-power
    #   """)
    '''
    if DBG: print("Adding custom steps")
    nodes=ParseNodes(nodelist_string)
    frame = inspect.stack()[1][0]
    for n in nodes.node_array:
      if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")
      step = self._add_step_with_handle(frame, n, DBG)
      self._connect_successor_nodes(frame, n, DBG)
      if DBG: print("  DONE\n\n")


  def extend_steps(self, nodelist_string, DBG=0 ):

    # EXAMPLE:
          #   extend_steps("custom_init - custom-init -> init")
          # Does this:
          #    custom_init = Step( this_dir + '/custom-init'                           )
          #    # Add extra input edges to innovus steps that need custom tweaks
          #    init.extend_inputs( custom_init.all_outputs() )
          #    g.add_step( custom_init              )
          #    g.connect_by_name( custom_init,  init     )

    if DBG: print("Extend existing steps")
    nodes=ParseNodes(nodelist_string)
    frame = inspect.stack()[1][0]
    for n in nodes.node_array:
      if DBG: print(f"  Found '{n.name}' - '{n.step}' -> {n.successors}   ")

      # Mark this step as an "extend" step
      self._extnodes.append(n.name)
      step = self._add_step_with_handle(frame, n, DBG)
      self._connect_successor_nodes(frame, n, DBG)
      if DBG: print("  DONE\n\n")



  def connect_outstanding_nodes(self, DBG=0):
    '''
    # construct.py should call this method after all steps have been built,
    # to clear out the todo list.
    '''
    frame = inspect.stack()[1][0]
    self._check_todo_list(frame, DBG)

  def _check_todo_list(self, frame, DBG=0):
    '''
    # Try and clear out the todo list, i.e. see if outstanding nodes have been built yet.
    '''
    print("CHECKING TODO LIST")
    for from_name in self._todo:

      # Must make shallow copy b/c we may be deleting elements in situ
      to_list = self._todo[from_name].copy() ;
      for to_name in to_list:
        if DBG:
          print(f"  TODO: connect {from_name} -> {to_name} --- connect({from_name}, {to_name})")
        if self._connect_from_to(frame, from_name, to_name, DBG):
          self._todo[from_name].remove(to_name)
          print(f'    REMOVED from todo list: {from_name} -> {to_name}')
        else:
          print(f'    looks like maybe {to_name} does not exist yet')

  def _add_step_with_handle(self, frame, node, DBG=0):
      '''
      # Given a node with a stepname and associated dir, build the
      # step and make a handle for the step in the calling frame
      # Nota bene: the handle will be a GLOBAL variable!
      #
      # Example:
      #     frame = inspect.stack()[0]
      #     g.add_step_with_handle( 'rtl',  '/../common/rtl' )
      #
      # Does this:
      #     rtl = Step( this_dir + '/../common/rtl' )
      #     g.add_step( rtl )
      #
      # Also: after step is built, checks todo list to see if
      # anyone is waiting to connect to this step.
      '''
      stepname   = node.name
      stepdir    = node.step

      # Start a todo list for connections from this node to yet-unresolved nodes
      self._todo[stepname] = [] ; # Initialize todo list

      # Check for global/local collision etc
      if stepname in frame.f_locals:
        print(f'**ERROR local var "{stepname}" exists already; cannot build step via parsenode')
        print(f"rtl='{frame[0].f_locals[stepname]}'")
        exit(13)

      # Build the step and assign the handle
      module = inspect.getmodule(frame)
      this_dir = os.path.dirname( os.path.abspath( module.__file__ ) )
      step = Step( this_dir + '/' + stepdir )
      frame.f_globals[stepname] = step

      # Add step to graph
      self.add_step(step)

      # Check todo list, see if new step has unlocked new connections
      self._check_todo_list(frame, DBG)
      return step

  def _connect_successor_nodes(self, frame, node, DBG=0):
      '''
      Given a node containing a list of successors, check each successor
      to see if it exists in the calling frame yet. If so, connect them; 
      otherwise, add it to a todo-list for later.
      '''
      node_name = node.name
      for succ_name in node.successors:
        if DBG: print(f"  CONNECTING {node_name} to {succ_name}")
        if self._connect_from_to(frame, node_name, succ_name, DBG=1):
          if DBG: print("    CONNECTED!!!")
        else:
          if DBG: print(f"    HA looks like {succ_name} don't exist (yet)")
          if DBG: print(f"    Add it to the todo list")
          self._todo[node_name].append(succ_name)

  def _connect_from_to(self, frame, from_name, to_name, DBG=0):
      '''
      Given names for "from" and "to" nodes, try and connect the two.
      If the "to" node does not exist (yet) in the given calling frame,
      return "False".
      '''
      # Only global vars end up on the todo list, so 'from' node must be global
      from_node = frame.f_globals[from_name]

      to_node = self._findvar(frame, to_name)
      if to_node == None:
        return False

      else:
        if from_name in list(self._extnodes):
          if DBG: print(f'    FOUND EXTNODE {from_name}')
          to_node.extend_inputs( from_node.all_outputs() )

        self.connect_by_name(from_node, to_node)
        if DBG: print(f'   CONNECTED {from_name} -> {to_name}')

        print(f'EXTNODES {self._extnodes}')
        cond = from_name in self._extnodes
        print(f'"{from_name}" in {self._extnodes}? "{cond}"')



        # TODO/FIXME/BOOKMARK check extnodes and do the thing


        return True
      

  def _findvar(self, frame, varname, DBG=0):
    """Search given frame for local or global var with called 'varname'"""
    try:
      value = frame.f_locals[varname] ;# This will fail if local not exists
      print(f'    Found local var {varname}')
      return value
    except: pass

    if DBG: print(f"    {varname} not local, is it global perchance?")
    try:
      value = frame.f_globals[varname] ;# This will fail if global not exists
      print(f'    Found global var {varname}')
      return value
    except: pass

    if DBG: print("    not global either; guess it's not plugged in yet")
    return None


##############################################################################
##############################################################################
##############################################################################
# OLD
# 
# 
#   def self.findvar(frame, varname):
#     outcome = {}
#     try:
#       outcome['where'] = 'local'
#       outcome['value'] = frame.f_locals[varname] ;# This will fail if local not exists
#       return outcome
#     except: pass
#     try:
#       outcome['where'] = 'global'
#       outcome['value'] = frame.f_globals[varname] ;# This will fail if global not exists
#       return outcome
#     except:
#       outcome['where'] = 'not found'
#       return outcome
# 
# 
# 
#   def testparser( s, nodestring ):
#     P = ParseNodes();
#     P.do_test(nodestring)
# 
# 
# 
#   def srtest ( s ):
#     """Usage info etc.
#     """
#     print("FOO I am srtest")
# 
#     P = ParseNodes();
#     P.do_all_tests()
# 
#     do_all_tests()
# 
# #     print(module.__file__)
# #     for v in module: print(v)
# # 
# # 
# #     globals = inspect.getmembers(frame[0].f_globals)
# #     for L in globals: print(L)
# # 
#     locals = frame[0].f_locals
#     for L in locals: print(L)
#     print("---")
# 
#     print(frame[0].f_locals['adk_name'])
#     frame[0].f_locals['adk_name'] = "footle"
#     print("---")
# 
# 
#     locals = frame[0].f_locals
#     for L in locals: print(L)
#     print("---")
# 
# #     exec( 'rtl=10', frame[0].f_globals, frame[0].f_locals)
# 
# 
#     return
# 
#     
# 
# 
# 
#     locals = inspect.getmembers(frame[0].f_locals)
#     for L in locals: print(L)
#                                 
#     print("FOOOOOOOO")
#     locals = inspect.getmembers(frame[1].f_locals)
#     for L in locals: print(L)
# 
# 
# 
# 
# #     module.locals()['rtl'] = Step(this_dir + '/../common/rtl')
# # 
# 
# getmembers()
# type='module', attribute='__file'
# type='frame', attribute='f_locals'
# 
# 
#       # frame[0].f_globals['rtl'] = Step( this_dir + '/../common/rtl')
#       # frame[0].f_globals[stepname] = Step( this_dir + '/' + stepdir )
#       # globals()[stepname] = step
# 
#       
# 
#       to_list=[]
#       for i in self._todo[from_name]: to_list.append(i); # must do this instead :(
# 
# 
#           self.connect_by_name( from_node, to_node)
# 
#           if DBG:
#             print(f"    REMOVING {to_name} from {from_name} todo list ")
#             print(f"      todo list BEFORE: {self._todo[from_name]}")
#           self._todo[from_name].remove(to_name)
#           if DBG: print(f"      todo list AFTER:  {self._todo[from_name]}")


      # 3. g.connect_by_name( rtl, synth )
      # If a successor node does not exist yet, add to 'todo' list



#         if DBG: print(f"  CONNECTING {stepname} to {succ_name}")
#         try:
#           # FIXME can succ_name be local instead of global??
#           self.connect_by_name( step, frame.f_globals[succ_name])
#           if DBG: print("    CONNECTED!!!")
# 
# #           if stepname in self._extnodes:
# #             #   extend_step("custom_init - custom-init -> init")
# #             # succ.extend_inputs( step.all_outputs() )
# # 
# 
#         except:
#           if DBG: print("    HA looks like {succ_name} don't exist (yet)")
#           if DBG: print("    Add it to the todo list")
#           # self._todo[stepname].append(succ_name)
#           self._todo[stepname].append(succ_name)


#       # Connect the nodes and update the todo list
#       def connectem( from_node, to_node ):
#         self.connect_by_name( from_node, to_node)
#         if DBG: print(f"      todo list BEFORE: {self._todo[from_name]}")
#         self._todo[from_name].remove(to_name)
#         if DBG: print(f"      todo list AFTER:  {self._todo[from_name]}")
#         print(f'    FOO CONNECTED {from_name} -> {to_name}')


#       # Connect node to its successor node, and update the todo list
#       def connectem(node, succ, succ_name):
#         self.connect_by_name(node, succ)
#         print(f'    FOO CONNECTED {from_name} -> {succ}')



#       if DBG:
#         print(f"  TODO: connect {from_name} -> {to_name} --- connect({from_name}, {to_name})")

      

#       # Look for succ in caller locals
#       try:
#         to_node = frame.f_locals[to_name] ;# This will fail if local not exists
#         self.connect_by_name(from_node, to_node)
#         if DBG: print(f'   CONNECTED {from_name} -> {to_name} (local)')
#         return True
#       except:
#         if DBG: print(f"    {to_name} not local, is it global perchance?")
# 
#       # Look for succ in caller globals
#       try: 
#         to_node = frame.f_globals[to_name] ;# This will fail if global not exists
#         self.connect_by_name(from_node, to_node)
#         if DBG: print(f'    CONNECTED {from_name} -> {to_name} (global)')
#         return True
#       except:
#         if DBG: print("    not global either; guess it's not plugged in yet")
#         return False

#   def _connect_from_to(self, frame, from_name, to_name, DBG=0):
#       '''
#       Given names for "from" and "to" nodes, try and connect the two.
#       If the "to" node does not exist (yet) in the given calling frame,
#       return "False".
#       '''
#       # Only global vars end up on the todo list, so 'from' node must be global
#       from_node = frame.f_globals[from_name]
# 
#       # Look for succ in caller locals
#       try:
#         to_node = frame.f_locals[to_name] ;# This will fail if local not exists
#         self.connect_by_name(from_node, to_node)
#         if DBG: print(f'   CONNECTED {from_name} -> {to_name} (local)')
#         return True
#       except:
#         if DBG: print(f"    {to_name} not local, is it global perchance?")
# 
#       # Look for succ in caller globals
#       try: 
#         to_node = frame.f_globals[to_name] ;# This will fail if global not exists
#         self.connect_by_name(from_node, to_node)
#         if DBG: print(f'    CONNECTED {from_name} -> {to_name} (global)')
#         return True
#       except:
#         if DBG: print("    not global either; guess it's not plugged in yet")
#         return False


