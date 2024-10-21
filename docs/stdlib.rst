Common Library Reference
==========================================================================

This section walks through the common library included in mflowgen, using
standard commercial tools to synthesize an RTL design, place and route the
gates, generate a layout, and verify it with a set of signoff steps.

This section provides a high-level overview of running an entire pipe
cleaner before doing deeper dives into the open-source technology files,
submodular node organization, the DC synthesis node, the Innovus
Foundation Flow, the Innovus nodes, how to run each node, and which
scripts and reports are the most important to inspect.

Pipe cleaners are small designs that run through the flow quickly and help
to identify errors early. It is good practice to frequently run pipe
cleaners while developing the flow before running your full design. We
will be using the GcdUnit design as a pipecleaner.

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   stdlib-pipe-cleaners
   stdlib-freepdk45
   stdlib-submodular-nodes.rst
   stdlib-dc-synthesis
   stdlib-innovus-flowsetup
   stdlib-innovus-floorplan
   stdlib-innovus-power
   stdlib-innovus-place
   stdlib-innovus-cts
   stdlib-innovus-signoff
   stdlib-mentor-drc
   stdlib-mentor-lvs
   stdlib-nodes
   stdlib-openroad

