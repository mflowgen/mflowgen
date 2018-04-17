simv:
	vcs -full64 -sverilog +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +v2k +rad +vcs+initreg+random +neg_tchk -noIncrComp +incdir+/work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc-ctorng/stdview IntDivRem4_adhoc_tb.v -o simv +define+ARM_UD_MODEL

sim: simv
	./simv +cycle=100000

clean:
	rm -rf csrc ucli.key simv simv.daidir
