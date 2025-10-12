#=========================================================================
# designer-interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by FM 
# and sets up ASIC design kit variables and inputs.
#
# Author : Kartik Prabhu
# Date   : March 23, 2021


#-------------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------------

set fm_design_name        		$::env(design_name)
set fm_num_cores                $::env(nthreads)

#-------------------------------------------------------------------------
# Libraries
#-------------------------------------------------------------------------

set adk_dir                       inputs/adk

set fm_additional_search_path   $adk_dir

set fm_extra_link_libraries     [join "
                                      [lsort [glob -nocomplain inputs/*.db]]
                                      [lsort [glob -nocomplain inputs/adk/*.db]]
                                  "]

#-------------------------------------------------------------------------
# Inputs
#-------------------------------------------------------------------------

set fm_ref_design           inputs/design.ref.v
set fm_ref_upf              inputs/design.ref.upf

set fm_impl_design          inputs/design.impl.v
set fm_impl_upf             inputs/design.impl.upf

set fm_svf                  inputs/design.svf

#-------------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------------

set fm_reports_dir	   	reports
set fm_logs_dir	   		logs


