==========================================================================
cadence-innovus-flowsetup
==========================================================================
Author : Christopher Torng
Date   : January 13, 2020

The Cadence Innovus Foundation Flow is a generator built by Cadence
for managing the primary steps of place and route:

- init
- place
- cts
- postcts_hold
- route
- postroute
- signoff

The goal of this node is to leverage the foundation flow's
development cycle to track Cadence-recommended usage of their own
super commands, while also allowing users to further customize the
generated PnR flow beyond what the foundation flow generator
enables.

Cadence's generator is not as flexible as mflowgen. For example:

- The graph is fairly rigid and only supports a certain set of steps.

- Each step's script contains the name and path to the previous
  step's files (i.e., generated scripts are not modular).

- The entire foundation flow is meant to be run from the same single
  directory at the same absolute path. Moving the directory
  elsewhere will break the scripts (i.e., not portable).

This mflowgen node packages the Innovus Foundation Flow in a way
that mitigates these problems.

- Flexibility to add more steps between foundation flow steps (e.g.,
  a power planning step)

- Modularity for each step

- Steps are portable (i.e., moving the directory elsewhere should
  not break the builds)



