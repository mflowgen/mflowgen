
include ../../Makefrag

ALLOY_ASIC_ROOT=/work/global/sj634/cornell-brg/alloy-asic


test-rtl: proc-test-bench.v $(ALLOY_ASIC_ROOT)/pymtl/build/ProcL0Mdu.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	+libext+.v+.vlib+.vh \
  +vcs+initreg+random \
	-timescale=1ns/1ps -diag timescale \
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
  -debug_pp \
	+notimingcheck +nospecify \
	+incdir+$(ALLOY_ASIC_ROOT)/pymtl/build \
	proc-test-bench.v $(ALLOY_ASIC_ROOT)/pymtl/build/ProcL0Mdu.v \
	-o test-rtl

test-gl: proc-test-bench.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.vcs.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
  -hsopt=gates +rad \
  +vcs+initreg+random \
  -line \
	-timescale=1ns/1ps -diag timescale \
  +ntb_random_seed_automatic \
	+define+INITIALIZE_MEMORY \
  +notimingcheck \
  -debug_pp \
  +define+ARM_UD_MODEL \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/pymtl/build \
	proc-test-bench.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.vcs.v \
	$(adk_dir)/stdcells.v \
	-o test-gl

clean:
	rm -rf csrc ucli.key test-* test-*.daidir *.vpd DVEfiles *.diag.*
