#=========================================================================
# floorplan.tcl
#=========================================================================
# This script is called from the Innovus init flow step.

floorPlan -s $core_width $core_height \
             $core_margin_l $core_margin_b $core_margin_r $core_margin_t

setFlipping s

# Arrange the pins so that inputs are on the left, spread around the
# center with 10um spacing between pins. This was done in the GUI pin
# editor and then the command was roughly copied here.

set ports_layer M4

setPinAssignMode -pinEditInBatch true
editPin -pin {in_chip_select in_clk_ref in_rstb in_scn_clk in_sdi} \
        -fixOverlap 1 -unit MICRON \
        -side Left \
        -spreadType center \
        -spreadDirection clockwise \
        -layer $ports_layer \
        -spacing 10

setPinAssignMode -pinEditInBatch true
editPin -pin {out_clk out_clk_tst out_sdo} \
        -fixOverlap 1 -unit MICRON \
        -side Right \
        -spreadType center \
        -spreadDirection clockwise \
        -layer $ports_layer \
        -spacing 10

#-------------------------------------------------------------------------
# Fences and regions
#-------------------------------------------------------------------------
# Fences and regions are hard boundaries where the instance can only be
# placed within the fence. Fences also prohibit cells from other blocks
# being placed inside, while regions allow cells from other blocks in the
# region.
#
# The PLL rough floorplan will look like this:
#
#     +--------------------------------------------------------------+
#     | +----------------------------------------------------------+ |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | |  spi_top           dco_top              lfsr_25b         | |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | |        fdc_top           timing_ctrl          lfsr_31b   | |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | |              dlc_top                                     | |
#     | |                                                          | |
#     | |                                                          | |
#     | |                                                          | |
#     | +----------------------------------------------------------+ |
#     |                                                              |
#     | +----++----++----++----++----++----++----++----++----+       |
#     | | RO || RO || RO || RO || RO || RO || RO || RO || RO |       |
#     | | 1  || 2  || 3  || 4  || 5  || 6  || 7  || 8  || 9  | . . . |
#     | +----++----++----++----++----++----++----++----++----+       |
#     +--------------------------------------------------------------+
#
# This is how Julian's floorplan looked as well.

# Ring oscillators
#
# The ring oscillators will be placed in a long line of fences.

# The left ROs will be inset by 1.4um to make room for endcaps and
# welltaps. Experimentation showed that 6x18 ring oscillators is a nice
# point because some oscillators have more stages and delay elements than
# others. Watch out for welltaps ending up inside a ring oscillator. Also
# watch out for the $ro_height being a non-multiple of the stdcell height,
# which creates odd scattered cells on the bottom-most or top-most rows.

set ro_inset_x [expr $core_margin_b +  1.4]; # N um inset to core area
set ro_inset_y [expr $core_margin_b + 00.0]; # N um inset to core area

set ro_width   6.0; # width  in um
set ro_height 18.0; # height in um (18um is 20 tracks)

set ro_gap     2.0; # Gap between ring oscillator fences

# Column 1

set ro_column1_llx $ro_inset_x
set ro_column1_urx [expr $ro_column1_llx + $ro_width]

set ro_1_llx  $ro_column1_llx
set ro_1_lly  $ro_inset_y
set ro_1_urx  $ro_column1_urx
set ro_1_ury  [expr $ro_1_lly + $ro_height]

set ro_2_llx  $ro_column1_llx
set ro_2_lly  [expr $ro_1_ury + $ro_gap]
set ro_2_urx  $ro_column1_urx
set ro_2_ury  [expr $ro_2_lly + $ro_height]

set ro_3_llx  $ro_column1_llx
set ro_3_lly  [expr $ro_2_ury + $ro_gap]
set ro_3_urx  $ro_column1_urx
set ro_3_ury  [expr $ro_3_lly + $ro_height]

set ro_4_llx  $ro_column1_llx
set ro_4_lly  [expr $ro_3_ury + $ro_gap]
set ro_4_urx  $ro_column1_urx
set ro_4_ury  [expr $ro_4_lly + $ro_height]

set ro_5_llx  $ro_column1_llx
set ro_5_lly  [expr $ro_4_ury + $ro_gap]
set ro_5_urx  $ro_column1_urx
set ro_5_ury  [expr $ro_5_lly + $ro_height]

set ro_6_llx  $ro_column1_llx
set ro_6_lly  [expr $ro_5_ury + $ro_gap]
set ro_6_urx  $ro_column1_urx
set ro_6_ury  [expr $ro_6_lly + $ro_height]

set ro_7_llx  $ro_column1_llx
set ro_7_lly  [expr $ro_6_ury + $ro_gap]
set ro_7_urx  $ro_column1_urx
set ro_7_ury  [expr $ro_7_lly + $ro_height]

set ro_8_llx  $ro_column1_llx
set ro_8_lly  [expr $ro_7_ury + $ro_gap]
set ro_8_urx  $ro_column1_urx
set ro_8_ury  [expr $ro_8_lly + $ro_height]

# Column 2

set ro_column2_llx [expr $ro_column1_urx + $ro_gap]
set ro_column2_urx [expr $ro_column2_llx + $ro_width]

