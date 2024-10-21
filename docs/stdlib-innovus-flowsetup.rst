The Innovus Foundation Flow
==========================================================================

Relevant mflowgen node: ``cadence-innovus-flowsetup``

Cadence Innovus comes with its own flow generator called the Innovus Foundation
Flow. The mflowgen nodes that we provide for Innovus use the foundation flow to
generate a base set of scripts that execute each of the major steps in place
and route (e.g., init, place, cts, route, postroute, signoff). Each script is
connected to a downstream mflowgen node that wraps the script and enhances it
for convenience and debuggability.

There is a major benefit to relying on the Cadence Innovus Foundation Flow for
the canonical commands. As Cadence updates its version of Innovus year after
year, their recommended options to achieve more optimal quality of results
changes. Some options are deprecated, other options are newly suggested, and
new commands are introduced. Using the foundation flow generator allows us to
easily leverage the most up-to-date, Cadence-recommended commands with no
maintenance costs of our own.

You can dump the foundation flow yourself by running the ``writeFlowTemplate``
command in an Innovus shell. This is essentially what the
``cadence-innovus-flowsetup`` node is responsible for (see the `node
configuration file
<https://github.com/mflowgen/mflowgen/blob/master/steps/cadence-innovus-flowsetup/configure.yml>`__).
Feel free to open Innovus and run it yourself:

.. code:: bash

    $ innovus
    >>> writeFlowTemplate

The generator will dump files into the current directory. The master script is
``SCRIPTS/gen_flow.tcl``. The ``cadence-innovus-flowsetup`` mflowgen node runs
this master script and generates the base scripts for the following steps:

+-----------------------------+------------------------------------------------------+
| Design initialization       | innovus-foundation-flow/INNOVUS/run_init.tcl         |
+-----------------------------+------------------------------------------------------+
| Placement                   | innovus-foundation-flow/INNOVUS/run_place.tcl        |
+-----------------------------+------------------------------------------------------+
| Clock tree synthesis (CTS)  | innovus-foundation-flow/INNOVUS/run_cts.tcl          |
+-----------------------------+------------------------------------------------------+
| Post-CTS hold-fixing        | innovus-foundation-flow/INNOVUS/run_postcts_hold.tcl |
+-----------------------------+------------------------------------------------------+
| Route                       | innovus-foundation-flow/INNOVUS/run_route.tcl        |
+-----------------------------+------------------------------------------------------+
| Postroute                   | innovus-foundation-flow/INNOVUS/run_postroute.tcl    |
+-----------------------------+------------------------------------------------------+
| Signoff                     | innovus-foundation-flow/INNOVUS/run_signoff.tcl      |
+-----------------------------+------------------------------------------------------+

The output of this node is the entire ``innovus-foundation-flow`` directory,
which feeds into all downstream Innovus nodes. Feel free to open each of these
scripts to see how the canonical place and route commands are run. Pay
particular attention to the super commands (e.g., placeDesign, optDesign).


