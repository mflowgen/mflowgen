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

flow_path=..

#-------------------------------------------------------------------------
# List of custom flows
#-------------------------------------------------------------------------
# Adding to this list will create a new "--with" option at configure time
#
# For example, to add a new custom flow called "foo", call this macro:
#
#   CTX_INCLUDE([foo])
#

CTX_INCLUDE([example])

#-------------------------------------------------------------------------
# Output
#-------------------------------------------------------------------------

AC_CONFIG_FILES([Makefile])
AC_OUTPUT

