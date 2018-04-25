#=========================================================================
# Local Autoconf Macros
#=========================================================================
# This file contains the macros for the Modular C++ Build System and
# additional autoconf macros which developers can use in their
# configure.ac scripts. Please read the documentation in
# mcppbs-uguide.txt for more details on how the Modular C++ Build
# System works. The documenation for each macro should include
# information about the author, date, and copyright.

#-------------------------------------------------------------------------
# MCPPBS_INIT
#-------------------------------------------------------------------------
# Setup any global configure command line arguments and the primary
# running shell variables which will be substituted into the makefile.

AC_DEFUN([MCPPBS_INIT],
[
  # Add command line argument to enable all optional subprojects

  AC_ARG_WITH(optional-subprojects,
    AS_HELP_STRING([--with-optional-subprojects],
      [Include all optional subprojects]))

  # Running variables to substitute into make

  AC_SUBST([mcppbs_include_internal])
  AC_SUBST([mcppbs_include_internal_en])
  AC_SUBST([mcppbs_include_external])
  AC_SUBST([mcppbs_include_external_en])
  AC_SUBST([mcppbs_install])
])

#-------------------------------------------------------------------------
# MCPPBS_ALWAYS_USE_CXX
#-------------------------------------------------------------------------
# If the user calls this macro then change the C compiler shell
# variables so that they use the C++ compiler.

AC_DEFUN([MCPPBS_ALWAYS_USE_CXX],
[
  AC_MSG_NOTICE([Will use ${CXX} for C and assembly source files])
  CC=${CXX}
  CFLAGS=${CXXFLAGS}
])

#-------------------------------------------------------------------------
# MCPPBS_PROG_INSTALL
#-------------------------------------------------------------------------
# This macro will add an --enable-stow command line option to the
# configure script. When enabled, this macro will first check to see if
# the stow program is available and if so it will set the $stow shell
# variable to the binary name and the $enable_stow shell variable to
# "yes". These variables can be used in a makefile to conditionally use
# stow for installation.
#
# This macro uses two environment variables to help setup default stow
# locations. The $STOW_PREFIX is used for stowing native built packages.
# The packages are staged in $STOW_PREFIX/pkgs and then symlinks are
# created from within $STOW_PREFIX into the pkgs subdirectory. If you
# only do native builds then this is all you need to set. If you don't
# set $STOW_PREFIX then the default is just the normal default prefix
# which is almost always /usr/local.
#
# For non-native builds we probably want to install the packages in a
# different location which includes the host architecture name as part
# of the prefix. For these kind of builds, we can specify the $STOW_ROOT
# environment variable and the effective prefix will be
# $STOW_ROOT/${host_alias} where ${host_alias} is specified on the
# configure command line with "--host".
#
# Here is an example setup:
#
#  STOW_ROOT="$HOME/install"
#  STOW_ARCH="i386-macosx10.4"
#  STOW_PREFIX="${STOW_ROOT}/${STOW_ARCH}"
#

AC_DEFUN([MCPPBS_PROG_INSTALL],
[

  # Configure command line option

  AC_ARG_ENABLE(stow,
    AS_HELP_STRING(--enable-stow,[Enable stow-based install]),
      [enable_stow="yes"],[enable_stow="no"])

  AC_SUBST([enable_stow])

  # Environment variables

  AC_ARG_VAR([STOW_ROOT],   [Root for non-native stow-based installs])
  AC_ARG_VAR([STOW_PREFIX], [Prefix for stow-based installs])

  # Check for install script

  AC_PROG_INSTALL

  # Deterimine if native build and set prefix appropriately

  AS_IF([ test "${enable_stow}" = "yes" ],
  [
    AC_CHECK_PROGS([stow],[stow],[no])
    AS_IF([ test "${stow}" = "no" ],
    [
      AC_MSG_ERROR([Cannot use --enable-stow since stow is not available])
    ])

    # Check if native or non-native build

    AS_IF([ test "${build}" = "${host}" ],
    [

      # build == host so this is a native build. Make sure --prefix not
      # set and $STOW_PREFIX is set, then set prefix=$STOW_PREFIX.

      AS_IF([ test "${prefix}" = "NONE" && test -n "${STOW_PREFIX}" ],
      [
        prefix="${STOW_PREFIX}"
        AC_MSG_NOTICE([Using \$STOW_PREFIX from environment])
        AC_MSG_NOTICE([prefix=${prefix}])
      ])

    ],[

      # build != host so this is a non-native build. Make sure --prefix
      # not set and $STOW_ROOT is set, then set
      # prefix=$STOW_ROOT/${host_alias}.

      AS_IF([ test "${prefix}" = "NONE" && test -n "${STOW_ROOT}" ],
      [
        prefix="${STOW_ROOT}/${host_alias}"
        AC_MSG_NOTICE([Using \$STOW_ROOT from environment])
        AC_MSG_NOTICE([prefix=${prefix}])
      ])

    ])

  ])

])

