#=========================================================================
# ctx.m4 -- The Modular VLSI Build System
#=========================================================================
# Helper macros for the Modular VLSI Build System
#
# Author : Christopher Torng
# Date   : March 26, 2018

#-------------------------------------------------------------------------
# CTX_INCLUDE
#-------------------------------------------------------------------------
# This function creates a --with command line option for the given custom
# flow name. The macro also emits code to replace the @flow_path@
# variables in the Makefile.in with the selected custom flow path if the
# user configures with this option.

AC_DEFUN([CTX_INCLUDE],
[
  AC_ARG_WITH([$1], AS_HELP_STRING([--with-$1], [Custom flow $1]))

  # Define m4 variables for the custom flow name with and without
  # underscores

  m4_define([CTX_CUSTOM_FLOW],  $1)
  m4_define([CTX_CUSTOM_FLOWU], m4_bpatsubst($1,[-],[_]))

  # Check if the option was selected using the underscore version of the
  # string. For example, "--with-foo-bar" results in the variable
  # ${with_foo_bar} set to "yes".
  #
  # If selected, emit code for the selected flow path.

  AS_IF([test "${with_[]CTX_CUSTOM_FLOWU}" = "yes"],
  [
    flow_path=../custom-flows/[]CTX_CUSTOM_FLOW[]
    AC_SUBST([flow_path])
  ])

])

