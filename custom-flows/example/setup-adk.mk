#=========================================================================
# setup-adk.mk
#=========================================================================
# The ASIC design kit (ADK) is the set of all physical backend files
# required to build a chip, as well as a unified and standard interface to
# those files.
#
# The key motivation behind the ADK is that building a chip requires
# gathering many packages and libraries from different vendors, and it is
# difficult to make them all work together. Therefore, an ASIC design kit
# is the set of packages and libraries that we have successfully gotten to
# work together and that we now wish to reuse across different designs.
# The ADK may include process technology files, physical IP libraries
# (e.g., iocells, stdcells, memory compilers), as well as physical
# verification decks (e.g., calibre drc/lvs).
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# ASIC Design Kit -- Setup
#-------------------------------------------------------------------------
# Variables:
#
# - adk      : ASIC design kit name (e.g., "tsmc-28nm-cln28hpc")
# - adk_view : ASIC design kit view (e.g., "stdview")
#
# Available ADKs:
#
# - tsmc-180nm-cl018g
# - tsmc-28nm-cln28hpc
# - freepdk-45nm
#
# ADKs that need to be updated before they will work:
#
# - ibm-130nm-bicmos8hp
# - saed-90nm
# - tsmc-65nm-cln65lp
# - tsmc-40nm-cln40lp
# - tsmc-16nm-cln16fcll001
#

adk      = freepdk-45nm
adk_view = stdview

export adk_dir = $(ADK_PKGS)/$(adk)/$(adk_view)


