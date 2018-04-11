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

# Test structures and stuff removed
#
#     vdd_core_2_iocell
#     vdd_core_test_0_iocell
#     vdd_core_test_1_iocell
#     vdd_io_1_iocell
#     vdd_io_test_0_iocell
#     vdd_poc_test_0_iocell
#     vss_core_2_iocell
#     vss_core_dummy_0_iocell
#     vss_core_dummy_1_iocell
#     vss_core_dummy_2_iocell
#     vss_core_dummy_3_iocell
#     vss_core_test_0_iocell
#     vss_core_test_1_iocell
#     vss_io_test_0_iocell
#     vss_io_test_1_iocell

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

addInst -physical -cell PVDD1CDG -inst vdd_core_0_iocell
addInst -physical -cell PVDD1CDG -inst vdd_core_1_iocell
#addInst -physical -cell PVDD1CDG -inst vdd_core_2_iocell
#addInst -physical -cell PVDD1CDG -inst vdd_core_test_0_iocell
#addInst -physical -cell PVDD1CDG -inst vdd_core_test_1_iocell

addInst -physical -cell PVSS1CDG -inst vss_core_0_iocell
addInst -physical -cell PVSS1CDG -inst vss_core_1_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_2_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_test_0_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_test_1_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_dummy_0_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_dummy_1_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_dummy_2_iocell
#addInst -physical -cell PVSS1CDG -inst vss_core_dummy_3_iocell

# IO VDD and VSS pads

addInst -physical -cell PVDD2CDG -inst vdd_io_0_iocell
#addInst -physical -cell PVDD2CDG -inst vdd_io_1_iocell
#addInst -physical -cell PVDD2CDG -inst vdd_io_test_0_iocell

addInst -physical -cell PVSS2CDG -inst vss_io_0_iocell
addInst -physical -cell PVSS2CDG -inst vss_io_1_iocell
addInst -physical -cell PVSS2CDG -inst vss_io_2_iocell
#addInst -physical -cell PVSS2CDG -inst vss_io_test_0_iocell
#addInst -physical -cell PVSS2CDG -inst vss_io_test_1_iocell

# POC pads

addInst -physical -cell PVDD2POC -inst vdd_poc_0_iocell
#addInst -physical -cell PVDD2POC -inst vdd_poc_test_0_iocell

# PRCUT cells

#addInst -physical -cell PRCUT -inst prcut_0
#addInst -physical -cell PRCUT -inst prcut_1
#addInst -physical -cell PRCUT -inst prcut_2

# Dummy cells

addInst -physical -cell PVSS2CDG -inst vss_dummy_0_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_1_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_2_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_3_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_4_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_5_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_6_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_7_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_8_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_9_iocell
addInst -physical -cell PVSS2CDG -inst vss_dummy_10_iocell
#addInst -physical -cell PVSS2CDG -inst vss_dummy_11_iocell
#addInst -physical -cell PVSS2CDG -inst vss_dummy_12_iocell
#addInst -physical -cell PVSS2CDG -inst vss_dummy_13_iocell
#addInst -physical -cell PVSS2CDG -inst vss_dummy_14_iocell

# The "dummy" is a blank entry that makes the iteration variable "i"
# increment just to make the inner/outer match up with the even/odd setup
# of my loop.

set num_bondpads 56

for {set bond_i 0} {$bond_i < $num_bondpads} {incr bond_i} {
  addInst -physical -cell $bondpad_cell -inst iobond_$bond_i
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
# loading a separate IO floorplan with the bond pads.

# Make sure to add fillers in order from largest width to smallest width

loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).save.io

addIoRowFiller -cell {PFILLER20 PFILLER10 PFILLER5 PFILLER1 PFILLER05 PFILLER0005}

loadIoFile -noAdjustDieSize $vars(plug_dir)/$vars(design).bond.save.io

#-------------------------------------------------------------------------

setIoFlowFlag 0

