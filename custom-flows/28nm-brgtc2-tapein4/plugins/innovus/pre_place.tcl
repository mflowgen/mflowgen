#=========================================================================
# pre_place.tcl
#=========================================================================
# This plug-in script is called before the corresponding Innovus flow step
#
#-------------------------------------------------------------------------
# Example tasks include:
#          - Power planning related tasks which includes
#            - Power planning for power domains (ring/strap creations)
#            - Power Shut-off cell power hookup
#-------------------------------------------------------------------------

specifyCellPad DFF* 2
reportCellPad -file $vars(rpt_dir)/$vars(step).cellpad.rpt

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------
# The CPF handles global net connections for VDD and VSS, but it caused
# DRC violations in route, so this chip flow is not using CPF...

# PG Pins used by stdcells

globalNetConnect VDD    -type pgpin -pin VDD    -inst * -verbose
globalNetConnect VDD    -type pgpin -pin VNW    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VSS    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VPW    -inst * -verbose

# PG Pins used by SRAMs

globalNetConnect VDD    -type pgpin -pin VDDCE  -inst * -verbose
globalNetConnect VDD    -type pgpin -pin VDDPE  -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VSSE   -inst * -verbose

# IO PG pins

globalNetConnect VDDPST -type pgpin -pin VDDPST -inst * -verbose
globalNetConnect VSSPST -type pgpin -pin VSSPST -inst * -verbose
globalNetConnect POC    -type pgpin -pin POC    -inst * -verbose

# Create PG pins labels so that GDS export creates text for LVS in
# Calibre. Use the bottom left corner cell and drop the labels on the
# rings.

set label_vsspst_llx [expr $io_corner_bl_llx +  41]
set label_vsspst_lly [expr $io_corner_bl_llx +  41]

set label_vddpst_llx [expr $io_corner_bl_llx +  59]
set label_vddpst_lly [expr $io_corner_bl_llx +  59]

set label_vss_llx    [expr $io_corner_bl_llx +  92]
set label_vss_lly    [expr $io_corner_bl_llx +  92]

set label_vdd_llx    [expr $io_corner_bl_llx + 107]
set label_vdd_lly    [expr $io_corner_bl_llx + 107]

set label_poc_llx    [expr $io_corner_bl_llx + 108.78]
set label_poc_lly    [expr $io_corner_bl_llx + 108.78]

add_gui_text -label VSSPST -pt $label_vsspst_llx $label_vsspst_lly -layer CUSTOM_BRG_LVS_M5 -height 5
add_gui_text -label VDDPST -pt $label_vddpst_llx $label_vddpst_lly -layer CUSTOM_BRG_LVS_M5 -height 5
add_gui_text -label VSS    -pt $label_vss_llx    $label_vss_lly    -layer CUSTOM_BRG_LVS_M5 -height 5
add_gui_text -label VDD    -pt $label_vdd_llx    $label_vdd_lly    -layer CUSTOM_BRG_LVS_M3 -height 5
add_gui_text -label POC    -pt $label_poc_llx    $label_poc_lly    -layer CUSTOM_BRG_LVS_M3 -height 5

#-------------------------------------------------------------------------
# Save design before continuing
#-------------------------------------------------------------------------

saveDesign $vars(dbs_dir)/$vars(step).power.enc -relativePath

#-------------------------------------------------------------------------
# M2 power rail preroute
#-------------------------------------------------------------------------
# ARM 28nm standard cells use 130nm width M2 rails. ARM suggests
# potentially prerouting a 250nm width M2 rail to improve IR drop and
# di/dt effects.

set M2_str_width 0.250

sroute -nets {VDD VSS} -corePinWidth $M2_str_width

