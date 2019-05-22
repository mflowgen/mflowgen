#=========================================================================
# pt_px.tcl
#=========================================================================
# We use Synopsys Prime-Time to get the power analysis of the PnR Netlist.
#
# This Prime-Time Power analysis step follows the Signoff step to estimate
# the average power of the gate-level netlist using RTL SAIF file.
#
# Author : Shady Agwa
# Date   : May 7, 2019
#

set pt_search_path  $::env(adk_dir)
set pt_target_libraries stdcells.db
set pt_design_name  $::env(design_name)
set pt_reports reports/synopsys-ptpx-rtl
set pt_pnr_design  $::env(innovus_results_dir)
set pt_clk clk
set pt_uut $::env(design_ptpx_strip_path)
#th/operator
set pt_clk_period $::env(pt_clk_p)

set_app_var target_library "* ${pt_search_path}/${pt_target_libraries}"
set_app_var link_library "* ${pt_search_path}/${pt_target_libraries} "
set_app_var power_enable_analysis true 
read_verilog ${pt_pnr_design}/${pt_design_name}.vcs.v
current_design ${pt_design_name}
link_design > ${pt_reports}/${pt_design_name}.link.rpt
create_clock ${pt_clk} -name ideal_clock1 -period ${pt_clk_period}
source reports/dc-synthesis/${pt_design_name}.namemap > ${pt_reports}/${pt_design_name}.map.rpt
read_saif reports/rtl-sim/run.saif -strip_path ${pt_uut}
read_parasitics -format spef ${pt_pnr_design}/*.spef.gz
read_sdc collect/synopsys-ptpx-rtl/${pt_design_name}.pt.sdc > ${pt_reports}/${pt_design_name}.sdc.rpt
update_power > ${pt_reports}/${pt_design_name}.update.rpt
report_switching_activity > ${pt_reports}/${pt_design_name}.sw.rpt 
report_power -nosplit > ${pt_reports}/signoff.pwr.rpt
report_power -nosplit -hierarchy > ${pt_reports}/${pt_design_name}.pwr.hier.rpt
exit
