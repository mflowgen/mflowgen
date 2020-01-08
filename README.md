mflowgen
==========================================================================

**Author**: Christopher Torng (clt67@cornell.edu)

mflowgen is a lightweight modular flow specification and build-system
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
  libraries and variables are abstracted and separated from
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
  flexible connection and disconnection of edges as well as
  insertion and removal of steps. A simple graph can be specified
  for a quick synthesis and place-and-route spin, or a more complex
  graph can be built for a more aggressive chip tapeout (reusing
  many of the same steps from before).

- **A focus on hardware design-space exploration** -- Steps can be
  parameterized to quickly spin out parallel builds for small
  physical-design decision points (e.g., different floorplan
  margins, different clock targets). Dependent files are shuttled to
  each sandbox as needed.

- **Complete freedom in defining what steps do** -- Aside from
  exposing precisely what the inputs and outputs are, no other
  restrictions are placed on what steps do. A step can be as simple
  as hello world (one line). A step may conduct an analysis pass and
  report a gate count. A step may also transform the netlist for
  consumption by other tools. A step can even instantiate a subgraph
  to implement a hierarchical flow.

mflowgen ships with a limited set of ASIC flow scripts for both
open-source and commercial tools including synthesis (e.g., Synopsys
DC, yosys), place and route (e.g., Cadence Innovus Foundation Flow,
RePlAce, graywolf, qrouter), and signoff (e.g., Synopsys PTPX). In
addition, we include an open-source 45nm ASIC design kit (ADK)
assembled from FreePDK45 version 1.4 and the NanGate Open Cell
Library.

--------------------------------------------------------------------------
License
--------------------------------------------------------------------------

mflowgen is offered under the terms of the Open Source Initiative BSD
3-Clause License. More information about this license can be found
here:

- http://choosealicense.com/licenses/bsd-3-clause
- http://opensource.org/licenses/BSD-3-Clause

--------------------------------------------------------------------------
Quick Start
--------------------------------------------------------------------------

This repo includes a small Verilog design that computes a greater
common divisor function. You can use this design to demo the ASIC
flow with open-source tools. This section steps through how to clone
the repo and push this design through synthesis, place, and route
using the included open-source 45nm ASIC design kit (ADK), assuming
the open-source tools are available.

Clone the repo:

    % git clone https://github.com/cornell-brg/mflowgen
    % cd mflowgen
    % TOP=$PWD

Configure for the example design (i.e., GcdUnit) with the default
open-source 45nm ADK and open-source ASIC toolflow. **Note**: To try
the commercial toolflow, open `designs/GcdUnit/.mflowgen.yml` and
select `construct-commercial.py` instead of `construct-open.py`.

    % cd $TOP
    % mkdir build && cd build
    % ../configure --design ../designs/GcdUnit

You can show information about the currently configured flow:

    % make info      # <-- shows which design is being targeted
    % make list      # <-- shows most things you can do
    % make status    # <-- prints the build status of each step
    % make graph     # <-- dumps a graphviz PDF of the configured flow

Now run synthesis and check the outputs of the sandbox to inspect
the area report. **Note**: For the commercial flow, check `make
list` for the build target name.

    % make open-yosys-synthesis
    % cat *-open-yosys-synthesis/outputs/synth.stats.txt

You can also run steps using the number from `make list`:

    % make list      # <-- 3 : open-yosys-synthesis
    % make 3

The yosys area report will look something like this:

    === GcdUnit ===

       Number of wires:                406
       Number of wire bits:           1011
       Number of public wires:         406
       Number of public wire bits:    1011
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:                941
         AOI211_X1                       3
         AOI21_X1                       34
         AOI22_X1                       30
         BUF_X1                        626
         CLKBUF_X1                       5
         DFF_X1                         34
         INV_X1                         48
         NAND2_X1                       42
         NAND3_X1                        3
         NOR2_X1                        34
         NOR3_X1                         3
         NOR4_X1                         4
         OAI211_X1                       1
         OAI21_X1                       40
         OAI221_X1                       1
         OAI22_X1                        2
         OR2_X1                          1
         XNOR2_X1                       18
         XOR2_X1                        12

       Chip area for this module: 932.330000

