"""
========================================================================
setup.py
========================================================================
setup.py inspired by the PyPA sample project:
https://github.com/pypa/sampleproject/blob/master/setup.py
"""

from os         import path
from setuptools import find_packages, setup

from mflowgen.version import __version__

#-------------------------------------------------------------------------
# get_long_descrption
#-------------------------------------------------------------------------

def get_long_description():
  here = path.abspath( path.dirname(__file__) )
  with open( path.join( here, 'README.md' ), encoding='utf-8' ) as f:
    return f.read()

#-------------------------------------------------------------------------
# setup
#-------------------------------------------------------------------------

setup(

  # General information

  name                          = 'mflowgen',
  version                       = __version__,
  description                   = \
      'mflowgen: A Modular ASIC and FPGA Flow Generator',
  long_description              = get_long_description(),
  long_description_content_type = 'text/markdown',
  url                           = 'https://github.com/mflowgen/mflowgen',
  author                        = 'Christopher Torng',
  author_email                  = 'clt67@cornell.edu',

  # Packages
  #
  # - Add root as a "package" in order to force non-Python files to appear
  #   in the bdist_wheel
  #

  packages = find_packages(
    exclude = [ 'adks', 'designs', 'docs', 'requirements', 'steps' ],
  ) + ['.'],

  # BSD 3-Clause License:
  # - http://choosealicense.com/licenses/bsd-3-clause
  # - http://opensource.org/licenses/BSD-3-Clause

  license = 'BSD',

  # Pip will block installation on unsupported versions of Python

  python_requires = '>=3.6',

  # Dependencies

  install_requires = [
    'pytest>=4.4',
    'pyyaml>=5.0',
  ],

  # Classifiers
  #
  # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
  #

  classifiers=[
    'Development Status :: 4 - Beta',
    'License :: OSI Approved :: BSD License',
    'Programming Language :: Python :: 3 :: Only',
    'Operating System :: MacOS :: MacOS X',
    'Operating System :: POSIX :: Linux',
    'Environment :: Console',
    'Topic :: Scientific/Engineering :: Electronic Design Automation (EDA)',
    'Topic :: Software Development :: Build Tools',
  ],

  # Non-Python files
  #
  # - Very hard to get non-python files to be included in the install
  #
  #     - These two are enough to include everything in the sdist
  #
  #         include_package_data = True,
  #         setup_requires = [ 'setuptools_scm' ],
  #         (put more stuff in MANIFEST.in if you want)
  #
  #     - To include everything in the bdist_wheel, the root dir needs to
  #       be seen as a "package". Only files in packages appear in bdist.
  #
  # - "Ionel Cristian Mărieș - Less known packaging features and tricks"
  #
  #     - See this video for best practices overall
  #     - Avoid data_files, very inconsistent
  #     - Do not use package_data either
  #     - if "include_package_data" is True, then MANIFEST.in files get
  #       included... but only _if_ they are inside a package
  #

  include_package_data = True,
  setup_requires = [ 'setuptools_scm' ], # include any files that git sees

  # Executable scripts

  entry_points = {
    'console_scripts': [
      'mflowgen        = mflowgen.cli:main',
      'mflowgen-python = mflowgen.mflowgen_python:_mflowgen_python_main',
#      'mflowgen-info = mflowgen.scripts:main' # use MFLOWGEN_HOME for now
    ]
  },

)

