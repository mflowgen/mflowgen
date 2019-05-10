#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Shady Agwa
# Date   : May 10, 2019
#
#-------------------------------------------------------------------------
# Step Description -- Summary for Area, Power, Clock Period, Slack
#-------------------------------------------------------------------------

#

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.summary
        @echo -e $(echo_green)
        @echo '#################################################################################'
        @echo '#                     _________     ______________                              #'
        @echo '#                    |   _____/    |  ___   ___   |                             #'
        @echo '#                    |  (_____     |  |  |  |  |  |                             #'
        @echo '#                    \ ____   |    |  |  |  |  |  |                             #'
        @echo '#                    ______|  |    |  |  |  |  |  |                             #'
        @echo '#                   /_________|    |__|  |__|  |__|                             #'
        @echo '#                                                                               #'
        @echo '#################################################################################'
        @echo -e $(echo_nocolor)
endef

abbr.summary = sm

sm_search_path=$(adk_dir)
sm_target_libraries=stdcells.db
sm_design_name=$(design_name)
sm_reports=reports/summary
sm_design_v=$(design_v)

define commands.summary

@mkdir ${sm_reports}

@echo "=========================================================================";
@echo "                         Design Information                              ";
@echo "=========================================================================";
@echo -e "\nVerilog Design: " ${sm_design_v} 
@echo -e "Clock Period: "${clock_period}
@echo -e "Std_Cells: " ${sm_search_path}/${sm_target_libraries} 
@echo -e "Design Name: " ${sm_design_name} 
@echo -e "P&R File: " ${sm_pnr_design}/${sm_design_name}.lvs.v 
@echo "=========================================================================";

python ../${master_steps_dir}/summary/summary.py

endef

clean-summary:
	rm -rf ./${sm_reports}
	rm -rf ./$(VPATH)/summary

clean-sm: clean-summary
