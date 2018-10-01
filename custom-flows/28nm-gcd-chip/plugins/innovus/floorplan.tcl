#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.

floorPlan -coreMarginsBy die \
          -b $die_llx  $die_lly  $die_urx  $die_ury \
             $io_llx   $io_lly   $io_urx   $io_ury  \
             $core_llx $core_lly $core_urx $core_ury

setFlipping s

# Choose bond pad cells

set bondpad_cell_outer PAD60GU
set bondpad_cell_inner PAD60NU
#set bondpad_cell_outer PAD50GU
#set bondpad_cell_inner PAD50NU

# Add physical IO cells
#
# - Corner cells
# - Bond pads
# - Power pads

addInst -physical -cell PCORNERE_G -inst PCORNER_TOPLEFT
addInst -physical -cell PCORNERE_G -inst PCORNER_TOPRIGHT
addInst -physical -cell PCORNERE_G -inst PCORNER_BOTTOMLEFT
addInst -physical -cell PCORNERE_G -inst PCORNER_BOTTOMRIGHT

addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_0_pad
addInst -physical -cell PVDD2CDE_H_G -inst vdd_io_0_pad
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_1_pad
addInst -physical -cell PVDD2POCE_H_G -inst vdd_poc_0_pad
addInst -physical -cell PVDD1CDE_H_G -inst vdd_core_2_pad
addInst -physical -cell PVDD2CDE_V_G -inst vdd_io_2_pad
addInst -physical -cell PVDD1CDE_V_G -inst vdd_core_3_pad

addInst -physical -cell PVSS1CDE_H_G -inst vss_core_0_pad
addInst -physical -cell PVSS2CDE_H_G -inst vss_io_0_pad
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_1_pad
addInst -physical -cell PVSS2CDE_H_G -inst vss_io_1_pad
addInst -physical -cell PVSS1CDE_H_G -inst vss_core_2_pad
addInst -physical -cell PVSS2CDE_V_G -inst vss_io_2_pad
addInst -physical -cell PVSS1CDE_V_G -inst vss_core_3_pad

# The "dummy" is a blank entry that makes the iteration variable "i"
# increment just to make the inner/outer match up with the even/odd setup
# of my loop.

set i 0

foreach bondpad_name \
[list                \
clk_bond             \
reset_bond           \
req_msg_0_bond       \
req_msg_1_bond       \
req_msg_2_bond       \
req_msg_3_bond       \
req_msg_4_bond       \
req_msg_5_bond       \
vdd_core_0_bond  \
vdd_io_0_bond    \
vdd_core_1_bond  \
vdd_poc_0_bond    \
vdd_core_2_bond  \
dummy \
req_msg_6_bond       \
req_msg_7_bond       \
req_msg_8_bond       \
req_msg_9_bond       \
req_msg_10_bond      \
req_msg_11_bond      \
req_msg_12_bond      \
req_msg_13_bond      \
req_msg_14_bond      \
req_msg_15_bond      \
req_msg_16_bond      \
req_msg_17_bond      \
req_msg_18_bond      \
req_msg_19_bond      \
req_msg_20_bond      \
req_msg_21_bond      \
req_msg_22_bond      \
req_msg_23_bond      \
req_msg_24_bond      \
vdd_io_2_bond    \
vdd_core_3_bond  \
dummy \
vss_core_2_bond  \
vss_io_1_bond    \
vss_core_1_bond  \
vss_io_0_bond    \
vss_core_0_bond  \
req_msg_25_bond      \
req_msg_26_bond      \
req_msg_27_bond      \
req_msg_28_bond      \
req_msg_29_bond      \
req_msg_30_bond      \
req_msg_31_bond      \
req_rdy_bond         \
dummy \
resp_val_bond        \
resp_rdy_bond        \
resp_msg_15_bond     \
resp_msg_14_bond     \
resp_msg_13_bond     \
resp_msg_12_bond     \
resp_msg_11_bond     \
resp_msg_10_bond     \
resp_msg_9_bond      \
resp_msg_8_bond      \
resp_msg_7_bond      \
resp_msg_6_bond      \
resp_msg_5_bond      \
resp_msg_4_bond      \
resp_msg_3_bond      \
resp_msg_2_bond      \
resp_msg_1_bond      \
resp_msg_0_bond      \
req_val_bond         \
vss_core_3_bond  \
vss_io_2_bond    \
] {
  if {$bondpad_name != "dummy"} {
    if {$i % 2 == 0} { addInst -physical -cell $bondpad_cell_outer -inst $bondpad_name } \
    else             { addInst -physical -cell $bondpad_cell_inner -inst $bondpad_name }
  }
  incr i
}

# Use the Innovus IO row flow to make the rows

setIoFlowFlag 1

foreach side [list S E N W] {
  createIoRow -site pad -beginOffset [expr $seal_ring_len + $io_chipedge_extension + $io_cell_len] \
                        -endOffset   [expr $seal_ring_len + $io_chipedge_extension + $io_cell_len] \
                        -rowMargin   [expr $seal_ring_len + $io_chipedge_extension               ] \
                        -side        $side                                                         \
                        -name        iorow_$side
}

foreach side [list BL BR TL TR] {
  createIoRow -site corner -xOffset [expr $seal_ring_len + $io_chipedge_extension] \
                           -yOffset [expr $seal_ring_len + $io_chipedge_extension] \
                           -corner  $side                                          \
                           -name    iorow_$side
}

# If we need to start over to get an IO save file...
#
# Misc experimentation just to get a save.io file to work with (assuming
# we are not using loadIoFile since we don't have one yet)
#
# Use the IO row flow to create an IO row on all four sides in the right
# locations (offset by seal ring). Also create the IO row for the corners.
# Load up the GUI to see the rows in the right places. Then use
# snapFPlanIO to get every IO instance onto the row. Then use placePIO to
# space things out evenly along the row. Save this file and modify by
# hand.
#
# Ways to save the IO file
#
# - Sequence: this just has the order of the IO cells as well as which row
# they are in and how they are orientated, but no absolute positions. This
# is very useful to save the sequence file first and make sure all the
# cells are in the right rows and oriented as expected. Usually corner
# cells will be in the wrong corner, digital IO cells will be in the wrong
# rows, etc. This is also a good time to check that the row can contain
# all of the IO cells you want with a large enough pitch to be bonded
# (e.g., 90um pitch).
#
# - Location: once sequence is good, save with absolute locations. This
# adds the "offset" field to each instance to save where they are in that
# row.
#
# Modifications by hand
#
# - Adjust offsets if needed
#
# - Add the bond pads directly centered on top of each iocell. This can be
# done pretty easily by adding a new entry after each iocell that uses the
# space parameter with some negative value. The space parameter places the
# instance relative to the edge of the previously placed cell, so a
# negative spacing will move the bondpad on top of the previous iocell.
#
# - Indent bond pads if using staggered IO to get the expected extensions
# into the die/core area.

#snapFPlanIO -toIoRow

#placePIO

# Load in the IO cells from the saved file

#loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).pad50.save.io
loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).pad60.save.io

#-------------------------------------------------------------------------

# Make sure to add fillers in order from largest width to smallest width

addIoRowFiller -cell {PFILLERE20_G PFILLERE10_G PFILLERE5_G PFILLERE1_G PFILLERE05_G PFILLERE0005_G}

setIoFlowFlag 0


