The Modular VLSI Build System
==========================================================================

**Author**: Christopher Torng (clt67@cornell.edu)

The Modular VLSI Build System is an open-source set of ASIC tool
scripts and build system generator scripts for interconnecting
moving pieces as well as a carefully designed set of policies for
minimizing friction when building new designs. The key idea is to
avoid rigidly structured ASIC flows that cannot be repurposed and to
instead break the ASIC flow into modular steps that can be
re-assembled for different designs.

--------------------------------------------------------------------------
License
--------------------------------------------------------------------------

The Modular VLSI Build System is offered under the terms of the Open
Source Initiative BSD 3-Clause License. More information about this
license can be found here:

- http://choosealicense.com/licenses/bsd-3-clause
- http://opensource.org/licenses/BSD-3-Clause

--------------------------------------------------------------------------
Quick Start
--------------------------------------------------------------------------

This repo includes a small Verilog design that computes a greater
common divisor that can be used to demo the ASIC flow
(designs/GcdUnit). This section steps through how to clone the repo
and push this design through synthesis, place, and route using the
open 45nm ASIC design kit.

Clone the repo:

    % git clone https://github.com/cornell-brg/alloy-asic
    % cd alloy-asic
    % TOP=$PWD

Configure for the default design (i.e., GcdUnit) with the default
open 45nm ASIC design kit:

    % cd $TOP
    % mkdir build && cd build
    % ../configure.py

You can show information about the currently configured flow fairly
easily:

    % make info      # <-- shows which design is being targeted
    % make list      # <-- shows most things you can do
    % make graph     # <-- dumps a PDF of the step dependency graph

Now run synthesis (requires yosys) and placement (requires RePlAce):

    % make open-yosys-synthesis
    % make open-replace-place

Report runtimes to check how long each step took:

    % make runtimes

<!--Open layout:-->


