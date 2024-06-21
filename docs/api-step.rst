--------------------------------------------------------------------------
Class Step
--------------------------------------------------------------------------

A Graph is composed of nodes and edges (i.e., `Step` and `Edge`
objects).

Note that for general discussion, we use the words "step" and "node"
interchangeably in the following documentation. However, the python code
defines a :py:mod:`Step` class.

.. py:class:: Step( step_path, default=False )
  :noindex:

.. py:module:: Step

.. py:classmethod:: clone()
.. py:classmethod:: get_input_handle( f )
.. py:classmethod:: get_output_handle( f )
.. py:classmethod:: i( name )
.. py:classmethod:: o( name )
.. py:classmethod:: all_input_handles()
.. py:classmethod:: all_output_handles()
.. py:classmethod:: extend_inputs( new_list )
.. py:classmethod:: extend_outputs( new_list )
.. py:classmethod:: pre_extend_commands( new_list )
.. py:classmethod:: extend_outputs( new_list )
.. py:classmethod:: extend_preconditions( new_list )
.. py:classmethod:: extend_postconditions( new_list )
.. py:classmethod:: set_name( name )
.. py:classmethod:: get_name()
.. py:classmethod:: set_param( param, value )
.. py:classmethod:: get_param( param )
.. py:classmethod:: update_params( params, allow_new=False )
.. py:classmethod:: params()
.. py:classmethod:: expand_params()
.. py:classmethod:: escape_dollars()
.. py:classmethod:: all_inputs()
.. py:classmethod:: all_outputs()
.. py:classmethod:: all_outputs_execute()
.. py:classmethod:: all_outputs_tagged()
.. py:classmethod:: all_outputs_untagged()
.. py:classmethod:: get_dir()
.. py:classmethod:: get_commands()
.. py:classmethod:: get_debug_commands()
.. py:classmethod:: dump_yaml( build_dir )
.. py:classmethod:: set_sandbox( val )
.. py:classmethod:: get_sandbox()

