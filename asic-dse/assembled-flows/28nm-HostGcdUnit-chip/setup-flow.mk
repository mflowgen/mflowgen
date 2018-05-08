#=========================================================================
# setup-flow.mk
#=========================================================================

# List the steps to use

steps = \
  info \
  sim-prep \
  vcs-common-build \
  vcs-rtl-build \
  vcs-rtl \
  vcs-aprff-build \
  vcs-aprff \
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

dependencies.dc-synthesis        = seed
dependencies.innovus-flowsetup   = dc-synthesis
dependencies.innovus-init        = innovus-flowsetup
dependencies.innovus-place       = innovus-flowsetup innovus-init
dependencies.innovus-cts         = innovus-flowsetup innovus-place
dependencies.innovus-postctshold = innovus-flowsetup innovus-cts
dependencies.innovus-route       = innovus-flowsetup innovus-postctshold
dependencies.innovus-postroute   = innovus-flowsetup innovus-route
dependencies.innovus-signoff     = innovus-flowsetup innovus-postroute
dependencies.all                 = innovus-signoff

# Simulation targets are purposely kept independent so that we don't
# accidentally re-trigger dc/innovus rebuilds when running simulation

dependencies.sim-prep            = seed

dependencies.vcs-rtl-build       = sim-prep
dependencies.vcs-rtl             = vcs-rtl-build

dependencies.vcs-aprff-build     = sim-prep
dependencies.vcs-aprff           = vcs-aprff-build


