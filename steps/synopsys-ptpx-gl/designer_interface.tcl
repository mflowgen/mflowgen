#=========================================================================
# designer_interface.tcl
#=========================================================================
# The designer_interface.tcl file is the first script run by PTPX (see the
# top of ptpx.tcl). It is the interface that connects the scripts with
# the following:
#
# - ASIC design kit
# - Build system variables
#
# Author : Christopher Torng
# Date   : May 20, 2019

#-------------------------------------------------------------------------
# Interface to the ASIC design kit
#-------------------------------------------------------------------------

set ptpx_additional_search_path   $::env(adk_dir)
set ptpx_target_libraries         stdcells.db

#-------------------------------------------------------------------------
# Interface to the build system
#-------------------------------------------------------------------------

set ptpx_design_name              $::env(design_name)

# The strip path must be defined in setup-design.tcl!
#
#   export design_ptpx_strip_path = th/design_foo
#
# There must _not_ be any quotes, or read_saif will fail. This fails:
#
#   export design_ptpx_strip_path = "th/design_foo"
#

set ptpx_strip_path               $::env(design_ptpx_strip_path)

set ptpx_flow_dir                 $::env(ptpx_gl_flow_dir)
set ptpx_plugins_dir              $::env(ptpx_gl_plugins_dir)
set ptpx_logs_dir                 $::env(ptpx_gl_logs_dir)
set ptpx_reports_dir              $::env(ptpx_gl_reports_dir)
set ptpx_results_dir              $::env(ptpx_gl_results_dir)
set ptpx_collect_dir              $::env(ptpx_gl_collect_dir)

set ptpx_gl_netlist         [glob -nocomplain $ptpx_collect_dir/*.vcs.v]
set ptpx_sdc                [glob -nocomplain $ptpx_collect_dir/*.pt.sdc]
set ptpx_spef               [glob -nocomplain $ptpx_collect_dir/*.spef.gz]
set ptpx_saif               [glob -nocomplain $ptpx_collect_dir/*.saif]

