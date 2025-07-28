.. _openroad-custom:

Customizing OpenROAD Integration in mflowgen
==========================================================================

We have improved our integration with the `OpenROAD Flow Scripts (ORFS) <https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts>`__
to give users more control and flexibility when building physical design flows in mflowgen.

In the earlier version, the mflowgen flow was closely tied to how ORFS works internally. It followed the same fixed order of steps as defined in the ORFS Makefile (for example, floorplan → place → route, etc.). This made it difficult to add new steps or change the flow.

In this improved version, the flow has been restructured so that each step in ORFS is a standalone mflowgen node. These nodes can now be connected
in any order using mflowgen’s normal configuration, which allows users to add their own steps, remove or replace existing ones, and modify the flow to suit their design goals.

What’s New?
-----------

- **Each ORFS step is separate**: Steps like floorplan, placement, clock tree synthesis, and routing are now separate blocks in mflowgen.
- **You can add your own steps**: Users can write their own OpenROAD scripts and plug them into the flow wherever needed.
- **More flexibility**: You’re no longer limited to the standard ORFS setup. You can experiment with different ideas easily.
- **Same base Docker setup**: All the steps still use the same Docker image, so everything stays compatible and easy to run.

Example: Adding a Power Planning Step
--------------------------------------

Let’s say you want to try different power grid strategies in your layout.

You can create a new step like this:

.. code:: bash

   orfs-openroad-custom-power/
     ├── configure.yml/
     ├── parse-connectivity.py/
     ├── pdn-new-strategy.tcl/

Then insert it into your graph between placement and CTS:

.. code:: python

    # construct-open.py
    g.connect_by_name(orfs_place, orfs_power)
    g.connect_by_name(orfs_power, orfs_cts)

Your graph now includes a `orfs-openroad-power` bubble that is executed within the larger OpenROAD flow context.

.. image:: _static/images/stdlib/openroad-power-bubble.jpg
   :width: 500px

Summary
-------

This new version of the integration lets you:

- Break apart the ORFS flow into flexible pieces
- Insert your own design steps easily
- Try out new ideas using your own OpenROAD scripts

We call this: **Support for customizing ORFS flows using your own OpenROAD steps in mflowgen**.

This makes mflowgen much more powerful for design experiments and advanced physical design work.