#-------------------------------------------------------------------------
# M3 power stripe settings
#-------------------------------------------------------------------------
# ARM recommendations
#
# The ARM super user guide says that the 28nm standard cell libraries are
# designed to accommodate a 150nm wide metal3 strap with a horizontal
# VIA_Rect. To maximize the number of tracks available for signal routing
# on metal3, ARM also recommends the pitch of the metal3 straps to be a
# multiple of the signal routing pitch (100nm) and be offset to align the
# center of the metal3 straps exactly half way between signal routing
# tracks (50nm or half offset).
#
# We are using addStripe to add sets of stripes (a set includes both VSS
# and VDD).
#
# Set variables to space VSS and VDD straps evenly throughout the chip.
#
#     VSS    VDD    VSS
#     | |    | |    | |
#     | |    | |    | |
#     | |    | |    | |
#
#     _______ <---- $M3_str_pitch
#     ______________
#        ____   ^
#     ___  ^    |
#      ^   |    +-- $M3_str_interset_pitch
#      |   +------- $M3_str_intraset_spacing
#      +----------- $M3_str_width
#
# - M3_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across all VSS and VDD stripes
# - M3_str_interset_pitch   : Pitch between same-signal stripes
#
# - M3_str_offset           : Offset from left edge of core to center the
#                             M3 stripe between vertical M3 routing tracks
#
# - M3_str_width            : ARM suggests 150nm
# - M3_str_pitch            : Choosing an arbitrary M3 pitch that is a
#                             multiple of M3 signal pitch for now

# Get M3 signal routing pitch as defined in the LEF

set M3_route_pitchX [dbGet [dbGetLayerByName M3].pitchX]

# Set M3 stripe variables

set M3_str_width            0.15
set M3_str_pitch            [expr 10  * $M3_route_pitchX]

set M3_str_intraset_spacing [expr $M3_str_pitch - $M3_str_width]
set M3_str_interset_pitch   [expr 2*$M3_str_pitch]

set M3_str_offset           [expr $M3_str_pitch + $M3_route_pitchX/2 - $M3_str_width/2]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M2 \
                 -stacked_via_top_layer    M3

addStripe -nets {VSS VDD} -layer M3 -direction vertical \
    -width $M3_str_width                                \
    -spacing $M3_str_intraset_spacing                   \
    -set_to_set_distance $M3_str_interset_pitch         \
    -start_offset $M3_str_offset

#-------------------------------------------------------------------------
# Core power ring
#-------------------------------------------------------------------------

addRing -nets {VDD VSS} -type core_rings -follow core   \
        -layer {top M8 bottom M8 left M9 right M9}      \
        -width $p_ring_width -spacing $p_ring_spacing   \
        -offset $p_ring_spacing                         \
        -extend_corner {tl tr bl br lt lb rt rb}

# Connect the ring to the IO pads

sroute                                  \
 -allowJogging 0                        \
 -connect padPin                        \
 -allowLayerChange 1                    \
 -layerChangeRange { M1 M9 }            \
 -nets { VDD VSS }                      \
 -padPinLayerRange { M1 M2 }            \
 -padPinPortConnect { allPort allGeom } \
 -padPinTarget { ring }

#-------------------------------------------------------------------------
# PLL power ring connections
#-------------------------------------------------------------------------

setAddRingMode -reset
setAddRingMode -stacked_via_bottom_layer M8
setAddRingMode -stacked_via_top_layer M9

# Because the PLL is right next to the core power ring, when adding this block
# power ring, the tool is smart enough to not build the west side of the
# block ring and instead directly extend the top and bottom of the block
# ring into the core power ring.

selectInst pll
addRing -nets {VDD VSS} -type block_rings \
        -around selected \
        -layer {top M8 bottom M8 left M9 right M9} \
        -width 1.0 -spacing 0.2 -offset 0.2
deselectAll

# Hookup the PLL to the ring

sroute -connect blockPin \
       -allowJogging 0 \
       -allowLayerChange 0 \
       -blockPin useLef \
       -blockPinTarget nearestTarget \
       -crossoverViaLayerRange "M8 M9" \
       -inst pll \
       -layerChangeRange "M8 M9" \
       -nets {VDD VSS} \
       -noBlockPinOneAmongOverlappedPins \
       -targetViaLayerRange "M8 M9" \
       -verbose

