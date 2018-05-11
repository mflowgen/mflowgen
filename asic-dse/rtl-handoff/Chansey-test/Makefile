
include ../../Makefrag

ALLOY_ASIC_ROOT=/work/global/sj634/cornell-brg/alloy-asic

# Four-state for RTL

test-rtl: Chansey_tb.v $(ALLOY_ASIC_ROOT)/pymtl/build/Chansey.v Chansey_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	+libext+.v+.vlib+.vh \
	-timescale=1ns/1ps -diag timescale \
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
	-debug_pp \
	+notimingcheck +nospecify \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	Chansey_tb.v \
	$(ALLOY_ASIC_ROOT)/pymtl/build/Chansey.v \
	-top top \
	-o test-rtl

# Four-state for RTL

sim-rtl: Chansey_sim.v $(ALLOY_ASIC_ROOT)/pymtl/build/Chansey.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	+libext+.v+.vlib+.vh \
	-timescale=1ns/1ps -diag timescale \
	+lint=all,noVCDE,noTFIPC,noIWU,noOUDPE \
	+rad \
	-debug_pp \
	+notimingcheck +nospecify \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	Chansey_sim.v \
	$(ALLOY_ASIC_ROOT)/pymtl/build/Chansey.v \
	-top top \
	-o sim-rtl

# initreg for GL

test-gl: Chansey_tb.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.vcs.v Chansey_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	-hsopt=gates +rad \
	-debug_pp \
	-line \
	-timescale=1ns/1ps -diag timescale \
	+define+INITIALIZE_MEMORY \
	+notimingcheck \
	+nospecify +vcs+initreg+random +define+ARM_UD_MODEL +define+ARM_EN_X_SQUASH \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	Chansey_tb.v	\
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.vcs.v \
	$(adk_dir)/stdcells.v \
	-top top \
	-o test-gl

test-glx: Chansey_tb.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.vcs.v Chansey_all_tests.v
	vcs -full64 -sverilog +v2k +noportcoerce +vc -notice -V \
	-hsopt=gates +rad \
	-debug_pp \
	-line \
	-timescale=1ns/1ps -diag timescale \
	+define+INITIALIZE_MEMORY \
	+notimingcheck \
	+define+ARM_UD_MODEL \
	+libext+.v+.vlib+.vh \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff \
	+incdir+$(ALLOY_ASIC_ROOT)/asic-dse/rtl-handoff/vc \
	Chansey_tb.v	\
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.vcs.v \
	$(adk_dir)/stdcells.v \
	-top top \
	-o test-gl

test-gl-sdf: Chansey_tb.v $(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.vcs.v Chansey_all_tests.v
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
	Chansey_tb.v \
	$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.vcs.v \
	-sdf max:Chansey:$(ALLOY_ASIC_ROOT)/asic-dse/build/results/innovus/Chansey.sdf \
	$(adk_dir)/iocells.v \
	$(adk_dir)/stdcells.v \
	-top top \
	-o test-gl-sdf | tee compile-gl-sdf.log

Chansey_all_tests.v: gen-all-tests.sh
	ALLOY_ASIC_ROOT=$(ALLOY_ASIC_ROOT) ./gen-all-tests.sh

clean:
	rm -rf csrc ucli.key test-* test-*.daidir sim-* sim-*.daidir *.vpd DVEfiles *.diag.* sdfAnnotateInfo *.log