#-------------------------------------------------------------------------
# MCPPBS_PROG_RUN
#-------------------------------------------------------------------------
# If we are doing a non-native build then we look for an isa simulator
# to use for running tests. We set the RUN substitution variable to be
# empty for native builds or to the name of the isa simulator for
# non-native builds. Thus a makefile can run compiled programs
# regardless if we are doing a native or non-native build like this:
#
#  $(RUN) $(RUNFLAGS) ./test-program
#

AC_DEFUN([MCPPBS_PROG_RUN],
[
  # Moyang: disable isa-sim check for riscv32-unknown-elf target.
  AS_IF([ test "${build}" != "${host}" && test "${host}" != "riscv32-unknown-elf" ],
  [
    AC_CHECK_TOOLS([RUN],[isa-run run],[no])
    AS_IF([ test ${RUN} = "no" ],
    [
      AC_MSG_ERROR([Cannot find simulator for target ${target_alias}])
    ])
  ],[
    RUN=""
  ])
  AC_SUBST([RUN])
  AC_SUBST([RUNFLAGS])
])

#-------------------------------------------------------------------------
# MCPPBS_INCLUDE_INTERNAL([subproject])
#-------------------------------------------------------------------------
# Use this macro to include an internal subproject meaning that the
# subproject's source code is included in a subdirectory of the
# top-level source directory. One should order the includes such that
# any given subproject only depends on subprojects listed before it. The
# subproject name can also include an * suffix which indicates that this
# is an optional subproject. Optional subprojects are only included as
# part of the project build if enabled on the configure command line
# with a --with-<subproject> flag. The user can also specify that all
# optional subprojects should be included in the build with the
# --with-optional-subprojects flag.
#
# Both required and optional subprojects should have a subproject.ac
# file. The script's filename should be the abbreivated subproject name.
# This macro includes the subproject.ac files for enabled subprojects.
# The very first macro in subproject.ac should be a call to
# MCPPBS_SUBPROJECT with the subproject's name and dependencies.
#
# Internal subprojects must also have a subproject.mk.in file which
# includes make variables for the compiler and linker flags specificly
# needed to build the subproject and also lists all of the source files
# for the subproject. The user should use the following configure
# substitution variables in their make fragment (assuming the
# subproject's name is foo).
#
#  - @foo_intdeps@  : List of internal subproject dependencies
#  - @foo_cppflags@ : List of include paths (-I)
#  - @foo_ldflags@  : List of library paths (-L)
#  - @foo_libs@     : List of libraries (-l)
#
# Note that we use a m4_define instead of AC_DEFUN for now because
# otherwise autoconf will call macros specified with AC_REQUIRE at the
# very outer AC_DEFUN which can be pretty confusing.