Then run place-and-route (requires graywolf and qrouter):

    % make open-graywolf-place
    % make open-qrouter-route

Report runtimes to check how long each step took:

    % make runtimes

--------------------------------------------------------------------------
Organization
--------------------------------------------------------------------------

The repository is organized at the top level with directories for
the ADKs, designs, and steps (and utility scripts):

```
mflowgen/
│
├── adks/      -- Each subdirectory is an ADK
├── designs/   -- Each subdirectory is a design (can be a cloned repo)
├── steps/     -- Collection of generic steps
│
│── mflowgen/  -- Source files for the build system generator
│── utils/     -- Helper scripts
└── configure  -- Config script to select a design
```

Designs include the graph specification, the source code, and any
design-specific steps.

New designs are meant to be cloned into (or symlinked into) the
designs subdirectory for easy access when configuring with `--design`.

--------------------------------------------------------------------------
Feature in Detail: Process and Technology Independence
--------------------------------------------------------------------------

The ASIC Design Kit (ADK) is a standard interface to all process
technology libraries and variables used across all ASIC scripts in
the tool flow. The ADK interface remains constant regardless of
where the actual packages and IP libraries are downloaded and how
they are organized. The ADK may include process technology files,
physical IP libraries (e.g., IO cells, standard cells, memory
compilers), as well as physical verification decks (e.g., Calibre
DRC/LVS).

mflowgen ships with an open-source 45nm ADK assembled from FreePDK45
version 1.4 and the NanGate Open Cell Library. We place all kits and
libraries into the directory `adks/freepdk-45nm/pkgs` in a
relatively unorganized manner (just untar them). We then create
different "views" into these packages for different purposes (e.g.,
front-end only, targeting open-source toolchains, targeting
commercial toolchains) by creating subdirectories with different
sets of symlinks to the vendor files.

Here is the "view-tiny" interface to the 45nm ADK containing only
the files needed by the open-source ASIC flow tools:

```
adk.tcl                     -- ADK variables setup script

rtk-tech.info               -- Qflow tech file
rtk-tech.lef                -- Routing tech kit LEF
rtk-tech.par                -- Graywolf tech file

stdcells.gds                -- Standard cell library GDS
stdcells.lef                -- Standard cell library LEF
stdcells.lib                -- Standard cell library typical Liberty
stdcells.v                  -- Standard cell library Verilog
```

**Note**: The `adk.tcl` encapsulates the ADK interface for
variables. Any information specific to this ADK goes here (e.g., the
list of filler cells, min/max routing metal layers).

The "view-standard" interface for the same 45nm ADK has more entries
and targets commercial ASIC flow tools. This interface is useful for
architectural design-space exploration of block-level designs. Note
that we conserve repository space by downloading this view from
online at build time:

```
adk.tcl                     -- ADK variables setup script

rtk-max.tluplus             -- Interconnect parasitics (max timing)
rtk-min.tluplus             -- Interconnect parasitics (min timing)
rtk-typical.captable        -- Interconnect parasitics (typical)
rtk-tech.lef                -- Routing tech kit LEF
rtk-tech.tf                 -- Routing tech kit Milkyway techfile
rtk-tluplus.map             -- Routing tech kit TLUPlus map
rtk-stream-out.map          -- Stream-out layer map for final GDS

stdcells.gds                -- Standard cell library GDS
stdcells.db                 -- Standard cell library typical DB
stdcells.lef                -- Standard cell library LEF
stdcells.lib                -- Standard cell library typical Liberty
stdcells.mwlib              -- Standard cell library Milkyway
stdcells.v                  -- Standard cell library Verilog
stdcells.cdl                -- Standard cell library LVS spice
stdcells-lpe.spi            -- Standard cell library extracted spice

calibre-drc-block.rule      -- Calibre DRC ruledeck
calibre-lvs.rule            -- Calibre LVS ruledeck
```

