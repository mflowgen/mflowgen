Sweeping Large Design Spaces
==========================================================================

.. In contrast to software, hardware design includes both logical
.. design-space exploration (i.e., architecture, RTL source code) and
.. physical design-space exploration (e.g., floorplanning and power
.. strategy). Physical design-space exploration can be uniquely
.. challenging because ASIC tools work extensively with files, making
.. an already challenging problem more difficult due to additional file
.. management for many slightly different builds.

Being embedded in a high-level language like Python allows mflowgen to
generate highly parameterized graphs to explore large design spaces. For
example, we could sweep the design space of combinational operators (e.g.,
add, mul, floating ops) across different bitwidths, precision formats,
and input datasets (for energy and for testing).

As a simpler example, suppose we would like to sweep the `clock_period`
parameter in the `open-yosys-synthesis` step in this graph:

.. image:: _static/images/example-params-1.jpg
  :width: 200px

The mflowgen Python API :py:mod:`Graph.param_space` expands the node for
each parameter value in the list:

.. code:: python

    g = Graph()
    (... add steps and connect them together ... )
    g.param_space( 'open-yosys-synthesis', 'clock_period', [ 0.5, 1.0, 1.5 ] )

The expansion propagates to all downstream nodes, resulting in three
slightly different builds:

.. image:: _static/images/example-params-2.jpg
  :width: 500px

The three builds can be run in parallel and the results compared.
All file management is handled cleanly by the build system (which
mflowgen generates from the graph).

Note that because parameters are passed as environment variables,
parameter sweeping can be flexibly applied anywhere in the physical design
flow in a very simple manner:

1. Replace some code with a variable anywhere in your scripts
2. Identify this variable as a parameter (i.e., in the step's configure.yml)
3. Use the `param_space()` mflowgen API to perform a sweep of that variable

This can be useful for automating design-space exploration sweeps
involving one parameter or multiple parameters.


