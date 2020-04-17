GcdUnit Pipe Cleaner
==========================================================================

To start the GcdUnit pipe cleaner, first start the built-in demo:

.. code:: bash

    % mflowgen run --demo
    % cd mflowgen-demo
    % top=$(pwd)

Then create a build directory and configure for this design:

.. code:: bash

    % cd $top
    % mkdir build && cd build
    % mflowgen run --design ../design
    % make list

Then open the mflowgen graph to see what this pipe cleaner flow looks
like:

.. code:: bash

    $ make graph
    (open graph.pdf in a PDF viewer like evince)
    $ evince graph.pdf

Here is the list of steps:

.. code:: bash

    $ make list
     -  0 : freepdk-45nm
     -  1 : rtl
     -  2 : info
     -  3 : constraints
     -  4 : testbench
     -  5 : rtl-sim
     -  6 : gen-saif-rtl
     -  7 : synopsys-dc-synthesis
     -  8 : cadence-innovus-flowsetup
     -  9 : cadence-innovus-init
     - 10 : cadence-innovus-power
     - 11 : cadence-innovus-place
     - 12 : cadence-innovus-cts
     - 13 : cadence-innovus-postcts_hold
     - 14 : cadence-innovus-route
     - 15 : cadence-innovus-postroute
     - 16 : cadence-innovus-signoff
     - 17 : mentor-calibre-gdsmerge
     - 18 : synopsys-pt-timing-signoff
     - 19 : synopsys-ptpx-rtl
     - 20 : synopsys-ptpx-genlibdb
     - 21 : mentor-calibre-drc
     - 22 : gl-sim
     - 23 : mentor-calibre-lvs
     - 24 : gen-saif-gl
     - 25 : synopsys-ptpx-gl

Feel free to cross-check the construct.py, the graph visualization, and
the `step configuration files
<https://github.com/cornell-brg/mflowgen/tree/master/steps>`_ to see which
files are passing between which steps.

Here is a high-level overview of the Innovus steps. The
``cadence-innovus-flowsetup`` node first uses a script generator to
generate the base scripts used in each of the downstream Innovus nodes
(also see the section on the Cadence Innovus Foundation Flow later in this
handout). The ``cadence-innovus-init`` step starts place and route by
reading in the design. Each of the subsequent nodes reads in a checkpoint
(i.e., an Innovus database), does something (e.g., runs placement), and
outputs another checkpoint. At the end of the flow, the
``cadence-innovus-signoff`` step dumps all outputs of place and route.
These outputs include the final gate-level netlist, GDS, and other files,
which are used to run further signoff steps (e.g., Calibre DRC and LVS).
Notice that a GDS merge step is needed to merge the GDS from place and
route (which includes only the wires) with the GDS of the standard cell
library.

You can run the GcdUnit pipe cleaner through to signoff like this:

.. code:: bash

    % make list   # check which step signoff is
    % make 16     # assuming signoff is step 16
    % make status # signoff should be marked done

Each of the Innovus steps can be brought up on a GUI with a debug target like this:

.. code:: bash

    % make debug-16 # brings up Innovus GUI after signoff

You should also get a sense of the runtime of each step:

.. code:: bash

    % make runtimes



