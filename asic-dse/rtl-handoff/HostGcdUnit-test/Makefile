
include ../../Makefrag

ALLOY_ASIC_ROOT=/work/global/sj634/cornell-brg/alloy-asic

# Four-state for RTL

test-rtl: HostGcdUnit_tb.v $(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/HostGcdUnit.v HostGcdUnit_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	+libext+.v+.vlib+.vh \
	-timescale=1ns/1ps -diag timescale \
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
  -debug_pp \
	+notimingcheck +nospecify \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	$(adk_dir)/iocells.v \
	HostGcdUnit_tb.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/HostGcdUnit.v \
	-top top \
	-o test-rtl

# initreg for GL

test-gl: HostGcdUnit_tb.v HostGcdUnit_SwShim.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.vcs.v HostGcdUnit_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
  -hsopt=gates +rad \
  -debug_pp \
  +vcs+initreg+random \
  -line \
	-timescale=1ns/1ps -diag timescale \
  +ntb_random_seed_automatic \
	+define+INITIALIZE_MEMORY \
  +notimingcheck \
  +define+ARM_UD_MODEL \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	HostGcdUnit_SwShim.v \
	HostGcdUnit_tb.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.vcs.v \
	$(adk_dir)/iocells.v \
	$(adk_dir)/stdcells.v \
	-top top \
	-o test-gl | tee compile-gl.log

test-gl-sdf: HostGcdUnit_tb.v HostGcdUnit_SwShim.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.vcs.v HostGcdUnit_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
  -hsopt=gates +rad \
  -debug_pp \
  +vcs+initreg+random \
  -line \
	-timescale=1ns/1ps -diag timescale \
  +ntb_random_seed_automatic \
	+define+INITIALIZE_MEMORY \
  +sdfverbose \
  +overlap +multisource_int_delays \
  +neg_tchk -negdelay \
  +define+ARM_NEG_MODEL \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	HostGcdUnit_SwShim.v \
	HostGcdUnit_tb.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.vcs.v \
	-sdf max:HostGcdUnit:$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/HostGcdUnit.sdf \
	$(adk_dir)/iocells.v \
	$(adk_dir)/stdcells.v \
	-o test-gl-sdf | tee compile-gl-sdf.log

HostGcdUnit_all_tests.v: gen-all-tests.sh
	./gen-all-tests.sh

clean:
	rm -rf csrc ucli.key test-* test-*.daidir *.vpd DVEfiles *.diag.* HostGcdUnit_all_tests.v
