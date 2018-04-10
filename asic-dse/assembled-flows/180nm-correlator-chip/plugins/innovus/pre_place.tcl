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

specifyCellPad DFQ* 2
reportCellPad -file $vars(rpt_dir)/$vars(step).cellpad.rpt

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

globalNetConnect VDD    -type pgpin -pin VDD    -inst * -verbose
globalNetConnect VSS    -type pgpin -pin VSS    -inst * -verbose
globalNetConnect VDDPST -type pgpin -pin VDDPST -inst * -verbose
globalNetConnect VSSPST -type pgpin -pin VSSPST -inst * -verbose
globalNetConnect POC    -type pgpin -pin POC    -inst * -verbose

# Create PG pins (temporary hardcoded) so that GDS export creates text for LVS in Calibre.

add_gui_text -label VDDPST -pt { 160   30} -layer CUSTOM_BRG_LVS_M6 -height 5
add_gui_text -label VDD    -pt {1090 1970} -layer CUSTOM_BRG_LVS_M6 -height 5
add_gui_text -label VSS    -pt { 950 2090} -layer CUSTOM_BRG_LVS_M6 -height 5
add_gui_text -label VSSPST -pt { 260   30} -layer CUSTOM_BRG_LVS_M6 -height 5
add_gui_text -label POC    -pt {1018 1300} -layer CUSTOM_BRG_LVS_M3 -height 5

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

set density_limit 35

createDensityArea $core_llx $core_lly $core_urx $core_ury \
                  $density_limit -name core_density_area

#-------------------------------------------------------------------------
# M2 power rail preroute
#-------------------------------------------------------------------------

set M1_str_width 0.470

sroute -nets {VDD VSS} -corePinWidth $M1_str_width

#-------------------------------------------------------------------------
# Power ring
#-------------------------------------------------------------------------

addRing -nets {VDD VSS} -type core_rings -follow core   \
        -layer {top M5 bottom M5 left M6 right M6}      \
        -width $p_ring_width -spacing $p_ring_spacing   \
        -offset $p_ring_spacing                         \
        -extend_corner {tl tr bl br lt lb rt rb}

# Connect the ring to the IO pads

sroute                                  \
 -allowJogging 0                        \
 -connect padPin                        \
 -allowLayerChange 1                    \
 -layerChangeRange { M1 M6 }            \
 -nets { VDD VSS }                      \
 -padPinLayerRange { M1 M2 }            \
 -padPinPortConnect { allPort allGeom } \
 -padPinTarget { ring }

#-------------------------------------------------------------------------
# M4 power stripe settings
#-------------------------------------------------------------------------
# - M4_str_width            : 6X thickness compared to M1 rails
# - M4_str_pitch            : Arbitrarily choosing the pitch between stripes
# - M4_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across VSS and VDD stripes
# - M4_str_interset_pitch   : Pitch between same-signal stripes

set M4_str_width 2.76
set M4_str_pitch [expr 50 * $t_pitch]

set M4_str_intraset_spacing [expr $M4_str_pitch - $M4_str_width]
set M4_str_interset_pitch   [expr 2*$M4_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M1 \
                 -stacked_via_top_layer    M4

addStripe -nets {VSS VDD} -layer M4 -direction vertical \
    -width $M4_str_width                                \
    -spacing $M4_str_intraset_spacing                   \
    -set_to_set_distance $M4_str_interset_pitch         \
    -max_same_layer_jog_length $M4_str_pitch            \
    -padcore_ring_bottom_layer_limit M4                 \
    -padcore_ring_top_layer_limit M6                    \
    -start [expr $core_llx + $M4_str_pitch/2]

#-------------------------------------------------------------------------
# M5 power stripe settings
#-------------------------------------------------------------------------
# - M5_str_width            : 6X thickness compared to M1 rails
# - M5_str_pitch            : Arbitrarily choosing the pitch between stripes
# - M5_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across VSS and VDD stripes
# - M5_str_interset_pitch   : Pitch between same-signal stripes

set M5_str_width 2.76
set M5_str_pitch [expr 50 * $t_pitch]

set M5_str_intraset_spacing [expr $M5_str_pitch - $M5_str_width]
set M5_str_interset_pitch   [expr 2*$M5_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M4 \
                 -stacked_via_top_layer    M6

addStripe -nets {VSS VDD} -layer M5 -direction horizontal \
    -width $M5_str_width                                  \
    -spacing $M5_str_intraset_spacing                     \
    -set_to_set_distance $M5_str_interset_pitch           \
    -max_same_layer_jog_length $M5_str_pitch              \
    -padcore_ring_bottom_layer_limit M5                   \
    -padcore_ring_top_layer_limit M6                      \
    -start [expr $M5_str_pitch/2]

#-------------------------------------------------------------------------
# M6 power stripe settings
#-------------------------------------------------------------------------
# - M6_str_width            : 6X thickness compared to M1 rails
# - M6_str_pitch            : Arbitrarily choosing the pitch between stripes
# - M6_str_intraset_spacing : Space between VSS/VDD, chosen for constant
#                             pitch across VSS and VDD stripes
# - M6_str_interset_pitch   : Pitch between same-signal stripes

set M6_str_width 2.76
set M6_str_pitch [expr 50 * $t_pitch]

set M6_str_intraset_spacing [expr $M6_str_pitch - $M6_str_width]
set M6_str_interset_pitch   [expr 2*$M6_str_pitch]

setViaGenMode -reset
setViaGenMode -viarule_preference default
setViaGenMode -ignore_DRC false

setAddStripeMode -reset
setAddStripeMode -stacked_via_bottom_layer M5 \
                 -stacked_via_top_layer    M6

addStripe -nets {VSS VDD} -layer M6 -direction vertical \
    -width $M6_str_width                                \
    -spacing $M6_str_intraset_spacing                   \
    -set_to_set_distance $M6_str_interset_pitch         \
    -max_same_layer_jog_length $M6_str_pitch            \
    -padcore_ring_bottom_layer_limit M6                 \
    -padcore_ring_top_layer_limit M6                    \
    -start [expr $core_llx + $M6_str_pitch/2]