Here is a more complete and general-purpose ADK interface that might
target a chip tapeout (**files not included**):

```
adk.tcl                     -- ADK-specific setup script
alib                        -- Synopsys DC performance cache
calibre-drc-antenna.rule    -- Calibre DRC antenna rule deck
calibre-drc-block.rule      -- Calibre DRC block-level rule deck
calibre-drc-chip.rule       -- Calibre DRC chip-level rule deck
calibre-drc-wirebond.rule   -- Calibre DRC wire bond rule deck
calibre-fill.rule           -- Calibre ODPO/metal fill utility
calibre.layerprops          -- Calibre DRV display properties
calibre-lvs-DFM             -- Calibre LVS design-for-manufacture rules
calibre-lvs.rule            -- Calibre LVS rule deck
calibre-rcx-DFM             -- Calibre RCX design-for-manufacture rules
calibre-rcx.rule            -- Calibre RCX rules
calibre-rcx-rules           -- Calibre RCX rules
display.drf                 -- Cadence Virtuoso display file
iocells-bc.db               -- IO cell library best-case DB
iocells-bc.lib              -- IO cell library best-case Liberty
iocells-bondpads.gds        -- IO bondpad GDS
iocells-bondpads.lef        -- IO bondpad LEF
iocells.db                  -- IO cell library typical DB
iocells.gds                 -- IO cell library GDS
iocells.lef                 -- IO cell library LEF
iocells.lib                 -- IO cell library Liberty
iocells.spi                 -- IO cell library SPICE
iocells.v                   -- IO cell library Verilog
iocells-wc.db               -- IO cell library worst-case DB
iocells-wc.lib              -- IO cell library worst-case Liberty
klayout.lyp                 -- KLayout GDS viewer display file
pdk                         -- Link to PDK directory
pdk.layermap                -- PDK layer mapping file
pdk-rcbest-qrcTechFile      -- Interconnect parasitics (rcbest)
pdk-rcworst-qrcTechFile     -- Interconnect parasitics (rcworst)
pdk-typical-qrcTechFile     -- Interconnect parasitics (typical)
rtk-antenna-rules.tcl       -- Routing rules to avoid antennas
rtk-cbest.captable          -- Interconnect parasitics (cbest)
rtk-cworst.captable         -- Interconnect parasitics (cworst)
rtk-max.tluplus             -- Interconnect parasitics (max timing)
rtk-min.tluplus             -- Interconnect parasitics (min timing)
rtk-rcbest.captable         -- Interconnect parasitics (rcbest)
rtk-rcworst.captable        -- Interconnect parasitics (rcworst)
rtk-stream-in-milkyway.map  -- GDS-to-Milkyway layer map
rtk-stream-out.map          -- Stream-out layer map for final GDS
rtk-stream-out-milkyway.map -- Milkyway-to-GDS layer map
rtk-tech.lef                -- Routing tech kit LEF
rtk-tech.tf                 -- Routing tech kit Milkyway techfile
rtk-tluplus.map             -- Routing tech kit TLUPlus map
rtk-typical.captable        -- Interconnect parasitics (typical)
stdcells-bc.db              -- Standard cell library best-case DB
stdcells-bc.lib             -- Standard cell library best-case Liberty
stdcells.cdl                -- Standard cell library CDL for LVS
stdcells.db                 -- Standard cell library typical DB
stdcells.gds                -- Standard cell library GDS
stdcells.lef                -- Standard cell library LEF
stdcells.lib                -- Standard cell library typical Liberty
stdcells.mwlib              -- Standard cell library Milkyway
stdcells.v                  -- Standard cell library Verilog
stdcells-wc.db              -- Standard cell library worst-case DB
stdcells-wc.lib             -- Standard cell library worst-case Liberty
```

