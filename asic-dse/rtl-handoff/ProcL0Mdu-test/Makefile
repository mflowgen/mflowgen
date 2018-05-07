
include ../../Makefrag

ALLOY_ASIC_ROOT=/work/global/sj634/cornell-brg/alloy-asic

# Four-state for RTL

test-rtl: ProcL0Mdu_tb.v $(ALLOY_ASIC_ROOT)/pymtl/build/ProcL0Mdu.v ProcL0Mdu_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	+libext+.v+.vlib+.vh \
	-timescale=1ns/1ps -diag timescale \
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
  -debug_pp \
	+notimingcheck +nospecify \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	ProcL0Mdu_tb.v \
	$(ALLOY_ASIC_ROOT)/pymtl/build/ProcL0Mdu.v \
	-top top \
	-o test-rtl

# initreg for GL

test-gl: ProcL0Mdu_tb.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.vcs.v ProcL0Mdu_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
  -hsopt=gates +rad \
  -debug_pp \
  -line \
  +vcs+initreg+random \
	-timescale=1ns/1ps -diag timescale \
	+define+INITIALIZE_MEMORY \
  +notimingcheck \
  +define+ARM_UD_MODEL \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	ProcL0Mdu_tb.v  \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.vcs.v \
	$(adk_dir)/stdcells.v \
	-top top \
	-o test-gl

test-gl-sdf: ProcL0Mdu_tb.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.vcs.v ProcL0Mdu_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
  -hsopt=gates +rad \
  -debug_pp \
  -line \
	-timescale=1ns/1ps -diag timescale \
	+define+INITIALIZE_MEMORY \
  +sdfverbose \
  +overlap +multisource_int_delays \
  +neg_tchk -negdelay \
  +define+ARM_NEG_MODEL \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	ProcL0Mdu_tb.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.vcs.v \
	-sdf max:ProcL0Mdu:$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/ProcL0Mdu.sdf \
	$(adk_dir)/iocells.v \
	$(adk_dir)/stdcells.v \
	-top top \
	-o test-gl-sdf | tee compile-gl-sdf.log

ProcL0Mdu_all_tests.v: gen-all-tests.sh
	ALLOY_ASIC_ROOT=$(ALLOY_ASIC_ROOT) ./gen-all-tests.sh

clean:
	rm -rf csrc ucli.key test-* test-*.daidir *.vpd DVEfiles *.diag.*
