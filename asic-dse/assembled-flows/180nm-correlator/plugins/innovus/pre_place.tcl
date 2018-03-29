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
reportCellPad -file $vars(rpt_dir)/place.cellpad.rpt

#-------------------------------------------------------------------------
# Global net connections for PG pins
#-------------------------------------------------------------------------

foreach net $vars(power_nets) {
  globalNetConnect VDD -type pgpin -pin "$net" -inst * -verbose
}

foreach net $vars(ground_nets) {
  globalNetConnect VSS -type pgpin -pin "$net" -inst * -verbose
}

#-------------------------------------------------------------------------
# M2 power rail preroute
#-------------------------------------------------------------------------
# ARM 28nm standard cells use 130nm width M2 rails. ARM suggests
# potentially prerouting a 250nm width M2 rail to improve IR drop and
# di/dt effects.

set M1_str_width 0.460

sroute -nets {VDD VSS} -corePinWidth $M1_str_width

#-------------------------------------------------------------------------
# Power ring
#-------------------------------------------------------------------------

addRing -nets {VDD VSS} -type core_rings -follow core   \
        -layer {top M5 bottom M5 left M6 right M6}      \
        -width $p_ring_width -spacing $p_ring_spacing   \
        -offset $p_ring_spacing                         \
        -extend_corner {tl tr bl br lt lb rt rb}

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
    -start [expr $core_margin_b + $p_ring_width]        \
    -extend_to design_boundary

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
    -start [expr $core_margin_l + $p_ring_width]          \
    -extend_to design_boundary

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
    -start [expr $core_margin_b + $p_ring_width]        \
    -extend_to design_boundary