m4_define([MCPPBS_INCLUDE_INTERNAL],
[
  # Determine if this is a required or an optional subproject and create
  # a m4 variable for his subproject name with and without dashes.

  m4_define([MCPPBS_IS_OPTIONAL],
    m4_bmatch(m4_normalize($1),[\*],[true],[false]))

  m4_define([MCPPBS_SPROJ],  m4_bpatsubst(m4_normalize($1),[*],[]))
  m4_define([MCPPBS_SPROJU], m4_bpatsubst(MCPPBS_SPROJ,[-],[_]))

  # Set the type of this subproject and add it to a shell and m4 list

  MCPPBS_SPROJU[]_type="internal"
  AS_VAR_APPEND([mcppbs_include_internal],"MCPPBS_SPROJ ")
  m4_set_add([MCPPBS_SPROJS],MCPPBS_SPROJ)

  # Optional subprojects add an --with-subproject command line options,
  # while default subprojects just make sure the shell enabled variable
  # is set to "yes" so we always configure this subproject.

  m4_if(MCPPBS_IS_OPTIONAL,[true],
  [
    AC_ARG_WITH(MCPPBS_SPROJ,
      AS_HELP_STRING(--with-MCPPBS_SPROJ,
        [Internal subproject MCPPBS_SPROJ]),
      [with_[]MCPPBS_SPROJU="yes"],[with_[]MCPPBS_SPROJU="no"])
  ],[
    with_[]MCPPBS_SPROJU="yes"
  ])

  # We create a shell function which contains all the code to actually
  # configure this project including adding it to the
  # $mcppbs_include_internal_en running shell variable, setting an
  # HAVE_SUBPROJECT C define, and actually processing the appropriate
  # subproject.ac. This will allow us to easily configure optional
  # subproject later by just executing this function.

  MCPPBS_SPROJU[]_cfg ()
  {
    AC_CONFIG_HEADERS(MCPPBS_SPROJ[]-config.h:config.h.in)
    AC_CONFIG_FILES(MCPPBS_SPROJ[].mk:MCPPBS_SPROJ[]/MCPPBS_SPROJ[].mk.in)
    AC_DEFINE(m4_toupper(HAVE_[]MCPPBS_SPROJU),,
      [Define if we should include subproject] MCPPBS_SPROJ )
    AS_VAR_APPEND([mcppbs_include_internal_en],"MCPPBS_SPROJ ")
    with_[]MCPPBS_SPROJU="yes"
    m4_include(MCPPBS_SPROJ[]/MCPPBS_SPROJ[].ac)
  };

  # See if we should actually configure this subproject and if so then
  # call the shell function we just created.

  AS_IF([    test "${with_optional_subprojects}" = "yes" \
          || test "${with_[]MCPPBS_SPROJU}" = "yes"  ],
  [
    eval "MCPPBS_SPROJU[]_cfg"
  ])

])

#-------------------------------------------------------------------------
# MCPPBS_INCLUDE_EXTERNAL([subproject])
#-------------------------------------------------------------------------
# Use this macro to include an external subproject meaning that the
# subproject is installed as a library with an appropriate pkg-config
# meta-data file named subproject.pc. The subproject.pc file should
# contain the compiler and linker flags necessary for linking to the
# subproject. One should order the includes such that any given
# subproject only depends on subprojects listed before it. The
# subproject name can also include an * suffix which indicates that this
# is an optional subproject. Optional subprojects are only included as
# part of the project build if enabled on the configure command line
# with a --with-<subproject> flag. The user can also specify that all
# optional subprojects should be included in the build with the
# --with-optional-subprojects flag.

