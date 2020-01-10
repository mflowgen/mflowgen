#=========================================================================
# run_debug.tcl
#=========================================================================
# Opens an Innovus session with GUI enabled and loads the finished
# checkpoint for this step.
#
# This script was adapted from the Innovus Foundation Flow Code
# Generator's generated run_debug.tcl ( Version : 19.10-p002_1 ).
#
# Author : Christopher Torng
# Date   : January 10, 2020
#

#-------------------------------------------------------------------------
# Set up any Innovus foundation flow variables
#-------------------------------------------------------------------------

if {[file exists innovus-foundation-flow/vars.tcl]} {
  source innovus-foundation-flow/vars.tcl
  foreach file $vars(config_files) {
     source $file
  }
}

if {[file exists innovus-foundation-flow/procs.tcl]} {
  source innovus-foundation-flow/procs.tcl
  ff_procs::system_info
  setDistributeHost -local
  setMultiCpuUsage -localCpu $vars(local_cpus)
}

#-------------------------------------------------------------------------
# Restore the finished checkpoint for this step
#-------------------------------------------------------------------------

restoreDesign checkpoints/design.enc.dat $vars(design)

#-------------------------------------------------------------------------
# More Innovus foundation flow variables
#-------------------------------------------------------------------------

um::enable_metrics -on
puts "<FF> Plugin -> always_source_tcl"
ff_procs::source_plug always_source_tcl

#-------------------------------------------------------------------------
# Open the Innovus GUI
#-------------------------------------------------------------------------

win

