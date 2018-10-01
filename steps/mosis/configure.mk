#=========================================================================
# configure.mk
#=========================================================================
# This file will be included inside the Makefile in the build directory
#
# Author : Christopher Torng
# Date   : May 15, 2018

#-------------------------------------------------------------------------
# Step Description
#-------------------------------------------------------------------------

descriptions.mosis = \
	"Checksum and compress the final gds"

#-------------------------------------------------------------------------
# ASCII art
#-------------------------------------------------------------------------

define ascii.mosis
	@echo -e $(echo_green)
	@echo '#-------------------------------------------------------------------------------'
	@echo '# Mosis prep'
	@echo '#-------------------------------------------------------------------------------'
	@echo -e $(echo_nocolor)
endef

#-------------------------------------------------------------------------
# Alias -- short name for this step
#-------------------------------------------------------------------------

#abbr.mosis = template

#-------------------------------------------------------------------------
# Misc
#-------------------------------------------------------------------------

# Input GDS

mosis_input_gds     = $(handoff_dir.calibre-stamp)/stamped.gds

# Output checksum and compressed GDS

mosis_cksum         = $(handoff_dir.mosis)/stamped.cksum
mosis_output_gds    = $(handoff_dir.mosis)/stamped.gds
mosis_output_gds_gz = $(handoff_dir.mosis)/stamped.gds.gz

$(mosis_output_gds_gz): $(dependencies.mosis)
	@mkdir -p $(handoff_dir.mosis)
	@cp -f $(mosis_input_gds) $(mosis_output_gds)
	@echo "Running checksum..."
	@echo
	@cksum $(mosis_output_gds) | tee $(mosis_cksum)
	@echo
	@echo "Compressing GDS..."
	@echo
	@gzip -vf $(mosis_output_gds)

skipvpath.mosis = yes

#-------------------------------------------------------------------------
# Extra dependencies
#-------------------------------------------------------------------------

extra_dependencies.mosis = $(mosis_output_gds_gz)

#-------------------------------------------------------------------------
# Primary command target
#-------------------------------------------------------------------------
# These are the commands run when executing this step. These commands are
# included into the build Makefile.

define commands.mosis
	@echo    "- Source GDS      : " $(PWD)/$(mosis_input_gds)
	@echo    "- Checksum file   : " $(PWD)/$(mosis_cksum)
	@echo -n "- Checksum        : "
	@awk '{print $$1}' $(mosis_cksum)

	@echo -n "- Checksum bytes  : "
	@awk '{print $$2}' $(mosis_cksum)

	@echo    "- Submit to MOSIS : " $(PWD)/$(mosis_output_gds_gz)
	@echo
endef

#-------------------------------------------------------------------------
# Extra targets
#-------------------------------------------------------------------------
# These are extra useful targets when working with this step. These
# targets are included into the build Makefile.

# Clean

clean-mosis:
	rm -rf ./$(VPATH)/mosis
	rm -rf ./$(collect_dir.mosis)
	rm -rf ./$(handoff_dir.mosis)

#clean-ex: clean-mosis