set ro_9_llx  $ro_column2_llx
set ro_9_lly  $ro_inset_y
set ro_9_urx  $ro_column2_urx
set ro_9_ury  [expr $ro_9_lly + $ro_height]

set ro_10_llx $ro_column2_llx
set ro_10_lly [expr $ro_9_ury + $ro_gap]
set ro_10_urx $ro_column2_urx
set ro_10_ury [expr $ro_10_lly + $ro_height]

set ro_11_llx $ro_column2_llx
set ro_11_lly [expr $ro_10_ury + $ro_gap]
set ro_11_urx $ro_column2_urx
set ro_11_ury [expr $ro_11_lly + $ro_height]

set ro_12_llx $ro_column2_llx
set ro_12_lly [expr $ro_11_ury + $ro_gap]
set ro_12_urx $ro_column2_urx
set ro_12_ury [expr $ro_12_lly + $ro_height]

set ro_13_llx $ro_column2_llx
set ro_13_lly [expr $ro_12_ury + $ro_gap]
set ro_13_urx $ro_column2_urx
set ro_13_ury [expr $ro_13_lly + $ro_height]

set ro_14_llx $ro_column2_llx
set ro_14_lly [expr $ro_13_ury + $ro_gap]
set ro_14_urx $ro_column2_urx
set ro_14_ury [expr $ro_14_lly + $ro_height]

set ro_15_llx $ro_column2_llx
set ro_15_lly [expr $ro_14_ury + $ro_gap]
set ro_15_urx $ro_column2_urx
set ro_15_ury [expr $ro_15_lly + $ro_height]

set ro_16_llx $ro_column2_llx
set ro_16_lly [expr $ro_15_ury + $ro_gap]
set ro_16_urx $ro_column2_urx
set ro_16_ury [expr $ro_16_lly + $ro_height]

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n1  \
  $ro_1_llx $ro_1_lly $ro_1_urx $ro_1_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n2  \
  $ro_2_llx $ro_2_lly $ro_2_urx $ro_2_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n3  \
  $ro_3_llx $ro_3_lly $ro_3_urx $ro_3_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n4  \
  $ro_4_llx $ro_4_lly $ro_4_urx $ro_4_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n5  \
  $ro_5_llx $ro_5_lly $ro_5_urx $ro_5_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n6  \
  $ro_6_llx $ro_6_lly $ro_6_urx $ro_6_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n7  \
  $ro_7_llx $ro_7_lly $ro_7_urx $ro_7_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n8  \
  $ro_8_llx $ro_8_lly $ro_8_urx $ro_8_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n9  \
  $ro_9_llx $ro_9_lly $ro_9_urx $ro_9_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n10 \
  $ro_10_llx $ro_10_lly $ro_10_urx $ro_10_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n11 \
  $ro_11_llx $ro_11_lly $ro_11_urx $ro_11_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n12 \
  $ro_12_llx $ro_12_lly $ro_12_urx $ro_12_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n13 \
  $ro_13_llx $ro_13_lly $ro_13_urx $ro_13_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n14 \
  $ro_14_llx $ro_14_lly $ro_14_urx $ro_14_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n15 \
  $ro_15_llx $ro_15_lly $ro_15_urx $ro_15_ury

createFence pll_loop/ring_oscillator_top/ring_oscillator_top_n16 \
  $ro_16_llx $ro_16_lly $ro_16_urx $ro_16_ury

# Regions for main blocks that may be more sensitive

set main_width   5; # Width of this main block
set main_xoffset 2; # Offset to the right of ring oscillator to main blocks

set main_llx [expr $ro_column2_urx + $main_xoffset]
set main_lly $ro_inset_y
set main_urx [expr $main_llx + $main_width]
set main_ury [expr $core_margin_b + $core_height]

createRegion pll_loop/ring_oscillator_top/programmable_divider_output \
  $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/ring_oscillator_top/mux_sel_ring_oscillator \
  $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/fdc_top     $main_llx $main_lly $main_urx $main_ury
createRegion pll_loop/timing_ctrl $main_llx $main_lly $main_urx $main_ury

# Regions for other blocks

set other_xoffset 2; # Offset to the right of main to other blocks

set other_llx [expr $main_urx + $other_xoffset]
set other_lly $ro_inset_y
set other_urx [expr $core_margin_l + $core_width]
set other_ury [expr $core_margin_b + $core_height]

createRegion spi_top           $other_llx $other_lly $other_urx $other_ury
createRegion pll_loop/dlc_top  $other_llx $other_lly $other_urx $other_ury
createRegion pll_loop/dco_top  $other_llx $other_lly $other_urx $other_ury
createRegion pll_loop/lfsr_25b $other_llx $other_lly $other_urx $other_ury
createRegion pll_loop/lfsr_31b $other_llx $other_lly $other_urx $other_ury
createRegion pll_loop/alpha_and_accum_top   $other_llx $other_lly $other_urx $other_ury
createRegion pll_loop/dco_drift_compensator $other_llx $other_lly $other_urx $other_ury

# By default, fences are not honored by CTS or optDesign, so make sure
# that these are honored

setPlaceMode -hardFence  true
setCTSMode   -honorFence true
setOptMode   -honorFence true

