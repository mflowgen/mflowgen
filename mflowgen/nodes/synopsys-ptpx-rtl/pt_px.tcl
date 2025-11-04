#=========================================================================
# pt_px.tcl
#=========================================================================
# We use Synopsys Prime-Time to get the power analysis of the PnR Netlist.
#
# This Prime-Time Power analysis step follows the Signoff step to estimate
# the average power of the gate-level netlist using RTL SAIF file.
#
# Author : Shady Agwa, Yanghui Ou
# Date   : May 7, 2019
#

set pt_search_path inputs/adk 
set pt_target_libraries stdcells.db
set pt_design_name  $::env(design_name)
set pt_reports reports
set pt_clk clk
set pt_uut TOP
set pt_clk_period $::env(clock_period)

set_app_var target_library "* ${pt_search_path}/${pt_target_libraries}"
set_app_var link_library "* ${pt_search_path}/${pt_target_libraries} "
set_app_var power_enable_analysis true 

read_verilog inputs/design.vcs.v

current_design ${pt_design_name}
file mkdir ${pt_reports}
link_design > ${pt_reports}/${pt_design_name}.link.rpt
create_clock ${pt_clk} -name ideal_clock1 -period ${pt_clk_period}
source inputs/design.namemap > ${pt_reports}/${pt_design_name}.map.rpt

read_saif inputs/run.saif -strip_path ${pt_uut}
read_parasitics -format spef inputs/design.spef.gz
read_sdc inputs/design.pt.sdc > ${pt_reports}/${pt_design_name}.sdc.rpt

update_power > ${pt_reports}/${pt_design_name}.update.rpt
report_switching_activity > ${pt_reports}/${pt_design_name}.sw.rpt 
report_power -nosplit  -verbose > ${pt_reports}/signoff.pwr.rpt
report_power -nosplit -hierarchy -verbose > ${pt_reports}/${pt_design_name}.pwr.hier.rpt
exit
