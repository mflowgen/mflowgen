Synthesis
==========================================================================

We use Synopsys DC to synthesize a single RTL netlist file into gates. You
can run the design up to this node like this:

.. code:: bash

    % cd $top/build
    % make synopsys-dc-synthesis

Here are the inputs, outputs, and scripts in the synthesis node and what they
do.

+--------+-------------------------+------------------------------------------------------------------------+
| input  | adk                     | ASIC design kit interface to the process technology and library files. |
+--------+-------------------------+------------------------------------------------------------------------+
| input  | design.v                | The RTL design in Verilog/SystemVerilog.                               |
+--------+-------------------------+------------------------------------------------------------------------+
| input  | constraints.tcl         | Constraints on the design (e.g., input/output delays, min/max delays). |
+--------+-------------------------+------------------------------------------------------------------------+
| input  | run.saif                | An optional SAIF activity file for RTL-driven power estimation.        |
+--------+-------------------------+------------------------------------------------------------------------+
| output | design.v                | The post-synthesis gate-level netlist.                                 |
+--------+-------------------------+------------------------------------------------------------------------+
| output | design.sdc              | Constraints dumped from synthesis.                                     |
+--------+-------------------------+------------------------------------------------------------------------+
| output | design.namemap          | An optional name mapping for RTL nets and matching post-synth nets.    |
+--------+-------------------------+------------------------------------------------------------------------+

After running synthesis, feel free to enter the synthesis sandbox (e.g.,
``4-synopsys-dc-synthesis``) and find the following files in the reports
directory:

- GcdUnit.mapped.area.rpt
- GcdUnit.mapped.power.rpt
- GcdUnit.mapped.qor.rpt
- GcdUnit.mapped.timing.setup.rpt
- GcdUnit.premapped.checkdesign.rpt

The quality-of-results (QoR) report is the most useful and summarizes both
timing and area. The area report is a hierarchical breakdown of the module
based on the area numbers reported for each gate (from the stdcells.lib).
The power report is a *high-level estimate* of the power of your design
assuming about 10% switching activity on all nets (not very accurate, but
a good first-order estimate). The setup timing report contains the full
trace for the most critical timing paths, with the critical path listed
first.

.. Here is a list of checks you will want to run through before moving on to the next node:
..
.. - ``reports/foo`` -- foo bar.
..
.. - ``reports/bar`` -- foo bar.
..

There are also many parameters that can be used to slightly tweak the
behavior of this node. Here are the key parameters:

- ``design_name`` -- (**string**) Target a particular module within the
  input RTL

- ``clock_period`` -- (**float**) Clock target in library time units

Here are other useful parameters:

- ``flatten_effort`` -- (**int**) Flatten effort "0" is strict hierarchy,
  and effort "3" is full flattening. Default = 0.

- ``topographical`` -- (**bool**) Enable DC topographical mode, which does
  mini placements at synthesis time to estimate wire delays more
  accurately. Default = True.

- ``nthreads`` -- (**int**) The maximum number of threads given to DC.
  Note that DC is not always able to make use of all threads, even if they
  are available. Default = 16.

- ``high_effort_area_opt`` -- (**bool**) Tell DC to do an additional
  post-compile area optimization pass (has longer spin time). Default =
  False.

- ``gate_clock`` -- (**bool**) Automatic fine-grain clock gating. Default
  = True.

- ``uniquify_with_design_name`` -- (**bool**) Uniquify by prefixing every
  module in the design with the design name. This is useful for
  hierarchical LVS when multiple blocks use modules with the same name but
  different definitions. Default = True.


