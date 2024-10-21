==========================================================================
Class Graph
==========================================================================

.. module:: mflowgen.components

A Graph is composed of nodes and edges (i.e., :py:mod:`Step` and
:py:mod:`Edge` objects).

Note that for general discussion, we use the words "step" and "node"
interchangeably in the following documentation. However, the python code
defines a :py:mod:`Step` class.

.. autoclass:: Graph

ADK-related
--------------------------------------------------------------------------

The following methods help interface with the ADK.

  .. automethod:: Graph.set_adk

  .. automethod:: Graph.get_adk_step

Adding Nodes
--------------------------------------------------------------------------

  .. automethod:: Graph.add_step

  .. automethod:: Graph.get_step

  .. automethod:: Graph.all_steps()

Connecting Nodes Together
--------------------------------------------------------------------------

The :py:meth:`Graph.connect_by_name` method is preferred when possible to
keep code clean. This requires setting up nodes such that the inputs and
outputs are name-matched (e.g., nodeA has output `foo` and nodeB has input
`foo`).

  .. automethod:: Graph.connect( l_handle, r_handle )
  .. automethod:: Graph.connect_by_name( src, dst )

Parameter System
--------------------------------------------------------------------------

  .. automethod:: Graph.update_params( params )

Advanced Graph-Building
--------------------------------------------------------------------------

  .. automethod:: Graph.param_space( step, param_name, param_space )

..  .. automethod:: Graph.get_edges_i( step_name )
..  .. automethod:: Graph.get_edges_o( step_name )
..  .. automethod:: Graph.dangling_inputs()
..
..  .. automethod:: Graph.plot( dot_title='', dot_f='graph.dot' )
..  .. automethod:: Graph.topological_sort( seed_steps=False )
..
..  .. expand_params()
..  .. escape_dollars()



