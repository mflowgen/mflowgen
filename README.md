The Modular VLSI Build System
==========================================================================

**Author**: Christopher Torng (clt67@cornell.edu)

Building VLSI implementations with millions of transistors is a
tremendous challenge for computer architecture and VLSI researchers,
and it is even more challenging to go beyond RTL to tape out fully
functional silicon prototypes for use as research vehicles. One of
the most challenging aspects of working with ASIC flows is managing
the many moving pieces (e.g., PDK, physical IP libraries,
ASIC-specific tools), which come from many different vendors and yet
must still be made to work together coherently. Once an ASIC flow
has been successfully assembled, it would be great to reuse it.
Unfortunately, teams typically end up with little reuse since new
designs may for example require slightly different ASIC flows,
target different technology nodes, or even use different vendors for
physical IP.

The Modular VLSI Build System is a set of ASIC tool scripts and
makefiles for managing the moving pieces as well as a carefully
designed set of policies for minimizing the friction when building
new designs. The key idea is to avoid rigidly structured ASIC flows
that cannot be repurposed and to instead break the ASIC flow into
modular steps that can be re-assembled into different flows. We also
introduce the idea of an ASIC design kit (ADK), which is the
specific set of physical backend files required to successfully
build chips, as well as a unified and standard interface to those
files. A well-defined interface enables swapping process and IP
libraries without modification to the scripts that use them.
Finally, this approach embraces plugins that hook into steps across
the entire ASIC flow for customizing the flow in design-specific
ways.

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

This repo includes the Verilog for a greater common divisor unit
that can be used to demo the ASIC flow (designs/GcdUnit-demo.v).
This section steps through how to clone the repo and push this
design through synthesis and automatic place-and-route.

Clone the repo:

    % git clone git@github.com:cornell-brg/alloy-asic.git
    % cd alloy-asic
    % TOP=$PWD

Configure for the default ASIC flow:

    % cd $TOP
    % mkdir build && cd build
    % ../configure
    % make info  # <-- shows which design is being targeted
    % make graph # <-- shows which steps are in the configured flow
    % make list  # <-- shows most things you can do

Start with synthesis:

    % make synth         # <-- this can take about a minute
    % make runtimes      # <-- check how long each step took
    % make debug-synth   # <-- bring up synthesis results in the GUI

Continue with place-and-route:

    % make signoff       # <-- this can take about ten minutes
    % make debug-signoff # <-- bring up the final layout in the GUI

Run Calibre DRC and LVS:

    % make drc           # <-- these can run in parallel with -j
    % make lvs           # <-- these can run in parallel with -j

Other useful asic flow commands:

    % make               # Execute all steps
    % make info          # Prints useful design information
    % make debug-synth   # Open design vision for synth
    % make debug-init    # See floorplan in Innovus
    % make debug-place   # See placement and power routing in Innovus
    % make debug-signoff # See final design in Innovus
    % make graph         # Draws an ASCII dependency graph of steps
    % make list          # Shows most things you can do
    % make print.*       # Print any Makefile variable
    % make print         # Print contents of all variables in print_list
    % make runtimes      # Table of runtimes
    % make seed          # Just generates the build directories

The rest of this README describes the ASIC Design Kit interface, the
modularized steps, the organization of the repository, the tools
used, and the verified tool versions in more detail.

--------------------------------------------------------------------------
ASIC Design Kit (ADK) Interface
--------------------------------------------------------------------------

The ADK interface is a standard set of filenames that are used
across all ASIC scripts in the flow. Regardless of how the actual
packages and IP libraries are downloaded, the ADK interface can be
created by making a single directory and copying or symlinking
(recommended) to the appropriate file in the backing store.

The ADK may include process technology files, physical IP libraries
(e.g., IO cells, standard cells, memory compilers), as well as
physical verification decks (e.g., Calibre DRC/LVS).

