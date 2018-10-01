#=========================================================================
# setup-flow.mk
#=========================================================================

# List the steps to use

steps = \
  info \
  gen-sram-verilog \
  gen-sram-lef \
  gen-sram-lib \
  gen-sram-gds \
  gen-sram-cdl \
  gen-sram-db \
  dc-synthesis \
  summarize-area-brgtc2 \
  innovus-flowsetup \
  innovus-init \
  innovus-place \
  innovus-cts \
  innovus-postctshold \
  innovus-route \
  innovus-postroute \
  innovus-signoff \
  pt-signoff \
  calibre-seal \
  calibre-drc-sealed \
  calibre-fill \
  calibre-stamp \
  calibre-drc-top \
  calibre-lvs \
  calibre-lvs-sealed \
  calibre-lvs-top \
  sim-prep \
  vcs-common-build \
  vcs-rtl-build \
  vcs-rtl \
  vcs-aprff-build \
  vcs-aprff \
  vcs-aprffx-build \
  vcs-aprffx \
  vcs-aprsdf-build \
  vcs-aprsdf \
  vcs-aprsdfx-build \
  vcs-aprsdfx \
  mosis \

# Step dependency graph

dependencies.info                = seed

dependencies.gen-sram-verilog    = seed
dependencies.gen-sram-db         = seed
dependencies.gen-sram-lef        = seed
dependencies.gen-sram-lib        = seed
dependencies.gen-sram-gds        = seed
dependencies.gen-sram-cdl        = seed

dependencies.dc-synthesis        = seed gen-sram-db
dependencies.innovus-flowsetup   = dc-synthesis gen-sram-lef gen-sram-lib gen-sram-db
dependencies.innovus-init        = innovus-flowsetup
dependencies.innovus-place       = innovus-flowsetup innovus-init
dependencies.innovus-cts         = innovus-flowsetup innovus-place
dependencies.innovus-postctshold = innovus-flowsetup innovus-cts
dependencies.innovus-route       = innovus-flowsetup innovus-postctshold
dependencies.innovus-postroute   = innovus-flowsetup innovus-route
dependencies.innovus-signoff     = innovus-flowsetup innovus-postroute
dependencies.all                 = innovus-signoff

# Signoff tools

dependencies.pt-signoff          = innovus-signoff gen-sram-db

# Simulation targets are purposely kept independent so that we don't
# accidentally re-trigger dc/innovus rebuilds when running simulation

dependencies.sim-prep            = seed

dependencies.vcs-rtl-build       = sim-prep
dependencies.vcs-rtl             = vcs-rtl-build

dependencies.vcs-aprff-build     = sim-prep
dependencies.vcs-aprff           = vcs-aprff-build

dependencies.vcs-aprffx-build    = sim-prep
dependencies.vcs-aprffx          = vcs-aprffx-build

dependencies.vcs-aprsdf-build    = sim-prep
dependencies.vcs-aprsdf          = vcs-aprsdf-build

dependencies.vcs-aprsdfx-build   = sim-prep
dependencies.vcs-aprsdfx         = vcs-aprsdfx-build

# Calibre steps

dependencies.calibre-seal        = innovus-signoff gen-sram-gds
dependencies.calibre-fill        = calibre-seal
dependencies.calibre-stamp       = calibre-fill

dependencies.calibre-drc-sealed  = calibre-seal
dependencies.calibre-drc-top     = calibre-stamp

dependencies.calibre-lvs         = innovus-signoff calibre-seal gen-sram-cdl
dependencies.calibre-lvs-sealed  = innovus-signoff calibre-seal gen-sram-cdl
dependencies.calibre-lvs-top     = innovus-signoff calibre-stamp gen-sram-cdl

# MOSIS handoff

dependencies.mosis               = calibre-stamp