AC_DEFUN([MCPPBS_INCLUDE_EXTERNAL],
[
  # Determine if this is a required or an optional subproject and create
  # a m4 variable for his subproject name with and without dashes.

  m4_define([MCPPBS_IS_OPTIONAL],
    m4_bmatch(m4_normalize($1),[\*],[true],[false]))

  m4_define([MCPPBS_SPROJ],  m4_bpatsubst(m4_normalize($1),[*],[]))
  m4_define([MCPPBS_SPROJU], m4_bpatsubst(MCPPBS_SPROJ,[-],[_]))

  # Set the type of this subproject and add it to a shell and m4 list

  MCPPBS_SPROJU[]_type="external"
  AS_VAR_APPEND([mcppbs_include_external],"MCPPBS_SPROJ ")
  m4_set_add([MCPPBS_SPROJS],MCPPBS_SPROJ)

  # Optional subprojects add an --with-subproject command line options,
  # while default subprojects just make sure the shell enabled variable
  # is set to "yes" so we always configure this subproject.

  m4_if(MCPPBS_IS_OPTIONAL,[true],
  [
    AC_ARG_WITH(MCPPBS_SPROJ,
      AS_HELP_STRING(--with-MCPPBS_SPROJ,
        [External subproject MCPPBS_SPROJ]),
      [with_[]MCPPBS_SPROJU="yes"],[with_[]MCPPBS_SPROJU="no"])
  ],[
    with_[]MCPPBS_SPROJU="yes"
  ])

  # We create a shell function which contains all the code to actually
  # configure this project including adding it to the
  # $mcppbs_include_external_en running shell variable and setting an
  # HAVE_SUBPROJECT C define. This will allow us to easily configure
  # optional subproject later by just executing this function.

  MCPPBS_SPROJU[]_cfg ()
  {
    # First see if the PKG_CONFIG shell variable is already set. If not
    # then we check and see if pkg-config is in our path. We use
    # AC_CHECK_TOOL so that if this is a non-native build we
    # automatically look for host-pkg-config.

    AS_IF([ test -z "${PKG_CONFIG}" ],
    [
      AC_CHECK_TOOL([PKG_CONFIG],[pkg-config],[no])
      AS_IF([ test "${PKG_CONFIG}" = "no" ],
      [
        AC_MSG_ERROR([Could not find pkg-config which is required for
          linking against external subprojects.])
      ])
    ])

    # Now that we know that pkg-config is available we can see if the
    # given subproject exists.

    AS_IF([ ${PKG_CONFIG} --exists MCPPBS_SPROJ ],[],
    [
      AC_MSG_ERROR([Could not find MCPPBS_SPROJ library with pkg-config.
        Perhaps MCPPBS_SPROJ was not found in the pkg-config search
        path. Try adding the directory containing 'MCPPBS_SPROJ.pc' to
        the PKG_CONFIG_PATH environment variable.])
    ])

    # Some nice configure output

    AC_MSG_CHECKING([for external subproject MCPPBS_SPROJ])
    AC_MSG_RESULT([yes])

    # Create the compiler and linker flags for this subproject

    MCPPBS_SPROJU[]_cppflags=`${PKG_CONFIG} --cflags MCPPBS_SPROJ`
    MCPPBS_SPROJU[]_ldflags=`${PKG_CONFIG} --libs-only-L MCPPBS_SPROJ`
    MCPPBS_SPROJU[]_libs=`${PKG_CONFIG} --libs-only-l MCPPBS_SPROJ`
    AS_VAR_APPEND(MCPPBS_SPROJU[]_libs,
     `${PKG_CONFIG} --libs-only-other MCPPBS_SPROJ`)

    AC_SUBST(MCPPBS_SPROJU[]_cppflags)
    AC_SUBST(MCPPBS_SPROJU[]_ldflags)
    AC_SUBST(MCPPBS_SPROJU[]_libs)

    # Create a header define and set the approriate shell variables

    AC_DEFINE(m4_toupper(HAVE_[]MCPPBS_SPROJU),,
      [Define if we should include subproject MCPPBS_SPROJ])
    AS_VAR_APPEND([mcppbs_include_external_en],"MCPPBS_SPROJ ")
    with_[]MCPPBS_SPROJU="yes"
  };

  # See if we should actually configure this subproject and if so then
  # call the shell function we just created.

  AS_IF([    test "${with_optional_subprojects}" = "yes" \
          || test "${with_[]MCPPBS_SPROJU}" = "yes"  ],
  [
    eval "MCPPBS_SPROJU[]_cfg"
  ])

])

#-------------------------------------------------------------------------
# _MCPPBS_UNIQ([var])
#-------------------------------------------------------------------------
# Helper macro which looks through the given shell variable and
# eliminates redundant tokens (ie. whitespace delimited substrings) and
# writes the result back to the given shell variable. It terms of
# ordering the macro uses the placement of the last occurrence of the
# redundant token. This will do the right thing for linker library
# ordering. The current implementation is pretty inefficient. I think it
# is worse than quadratic, but it is simple and the number of tokens is
# usually pretty small.