Here is the ADK interface that we use in this repository (files not
included):

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
pdk-rcbest-qrcTechFile      -- Interconnect parasitics (best case)
pdk-rcworst-qrcTechFile     -- Interconnect parasitics (worst case)
pdk-typical-qrcTechFile     -- Interconnect parasitics (typical)
rtk-antenna-rules.tcl       -- Routing tech kit antenna rule script
rtk-cbest.captable          -- Routing tech kit cbest cap tables
rtk-cworst.captable         -- Routing tech kit cworst cap tables
rtk-max.tluplus             -- Routing tech kit max TLUPlus parasitics
rtk-min.tluplus             -- Routing tech kit min TLUPlus parasitics
rtk-rcbest.captable         -- Routing tech kit rcbest cap tables
rtk-rcworst.captable        -- Routing tech kit rcworst cap tables
rtk-stream-in-milkyway.map  -- GDS-to-Milkyway layer map
rtk-stream-out.map          -- Innovus/EDI-to-GDS layer map
rtk-stream-out-milkyway.map -- Milkyway-to-GDS layer map
rtk-tech.lef                -- Routing tech kit LEF
rtk-tech.tf                 -- Routing tech kit Milkyway techfile
rtk-tluplus.map             -- Routing tech kit TLUPlus map
rtk-typical.captable        -- Routing tech kit typical cap tables
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

--------------------------------------------------------------------------
Modularized Steps
--------------------------------------------------------------------------

The key idea of a modular VLSI build system is to avoid rigidly
structured ASIC flows that cannot be repurposed and to instead break
the ASIC flow into modular steps that can be re-assembled into
different flows. Specifically, instead of having ASIC steps that
directly feed into the next steps, we design each step in modular
fashion with a collection directory for inputs and a handoff
directory for outputs. If we then describe the ASIC flow as a
dependency graph of these modular steps, then we can leverage the
build system to handle the edges by moving files from the handoff of
one step to the collection of the dependent step.

Here is a list of example steps, of which a subset are included in
this repository for reference:

```
template-step          -- Template for creating new steps
template-step-verbose  -- Template for creating new steps with help

calibre-drc            -- Run block-level DRC (Calibre)
calibre-drc-sealed     -- Run seal-ring'ed DRC (Calibre)
calibre-drc-top        -- Run chip-level DRC (Calibre)
calibre-fill           -- Run the Calibre ODPO/metal fill utility
calibre-gds-merge      -- GDS merge the design with IP library GDS
calibre-lvs            -- Run block-level LVS (Calibre)
calibre-lvs-sealed     -- Run seal-ring'ed LVS (Calibre)
calibre-lvs-top        -- Run chip-level LVS (Calibre)
calibre-seal           -- GDS merge the design with the seal ring
dc-synthesis           -- Synthesize the design RTL
gen-sram-cdl           -- Generate CDL from memory compiler
gen-sram-db            -- Generate DB from memory compiler
gen-sram-gds           -- Generate GDS from memory compiler
gen-sram-lef           -- Generate LEF from memory compiler
gen-sram-lib           -- Generate Liberty from memory compiler
gen-sram-verilog       -- Generate Verilog from memory compiler
info                   -- Print useful summary information
innovus-cts            -- Clock tree synthesis
innovus-flowsetup      -- Generate the Innovus Foundation Flow
innovus-init           -- Initialize and floorplan the design
innovus-place          -- Place
innovus-postctshold    -- Hold-fixing after clock tree synthesis
innovus-postroute      -- Timing optimization and final tweaks
innovus-route          -- Routing
innovus-signoff        -- Verifying the design + Generating results
mosis                  -- Tarball + Generate checksum before tapeout
sim-prep               -- Simulation preparation
sim-rtl-hard           -- RTL simulation with hardened IP
summarize-area         -- Analysis pass summarizing post-syn area
vcs-aprff              -- Gate-level sim for functionality
vcs-aprff-build        -- Gate-level sim for functionality
vcs-aprffx             -- Gate-level sim for functionality with X
vcs-aprffx-build       -- Gate-level sim for functionality with X
vcs-aprsdf             -- Gate-level sim for timing
vcs-aprsdf-build       -- Gate-level sim for timing
vcs-aprsdfx            -- Gate-level sim for timing with X
vcs-aprsdfx-build      -- Gate-level sim for timing with X
vcs-common-build       -- Common step for VCS sim
vcs-rtl                -- Synopsys VCS RTL sim
vcs-rtl-build          -- Synopsys VCS RTL sim
```

--------------------------------------------------------------------------
Organization of the Repository
--------------------------------------------------------------------------

The repository is organized as follows:

```
alloy-asic
│
├── Makefile.in  -- Primary makefile for the build system
│
├── designs      -- RTL source code
│
├── default-flow -- Default flow for architectural design-space explor.
├── custom-flows -- Custom flows for VLSI exploration, full chips, etc.
│
├── steps        -- Collection of modular steps
│
│── utils        -- Helper scripts
│
├── configure    -- Configure script to select an assembled ASIC flow
├── configure.ac -- Autoconf configure script that generates "configure"
├── ctx.m4       -- Autoconf helper macros
│
└── LICENSE      -- License
```

