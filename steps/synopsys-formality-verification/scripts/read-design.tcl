#=========================================================================
# read-design.tcl
#=========================================================================
# This script reads in all the input files.
#
# Author : Kartik Prabhu
# Date   : March 23, 2021

set_svf $fm_svf

read_db $fm_extra_link_libraries

# Load reference design
read_verilog -r $fm_ref_design

if {[ file exists $fm_ref_upf ]} {
    load_upf $fm_ref_upf
}

set_top $fm_design_name


# Load implemented design
read_verilog -i $fm_impl_design

if {[ file exists $fm_impl_upf ]} {
    load_upf $fm_impl_upf
}

set_top $fm_design_name