m4_define([_MCPPBS_UNIQ],
[
  # Reverse the order of the input
  $1_rev=""
  for input_token in ${$1}; do
    $1_rev="${input_token} ${$1_rev}"
  done

  # Step through each input token (now in reverse order)
  $1=""
  for input_token in ${$1_rev}; do

    # See if input token is in output token list
    token_found="no"
    for output_token in ${$1}; do
      if ( test "${input_token}" = "${output_token}" ); then
        token_found="yes"
      fi
    done

    # If this is the first time we have seen token push it onto list
    if ( test "${token_found}" = "no" ); then
      $1="${input_token} ${$1}"
    fi
  done
])

#-------------------------------------------------------------------------
# MCPPBS_SUBPROJECT( [subproject], [ dep1, dep2, ... ] )
#-------------------------------------------------------------------------
# Go through list of subprojects which this subproject depends on and
# make sure they are configured. Create a cummulative list of all the
# compiler and linker flags from all the subprojects which this
# subproject depends on including both direct and indirect dependencies.
#
# Note that we use a m4_define instead of AC_DEFUN for now because
# otherwise autoconf will call macros specified with AC_REQUIRE at the
# very outer AC_DEFUN which can be pretty confusing.

m4_define([MCPPBS_SUBPROJECT],
[
  # Verify that the subproject name give in the configure.ac matches the
  # name give in the autoconf fragment.

  m4_if(m4_normalize($1),MCPPBS_SPROJ,[],
  [
    m4_fatal(Subproject name in configure.ac does not match name
             in MCPPBS_SPROJ.ac ('MCPPBS_SPROJ' != 'm4_normalize($1)'))
  ])

  m4_define([MCPPBS_SPROJ],  m4_normalize($1))
  m4_define([MCPPBS_SPROJU], m4_bpatsubst(MCPPBS_SPROJ,[-],[_]))

  # Save the list of direct dependencies (ie dirdeps) and a list of
  # dependencies which are comma separated for pkg-config file.

  MCPPBS_SPROJU[]_dirdeps="m4_join([ ],$2)"
  MCPPBS_SPROJU[]_pkcdeps="$2"

  # Initialize this subproject's compiler and linker flags

  MCPPBS_SPROJU[]_cppflags="-I${srcdir}/MCPPBS_SPROJ "
  MCPPBS_SPROJU[]_libs="-l[]MCPPBS_SPROJ "

  # Loop through the list of given subprojects and for each one see if
  # it has already been configured. If no then configure it by calling
  # the appropriate shell function created in MCPPBS_SUBPROJECT. This
  # will recursively configure transitively dependent subprojects.
  # Eventually maybe this should happen at configure run time as opposed
  # to autoconf run time.

  m4_foreach([MCPPBS_DEP],[$2],
  [
    # Determine if this dependency is required or optional

    m4_define([MCPPBS_DEP_OPTIONAL],
      m4_bmatch(MCPPBS_DEP,[\*],[true],[false]))

    # Create some names which characterize this dependency including a
    # shell variable indicating if this subproject has been configured,
    # the function name to call if we need to configure this dependency,
    # and a shell variable which has this dependency's dependencies.

    m4_define([MCPPBS_DEP],
      m4_normalize(m4_bpatsubsts(MCPPBS_DEP,[*],[])))

    m4_define([MCPPBS_DEPU], m4_bpatsubsts(MCPPBS_DEP,[-],[_]))

    # If the dependency is required and has not been configured then
    # configure it. Issue error if subproject does not exist.

    m4_if(MCPPBS_DEP_OPTIONAL,[false],
    [
      m4_set_contains(MCPPBS_SPROJS,MCPPBS_DEP,[],
      [
        m4_fatal(Subproject MCPPBS_SPROJ depends on non-existent
                 subproject MCPPBS_DEP)
      ])

      AS_IF([ test "${with_[]MCPPBS_DEPU}" = "no" ],
      [
        eval "MCPPBS_DEPU[]_cfg"
      ])
    ])

    # Add information about this dependency to our running lists

    AS_IF([ test "${with_[]MCPPBS_DEPU}" = "yes" ],
    [
      # Add the actual dependency to our libs list and our intdeps list
      # which are both ordered such that libs only depend on later libs

      AS_VAR_APPEND(MCPPBS_SPROJU[]_libs,"-l[]MCPPBS_DEP ")
      AS_IF([ test "${MCPPBS_DEPU[]_type}" = "internal" ],
      [
        AS_VAR_APPEND(MCPPBS_SPROJU[]_intdeps,"MCPPBS_DEP ")
      ])

      # Add dependency's variables to our own

      AS_VAR_APPEND(MCPPBS_SPROJU[]_intdeps,"${MCPPBS_DEPU[]_intdeps} ")
      AS_VAR_APPEND(MCPPBS_SPROJU[]_cppflags,"${MCPPBS_DEPU[]_cppflags} ")
      AS_VAR_APPEND(MCPPBS_SPROJU[]_ldflags,"${MCPPBS_DEPU[]_ldflags} ")
      AS_VAR_APPEND(MCPPBS_SPROJU[]_libs,"${MCPPBS_DEPU[]_libs} ")
    ])
  ])

  # Make the dependency list, cppflags, ldflags, and libs variable unique
  # by eliminating redundant tokens in the full lists.

  _MCPPBS_UNIQ([MCPPBS_SPROJU[]_intdeps])
  _MCPPBS_UNIQ([MCPPBS_SPROJU[]_cppflags])
  _MCPPBS_UNIQ([MCPPBS_SPROJU[]_ldflags])
  _MCPPBS_UNIQ([MCPPBS_SPROJU[]_libs])

  # Keep a copy of the compiler and linker flags as they are now,
  # because if we want to install this project we don't really need to
  # include these flags in the pkg-config file. We do of course need to
  # keep the flags that a user might add later in their subproject.ac.

  MCPPBS_SPROJU[]_base_cppflags=${MCPPBS_SPROJU[]_cppflags}
  MCPPBS_SPROJU[]_base_ldflags=${MCPPBS_SPROJU[]_ldflags}
  MCPPBS_SPROJU[]_base_libs=${MCPPBS_SPROJU[]_libs}

  # Substitute variables for makefile

  AC_SUBST(MCPPBS_SPROJU[]_intdeps)
  AC_SUBST(MCPPBS_SPROJU[]_cppflags)
  AC_SUBST(MCPPBS_SPROJU[]_ldflags)
  AC_SUBST(MCPPBS_SPROJU[]_libs)

  # Substitute variables for pkg-config files (these will be set in the
  # MCPPBS_INSTALL_LIBS macro)

  AC_SUBST(MCPPBS_SPROJU[]_pkcdeps)
  AC_SUBST(MCPPBS_SPROJU[]_extra_cppflags)
  AC_SUBST(MCPPBS_SPROJU[]_extra_ldflags)
  AC_SUBST(MCPPBS_SPROJU[]_extra_libs)

  # Display that we are now configuring this subproject (ie running the
  # rest of the macros in the corresponding subproject.ac)

  AC_MSG_NOTICE([configuring internal subproject MCPPBS_SPROJ])

])

