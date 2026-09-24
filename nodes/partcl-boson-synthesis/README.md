# partcl-boson-synthesis

Logic synthesis and technology mapping with **partcl's boson**, as an mflowgen node. It is a drop-in
alternative to `open-yosys-synthesis` / `cadence-genus-synthesis` / `synopsys-dc-synthesis`: it reads
the design RTL and the ADK standard cells and produces a gate netlist mapped to the ADK.

## Inputs / outputs

| direction | name | what |
|---|---|---|
| input | `adk` | the ASIC design kit (`stdcells.lib`, `rtk-tech.lef`, `stdcells.lef`, `adk.tcl`) |
| input | `design.v` | the design RTL |
| output | `design.v` | the mapped gate netlist |
| output | `synth.stats.txt` | boson QoR summary |

## Parameters

| parameter | default | meaning |
|---|---|---|
| `design_name` | `undefined` | top module |
| `clock_period` | `2.0` | clock period (ns) the synthesis SDC constrains |
| `clock_port` | `clk` | top-level clock port |
| `boson_bin` | `boson` | path to (or name on `$PATH` of) the boson binary |
| `effort` | `high` | boson compile effort |

## How it works

`boson-synth.tcl` reads the ADK liberty/LEF, sources `adk.tcl` for the cell names, writes a synthesis
SDC from the parameters, runs `compile`, and writes the mapped netlist. boson reads its parameters from
the environment (which mflowgen populates), so no script-generation pass is needed. boson emits real
Verilog vector bus ports (`input [7:0] a`) directly, so the netlist is handed to the downstream P&R node
as-is. Constant tie-offs are resolved to the ADK tie cells (`ADK_TIE_HI_CELL` / `ADK_TIE_LO_CELL`) when
the ADK names them.

## Status

Validated against the bundled `freepdk-45nm` ADK on the `GcdUnit` demo design: boson maps the RTL to the
ADK's cells (BUF_X1, INV_X1, DFF_X1, MUX2_X1, ...) with a bus-port interface, and the netlist feeds the
downstream place-and-route nodes unchanged.

## About boson

boson is a proprietary GPU-accelerated synthesis tool from partcl (https://partcl.com). This node
invokes it through its command-line / TCL interface and **does not include boson itself** — set
`boson_bin` to a boson you have. The node, like the `cadence-*` and `synopsys-*` nodes in this repo,
is the open integration glue; the tool is obtained separately.
