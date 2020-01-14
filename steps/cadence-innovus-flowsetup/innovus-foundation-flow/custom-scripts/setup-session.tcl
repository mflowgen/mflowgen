#=========================================================================
# setup-session.tcl
#=========================================================================
# Sets up an Innovus session with all Foundation Flow variables sourced.
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
}

foreach file $vars(config_files) {
   source $file
}

source innovus-foundation-flow/procs.tcl

ff_procs::system_info
setDistributeHost -local
setMultiCpuUsage -localCpu $vars(local_cpus)

#-------------------------------------------------------------------------
# Other setup
#-------------------------------------------------------------------------

puts "<FF> Plugin -> always_source_tcl"
ff_procs::source_plug always_source_tcl


