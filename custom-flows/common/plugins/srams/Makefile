#=========================================================================
# Makefile for Integrating Memory Compiler with Stratus
#=========================================================================
#
# This Makefile flow invokes the correct memory compiler for a list of
# memory specs stored in $(SPECS_DIR) to generate any views needed.
#
# Date   : February 13, 2017
# Author : Khalid Al-Hawaj

# Turn-off internal rules
.SUFFIXES:

default: all

#-------------------------------------------------------------------------
# Constants
#-------------------------------------------------------------------------

SPECS_DIR?=specs
OUTPUT_DIR?=.
MEM_COMPILER_SP=sram_sp_hsd
MEM_COMPILER_DP=sram_dp_uhde
MEM_COMPILER_2P=sram_2p_uhde
RF_COMPILER_2P=rf_2p_hsc
RF_COMPILER_SP_HSE=rf_sp_hse
RF_COMPILER_SP_HDE=rf_sp_hde

ifeq (error, $(shell [ -d $(SPECS_DIR) ] || echo error))
  $(error Folder $(SPECS_DIR) does not exists)
endif

#-------------------------------------------------------------------------
# Needed memories target
#-------------------------------------------------------------------------
# This automatically constructs a list of targets based on files in spec
# directory.
#

MEMORIES=$(basename $(basename $(notdir $(wildcard $(SPECS_DIR)/*.spec))))
MEMORIES_V=$(addprefix $(OUTPUT_DIR)/, $(addsuffix .v, $(MEMORIES)))
MEMORIES_DB=$(addprefix $(OUTPUT_DIR)/, $(addsuffix .db, $(MEMORIES)))
MEMORIES_LIB=$(addprefix $(OUTPUT_DIR)/, $(addsuffix .lib, $(MEMORIES)))
MEMORIES_LEF=$(addprefix $(OUTPUT_DIR)/, $(addsuffix .lef, $(MEMORIES)))
MEMORIES_GDS=$(addprefix $(OUTPUT_DIR)/, $(addsuffix .gds, $(MEMORIES)))
MEMORIES_CDL=$(addprefix $(OUTPUT_DIR)/, $(addsuffix .cdl, $(MEMORIES)))

#-------------------------------------------------------------------------
# Create output directory if is doesn't exist
#-------------------------------------------------------------------------

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

#-------------------------------------------------------------------------
# Create SRAMs CDL model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.cdl: $(SPECS_DIR)/%.sram_sp_hsd.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_SP) lvs -spec $<
	-mv -f $(basename $(notdir $@))*.cdl $@
	[[ -f $@ ]]

# Two Ports
$(OUTPUT_DIR)/%.cdl: $(SPECS_DIR)/%.2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_2P) lvs -spec $<
	-mv -f $(basename $(notdir $@))*.cdl $@
	[[ -f $@ ]]

# Double Ported
$(OUTPUT_DIR)/%.cdl: $(SPECS_DIR)/%.dp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_DP) lvs -spec $<
	-mv -f $(basename $(notdir $@))*.cdl $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.cdl: $(SPECS_DIR)/%.rf_2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_2P) lvs -spec $<
	-mv -f $(basename $(notdir $@))*.cdl $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.cdl: $(SPECS_DIR)/%.rf_sp_hde.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HDE) lvs -spec $<
	-mv -f $(basename $(notdir $@))*.cdl $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.cdl: $(SPECS_DIR)/%.rf_sp_hse.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HSE) lvs -spec $<
	-mv -f $(basename $(notdir $@))*.cdl $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs GDS model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.gds: $(SPECS_DIR)/%.sram_sp_hsd.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_SP) gds2 -spec $<
	-mv -f $(basename $(notdir $@))*.gds2 $@
	[[ -f $@ ]]

# Two Ports
$(OUTPUT_DIR)/%.gds: $(SPECS_DIR)/%.2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_2P) gds2 -spec $<
	-mv -f $(basename $(notdir $@))*.gds2 $@
	[[ -f $@ ]]

# Double Ported
$(OUTPUT_DIR)/%.gds: $(SPECS_DIR)/%.dp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_DP) gds2 -spec $<
	-mv -f $(basename $(notdir $@))*.gds2 $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.gds: $(SPECS_DIR)/%.rf_2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_2P) gds2 -spec $<
	-mv -f $(basename $(notdir $@))*.gds2 $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.gds: $(SPECS_DIR)/%.rf_sp_hde.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HDE) gds2 -spec $<
	-mv -f $(basename $(notdir $@))*.gds2 $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.gds: $(SPECS_DIR)/%.rf_sp_hse.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HSE) gds2 -spec $<
	-mv -f $(basename $(notdir $@))*.gds2 $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs DB model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.db: $(OUTPUT_DIR)/%.lib
	# Fix library name
	$(eval module_name=$(basename $(notdir $@)))
	sed -i -e 's/\(^library($(module_name)\)[[:graph:]]\+)/\1)/' $<
	lc_shell -x "read_lib $<; \
	             write_lib -output $@ -format db $(module_name); \
	             exit" -no_log
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs Lef model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.lef: $(SPECS_DIR)/%.sram_sp_hsd.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_SP) lef-fp -spec $<
	-mv -f $(basename $(notdir $@))*.lef $@
	[[ -f $@ ]]

# Two Ports
$(OUTPUT_DIR)/%.lef: $(SPECS_DIR)/%.2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_2P) lef-fp -spec $<
	-mv -f $(basename $(notdir $@))*.lef $@
	[[ -f $@ ]]

# Double Ported
$(OUTPUT_DIR)/%.lef: $(SPECS_DIR)/%.dp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_DP) lef-fp -spec $<
	-mv -f $(basename $(notdir $@))*.lef $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.lef: $(SPECS_DIR)/%.rf_2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_2P) lef-fp -spec $<
	-mv -f $(basename $(notdir $@))*.lef $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.lef: $(SPECS_DIR)/%.rf_sp_hde.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HDE) lef-fp -spec $<
	-mv -f $(basename $(notdir $@))*.lef $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.lef: $(SPECS_DIR)/%.rf_sp_hse.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HSE) lef-fp -spec $<
	-mv -f $(basename $(notdir $@))*.lef $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs LIB model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.sram_sp_hsd.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_SP) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

# Two Ports
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_2P) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

# Double Ported
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.dp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_DP) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.rf_2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_2P) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.rf_sp_hde.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HDE) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.rf_sp_hse.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HSE) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs Verilog model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.sram_sp_hsd.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_SP) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

# Two Ports
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_2P) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

# Double Ported
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.dp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(MEM_COMPILER_DP) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.rf_2p.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_2P) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.rf_sp_hde.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HDE) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

# RF Two Ports
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.rf_sp_hse.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP_HSE) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Generic main targets
#-------------------------------------------------------------------------

verilog: $(MEMORIES_V)
db: $(MEMORIES_DB)
lib: $(MEMORIES_LIB)
lef: $(MEMORIES_LEF)
gds: $(MEMORIES_GDS)
cdl: $(MEMORIES_CDL)

#-------------------------------------------------------------------------
# Preserve intermediate files
#-------------------------------------------------------------------------

.PRECIOUS: $(MEMORIES_V) $(MEMORIES_LEF) $(MEMORIES_LIB) $(MEMORIES_DB) $(MEMORIES_GDS) $(MEMORIES_CDL)

#-------------------------------------------------------------------------
# Default make target
#-------------------------------------------------------------------------

.PHONY: all verilog db $(MEMORIES)

all: $(MEMORIES_V)

#-------------------------------------------------------------------------
# Clean up
#-------------------------------------------------------------------------

junk += $(OUTPUT_DIR)/*.v *.log

clean:
	rm -rf $(junk) *~ \#*
