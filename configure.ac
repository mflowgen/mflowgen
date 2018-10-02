#=========================================================================
# configure.ac -- The Modular VLSI Build System
#=========================================================================
# This configure script is used in the Modular VLSI Build System to select
# between the default ASIC flow and the various custom ASIC flows.
#
# Configuring without any options selects the default flow, while
# configuring using a "--with" option selects for that custom flow.
#
# Append to the list of custom flows below to enable more "--with" flags.
#
# Author : Christopher Torng
# Date   : March 26, 2018

m4_include([ctx.m4])

#-------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------
# The default flow is used if no --with options are given at config time

AC_INIT

flow_path=../default-flow/

#-------------------------------------------------------------------------
# List of custom flows
#-------------------------------------------------------------------------
# Adding to this list will create a new "--with" option at configure time

CTX_INCLUDE([180nm-pcosync-chip])
CTX_INCLUDE([28nm-brgtc2-tapein-ka429])
CTX_INCLUDE([28nm-brgtc2-tapein1])
CTX_INCLUDE([28nm-brgtc2-tapein2])
CTX_INCLUDE([28nm-brgtc2-tapein3])
CTX_INCLUDE([28nm-brgtc2-tapein4])
CTX_INCLUDE([28nm-gcd-chip])
CTX_INCLUDE([28nm-HostGcdUnit-chip])
CTX_INCLUDE([28nm-pll-ro])
CTX_INCLUDE([28nm-pll])
CTX_INCLUDE([28nm-rgals])
CTX_INCLUDE([28nm-sram])

#-------------------------------------------------------------------------
# Output
#-------------------------------------------------------------------------

AC_CONFIG_FILES([Makefile])
AC_OUTPUT

