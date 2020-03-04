#=========================================================================
# ASIC Design Kit Setup TCL File
#=========================================================================
# This file is sourced by every asic flow tcl script that uses the
# ASIC design kit. This allows us to set ADK-specific variables.

#-------------------------------------------------------------------------
# ADK_PROCESS
#-------------------------------------------------------------------------
# This variable is used by the Innovus Foundation Flow to automatically
# configure process-specific options (e.g., extraction engines).
#
# The process can be "28", "180", etc., with units in nm.

set ADK_PROCESS 45

#-------------------------------------------------------------------------
# Preferred routing layers
#-------------------------------------------------------------------------
# These variables are used by the Synopsys DC Topographical flow and also
# by the Innovus Foundation Flow. Typically the top few metal layers are
# reserved for power straps and maybe clock routing.

set ADK_MIN_ROUTING_LAYER_DC metal2
set ADK_MAX_ROUTING_LAYER_DC metal7

set ADK_MAX_ROUTING_LAYER_INNOVUS 7

#-------------------------------------------------------------------------
# Power mesh layers
#-------------------------------------------------------------------------
# These variables are used in Innovus scripts to reference the layers used
# for the coarse power mesh.
#
# Care must be taken to choose the right layers for the power mesh such
# that the bottom layer of the power mesh is perpendicular to the
# direction of the power rails in the stdcells. This allows Innovus to
# stamp stacked vias down at each intersection.

set ADK_POWER_MESH_BOT_LAYER 8
set ADK_POWER_MESH_TOP_LAYER 9

#-------------------------------------------------------------------------
# ADK_DRIVING_CELL
#-------------------------------------------------------------------------
# This variable should indicate which cell to use with the
# set_driving_cell command. The tools will assume all inputs to a block
# are being driven by this kind of cell. It should usually be some kind
# of simple inverter.

set ADK_DRIVING_CELL "INV_X2"

#-------------------------------------------------------------------------
# ADK_TYPICAL_ON_CHIP_LOAD
#-------------------------------------------------------------------------
# Our default timing constraints assume that we are driving another block
# of on-chip logic. Select how much load capacitance in picofarads we
# should drive here. This is the load capacitance that the output pins of
# the block will expect to be driving.
#
# The stdcell lib shows about 6.5fF for an inverter x4, so about 7fF is
# reasonable.

set ADK_TYPICAL_ON_CHIP_LOAD 7

#-------------------------------------------------------------------------
# ADK_FILLER_CELLS
#-------------------------------------------------------------------------
# This variable should include a space delimited list of the names of
# the filler cells in the library. Note, you must order the filler cells
# from largest to smallest because ICC / Innovus will start by using the
# first filler cell, and only use the second filler cell if there is
# space.

set ADK_FILLER_CELLS \
  "FILLCELL_X32 \
   FILLCELL_X16 \
   FILLCELL_X8 \
   FILLCELL_X4 \
   FILLCELL_X2 \
   FILLCELL_X1"

#-------------------------------------------------------------------------
# ADK_TIE_CELLS
#-------------------------------------------------------------------------
# This list should specify the cells to use for tying high to VDD and
# tying low to VSS.

set ADK_TIE_CELLS \
  "LOGIC1_X1 \
   LOGIC0_X1"

#-------------------------------------------------------------------------
# ADK_WELL_TAP_CELL
#-------------------------------------------------------------------------
# This list should specify the well tap cell if the stdcells in the
# library do not already include taps. The interval is the DRC rule for
# the required spacing between tap cells.

set ADK_WELL_TAP_CELL     "WELLTAP_X1"
set ADK_WELL_TAP_INTERVAL 120

#-------------------------------------------------------------------------
# ADK_END_CAP_CELL
#-------------------------------------------------------------------------
# This list should specify the end cap cells if the library requires them.

set ADK_END_CAP_CELL ""

#-------------------------------------------------------------------------
# ADK_ANTENNA_CELL
#-------------------------------------------------------------------------
# This list has the antenna diode cell used to avoid antenna DRC
# violations.

set ADK_ANTENNA_CELL "ANTENNA_X1"

#-------------------------------------------------------------------------
# ADK_LVS_EXCLUDE_CELL_LIST (OPTIONAL)
#-------------------------------------------------------------------------
# For LVS, we usually want a netlist that excludes physical cells that
# have no devices in them (or else LVS will have issues). Specifically for
# filler cells, the extracted layout will not have any trace of the
# fillers because there are no devices in them. Meanwhile, the schematic
# generated from the netlist will show filler cells instances with VDD/VSS
# ports, and this will cause LVS to flag a "mismatch" with the layout.
#
# This list can be used to filter out physical-only cells from the netlist
# generated for LVS. If this is left empty, LVS will just be a bit more
# difficult to deal with.

set ADK_LVS_EXCLUDE_CELL_LIST \
  "FILL* \
  WELLTAP*"

#-------------------------------------------------------------------------
# ADK_VIRTUOSO_EXCLUDE_CELL_LIST (OPTIONAL)
#-------------------------------------------------------------------------
# Similar to the case with LVS, we may want to filter out certain cells
# for Virtuoso simulation. Specifically, decaps can make Virtuoso
# simulation very slow. While we do eventually want to do a complete
# simulation including decaps, excluding them can speed up simulation
# significantly.
#
# This list can be used to filter out such cells from the netlist
# generated for Virtuoso simulation. If this is left empty, then Virtuoso
# simulations will just run more slowly.

set ADK_VIRTUOSO_EXCLUDE_CELL_LIST \
  "FILL* \
  WELLTAP*"

#-------------------------------------------------------------------------
# Support for open-source tools
#-------------------------------------------------------------------------
# Open-source tools tend to require more detailed variables than
# commercial tools do. In this section we define extra variables for them.

set ADK_TIE_HI_CELL "LOGIC1_X1"
set ADK_TIE_LO_CELL "LOGIC0_X1"
set ADK_TIE_HI_PORT "Z"
set ADK_TIE_LO_PORT "Z"

set ADK_MIN_BUF_CELL   "BUF_X1"
set ADK_MIN_BUF_PORT_I "A"
set ADK_MIN_BUF_PORT_O "Z"