#-------------------------------------------------------------------------
# _MCPPBS_CREATE_EXTRA_FLAGS([var],[suffix])
#-------------------------------------------------------------------------
# Var is a bash shell variable while suffix is a string literal. This
# helper macro works with three variables:
#
#  eval var_suffix=\${${var}_suffix}
#  eval var_base_suffix=\${${var}_base_suffix}
#  eval var_extra_suffix=\${${var}_extra_suffix}
#
# The first two are inputs and the third is the output. The first input
# is the entire set of compiler or linker flags. The second are just the
# base flags defined at the time that MCPPBS_SUBPROJECT is finished. The
# output will be those flags which are in the first input but not in the
# second input. For now we just use sed to remove the base from the
# first input which should be fine assuming the user hasn't mucked with
# what was already in the standard variables.

m4_defun([_MCPPBS_CREATE_EXTRA_FLAGS],
[
  # Read the two input variables
  eval "$1_$2=\${${$1}_$2}"
  eval "$1_base_$2=\${${$1}_base_$2}"

  # If nothing would go in extra flags then we are done
  if ( test "${$1_$2}" = "${$1_base_$2}" ); then
    $1_extra_$2=""

  # As long as both inputs are non-empty then do the substitution
  elif ( test -n "${$1_$2}" && test -n "${$1_base_$2}" ); then
    $1_extra_$2=`echo "${$1_$2}" | sed "s|${$1_base_$2}||"`

  # If at least one input was empty then extra is just current value
  else
    $1_extra_$2="${$1_$2}"

  fi

  # Set the output variable
  eval "${$1}_extra_$2=\${$1_extra_$2}"
])

