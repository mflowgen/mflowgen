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

set bondpad_cell PAD80LU_OBV

# Add physical IO cells
#
# - Corner cells
# - Bond pads
# - Power pads

addInst -physical -cell PCORNER -inst PCORNER_TOPLEFT
addInst -physical -cell PCORNER -inst PCORNER_TOPRIGHT
addInst -physical -cell PCORNER -inst PCORNER_BOTTOMLEFT
addInst -physical -cell PCORNER -inst PCORNER_BOTTOMRIGHT

# Core VDD and VSS pads

addInst -physical -cell PVDD1CDG -inst vdd_core_0_pad
addInst -physical -cell PVDD1CDG -inst vdd_core_1_pad
addInst -physical -cell PVDD1CDG -inst vdd_core_2_pad
addInst -physical -cell PVDD1CDG -inst vdd_core_test_0_pad
addInst -physical -cell PVDD1CDG -inst vdd_core_test_1_pad

addInst -physical -cell PVSS1CDG -inst vss_core_0_pad
addInst -physical -cell PVSS1CDG -inst vss_core_1_pad
addInst -physical -cell PVSS1CDG -inst vss_core_2_pad
addInst -physical -cell PVSS1CDG -inst vss_core_test_0_pad
addInst -physical -cell PVSS1CDG -inst vss_core_test_1_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummy_0_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummy_1_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummy_2_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummy_3_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummyclk_0_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummyclk_1_pad
addInst -physical -cell PVSS1CDG -inst vss_core_dummyclk_2_pad

# IO VDD and VSS pads

addInst -physical -cell PVDD2CDG -inst vdd_io_0_pad
addInst -physical -cell PVDD2CDG -inst vdd_io_1_pad
addInst -physical -cell PVDD2CDG -inst vdd_io_test_0_pad

addInst -physical -cell PVSS2CDG -inst vss_io_0_pad
addInst -physical -cell PVSS2CDG -inst vss_io_1_pad
addInst -physical -cell PVSS2CDG -inst vss_io_2_pad
addInst -physical -cell PVSS2CDG -inst vss_io_test_0_pad
addInst -physical -cell PVSS2CDG -inst vss_io_test_1_pad

# POC pads

addInst -physical -cell PVDD2POC -inst vdd_poc_0_pad
addInst -physical -cell PVDD2POC -inst vdd_poc_test_0_pad

# PRCUT cells

addInst -physical -cell PRCUT -inst prcut_0
addInst -physical -cell PRCUT -inst prcut_1
addInst -physical -cell PRCUT -inst prcut_2

# The "dummy" is a blank entry that makes the iteration variable "i"
# increment just to make the inner/outer match up with the even/odd setup
# of my loop.

foreach bondpad_name \
[list                \
ADC_I_0_bond          \
ADC_I_1_bond          \
ADC_I_2_bond          \
ADC_I_3_bond          \
ADC_I_4_bond          \
ADC_I_5_bond          \
ADC_I_6_bond          \
ADC_I_7_bond          \
ADC_I_8_bond          \
ADC_I_9_bond          \
ADC_Q_0_bond          \
ADC_Q_1_bond          \
ADC_Q_2_bond          \
ADC_Q_3_bond          \
ADC_Q_4_bond          \
ADC_Q_5_bond          \
ADC_Q_6_bond          \
ADC_Q_7_bond          \
ADC_Q_8_bond          \
ADC_Q_9_bond          \
clk_bond          \
debug_in_bond          \
greset_n_bond          \
out_mux_0_bond          \
out_mux_1_bond          \
out_mux_2_bond          \
out_mux_3_bond          \
spidin_bond          \
spiload_bond          \
vdd_core_0_bond          \
vdd_core_1_bond          \
vdd_core_2_bond          \
vdd_core_test_0_bond          \
vdd_core_test_1_bond          \
vdd_io_0_bond          \
vdd_io_1_bond          \
vdd_io_test_0_bond          \
vdd_poc_test_0_bond          \
vdd_poc_0_bond          \
vss_core_0_bond          \
vss_core_1_bond          \
vss_core_2_bond          \
vss_core_test_0_bond          \
vss_core_test_1_bond          \
vss_core_dummy_0_bond          \
vss_core_dummy_1_bond          \
vss_core_dummy_2_bond          \
vss_core_dummy_3_bond          \
vss_io_0_bond          \
vss_io_1_bond          \
vss_io_2_bond          \
vss_io_test_0_bond          \
vss_io_test_1_bond          \
vss_core_dummyclk_0_bond          \
vss_core_dummyclk_1_bond          \
vss_core_dummyclk_2_bond          \
] {
  addInst -physical -cell $bondpad_cell -inst $bondpad_name
}

# Use the Innovus IO row flow to make the rows

setIoFlowFlag 1

foreach side [list S E N W] {
  createIoRow -site pad -beginOffset $io_cell_len \
                        -endOffset   $io_cell_len \
                        -rowMargin   0            \
                        -side        $side        \
                        -name        iorow_$side
}

foreach side [list BL BR TL TR] {
  createIoRow -site corner -xOffset 0           \
                           -yOffset 0           \
                           -corner  $side       \
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
#
# For some reason, the IO fillers will not place wherever there is a bond
# pad, probably because the bond pad lef has a blockage. This leaves gaps
# in the IO ring wherever there is a bond pad.
#
# To get around this, we (1) first load the IO floorplan that places the
# IO cells, (2) then add IO fillers while there are no bond pads placed
# yet so there should be no gaps, and then (3) add the bond pads by
# loading the IO floorplan that has both IO cells and bond pads.
#
# Note that the two IO floorplans are identical except that one floorplan
# has the bond pad entries deleted.

# Make sure to add fillers in order from largest width to smallest width

loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).nobondpads.save.io

addIoRowFiller -cell {PFILLER20 PFILLER10 PFILLER5 PFILLER1 PFILLER05 PFILLER0005}

loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).save.io

#-------------------------------------------------------------------------

setIoFlowFlag 0