Assembling a flow involves (1) setting up the ADK, (2) setting up
the design, (3) assembling the ASIC flow from modular steps, and (4)
providing plugins to customize the steps. For example, here is the
default flow:

```
default-flow/
│
├── setup-adk.mk
├── setup-design.mk
├── setup-flow.mk
│
└── plugins
    ├── calibre
    │   └── (calibre-plugins)
    ├── dc-synthesis
    │   └── (dc-synthesis-plugins)
    └── innovus
        └── (innovus-plugins)
```

- **Setting up the ADK**: This just involves setting the "$adk\_dir"
  variable to point to the directory with the ADK symlinks.

- **Setting up the design**: This involves selecting the design to
  push as well as its top-level Verilog module name, the clock
  target, and the Verilog source file.

- **Assembling the ASIC flow**: To assemble an ASIC flow, list the
  steps and then specify for each step what the dependencies of that
  step are. See the default flow "setup-flow.mk" for an example.

- **Creating plugins for customization**: Plugin scripts are called
  from within steps and serve as user-defined hooks for customizing
  a step to a particular design. The default flow has default
  plugins that will work for a small subset of designs, but more
  complex designs (e.g., taping out a chip) will require heavy
  modifications to the plugin scripts.

--------------------------------------------------------------------------
Tools
--------------------------------------------------------------------------

The existing steps are based on the following tools, but other tools
can be plugged into the flow as well.

- Synopsys Design Compiler
- Synopsys VCS
- Cadence Innovus
- Cadence Virtuoso
- Calibre
- Calibre DESIGNrev

--------------------------------------------------------------------------
Verified Tool Versions
--------------------------------------------------------------------------

This build system has been verified with the following ASIC tool versions.

Synopsys Design Compiler:

```
% dc_shell-xg-t -v

dc_shell version    -  M-2016.12
dc_shell build date -  Nov 21, 2016
```

Synopsys VCS:

```
% vcs -ID

vcs script version : N-2017.12
Compiler version = VCS N-2017.12-1
VCS Build Date = Jan 18 2018 20:49:41
```

Cadence Innovus:

```
% innovus -version

@(#)CDS: Innovus v17.13-s098_1 (64bit) 02/08/2018 11:26 (Linux 2.6.18-194.el5)
@(#)CDS: NanoRoute 17.13-s098_1 NR180117-1602/17_13-UB (database version 2.30, 414.7.1) {superthreading v1.44}
@(#)CDS: AAE 17.13-s036 (64bit) 02/08/2018 (Linux 2.6.18-194.el5)
@(#)CDS: CTE 17.13-s031_1 () Feb  1 2018 09:16:44 ( )
@(#)CDS: SYNTECH 17.13-s011_1 () Jan 14 2018 01:24:42 ( )
@(#)CDS: CPE v17.13-s062
@(#)CDS: IQRC/TQRC 16.1.1-s220 (64bit) Fri Aug  4 09:53:48 PDT 2017 (Linux 2.6.18-194.el5)
@(#)CDS: OA 22.50-p063 Fri Feb  3 19:45:13 2017
@(#)CDS: SGN 10.10-p124 (19-Aug-2014) (64 bit executable)
@(#)CDS: RCDB 11.10
```

Cadence Virtuoso:

```
% virtuoso -V

@(#)$CDS: virtuoso version 6.1.7-64b 01/24/2018 13:57 (sjfhw315) $
```

Calibre:

```
% calibre -version

//  Calibre v2018.1_27.18    Thu Mar 1 14:53:23 PST 2018
//  Calibre Utility Library   v0-8_2-2017-1    Thu Aug 3 00:36:49 PDT 2017
//  Litho Libraries v2018.1_27.18  Thu Mar 1 14:53:23 PST 2018
```

Calibre DESIGNrev:

```
% calibredrv -version

//  Calibre DESIGNrev v2018.1_27.18    Thu Mar 1 14:53:23 PST 2018
//  Calibre Utility Library   v0-8_2-2017-1    Thu Aug 3 00:36:49 PDT 2017
```

Some parts of the Makefile are dependent on Bash (verified with
version 4.2.46(2)).

