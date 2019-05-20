#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 17, 2019

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.operator-vcs-aprffx = \
	"Operator characterization study -- GL simulation to generate SAIF"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.operator-vcs-aprffx
	@echo -e $(echo_green)
	@echo '#################################################################################'
	@echo '#                  ___        ___   ________    _________                       #'
	@echo '#                  \  \      /  /  / _______|  /  _______/                      #'
	@echo '#                   \  \    /  /   | |        (  (_______                       #'
	@echo '#                    \  \  /  /    | |         \_______  |                      #'
	@echo '#                     \  \/  /     | |______    _______| |                      #'
	@echo '#                      \____/      |________|  |_________|                      #'
	@echo '#                                                                               #'
	@echo '#################################################################################'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.operator-vcs-aprffx = op-glsim

#-------------------------------------------------------------------------
# Options
#-------------------------------------------------------------------------

# Paths

operator_vcs_aprffx_sim_bin  = $(handoff_dir.operator-vcs-aprffx)/simv
operator_vcs_aprffx_csrc     = $(handoff_dir.operator-vcs-aprffx)/csrc

operator_vcs_aprffx_gl_model = $(wildcard $(innovus_results_dir)/*.vcs.v)

# General options

operator_vcs_aprffx_options  = -full64 -sverilog -debug_pp
operator_vcs_aprffx_options += -Mdir=$(operator_vcs_aprffx_csrc)
operator_vcs_aprffx_options += -o $(operator_vcs_aprffx_sim_bin)

# Gate-level fast-functional simulation options

operator_vcs_aprffx_options += -v $(adk_dir)/stdcells.v
operator_vcs_aprffx_options += -hsopt=gates -rad
operator_vcs_aprffx_options += +notimingcheck
operator_vcs_aprffx_options += +define+ARM_UD_MODEL

# SAIF dump options

operator_vcs_aprffx_options += +vcs+saif_libcell -lca

# Design

operator_vcs_aprffx_options += -v $(operator_vcs_aprffx_gl_model)

# Testbench

operator_vcs_aprffx_options += $(design_tb_v) -top th
operator_vcs_aprffx_options += $(design_tb_options)

# Lint rules
#
# Enable error-checking when ports and connections mismatch in bit-width
#
# This is very important to double-check on parameterized input and output
# ports. Ignoring this warning caused bugs in every tests related to data
# caches. We configured the test memory to have data interface with 32-bit
# bit-width. This caused the memory to slice the wrong bits from incoming
# requests. Since the very first bits are data and data is 128-bit for the
# other end of the interface, the test memory was extracting the data as
# different request fields. Since request for memory reads have X's in the
# data and thus the memory read request will be all X's for all fields
# including address. So we want to catch these warning:
#
# Lint-[CAWM-L] Width mismatch
# ../rtl-handoff/vc/vc-TestMemory_1i1d.v, 94
#   Continuous assignment width mismatch
#   5 bits (lhs) versus 32 bits (rhs).
#   Source info: assign imemreq0_msg_len_modified_M = ((imemreq0_msg[((p_i_nbits
#   + $clog2((p_i_nbits / 8))) - 1):p_i_nbits] == 0) ? (p_i_nbits / 8) :
#   imemreq0_msg[((p_i_nbits  ...

operator_vcs_aprffx_options += -error=CAWM-L

# Suppress certain lint and warnings

operator_vcs_aprffx_options += +lint=all,noVCDE,noTFIPC,noIWU,noOUDPE

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

operator_vcs_aprffx_build_log = $(logs_dir.operator-vcs-aprffx)/build.log
operator_vcs_aprffx_build_cmd = vcs $(operator_vcs_aprffx_options)

define commands.operator-vcs-aprffx

	mkdir -p $(logs_dir.operator-vcs-aprffx)
	mkdir -p $(handoff_dir.operator-vcs-aprffx)

# Record the full command used to build the simulator

	@printf "%.s-" {1..80}           > $(operator_vcs_aprffx_build_log)
	@echo                           >> $(operator_vcs_aprffx_build_log)
	@echo   "Full VCS Command"      >> $(operator_vcs_aprffx_build_log)
	@printf "%.s-" {1..80}          >> $(operator_vcs_aprffx_build_log)
	@echo                           >> $(operator_vcs_aprffx_build_log)
	@echo "$(operator_vcs_aprffx_build_cmd)" >> $(operator_vcs_aprffx_build_log)

# Build the simulator

	@printf "%.s-" {1..80}          >> $(operator_vcs_aprffx_build_log)
	@echo                           >> $(operator_vcs_aprffx_build_log)
	@echo   "Build log"             >> $(operator_vcs_aprffx_build_log)
	@printf "%.s-" {1..80}          >> $(operator_vcs_aprffx_build_log)
	@echo                           >> $(operator_vcs_aprffx_build_log)
	$(operator_vcs_aprffx_build_cmd) | tee -a   $(operator_vcs_aprffx_build_log)

# Run the simulator

	@printf "%.s-" {1..80}          >> $(operator_vcs_aprffx_build_log)
	@echo                           >> $(operator_vcs_aprffx_build_log)
	@echo   "Run log"               >> $(operator_vcs_aprffx_build_log)
	@printf "%.s-" {1..80}          >> $(operator_vcs_aprffx_build_log)
	@echo                           >> $(operator_vcs_aprffx_build_log)
	./$(operator_vcs_aprffx_sim_bin) | tee -a   $(operator_vcs_aprffx_build_log)

# Prepare handoffs

	mkdir -p $(handoff_dir.operator-vcs-aprffx)
	mv run.saif ./$(handoff_dir.operator-vcs-aprffx)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-operator-vcs-aprffx:
	rm -rf ./$(VPATH)/operator-vcs-aprffx
	rm -rf ./$(collect_dir.operator-vcs-aprffx)
	rm -rf ./$(handoff_dir.operator-vcs-aprffx)
	rm -rf ./$(logs_dir.operator-vcs-aprffx)

clean-op-glsim: clean-operator-vcs-aprffx

