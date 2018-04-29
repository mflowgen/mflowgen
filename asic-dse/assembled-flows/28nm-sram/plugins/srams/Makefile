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
MEM_COMPILER_SP=sram_sp_hde
MEM_COMPILER_DP=sram_dp_uhde
MEM_COMPILER_2P=sram_2p_uhde
RF_COMPILER_2P=rf_2p_hsc
RF_COMPILER_SP=rf_sp_hde

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

#-------------------------------------------------------------------------
# Create output directory if is doesn't exist
#-------------------------------------------------------------------------

$(OUTPUT_DIR):
	mkdir -p $(OUTPUT_DIR)

#-------------------------------------------------------------------------
# Create SRAMs LIB model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.db: $(OUTPUT_DIR)/%.lib
	# Fix library name
	$(eval module_name=$(basename $(notdir $@)))
	sed -ie 's/\(^library($(module_name)\)[[:graph:]]\+)/\1)/' $<
	lc_shell -x "read_lib $<; \
	             write_lib -output $@ -format db $(module_name); \
	             exit"
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs LIB model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.sp.spec | $(OUTPUT_DIR)
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
$(OUTPUT_DIR)/%.lib: $(SPECS_DIR)/%.rf_sp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP) liberty -spec $<
	-mv -f $(basename $(notdir $@))*.lib $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Create SRAMs Verilog model
#-------------------------------------------------------------------------

# Single Ported
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.sp.spec | $(OUTPUT_DIR)
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
$(OUTPUT_DIR)/%.v: $(SPECS_DIR)/%.rf_sp.spec | $(OUTPUT_DIR)
	rm -f $@
	$(RF_COMPILER_SP) verilog -spec $<
	-mv -f $(basename $(notdir $@))*.v $@
	[[ -f $@ ]]

#-------------------------------------------------------------------------
# Generic main targets
#-------------------------------------------------------------------------

verilog: $(MEMORIES_V)
db: $(MEMORIES_DB)
lib: $(MEMORIES_LIB)

#-------------------------------------------------------------------------
# Default make target
#-------------------------------------------------------------------------

.PRECIOUS: $(MEMORIES_V) $(MEMORIES_LIB) $(MEMORIES_DB)

#-------------------------------------------------------------------------
# Default make target
#-------------------------------------------------------------------------

.PHONY: all verilog dbs $(MEMORIES)

all: $(MEMORIES_V)

#-------------------------------------------------------------------------
# Clean up
#-------------------------------------------------------------------------

junk += $(OUTPUT_DIR)/*.v *.log

clean:
	rm -rf $(junk) *~ \#*
