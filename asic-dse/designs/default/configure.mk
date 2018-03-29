#=========================================================================
# configure
#=========================================================================
# This design flow has the set of default ASIC steps for any design we
# want to do architectural design-space exploration on. This configuration
# should always work as long as the ASIC design kit (ADK) is set up.

# ASIC design kit setup
#
# - adk      : ASIC design kit name (e.g., "tsmc-28nm-cln28hpc")
# - adk_view : ASIC design kit view (e.g., "stdview")
# - adk_node : ASIC design kit node (e.g., "28nm")

export adk     = tsmc-28nm-cln28hpc
export view    = stdview
export adk_dir = /work/global/brg/install/adk-pkgs/$(adk)/$(view)

export process = 28nm         # This can move into stdcells.tcl or adk.tcl

export design_flow_name = default

#=========================================================================
# Design
#=========================================================================

setup_design = pymtl-gcd

#-------------------------------------------------------------------------
# PyMTL GCD
#-------------------------------------------------------------------------

ifeq ($(setup_design),pymtl-gcd)
  export design_name  = GcdUnit
  export clock_period = 2.0
  export vsrc         = rtl-handoff/GcdUnit.v
endif


