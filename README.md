mflowgen
==========================================================================
[![Documentation Status](https://readthedocs.org/projects/mflowgen/badge/?version=latest)](https://mflowgen.readthedocs.io/en/latest) [![Build Status](https://travis-ci.com/mflowgen/mflowgen.svg?branch=master)](https://travis-ci.com/mflowgen/mflowgen)

**Author**: Christopher Torng (ctorng@stanford.edu)

mflowgen is a modular flow specification and build-system
generator for ASIC and FPGA design-space exploration built around
sandboxed and modular steps.

mflowgen allows you to programmatically define and parameterize a graph
of steps (i.e., sandboxes that run anything you like) with
well-defined inputs and outputs. Build system files (e.g., make,
ninja) are then generated which shuttle files between steps before
running them.

<img width='350px' src='docs/_static/images/example-graph.jpg'>

Key features and design philosophies:

- **Process and technology independence** -- Process technology
  libraries and variables can be abstracted and separated from
  physical design scripts. Specifically, a single node called the
  ASIC design kit (ADK) captures this material in one place for
  better maintainability and access control.

- **Sandboxed and modular steps** -- Traditional ASIC flows are
  composed of many steps executing with fixed path dependencies. The
  resulting flows have low reusability across designs and technology
  nodes and can be confusing and monolithic. In contrast,
  _modularity_ encourages reuse of the same scripts across many
  projects, while _sandboxing_ makes each step self-contained and
  also makes the role of each step easy to understand (i.e., take
  these inputs and generate those outputs).

- **Programmatically defined build-system generator**: A
  Python-based scripting interface and a simple graph API allows
  flexible connection and disconnection of edges, insertion and
  removal of steps, and parameter space expansions. A simple graph
  can be specified for a quick synthesis and place-and-route spin,
  or a more complex graph can be built for a more aggressive chip
  tapeout (reusing many of the same steps from before).

- **Runtime assertions** -- Assertions can be built into each
  modular node and checked at runtime. Preconditions and
  postconditions are simply Python snippets that run before and
  after a node to catch unexpected situations that arise at build
  time. Assertions are collected and run with pytest. The mflowgen
  graph-building DSL can also extend a node with _design-specific_
  assertions by extending Python lists.

- **A focus on hardware design-space exploration** -- Parameter
  expansion can be applied to steps to quickly spin out parallel
  builds for design-space exploration at both smaller scales with a
  single parameter (e.g., sweeping clock targets) as well as at
  larger scales with multiple parameters (e.g., to characterize the
  area-energy tradeoff space of a new architectural widget with
  different knobs). Dependent files are shuttled to each sandbox
  as needed.

- **Complete freedom in defining what steps do** -- Aside from
  exposing precisely what the inputs and outputs are, no other
  restrictions are placed on what steps do and a step can be as
  simple as hello world (one line). A step may conduct an analysis
  pass and report a gate count. A step can also apply a transform
  pass to a netlist before passing it to other tools. In addition, a
  step can even instantiate a subgraph to implement a hierarchical
  flow.

mflowgen ships with a limited set of ASIC flow scripts for both
open-source and commercial tools including synthesis (e.g., Synopsys
DC, yosys), place and route (e.g., Cadence Innovus Foundation Flow,
RePlAce, graywolf, qrouter), and signoff (e.g., Synopsys PTPX,
Mentor Calibre). In addition, we include an open-source 45nm ASIC design
kit (ADK) assembled from FreePDK45 version 1.4 and the NanGate Open
Cell Library.

More info can be found in the
[documentation](https://mflowgen.readthedocs.io/en/latest).

--------------------------------------------------------------------------
License
--------------------------------------------------------------------------

mflowgen is offered under the terms of the Open Source Initiative BSD
3-Clause License. More information about this license can be found
here:

- http://choosealicense.com/licenses/bsd-3-clause
- http://opensource.org/licenses/BSD-3-Clause

