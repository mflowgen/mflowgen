#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Shady Agwa
# Date   : May 7, 2019
#
#-------------------------------------------------------------------------
# Step Description -- VCS RTL Simulation 
#-------------------------------------------------------------------------
# This step runs the VCS RTL Simulation, generates SAIF file
#

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.operator-vcs-rtl
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

abbr.operator-vcs-rtl = rtl-sim

sim_design_name=$(design_name)
sim_reports=reports/rtl-sim
sim_design_v=$(design_v)
sim_clk?=clk
sim_tb= $(design_tb_v)
sim_clk_p = $(clock_period)

define commands.operator-vcs-rtl

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

vcs -full64 -debug_pp -top th -sverilog ${sim_tb} -v  ${sim_design_v} ${design_tb_options} +vcs+saif_libcell -lca
./simv
mv run.saif ./${sim_reports}/run.saif

endef

clean-operator-vcs-rtl:
	rm -rf ./${sim_reports}
	rm -rf ./$(VPATH)/operator-vcs-rtl
	rm -rf csrc simv simv.daidir ucli.key
clean-rtl-sim: clean-operator-vcs-rtl