#-------------------------------------------------------------------------
# M5 straps over memory
#-------------------------------------------------------------------------
# The M5 straps are required over the memory because the M4 power straps
# inside the SRAMs are horizontal, and our M8 strap in the coarse power
# mesh are also horizontal. The M5 vertical straps are needed to form an
# intersection with the M8 straps where the tool can place via stacks.
#
# Single-ported SRAM notes from user guide:
#
#     ARM® 28nm TSMC CLN28HPC SRAM Memory Compiler
#     Revision: r0p0
#     User Guide
#
#     To maintain power density for each strap, use multiple top-level
#     grid connections with a maximum spacing of 10um and a minimum width
#     of 0.210um. Each intersection of supply grid M5 and instance supply
#     M4 must be maximally contacted. M5 straps must be within 7um of the
#     instance edge.
#
#     The compiler top supply metal is M4. To meet instance IR drop
#     requirements, M5 straps at least 0.210um wide for power and ground
#     must be located over the instance, perpendicular to the instance M4
#     ArtiGrid direction, and within 7um of the instance edge. In
#     addition, a pattern of M5 straps, each at least 0.210um wide, must
#     be repeated across the instance at 10um intervals. ARM recommends
#     that each intersection of instance supply M4 and overlapping,
#     perpendicular supply strap M5 have the maximum number of vias
#     allowed.
#
# Dual-ported SRAM notes from user guide:
#
#     ARM® Artisan® 28nm TSMC CLN28HPC Dual-Port SRAM Compiler
#     User Guide
#
#     (identical notes as the single-port user guide)
#
# ARM external power-gating SRAM notes from that user guide:
#
#     ARM® 28nm TSMC CLN28HPC External Power Gating
#     Revision: r0p0
#
#     The top supply metal in ARM memory compilers is M4. To meet instance
#     IR drop requirements, M5 straps at least 0.120μm wide for VDDPE,
#     VSSE, and VDDCE must be located over the instance, perpendicular
#     to the instance M4 supply strap direction, and within 5μm of the
#     instance edge. In addition, a pattern of VDDPE, VSSE, and VDDCE
#     M5 straps, each at least 0.120μm wide, must be repeated across
#     the instance at 10μm intervals. Each intersection of instance
#     supply M4 and overlapping, perpendicular supply strap M5 must be
#     maximally contacted.
#
# These all sound pretty similar.
#
# Parameters:
#
# - M5_str_width            : ARM recommended 8X thickness for M8 compared
#                             to M3 width. This is M5, so we choose 6X
#                             thickness to make the thickness "graduated"
#                             as we go up. It is also greater than the
#                             minimum width of 0.210um mandated by ARM's
#                             SRAM user guide.
# - M5_str_pitch            : Arbitrarily choosing the pitch between stripes
# - M5_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across VSS and VDD stripes
# - M5_str_interset_pitch   : Pitch between same-signal stripes

