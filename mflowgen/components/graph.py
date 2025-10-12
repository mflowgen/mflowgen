#=========================================================================
# graph.py
#=========================================================================
# Author : Christopher Torng
# Date   : June 2, 2019
#

import os

from mflowgen.components.node     import Node
from mflowgen.components.subgraph import Subgraph
from mflowgen.components.edge     import Edge
from mflowgen.utils               import get_top_dir

class Graph:
  """Graph of nodes and edges (i.e., :py:mod:`Node` and :py:mod:`Edge`)."""

  def __init__( s ):

    s._edges_i   = {}
    s._edges_o   = {}
    s._nodes     = {}
    s._subgraphs = {}
    s._inputs    = {}
    s._outputs   = {}

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

    # Search for adk nodes

    for p in s.sys_path:
      adk_path = p + '/' + adk
      try:
        s.adk_node = Node( adk_path, default=False )
      except:
        pass

    try:
      s.adk_node
    except AttributeError:
      raise OSError( 'Could not find adk "{}" in system paths: {}'.format(
        adk, s.sys_path ) )

    # Add the adk node to the graph

    s.add_node( s.adk_node )

  # get_adk_node

  def get_adk_node( s ):
    """Gets the Node object representing the ASIC design kit.

    Returns:
      The Node object that was constructed from the currently set ADK.
    """
    return s.adk_node

  # Make 'get_adk_step' an identical reference to 'get_adk_node'

  get_adk_step = get_adk_node

  # add_node

  def add_node( s, node ):
    """Adds a Node to the graph as a node.

    The name of the new Node cannot conflict with any nodes that already
    exist in the graph. This method fails an assertion if given a
    duplicate node name.

    Args:
      node: A Node object
    """
    key = node.get_name()
    assert key not in s._nodes.keys(), \
      'add_node -- Duplicate node "{}", ' \
      'if this is intentional, first change the node name'.format( key )
    s._nodes[ key ] = node
    if type(node) == Subgraph:
      s._subgraphs[ key ] = node

  # Make 'add_step' an identical reference to 'add_node'

  add_step = add_node

  def get_node( s, node_name ):
    """Gets the Node object with the given name.

    Args:
      node_name: A string representing the name of the node from :py:meth:`Node.get_name`
    """
    return s._nodes[ node_name ]

  # Make 'get_step' an identical reference to 'get_node'

  get_step = get_node

  def all_nodes( s ):
    return sorted( s._nodes.keys() )

  # Make 'all_steps' an identical reference to 'all_nodes'

  all_steps = all_nodes

  def all_subgraphs( s ):
    return sorted( s._subgraphs.keys() )

  # Edges -- incoming and outgoing adjacency lists
  # Sort them for better debuggability / repeatability / causality

  def sort_edges( s, edge_list ):
    edge_list.sort(key=lambda x: x.dst)
    return edge_list

  def get_edges_i( s, node_name ):
    try:
      return s.sort_edges(s._edges_i[ node_name ])
    except KeyError:
      return []

  def get_edges_o( s, node_name ):
    try:
      return s.sort_edges(s._edges_o[ node_name ])
    except KeyError:
      return []

  def add_input( s, name, *args ):
    """Makes the input of a node in the graph into an input of the full
    graph for when the graph is used as a subgraph in a hierarchical flow

    Args:
      name: Name to assign to the graph-level input
      args: Handle(s) of a nodes' inputs that we want to connect to graph input
    """
    assert name not in s._inputs.keys(), \
      f"add_input -- Duplicate input \"{name}\"."
    s._inputs[ name ] = []
    for input_handle in args:
      s._inputs[ name ].append( input_handle )

  def get_input( s, input_name ):
    """Gets the list of input handle objects connected to the given graph input name.
    Args:
      input_name: A string representing the name of the input assigned in from :py:meth:`Graph.add_input`
    """
    return s._inputs[ input_name ]

  def all_inputs( s ):
    return sorted( s._inputs.keys() )

  def add_output( s, name, output_handle ):
    """Makes the output of a node in the graph into an output of the full
    graph for when the graph is used as a subgraph in a hierarchical flow

    Args:
      name: Name to assign to the graph-level output
      output_node: Handle of node where graph output comes from
      output_handle: Handle of a node's output that we want to make a graph output
    """
    assert name not in s._outputs.keys(), \
      f"add_output -- Duplicate output \"{name}\"."
    s._outputs[ name ] = output_handle

  def get_output( s, output_name ):
    """Gets the output handle object connected to the given graph output name.

    Args:
      output_name: A string representing the name of the output assigned in from :py:meth:`Graph.add_output`
    """
    return s._outputs[ output_name ]

  def all_outputs( s ):
    return sorted( s._outputs.keys() )

  # Quality-of-life utility function

  def dangling_inputs( s ):

    dangling = []

    for node_name in s.all_nodes():

      incoming_edges        = s.get_edges_i( node_name )
      incoming_edge_f_names = [ e.get_dst()[1] for e in incoming_edges ]

      inputs = s.get_node( node_name ).all_inputs()

      if inputs:
        for x in inputs:
          if x not in incoming_edge_f_names:
            dangling.append( ( node_name, x ) )

    if dangling:
      for node_name, f_name in dangling:
        msg = 'Dangling input in node "{}": {}'
        msg = msg.format( node_name, f_name )
        print( msg )
    else:
      print( 'No dangling inputs in graph' )

  #-----------------------------------------------------------------------
  # Connect
  #-----------------------------------------------------------------------

  def connect( s, l_handle, r_handle ):

    # Twizzle and figure out which side is the src and which is the dst

    l_node_name, l_direction, l_handle_name = l_handle
    r_node_name, r_direction, r_handle_name = r_handle

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

    src_node_name, src_direction, src_f = src_handle
    dst_node_name, dst_direction, dst_f = dst_handle

    if dst_node_name not in s._edges_i.keys():
      s._edges_i[ dst_node_name ] = []
    if src_node_name not in s._edges_o.keys():
      s._edges_o[ src_node_name ] = []

    src = ( src_node_name, src_f )
    dst = ( dst_node_name, dst_f )
    e   = Edge( src, dst )

    # Add this edge to tracking

    s._edges_i[ dst_node_name ].append( e )
    s._edges_o[ src_node_name ].append( e )

  def connect_by_name( s, src, dst ):

    # Get the node (in case the user provided node names instead)

    if (type( src ) != Node) and not issubclass( type( src ), Node ):
      src_node = s.get_node( src )
    else:
      src_node = src
    src_node_name = src_node.get_name()
    assert src_node_name in s.all_nodes(), \
      'connect_by_name -- ' \
      'Node "{}" not found in graph'.format( src_node_name )

    if (type( dst ) != Node) and not issubclass( type( dst ), Node ):
      dst_node = s.get_node( dst )
    else:
      dst_node = dst
    dst_node_name = dst_node.get_name()
    assert dst_node_name in s.all_nodes(), \
      'connect_by_name -- ' \
      'Node "{}" not found in graph'.format( dst_node_name )

    # Find same-name matches between the src output and dst input

    src_outputs = src_node.all_outputs()
    dst_inputs  = dst_node.all_inputs()

    overlap = set( src_outputs ).intersection( set( dst_inputs ) )

    # For all overlaps, connect src to dst

    for name in overlap:
      l_handle = src_node.o( name )
      r_handle = dst_node.i( name )
      s.connect( l_handle, r_handle )

  #-----------------------------------------------------------------------
  # Parameter system
  #-----------------------------------------------------------------------

  def update_params( s, params ):
    """Updates parameters for all nodes in the graph.

    Calls :py:meth:`Node.update_params` for each node in the graph with the
    given parameter dictionary.

    Args:
      params: A dict of parameter names (strings) and values
    """

    for node_name in s.all_nodes():
      s.get_node( node_name ).update_params( params )

  def expand_params( s ):
    for node_name in s.all_nodes():
      s.get_node( node_name ).expand_params()

  #-----------------------------------------------------------------------
  # Metadata
  #-----------------------------------------------------------------------

  def dump_metadata_to_nodes( s, build_dirs, build_ids ):

    for node_name in s.all_nodes():

      edges_i = {}
      edges_o = {}

      try:
        for e in s._edges_i[ node_name ]:
          f = e.get_dst()[1]
          edge = { 'f'    : e.get_src()[1],
                   'node' : build_dirs[ e.get_src()[0] ] }
          try:
            edges_i[f].append( edge )
          except KeyError:
            edges_i[f] = [ edge ]
      except KeyError:
        pass

      try:
        for e in s._edges_o[ node_name ]:
          f = e.get_src()[1]
          edge = { 'f'    : e.get_dst()[1],
                   'node' : build_dirs[ e.get_dst()[0] ] }
          try:
            edges_o[f].append( edge )
          except KeyError:
            edges_o[f] = [ edge ]
      except KeyError:
        pass

      data = {
        'build_dir' : build_dirs [ node_name ],
        'build_id'  : build_ids  [ node_name ],
        'edges_i'   : edges_i,
        'edges_o'   : edges_o,
      }

      s.get_node( node_name ).update_metadata( data )

  # Make 'dump_metadata_to_steps' an identical reference to 'dump_metadata_to_nodes'

  dump_metadata_to_steps = dump_metadata_to_nodes

  #-----------------------------------------------------------------------
  # Design-space exploration
  #-----------------------------------------------------------------------

  # param_space

  def param_space( s, node, param_name, param_space ):
    """Spins out new copies of the node across the parameter space.

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
      node        : A string for the node name targeted for expansion
      param_name  : A string for the parameter name
      param_space : A list of parameter values to expand to

    Returns:
      A list of (parameterized) nodes (i.e., 'bar-p-1', 'bar-p-2', and
      'bar-p-3').
    """

    # Get the node name (in case the user provided a node object instead)

    if type( node ) != str:
      node_name = node.get_name()
    else:
      node_name = node
      node      = s.get_node( node_name )

    assert node_name in s.all_nodes(), \
      'param_space -- ' \
      'Node "{}" not found in graph'.format( node_name )

    # Remove the node and its incoming edges from the graph

    del( s._nodes[ node_name ] )

    elist_i = s._param_space_helper_remove_incoming_edges( node_name )

    # Now spin out new copies of the node across the parameter space
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

    new_nodes = []

    for p in param_space:
      p_node = node.clone()
      p_node.set_param( param_name, p )
      p_node.set_name( node_name + '-' + param_name + '-' + str(p) )
      s.add_node( p_node )
      for e in elist_i:
        src_node_name, src_f = e.get_src()
        dst_node_name, dst_f = e.get_dst()
        src_node = s.get_node( src_node_name )
        s.connect( src_node.o( src_f ), p_node.i( dst_f ) )
      new_nodes.append( p_node )

    # Build a dict to map (removed) base nodes to their expanded nodes

    new_src_map = { node_name : new_nodes }

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

    dep_nodes = s._param_space_helper_get_dependent_nodes( node_name )
    dep_nodes = s.topological_sort( seed_nodes=dep_nodes )

    # For each dependent node, replicate and connect to the graph

    visited = set()

    for dep_node in dep_nodes:
      s._param_space_helper( node_name   = dep_node,
                             new_src_map = new_src_map,
                             visited     = visited,
                             param_name  = param_name,
                             param_space = param_space )

    return new_nodes

  # _param_space_helper
  #
  # Take the dependent node (i.e., baz), replicate the node across the
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

  def _param_space_helper( s, node_name, new_src_map, visited,
                                         param_name,  param_space ):

    if node_name in visited:
      return
    else:
      visited.add( node_name )

    node = s.get_node( node_name )

    # Remove the node and its incoming edges from the graph

    del( s._nodes[ node_name ] )

    elist_i = s._param_space_helper_remove_incoming_edges( node_name )

    # Now spin out new copies of the node + attach them to new srcs

    new_nodes = []

    for i, p in enumerate( param_space ):
      p_node = node.clone()
      p_node.set_name( node_name + '-' + param_name + '-' + str(p) )
      # Propagate the new parameter value to downstream nodes
      try:
        p_node.set_param( param_name, p )
      # If the parameter cannot be accessed, do nothing to the parameter
      except KeyError:
        pass
      s.add_node( p_node )
      for e in elist_i:
        src_node_name, src_f = e.get_src()
        dst_node_name, dst_f = e.get_dst()
        if src_node_name in new_src_map.keys():
          src_node = new_src_map[src_node_name][i]
        else:
          src_node = s.get_node( src_node_name )
        s.connect( src_node.o( src_f ), p_node.i( dst_f ) )
      new_nodes.append( p_node )

    # Build a dict to map (removed) base nodes to their expanded nodes

    new_src_map.update( { node_name : new_nodes } )

    # Recurse on downstream nodes

    dep_nodes = s._param_space_helper_get_dependent_nodes( node_name )
    dep_nodes = s.topological_sort( seed_nodes=dep_nodes )

    # For each dependent node, replicate and connect to the new nodes

    for dep_node in dep_nodes:
      s._param_space_helper( node_name   = dep_node,
                             new_src_map = new_src_map,
                             visited     = visited,
                             param_name  = param_name,
                             param_space = param_space )

    return new_nodes

  def _param_space_helper_remove_incoming_edges( s, node_name ):

    try:
      elist_i = s._edges_i[ node_name ]
      del( s._edges_i[ node_name ] ) # Delete edges in incoming edge list
      for e in elist_i: # Also delete these edges in outgoing edge lists
        src_node_name, src_f = e.get_src()
        src_elist_o = s._edges_o[src_node_name]
        del( src_elist_o[ src_elist_o.index( e ) ] )
    except KeyError:
      elist_i = []

    return elist_i

  def _param_space_helper_get_dependent_nodes( s, node_name ):

    dep_nodes = set()

    try:
      elist_o = s._edges_o[ node_name ]
    except KeyError:
      elist_o = []

    for e in elist_o:
      dst_node_name, dst_f = e.get_dst()
      dep_nodes.add( dst_node_name )

    return dep_nodes

  # Make '_param_space_helper_get_dependent_steps' an identical reference to '_param_space_helper_get_dependent_nodes'

  _param_space_helper_get_dependent_steps = _param_space_helper_get_dependent_nodes

  #-----------------------------------------------------------------------
  # Ninja helpers
  #-----------------------------------------------------------------------

  def escape_dollars( s ):
    for node_name in s.all_nodes():
      s.get_node( node_name ).escape_dollars()

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

    # Loop over all nodes and generate a graphviz node declaration
    #
    # Each node will become a graphviz "record" shape, which has a special
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

    for node_name in s.all_nodes():
      node     = s.get_node( node_name )
      port_str = '<{dot_port_id}> {label}'

      i_port_strs = []
      o_port_strs = []

      for _input in sorted( node.all_inputs() ):
        dot_port_id = dot_format_fix( 'i_' + _input )
        i_port_strs.append( \
          port_str.format( dot_port_id=dot_port_id, label=_input ) )

      for _output in sorted( node.all_outputs() ):
        dot_port_id = dot_format_fix( 'o_' + _output )
        o_port_strs.append( \
          port_str.format( dot_port_id=dot_port_id, label=_output ) )

      node_cfg           = {}
      node_cfg['dot_id'] = dot_format_fix( node_name )
      node_cfg['name']   = node_name
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

        src_node_name, src_f = e.get_src()
        dst_node_name, dst_f = e.get_dst()

        e_cfg                = {}
        e_cfg['src_dot_id']  = dot_format_fix( src_node_name )
        e_cfg['src_port_id'] = dot_format_fix( 'o_' + src_f  )
        e_cfg['dst_dot_id']  = dot_format_fix( dst_node_name )
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

  def topological_sort( s, seed_nodes=False ):

    order = []

    # Make a deep copy of the edges (destructive algorithm)

    edges_deep_copy = {}
    for node_name, elist in s._edges_i.items():
      edges_deep_copy[ node_name ] = list(elist)
    edges = edges_deep_copy

    # Consider all nodes in the graph, or if there are seed nodes then
    # only consider that subgraph (with incoming dangling edges removed)

    if type( seed_nodes ) != set:
      nodes = set( s.all_nodes() )
    else:
      nodes = set( seed_nodes )
      # If there are no nodes, just return an empty list
      if not nodes:
        return []
      # Delete any edges directed to nodes not in the subgraph
      nodes_with_edges_i = list( edges.keys() )
      for k in nodes_with_edges_i:
        if k not in seed_nodes:
          del( edges[k] )
      # Delete any incoming edges from src nodes not in the subgraph
      keys_to_delete = []
      for node_name, elist in edges.items():
        idx_to_delete = []
        for i, e in enumerate( elist ):
          if e.get_src()[0] not in seed_nodes:
            idx_to_delete.append( i )
        for i in reversed( idx_to_delete ):
          del( elist[i] )
        if elist == []:
          keys_to_delete.append( node_name )
      for k in keys_to_delete:
        del( edges[k] )

    # Topological sort

    while( nodes ):

      nodes_with_deps    = set( edges.keys() )
      nodes_without_deps = nodes.difference( nodes_with_deps )

      assert nodes_without_deps, \
        'topological_sort -- Could not find a valid sort for ' \
        '{}'.format( nodes )

      order.extend( sorted( nodes_without_deps ) ) # sort for determinacy
      nodes = nodes_with_deps

      keys_to_delete = []
      for node_name, elist in edges.items():
        idx_to_delete = []
        for i, e in enumerate( elist ):
          if e.get_src()[0] in order:
            idx_to_delete.append( i )
        for i in reversed( idx_to_delete ):
          del( elist[i] )
        if elist == []:
          keys_to_delete.append( node_name )

      for k in keys_to_delete:
        del( edges[k] )

    return order

  #-----------------------------------------------------------------------
  # Input node generation for hierarchical support
  #-----------------------------------------------------------------------

  def generate_input_node( s ):
    input_node_config = {}
    graph_input_names = list(s._inputs.keys())
    # Output node simply gathers together all the inputs
    # from other nodes in the graph.
    input_node_config['outputs'] = graph_input_names
    input_node_config['name'] = 'inputs'
    input_node_config['commands'] = [ 'mkdir -p outputs && cd outputs' ]
    for input_name in s._inputs:
      input_node_config['commands'].append(f"ln -sf ../../inputs/{input_name} .")
    input_node = Node( input_node_config )

    # Now that we've created the node, add it to the graph and connect
    s.add_node( input_node )
    for input_name, int_node_inputs in s._inputs.items():
      for int_node_input in int_node_inputs:
        s.connect( input_node.o( input_name ), int_node_input )

  # Make 'generate_input_step' an identical reference to 'generate_input_node'

  generate_input_step = generate_input_node

  #-----------------------------------------------------------------------
  # Output node generation for hierarchical support
  #-----------------------------------------------------------------------

  def generate_output_node( s ):
    output_node_config = {}
    graph_output_names = list(s._outputs.keys())
    # Output node simply gathers together all the outputs
    # from other nodes in the graph.
    output_node_config['inputs'] = graph_output_names
    output_node_config['outputs'] = graph_output_names
    output_node_config['name'] = 'outputs'
    output_node_config['commands'] = [ 'mkdir -p outputs && cd outputs' ]
    for output_name in s._outputs:
      output_node_config['commands'].append(f"ln -sf ../inputs/{output_name} .")
    output_node = Node( output_node_config )

    # Now that we've created the node, add it to the graph and connect
    s.add_node( output_node )
    for output_name, int_node_output in s._outputs.items():
      s.connect( int_node_output, output_node.i( output_name ) )

  # Make 'generate_output_step' an identical reference to 'generate_output_node'

  generate_output_step = generate_output_node


