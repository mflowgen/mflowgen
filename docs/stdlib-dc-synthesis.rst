Synthesis
==========================================================================

We use Synopsys DC to synthesize a single RTL netlist file into gates. You
can run the design up to this step like this:

.. code:: bash

    % cd $top/build
    % make synopsys-dc-synthesis

Here are the inputs, outputs, and scripts in the synthesis step and what they
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

.. Here is a list of checks you will want to run through before moving on to the next step:
..
.. - ``reports/place.summary`` -- With wires in place, the timing will be
..   worse than it was in init and synthesis. The timing must look good in
..   this report. The goal of all future steps is only to *preserve* the
..   timing in this report.
..
.. - ``logs/run.log`` -- Look for the final congestion analysis table in the
..   log. Make sure that the overflows are at most a few percent. If the
..   routing tracks are too oversubscribed (across all GCells in the design),
..   the resulting congestion will make timing very hard to meet. The table
..   below is nearly clean because there is no congestion in GcdUnit.
..
.. - Check density and congestion overlays in the GUI -- Open the debug
..   target for place. Then enable overlays as shown in the following figure.
..   This is a visual version of what you can already find in the logs.
..

There are also many parameters that can be used to slightly tweak the
behavior of this node. Here are the key parameters:

- ``design_name`` -- (string) Target a particular module within the input RTL

- ``clock_period`` -- (float) Clock target in library time units

Here are other useful parameters:

- ``flatten_effort`` -- (int) Flatten effort "0" is strict hierarchy, and effort "3" is full flattening. Default = 0.

- ``topographical`` -- (bool) Enable DC topographical mode, which does
  mini placements at synthesis time to estimate wire delays more
  accurately. Default = True.

- ``nthreads`` -- (int) The maximum number of threads given to DC. Note
  that DC is not always able to make use of all threads, even if they are
  available. Default = 16.

- ``high_effort_area_opt`` -- (bool) Tell DC to do an additional
  post-compile area optimization pass (has longer spin time). Default = False.

- ``gate_clock`` -- (bool) Automatic fine-grain clock gating. Default =
  True.

- ``uniquify_with_design_name`` -- (bool) Uniquify by prefixing every
  module in the design with the design name. This is useful for
  hierarchical LVS when multiple blocks use modules with the same name but
  different definitions. Default = True.


