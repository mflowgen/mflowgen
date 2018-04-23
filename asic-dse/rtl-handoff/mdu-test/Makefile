test-gl-no-delay: simv-gl-no-delay
	./simv-gl-no-delay +cycle=100000

test-rtl: simv-rtl
	./simv-rtl +cycle=100000

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

# sim-delay:
# 	vcs -full64 -sverilog +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +v2k +rad +vcs+initreg+random +neg_tchk -noIncrComp +incdir+/work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc-brg/stdview IntMulDivUnit_adhoc_tb.v -o simv-delay +define+ARM_UD_MODEL

# 	./simv +cycle=100000

clean:
	rm -rf csrc ucli.key simv* simv*.daidir