set M5_str_width            0.9
set M5_str_pitch            [expr 5 * $M3_str_pitch]
set M5_str_intraset_spacing [expr $M5_str_pitch - $M5_str_width]
set M5_str_interset_pitch   [expr 2*$M5_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC 0

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M4 \
                 -stacked_via_top_layer    M5

foreach block $mem_macros {
    selectInst $block
    addStripe -nets {VSS VDD} -layer M5 -direction vertical \
        -width $M5_str_width                                \
        -spacing $M5_str_intraset_spacing                   \
        -set_to_set_distance $M5_str_interset_pitch         \
        -start_offset 1                                     \
        -stop_offset 1                                      \
        -area [dbGet selected.box]
    deselectAll
}

#-------------------------------------------------------------------------
# M8 power stripe settings
#-------------------------------------------------------------------------
# - M8_str_width            : ARM recommends 8X thickness compared to M3
# - M8_str_pitch            : Arbitrarily choosing the pitch between stripes
# - M8_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across VSS and VDD stripes
# - M8_str_interset_pitch   : Pitch between same-signal stripes

set M8_str_width 1.20
set M8_str_pitch [expr 10 * $M3_str_pitch]

set M8_str_intraset_spacing [expr $M8_str_pitch - $M8_str_width]
set M8_str_interset_pitch   [expr 2*$M8_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

# The "-allow_wire_shape_change false" option can prevent some DRC
# violations for corner cases with power strap jogs (e.g., power straps
# jogging to connect to the core power ring to get around a
# core-ring-to-io-ring power trunk). Without this option, vias placed
# during the jog can overlap illegally, especially for jogs over the wider
# SRAM power straps.

setViaGenMode -allow_wire_shape_change false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M3 \
                 -stacked_via_top_layer    M9

# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.

addStripe -nets {VSS VDD} -layer M8 -direction horizontal \
    -width $M8_str_width                                  \
    -spacing $M8_str_intraset_spacing                     \
    -set_to_set_distance $M8_str_interset_pitch           \
    -max_same_layer_jog_length $M8_str_pitch              \
    -padcore_ring_bottom_layer_limit M8                   \
    -padcore_ring_top_layer_limit M9                      \
    -start [expr $M8_str_pitch]

#-------------------------------------------------------------------------
# M9 power stripe settings
#-------------------------------------------------------------------------
# - M9_str_width            : ARM recommends 16X thickness compared to M3
# - M9_str_pitch            : Arbitrarily choosing the pitch between stripes
# - M9_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across VSS and VDD stripes
# - M9_str_interset_pitch   : Pitch between same-signal stripes

set M9_str_width 2.40 ; # ARM recommends 16X thickness compared to M3
set M9_str_pitch [expr 20 * $M3_str_pitch] ; # Arbitrarily choosing this

set M9_str_intraset_spacing [expr $M9_str_pitch - $M9_str_width]
set M9_str_interset_pitch   [expr 2*$M9_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M8 \
                 -stacked_via_top_layer    M9

# Add the stripes
#
# Use -start to offset the stripes slightly away from the core edge.
# Allow same-layer jogs to connect stripes to the core ring if some
# blockage is in the way (e.g., connections from core ring to pads).
# Restrict any routing around blockages to use only layers for power.

# VDD VSS ordering
#
# For very small designs, there may only be room for one coarse power
# strap. If the first strap on both M8 and M9 are VSS, then the block will
# have no VDD straps. So we place a VSS strap first for M8, and here we
# place a VDD strap first for M9. Now even for very small designs, there
# should be a supply for both VSS and VDD available.

addStripe -nets {VDD VSS} -layer M9 -direction vertical \
    -width $M9_str_width                                \
    -spacing $M9_str_intraset_spacing                   \
    -set_to_set_distance $M9_str_interset_pitch         \
    -max_same_layer_jog_length $M9_str_pitch            \
    -padcore_ring_bottom_layer_limit M8                 \
    -padcore_ring_top_layer_limit M9                    \
    -start [expr $M9_str_pitch/4]

#-------------------------------------------------------------------------
# Save design after power routing
#-------------------------------------------------------------------------

saveDesign $vars(dbs_dir)/$vars(step).power.done.enc -relativePath

#-------------------------------------------------------------------------
# SRAM routing halos
#-------------------------------------------------------------------------
# Encourage signal router to access block pins with planar access instead
# of by dropping vias from above. Dropping vias tends to cause DRC
# violations when vias do not drop cleanly or if they create metal shapes
# inside the LEF block pin cutout that are too close to other metal shapes
# inside the block but invisible to Innovus.

addRoutingHalo -inst $mem_macro_paths \
               -space   1 \
               -bottom M1 \
               -top    M4

set i 0

foreach block $mem_macro_paths {
  createRouteBlk -inst $block \
                 -cover \
                 -layer M4 \
                 -name sram_routeblk_$i
  incr i
}

#-------------------------------------------------------------------------
# Clock uncertainty
#-------------------------------------------------------------------------

set_interactive_constraint_modes [all_constraint_modes -active]
set_clock_uncertainty 0.05 [get_clocks *]

