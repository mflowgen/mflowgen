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

define ascii.vcs-sim
        @echo -e $(echo_green)
        @echo '#################################################################################'
        @echo '#                  ___        ___    ________    _________                      #'
        @echo '#                  \  \      /  /   / _______|  /  _______/                     #'
        @echo '#                   \  \    /  /    | |        (  (_______                      #'
        @echo '#                    \  \  /  /     | |         \_______  |                     #'
        @echo '#                     \  \/  /      | |______    _______| |                     #'
        @echo '#                      \____/       |________|  |_________|                     #'
        @echo '#                                                                               #'
        @echo '#################################################################################'
        @echo -e $(echo_nocolor)
endef

abbr.vcs-sim = sim

sim_design_name=$(design_name)
sim_reports=reports/sim
sim_design_v=$(design_v)
sim_clk?=clk
sim_uut?=operator
sim_tb= ../../sim/$(sim_design_name)/$(sim_design_name).t.v
sim_clk_p = $(clock_period)

define commands.vcs-sim

@mkdir ${sim_reports}

@echo "=========================================================================";
@echo "                         Design Information                              ";
@echo "=========================================================================";
@echo -e "Verilog Design: " ${sim_design_v} 
@echo -e "Clock Period: "${sim_clk_p}
@echo -e "Design Name: " ${sim_design_name} 
@echo -e "TestBench File:"${sim_tb}
@echo -e "SAIF & VCD Files: " ${sim_reports}
@echo "=========================================================================";
@echo "                     VCS simulation Step Starts                          ";
@echo "=========================================================================";

vcs -full64 -debug_pp -sverilog ${sim_tb} -v  ${sim_design_v} +vcs+saif_libcell -lca
./simv
mv run.saif ./${sim_reports}/run.saif

endef

clean-vcs-sim:
	rm -rf ./${sim_reports}
	rm -rf ./$(VPATH)/vcs-sim
	rm -rf csrc simv simv.daidir ucli.key
clean-sim: clean-vcs-sim
