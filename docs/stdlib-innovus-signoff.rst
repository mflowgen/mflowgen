Route, Postroute, and Signoff
==========================================================================

The final nodes are less involved from a designer perspective. These nodes
run detailed route (i.e., the ``cadence-innovus-route`` node) and loop
until timing is met or until the tool quits (i.e., the
``cadence-innovus-postroute`` node). Then the final timing analysis is run
and output files are written out (i.e., the ``cadence-innovus-signoff``
node). You can run the design up to this node like this:

.. code:: bash

    % cd $top/build
    % make cadence-innovus-route
    % make cadence-innovus-postroute
    % make cadence-innovus-signoff

Here are the inputs, outputs, and scripts and what they do. You should not
expect to change these.

+--------+----------------------+---------------------------------------------------------+
| input  | design.checkpoint    | The working Innovus database from the previous node.    |
+--------+----------------------+---------------------------------------------------------+
| output | design.checkpoint    | The working Innovus database after the node finishes.   |
+--------+----------------------+---------------------------------------------------------+
| output | design.gds.gz        | The GDS layout with all wires and empty                 |
|        |                      | holes for the stdcells. The GDS merge                   |
|        |                      | node that comes next will combine this                  |
|        |                      | one with the stdcell.gds in the ADK (and                |
|        |                      | any SRAM gds) to create the final GDS.                  |
+--------+----------------------+---------------------------------------------------------+
| output | design.lvs.v,        | These are slightly different versions of the            |
|        | design.vcs.v, and    | post-place-and-route gate-level netlist for             |
|        | design.virtuoso.v    | different purposes. The LVS version removes             |
|        |                      | physical-only cells (e.g., fillers) that                |
|        |                      | would cause spurious LVS failures. The                  |
|        |                      | Virtuoso version removes decaps that                    |
|        |                      | significantly slow down SPICE simulation.               |
+--------+----------------------+---------------------------------------------------------+
| output | design.lef           | The LEF view of your final design. This can be used to  |
|        |                      | insert your design into a larger design in another flow.|
+--------+----------------------+---------------------------------------------------------+
| output | design.pt.sdc        | The constraints that Innovus used, meant to tell the    |
|        |                      | timing signoff engine in Synopsys PT what constraints   |
|        |                      | to use.                                                 |
+--------+----------------------+---------------------------------------------------------+
| output | design.spef.gz       | This file has parasitic RC values for every net in your |
|        |                      | design. This is used in timing signoff and power        |
|        |                      | estimation.                                             |
+--------+----------------------+---------------------------------------------------------+
| script | setup-optmode.tcl    | This is where you might set up slack targets for        |
|        |                      | setup/hold. If you are having trouble with small        |
|        |                      | amounts of negative slack, you can set numbers here.    |
+--------+----------------------+---------------------------------------------------------+
| script | generate-results.tcl | This script writes out all the design files after place |
|        |                      | and route is over.                                      |
+--------+----------------------+---------------------------------------------------------+

Here is a list of checks you will want to run through:

- ``reports/signoff.area.rpt`` -- Compare this area report to the report
  from synthesis. This area will be higher because it includes not just
  the gates but also margins, empty space (filler), halos, buffers, and
  any overheads from floorplan restrictions.

- ``logs/run.log`` -- Search for ``violations`` and make sure the
  violation count is zero. This is an automated Innovus DRC that is
  equivalent to clicking ``Verify DRC`` in the GUI. Also check the
  connectivity report in the log right next to the DRC. This is Innovus
  running LVS on the wires and making sure connections in the layout match
  those in the netlist.

- ``reports/signoff.summary`` -- The numbers in this report should be
  similar to those in the place summary report. The timing engine that
  generated these numbers is signoff quality, so the exact numbers will be
  slightly different.

- ``reports/signoff_hold.summary`` -- This is the hold timing report. This
  report must only have positive numbers!

- Pull up the GUI -- This is a good chance to just look at your final
  layout and check if anything odd catches your eye. Feel free to do any
  of the checks from previous nodes again.




