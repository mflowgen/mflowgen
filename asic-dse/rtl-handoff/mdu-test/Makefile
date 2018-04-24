test-gl-no-delay: simv-gl-no-delay
	./simv-gl-no-delay

test-rtl: simv-rtl
	./simv-rtl

debug-rtl: simv-rtl-debug
	./simv-rtl

simv-gl-no-delay: IntMulDivUnit_adhoc_tb.v ../../build/results/innovus/IntMulDivUnit.vcs.v
	vcs -full64 -sverilog +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +v2k +rad +vcs+initreg+random +neg_tchk -noIncrComp \
  +define+ARM_UD_MODEL +define+BRG_GL_TESTING \
	+incdir+/work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc-brg/stdview \
	+incdir+../../build/results/innovus/ \
	IntMulDivUnit_adhoc_tb.v -o simv-gl-no-delay

simv-rtl: IntMulDivUnit_adhoc_tb.v ../IntMulDivUnit.v
	vcs -full64 -sverilog +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +v2k +rad +vcs+initreg+random +neg_tchk -noIncrComp \
	+incdir+/work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc-brg/stdview \
	+incdir+.. \
	IntMulDivUnit_adhoc_tb.v -o simv-rtl

simv-rtl-debug: IntMulDivUnit_adhoc_tb.v ../IntMulDivUnit.v
# 	export VCS_PRINT_INITREG_INITIALIZATION=1

	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V\
	+vcs+lic_wait +vcs+loopreport \
	+libext+.v+.vlib+.vh \
	-timescale=1ps/1ps -diag timescale \
# 	+optconfigurefile+${}/timing_config \
# 	-bom IntMuld -bfl ${resultsdir}/vcs_file_list
# -top 
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
	+notimingcheck +nospecify \
# 	+define+INITIALIZE_MEMORY
	-debug_pp \
	+incdir+/work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc-brg/stdview \
	+incdir+.. \
	IntMulDivUnit_adhoc_tb.v \
	-o simv-rtl

# sim-delay:
# 	vcs -full64 -sverilog +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +v2k +rad +vcs+initreg+random +neg_tchk -noIncrComp +incdir+/work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc-brg/stdview IntMulDivUnit_adhoc_tb.v -o simv-delay +define+ARM_UD_MODEL

# 	./simv +cycle=100000

clean:
	rm -rf csrc ucli.key simv* simv*.daidir
