#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Shady Agwa
# Date   : May 7, 2019
#
#-------------------------------------------------------------------------
# Step Description -- synopsys-ptpx
#-------------------------------------------------------------------------
# This step runs Power analysis using Synopsys Prime-Time
#

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.synopsys-ptpx
        @echo -e $(echo_green)
        @echo '#################################################################################'
        @echo '#                     ______     __________                                     #'
        @echo '#                    |  ___ \   |___    ___|                                    #'
        @echo '#                    | (__ ) |      |  |                                        #'
        @echo '#                    |  ____/       |  |                                        #'
        @echo '#                    |  |           |  |                                        #'
        @echo '#                    |__|           |__|                                        #'
        @echo '#                                                                               #'
        @echo '#################################################################################'
        @echo -e $(echo_nocolor)
endef

abbr.synopsys-ptpx = ptpx

pt_search_path=$(adk_dir)
pt_target_libraries=stdcells.db
pt_design_name=$(design_name)
pt_reports=reports/synopsys-ptpx
pt_design_v=$(design_v)
pt_pnr_design=$(innovus_results_dir)
pt_clk?=clk
pt_uut?=operator

export pt_clk_p = $(clock_period)

define commands.synopsys-ptpx

@mkdir ${pt_reports}

@echo "=========================================================================";
@echo "                         Design Information                              ";
@echo "=========================================================================";
@echo -e "\nVerilog Design: " ${pt_design_v} 
@echo -e "Clock Period: "${clock_period}
@echo -e "Std_Cells: " ${pt_search_path}/${pt_target_libraries} 
@echo -e "Design Name: " ${pt_design_name} 
@echo -e "P&R File: " ${pt_pnr_design}/${pt_design_name}.lvs.v 
@echo -e "Power Analysis Report Files: " ${pt_reports}
@echo "=========================================================================";
@echo "                 Prime-Time Power Analysis Starts                          ";
@echo "=========================================================================";

pt_shell -file ../${master_steps_dir}/synopsys-ptpx/pt_px.tcl

endef

clean-synopsys-ptpx:
	rm -rf ./${pt_reports}
	rm -rf ./$(VPATH)/synopsys-ptpx
	rm -rf pt_shell_command.log
	rm -rf parasitics_command.log 

clean-ptpx: clean-synopsys-ptpx
