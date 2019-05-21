#=========================================================================
# ptpx.tcl
#=========================================================================
# Use Synopsys PrimeTime to run power analysis
#
# - Gate-level power analysis
# - Averaged power analysis
#
# Requires:
#
# - *.v    -- gate-level netlist
# - *.saif -- switching activity dump from gate-level simulation
# - *.sdc  -- constraints (e.g., create_clock) from PnR
# - *.spef -- parasitics from PnR
#
# Author : Christopher Torng
# Date   : May 20, 2019
#

#-------------------------------------------------------------------------
# Designer interface
#-------------------------------------------------------------------------
# Source the designer interface script, which sets up variables from the
# build system, sets up ASIC design kit variables, etc.

source -echo -verbose $::env(ptpx_gl_flow_dir)/designer_interface.tcl

#-------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------

# Set up paths and libraries

set_app_var search_path      ". $ptpx_additional_search_path $search_path"
set_app_var target_library   $ptpx_target_libraries
set_app_var link_library     "* $ptpx_target_libraries"

# Set up power analysis

set_app_var power_enable_analysis true
set_app_var power_analysis_mode   averaged

set_app_var report_default_significant_digits 2

#-------------------------------------------------------------------------
# Read design
#-------------------------------------------------------------------------

# Read and link the design

read_verilog   $ptpx_gl_netlist
current_design $ptpx_design_name

link_design

# Read in the SDC and parasitics

read_sdc -echo $ptpx_sdc
read_parasitics -format spef $ptpx_spef

# Read in switching activity

report_activity_file_check $ptpx_saif -strip_path $ptpx_strip_path \
  > $ptpx_reports_dir/$ptpx_design_name.activity.pre.rpt

read_saif $ptpx_saif -strip_path $ptpx_strip_path

# Checks

check_constraints -verbose \
  > $ptpx_reports_dir/$ptpx_design_name.checkconstraints.rpt

check_power \
  > $ptpx_reports_dir/$ptpx_design_name.checkpower.rpt

#-------------------------------------------------------------------------
# Power analysis
#-------------------------------------------------------------------------

update_power

#-------------------------------------------------------------------------
# Final reports
#-------------------------------------------------------------------------

report_switching_activity \
  > $ptpx_reports_dir/$ptpx_design_name.activity.post.rpt

report_power -nosplit \
  > $ptpx_reports_dir/$ptpx_design_name.power.rpt

report_power -nosplit -hierarchy \
  > $ptpx_reports_dir/$ptpx_design_name.power.hier.rpt

exit

