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
# Design
#-------------------------------------------------------------------------
# In the default flow, the design should be selected at configure time:
#
#     "../configure --design=foo", which will
#
# This variable will be used to select the right set of design-specific
# parameters in setup-design.mk.

AC_ARG_VAR(design, [Selected design for default flow])

# Set a default design if there is none defined

AS_IF([test "x$design" = x],
  design=pymtl-gcd
)

#-------------------------------------------------------------------------
# Copy in Makefile Fragments
#-------------------------------------------------------------------------
# From the selected flow path, copy in the following Makefile fragments:
#
# - setup-adk.mk
# - setup-design.mk
# - setup-flow.mk

cp $flow_path/setup-adk.mk .
cp $flow_path/setup-design.mk .
cp $flow_path/setup-flow.mk .

#-------------------------------------------------------------------------
# Output
#-------------------------------------------------------------------------

AC_CONFIG_FILES([Makefile])
AC_OUTPUT

