#=========================================================================
# setup-design.mk
#=========================================================================
# Here we select the design to push as well as its top-level Verilog
# module name, the clock target, and the Verilog source file.
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# PyMTL GcdUnit
#-------------------------------------------------------------------------

ifeq ($(design),pymtl-gcd)
  design_name  = GcdUnit
  clock_period = 2.0
  design_v     = ../designs/GcdUnit-demo.v
endif

#-------------------------------------------------------------------------
# PyMTL MulDivUnit
#-------------------------------------------------------------------------

ifeq ($(design),pymtl-imul-pipelined-2stage)
  design_name  = IntMulPipelined_2Stage
  clock_period = 1.0
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/IntMulPipelined_2Stage.v
endif

ifeq ($(design),pymtl-imul-pipelined-4stage)
  design_name  = IntMulPipelined_4Stage
  clock_period = 1.0
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/IntMulPipelined_4Stage.v
endif

ifeq ($(design),pymtl-imul-pipelined-8stage)
  design_name  = IntMulPipelined_8Stage
  clock_period = 1.0
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/IntMulPipelined_8Stage.v
endif

ifeq ($(design),pymtl-imul-pipelined-16stage)
  design_name  = IntMulPipelined_16Stage
  clock_period = 1.0
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/IntMulPipelined_16Stage.v
endif

ifeq ($(design),pymtl-mdu)
  design_name  = IntMulDivUnit
  clock_period = 1.0
  design_v     = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/IntMulDivUnit.v
endif

#-------------------------------------------------------------------------
# PyMTL InstBuffer
#-------------------------------------------------------------------------

ifeq ($(design),pymtl-dm-ibuffer-2-16B)
  design_name  = DirectMappedInstBuffer_2_16B
  clock_period = 0.5
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/DirectMappedInstBuffer_2_16B.v
endif

ifeq ($(design),pymtl-dm-ibuffer-2-32B)
  design_name  = DirectMappedInstBuffer_2_32B
  clock_period = 0.5
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/DirectMappedInstBuffer_2_32B.v
endif

ifeq ($(design),pymtl-dm-ibuffer-4-16B)
  design_name  = DirectMappedInstBuffer_4_16B
  clock_period = 0.5
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/DirectMappedInstBuffer_4_16B.v
endif

ifeq ($(design),pymtl-dm-ibuffer-4-32B)
  design_name  = DirectMappedInstBuffer_4_32B
  clock_period = 0.5
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/DirectMappedInstBuffer_4_32B.v
endif

ifeq ($(design),pymtl-fa-ibuffer-2-16B)
  design_name  = FullyAssocInstBuffer_2_16B
  clock_period = 0.5
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/FullyAssocInstBuffer_2_16B.v
endif

ifeq ($(design),pymtl-fa-ibuffer-2-32B)
  design_name  = FullyAssocInstBuffer_2_32B
  clock_period = 0.5
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/FullyAssocInstBuffer_2_32B.v
endif

ifeq ($(design),pymtl-procl0mdu)
  design_name  = ProcL0Mdu
  clock_period = 0.8
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/ProcL0Mdu.v
endif

#-------------------------------------------------------------------------
# DesignWare FPU
#-------------------------------------------------------------------------

ifeq ($(design),pymtl-dw-fpu)
  design_name  = DesignWareFloatingPointUnit
  clock_period = 1.0
  design_v     = ../../alloy-sim/brgtc2/pymtl/build/DesignWareFloatingPointUnit.v
endif

#-------------------------------------------------------------------------
# Synthesizable PLL
#-------------------------------------------------------------------------

ifeq ($(design),verilog-synthesizable-pll)
  design_name  = pll
  clock_period = 2.0
  design_v     = ../../alloy-sim/brgtc2/asic-dse/rtl-handoff/pll.v
endif

#-------------------------------------------------------------------------
# Export
#-------------------------------------------------------------------------

export design_name


