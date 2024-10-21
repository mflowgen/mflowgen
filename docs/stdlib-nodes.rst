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
| Mentor  Calibre             | 7     | DRC, LVS, GDS merging, metal fill,                   |
|                             |       | convert verilog2spice, drawing chip art              |
+-----------------------------+-------+------------------------------------------------------+
| Open-Source                 | 7     | Synthesis (yosys), floorplan (OpenROAD)              |
| (based on OpenROAD)         |       | place (OpenROAD), cts (OpenROAD)                     |
|                             |       | route (OpenROAD), finish (OpenROAD)                  |
|                             |       | docker-based flow setup                              |
+-----------------------------+-------+------------------------------------------------------+
| Open-Source                 | 8     | Synthesis (yosys), place (graywolf),                 |
| (not based on OpenROAD)     |       | place (RePlAcE), route (qrouter)                     |
|                             |       | LVS (netgen), DRC (magic)                            |
|                             |       | gds2spice and def2spice (magic)                      |
+-----------------------------+-------+------------------------------------------------------+
| **Total # of Nodes**        | 51    |                                                      |
+-----------------------------+-------+------------------------------------------------------+
| Open-Source Technologies    | 2     | SkyWater 130nm, FreePDK45 with                       |
|                             |       | NanGate Open Cell Library                            |
+-----------------------------+-------+------------------------------------------------------+