#-------------------------------------------------------------------------
# MCPPBS_INSTALL_LIBS([ subproject1, subproject2, ... ])
#-------------------------------------------------------------------------
# Configure the project so that it will install the libraries (and
# headers of course) for the given subproject. For a subproject to be
# able to be installed it must have a pkg-config subproject.pc.in file
# which can use the following substitution variables:
#
#  - @foo_pkcdeps@        : List of all subproject dependencies
#  - @foo_extra_cppflags@ : List of include paths (-I)
#  - @foo_extra_ldflags@  : List of library paths (-L)
#  - @foo_extra_libs@     : List of libraries (-l)
#
# The "extra" compiler and linker flags are the subset of the compiler
# and linker flags used in the makefile which are not provided by other
# subprojects.
#
# It is an error for an "install" subproject to depend on subprojects
# which are internal and not marked for installation.

AC_DEFUN([MCPPBS_INSTALL_LIBS],
[
  # Normalize input list and step through each subproject on list

  mcppbs_install=`echo "$1" | tr -s ",\n " "   "`
  for mcppbs_sproj in ${mcppbs_install}; do

    # Change dashes to underscores in given subproject

    mcppbs_sproju=`echo "${mcppbs_sproj}" | tr "-" "_"`

    # Make sure this is a valid subproject

    eval "with_mcppbs_sproju=\${with_${mcppbs_sproju}}"
    AS_IF([ test -z "${with_mcppbs_sproju}" ],
    [
       AC_MSG_ERROR([Subproject ${mcppbs_sproj} is in
         MCPPBS_[]INSTALL_LIBS but has not been initialized with a call
         to MCPPBS_[]INCLUDE_INTERNAL.])
    ])

    # Verify that all of the dependencies for this subproject are either
    # external or also on this install list. You cannot install a
    # subproject which depends on other subprojects which are not also
    # installed (or will be installed).

    eval "mcppbs_sproju_dirdeps=\${${mcppbs_sproju}_dirdeps}"
    for mcppbs_dep in ${mcppbs_sproju_dirdeps}; do

      mcppbs_depu=`echo ${mcppbs_dep} | tr "-" "_"`
      eval "mcppbs_depu_type=\${${mcppbs_depu}_type}"
      AS_IF([ test "${mcppbs_depu_type}" = "internal" ],
      [
        AS_IF([ echo "${mcppbs_install}" | grep -qvw "${mcppbs_dep}" ],
        [
          AC_MSG_ERROR([Subproject ${mcppbs_sproj} is in
            MCPPBS_[]INSTALL_LIBS but it depends on subproject
            ${mcppbs_dep} which is an internal subproject not marked for
            installation. Maybe you should add subproject ${mcppbs_dep}
            to MCPPBS_[]INSTALL_LIBS?])
        ])
      ])
    done

    # Only install subprojects which are enabled

    AS_IF([ test "${with_mcppbs_sproju}" = "yes" ],
    [
      # Create the "extra" version of the compiler and linker flags

      _MCPPBS_CREATE_EXTRA_FLAGS([mcppbs_sproju],[cppflags])
      _MCPPBS_CREATE_EXTRA_FLAGS([mcppbs_sproju],[ldflags])
      _MCPPBS_CREATE_EXTRA_FLAGS([mcppbs_sproju],[libs])

      # Create subproject.pc from subproject.pc.in

      AC_CONFIG_FILES(${mcppbs_sproj}.pc:${mcppbs_sproj}/${mcppbs_sproj}.pc.in)
    ])

  done
])
