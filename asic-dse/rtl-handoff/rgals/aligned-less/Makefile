gcd-top:
	vcs -full64 -sverilog -debug_pp gcd-test.v -v GcdTop.v

gcd-top-sdf:
	vcs -full64 -sverilog +v2k +vc -notice -V +libext+.v +noportcoerce -debug_pp -diag timescale -diag env -timescale=1ns/1ps -error=CIRNU -error=CAWM-L gcd-test.v -top th -o simv -v /work/global/clt67/work/2018-summer/alloy-asic/asic-dse/build/results/innovus/GcdTop.vcs.v -v /work/global/brg/install/adk-pkgs/tsmc-28nm-cln28hpc/stdview/stdcells.v -hsopt=gates +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE +sdfverbose +overlap +multisource_int_delays +neg_tchk -negdelay -sdf max:th.top:/work/global/clt67/work/2018-summer/alloy-asic/asic-dse/build/results/innovus/GcdTop.sdf +define+ARM_NEG_MODEL

fifo-top:
	vcs -full64 -sverilog -debug_pp fifo-test.v -v FifoTop.v

fifo-isolated:
	vcs -full64 -sverilog -debug_pp fifo-isolated-test.v -v BisynchronousNormalQueue.v
