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
generate highly parameterized graphs to explore large design spaces in a
single graph. For example, we could sweep the design clock period to
quickly see where timing fails, or we could sweep a set of combinational
operators (e.g., add, mul, floating ops) across different bitwidths,
precision formats, and input datasets both for testing and for energy and
timing estimation.

.. In a basic workflow, trying multiple values for a single parameter looks
.. like a user loop around the entire graph (i.e., multiple independent runs
.. configured and kicked off manually). Mflowgen provides the API to unroll
.. the loop into one big graph. For example, suppose we wanted to quickly
.. sweep the clock period parameter from 500 MHz to 800 MHz to see where
.. timing fails. Instead of manually instantiating the same graph multiple
.. times with tweaked clock periods ...

As a simple example, suppose we would like to sweep the `clock_period`
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

This essentially "unrolls the loop" within a single graph, allowing you to
more easily define and explore a parameter space, while avoiding manually
creating these spaces on your own. The three builds can be run in parallel
as usual (e.g., with "make -j" on different nodes), and all file
management is handled cleanly by the build system according to your
expanded graph.

.. note::

    If your graph updates parameters, please make sure to only run
    :py:mod:`Graph.param_space` *after* those calls. Specifically, all
    parameters except the target parameter should already be set.
    :py:mod:`Graph.param_space` unrolls the loop across the parameter
    space for the *target* parameter (e.g., "clock_period") but uses the
    existing values for non-target parameters. It is difficult to adjust
    parameters after the loop has already been unrolled.

Note that because parameters are passed as environment variables,
parameter sweeping can be flexibly applied anywhere in the physical design
flow in a very simple manner:

1. Replace some code with a variable anywhere in your scripts
2. Identify this variable as a parameter (i.e., in the step's configure.yml)
3. Use the `param_space()` mflowgen API to perform a sweep of that variable

This can be useful for automating design-space exploration sweeps
involving one parameter or multiple parameters.


