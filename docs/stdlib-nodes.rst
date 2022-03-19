List of mflowgen Common Library Nodes
==========================================================================



+-----------------------------+-------+------------------------------------------------------+
| **Base Tool**               | **#** | **Description of Modular Nodes**                     |
+-----------------------------+-------+------------------------------------------------------+
| Cadence Genus               | 1     | Synthesis                                            |
+-----------------------------+-------+------------------------------------------------------+
| Cadence Innovus             | 14    | Init, place, cts, route, postroute, signoff,         |
|                             |       | post-pnr ecos, foundation flow setup,                |
|                             |       | hold-fixing nodes, power grid setup                  |
+-----------------------------+-------+------------------------------------------------------+
| Cadence Pegasus             | 4     | DRC, LVS, GDS merging, metal fill                    |
+-----------------------------+-------+------------------------------------------------------+
| Synopsys DC                 | 1     | Synthesis                                            |
+-----------------------------+-------+------------------------------------------------------+
| Synopsys Formality          | 1     | Logical equivalence check                            |
+-----------------------------+-------+------------------------------------------------------+
| Synopsys PT(PX)             | 6     | Timing/power signoff, ECOs, gen lib/db,              |
|                             |       | RTL- and gate-level power estimation                 |
+-----------------------------+-------+------------------------------------------------------+
| Synopsys VCS                | 2     | RTL- and gate-level simulation, vcd2saif             |
+-----------------------------+-------+------------------------------------------------------+
| Mentore Calibre             | 7     | DRC, LVS, GDS merging, metal fill,                   |
|                             |       | convert verilog2spice, drawing chip art              |
+-----------------------------+-------+------------------------------------------------------+
| Open-Source                 | 8     | Synthesis (yosys), place (graywolf),                 |
|                             |       | place (RePlAcE), route (qrouter)                     |
|                             |       | LVS (netgen), DRC (magic)                            |
|                             |       | gds2spice and def2spice (magic)                      |
+-----------------------------+-------+------------------------------------------------------+
| **Total # of Nodes**        | 44    |                                                      |
+-----------------------------+-------+------------------------------------------------------+
| Open-Source Technologies    | 2     | SkyWater 130nm, FreePDK45 with                       |
|                             |       | NanGate Open Cell Library                            |
+-----------------------------+-------+------------------------------------------------------+
