
include ../../Makefrag

ALLOY_ASIC_ROOT=/work/global/sj634/cornell-brg/alloy-asic

# Four-state for RTL

test-rtl: HostGcdUnit_tb.v swshim.v $(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/HostGcdUnit.v HostGcdUnit_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	+libext+.v+.vlib+.vh \
	-timescale=1ns/1ps -diag timescale \
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
	+notimingcheck +nospecify \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	$(adk_dir)/iocells.v \
	HostGcdUnit_tb.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/HostGcdUnit.v \
	-o test-rtl

# initreg for GL

test-gl: proc-test-bench.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.v HostGcdUnit_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
  -hsopt=gates +rad \
  +vcs+initreg+random \
  -line \
	-timescale=1ns/1ps -diag timescale \
  +ntb_random_seed_automatic \
	+define+INITIALIZE_MEMORY \
  +notimingcheck \
  +define+ARM_UD_MODEL \
	+libext+.v+.vlib+.vh \
	swshim.v \
	proc-test-bench.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.vcs.v \
	$(adk_dir)/stdcells.v \
	-o test-gl

HostGcdUnit_all_tests.v: gen-all-tests.sh
	./gen-all-tests.sh

clean:
	rm -rf csrc ucli.key test-* test-*.daidir *.vpd DVEfiles *.diag.* HostGcdUnit_all_tests.v