The ADK interface for variables in the `adk.tcl` includes the
following (with example values given), and examples of steps that
use these variables are listed in the comment:

```
set ADK_PROCESS                     28           # steps/innovus-flowsetup
set ADK_MIN_ROUTING_LAYER_DC        M2           # steps/dc-synthesis
set ADK_MAX_ROUTING_LAYER_DC        M7           # steps/dc-synthesis
set ADK_MAX_ROUTING_LAYER_INNOVUS   7            # steps/innovus-flowsetup
set ADK_POWER_MESH_BOT_LAYER        8            # steps/innovus-plugins
set ADK_POWER_MESH_TOP_LAYER        9            # steps/innovus-plugins
set ADK_DRIVING_CELL                (cell-name)  # steps/constraints
set ADK_TYPICAL_ON_CHIP_LOAD        0.005        # steps/constraints
set ADK_FILLER_CELLS                (list)       # steps/innovus-flowsetup
set ADK_TIE_CELLS                   (list)       # steps/innovus-flowsetup
set ADK_WELL_TAP_CELL               (cell-name)  # steps/innovus-flowsetup
set ADK_END_CAP_CELL                (cell-name)  # steps/innovus-flowsetup
set ADK_ANTENNA_CELL                (cell-name)  # steps/innovus-flowsetup
set ADK_LVS_EXCLUDE_CELL_LIST       ""           # steps/innovus-plugins
set ADK_VIRTUOSO_EXCLUDE_CELL_LIST  ""           # steps/innovus-plugins
```

--------------------------------------------------------------------------
Feature in Detail: Sandboxed and Modular Steps
--------------------------------------------------------------------------

A key philosophy of mflowgen is to avoid rigidly structured ASIC flows
that cannot be repurposed and to instead break the ASIC flow into
modular steps that can be re-assembled into different flows with
high reuse. Specifically, instead of having ASIC steps that directly
feed into the next steps, we design each step in modular fashion
with an "inputs" directory for inputs and an "outputs" directory for
outputs. The build system runs each step in its sandbox, generating
the outputs. Then, the build system handles the edges of the graph
by moving files between sandboxes.

Sandboxing each step encourages reuse of the same scripts across
many projects.

More details to come...

--------------------------------------------------------------------------
Feature in Detail: A focus on hardware design-space exploration
--------------------------------------------------------------------------

In contrast to software, hardware design includes both logical
design-space exploration (i.e., architecture, RTL source code) and
physical design-space exploration (e.g., floorplanning and power
strategy). Physical design-space exploration can be uniquely
challenging because ASIC tools work extensively with files, making
an already challenging problem more difficult due to additional file
management for many slightly different builds.

mflowgen supports both parameterization and parallel expansion across a
parameter space.

For example, suppose we would like to sweep the `clock_period` parameter in the `open-yosys-synthesis` step in this graph:

<img height='300px' src='docs/_static/images/example-params-1.jpg'>

The mflowgen Python API `param_space()` expands the node for each
parameter value in the list:

```
  g = Graph()
  (... add steps and connect them together ... )
  g.param_space( 'open-yosys-synthesis', 'clock_period', [ 0.5, 1.0, 1.5 ] )
```

The expansion propagates to all downstream nodes, resulting in three
slightly different builds:

<img height='300px' src='docs/_static/images/example-params-2.jpg'>

The three builds can be run in parallel and the results compared.
All file management is handled cleanly by the build system (which
mflowgen generates from the graph).

Note that because parameters are passed as environment variables,
parameter sweeping can be flexibly applied across the physical
design flow in a very simple manner:

1. Replace some code with a variable anywhere in your scripts
2. Identify this variable as a parameter (i.e., in the step's `configure.yml`)
3. Use the `param_space()` mflowgen API to perform a sweep of that variable

This can be useful for automating large design-space exploration
sweeps (e.g., different clock targets for designs with different
port widths, bitwidths, floorplan margins).

