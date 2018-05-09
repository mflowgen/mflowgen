#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.calibre-seal = \
	"Seal the chip with the sealring"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.calibre-seal
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Calibre -- Merge design with sealring'
	@echo '#-------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

abbr.calibre-seal = seal

#-------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------

# GDS for the design without the seal ring

unsealed_gds = $(handoff_dir.calibre-seal)/unsealed.gds

# GDS for the design with the seal ring

sealed_gds   = $(handoff_dir.calibre-seal)/sealed.gds

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.calibre-seal
	mkdir -p $(handoff_dir.calibre-seal)

# Merge the design gds with IP gds files to create the unsealed gds

	calibredrv -a layout filemerge \
		-indir $(collect_dir.calibre-seal) \
		-in $(adk_dir)/stdcells.gds \
		-in $(adk_dir)/iocells.gds \
		-in $(adk_dir)/iocells-bondpads.gds \
		-topcell $(design_name) \
		-out $(unsealed_gds)

# Seal the design by merging with the sealring gds

	calibredrv -a layout filemerge \
		-in $(unsealed_gds) \
		-in $(adk_dir)/brgtc2-sealring.gds \
		-createtop top_sealed \
		-out $(sealed_gds)

endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-calibre-seal:
	rm -rf ./$(VPATH)/calibre-seal
	rm -rf ./$(collect_dir.calibre-seal)
	rm -rf ./$(handoff_dir.calibre-seal)

clean-seal: clean-calibre-seal

