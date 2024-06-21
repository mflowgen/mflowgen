Modifying Parameters
==========================================================================

Parameters can be updated across the modular flow in the following ways:

- **Node-specific** -- A node can specify a default setting for each parameter
  in its modular node specification file in YAML syntax.

- **Graph-specific** -- At graph construction time, users can use the
  Python-based graph building API (e.g., :py:meth:`set_param()`, :py:meth:`get_param()`, and
  :py:meth:`update_params()` to modify any parameters in the graph.

- **Interactively** -- At the command line, there is an additional command
  space called ``mflowgen param`` that can update parameters at build time.

This section describes the interactive mode in more detail.

On the command line, we want a simple interface to update parameters for
any node in the graph (or update all nodes). It looks like this:

.. code::

    % mflowgen param update --key clock_period --value 2.0 --step 5
    % mflowgen param update  -k   clock_period  -v     2.0  -s 5

Updating all nodes in the graph can use the ``--all`` flag:

.. code::

    % mflowgen param update --key clock_period --value 2.0 --all

For example, you can update the "design_name" parameter to modify the flow
to target a different top-level module:

.. code::

    % mflowgen param update -k design_name -v GcdUnit-modified --all

     - Update: 9-cadence-genus-synthesis    -- params["design_name"] = "GcdUnit-modified" ( was "GcdUnit" )
     - Update: 11-cadence-innovus-flowsetup -- params["design_name"] = "GcdUnit-modified" ( was "GcdUnit" )

As another example, you can update the "clock_period" parameter to try to
push timing on just the synthesis node:

.. code::

    % mflowgen param update -k clock_period -v 0.9 -s 9

     - Update: 9-cadence-genus-synthesis -- params["clock_period"] = "0.9" (
       was "1.0" )

The parameter updates are only applied if the key is defined and exists for
that node.

Also note that if you call "mflowgen run" again, these interactive parameter
updates are not preserved and must be run again.

