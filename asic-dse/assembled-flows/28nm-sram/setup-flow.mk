#=========================================================================
# setup-flow.mk
#=========================================================================
# This design flow has the set of default ASIC steps for any design we
# want to do architectural design-space exploration on. This configuration
# should always work as long as the ASIC design kit (ADK) is set up.

# List the steps to use in the default design flow

steps = \
  gen-sram-verilog \
  gen-sram-db \
  prep-rtl-hard \
  sim-rtl-hard \
  dc-synthesis \
  innovus-flowsetup \
  innovus-init \
  innovus-place \
  innovus-cts \
  innovus-postctshold \
  innovus-route \
  innovus-postroute \
  innovus-signoff

# Step dependency graph

dependencies.gen-sram-verilog    = seed
dependencies.gen-sram-db         = seed
dependencies.prep-rtl-hard       = gen-sram-verilog
dependencies.sim-rtl-hard        = prep-rtl-hard

dependencies.dc-synthesis        = gen-sram-db
dependencies.innovus-flowsetup   = dc-synthesis
dependencies.innovus-init        = innovus-flowsetup
dependencies.innovus-place       = innovus-flowsetup innovus-init
dependencies.innovus-cts         = innovus-flowsetup innovus-place
dependencies.innovus-postctshold = innovus-flowsetup innovus-cts
dependencies.innovus-route       = innovus-flowsetup innovus-postctshold
dependencies.innovus-postroute   = innovus-flowsetup innovus-route
dependencies.innovus-signoff     = innovus-flowsetup innovus-postroute
dependencies.all                 = innovus-signoff

#-------------------------------------------------------------------------
# Notes on step dependency graph
#-------------------------------------------------------------------------
# The build system uses the step dependency graph to order the steps. The
# listed dependencies are actually the Makefile prerequisites for each
# step. In addition, the build system takes care of collecting handoff
# files from all dependency steps before executing each step.
#
# Two requirements:
#
# - The first step should depend on "seed", which generates the build env
# - The special "all" target should depend on the last step
#
# Any of the steps in the top-level steps directory can be used as part of
# a custom VLSI flow.
#

