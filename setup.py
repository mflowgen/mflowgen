"""
========================================================================
setup.py
========================================================================
setup.py inspired by the PyPA sample project:
https://github.com/pypa/sampleproject/blob/master/setup.py
"""

from os import path
from setuptools import find_packages, setup

#-------------------------------------------------------------------------
# get_long_descrption
#-------------------------------------------------------------------------

def get_long_description():
  here = path.abspath(path.dirname(__file__))
  with open(path.join(here, 'README.md'), encoding='utf-8') as f:
    return f.read()

#-------------------------------------------------------------------------
# setup
#-------------------------------------------------------------------------

setup(

  # General information

  name                          = 'mflowgen',
  use_scm_version               = True,  # Replaces manual version management
  description                   = 'mflowgen: A Modular ASIC and FPGA Flow Generator',
  long_description              = get_long_description(),
  long_description_content_type = 'text/markdown',
  url                           = 'https://github.com/mflowgen/mflowgen',
  author                        = 'Christopher Torng',
  author_email                  = 'clt67@cornell.edu',

  # Packages
  packages = find_packages(
    exclude = ['adks', 'designs', 'docs', 'requirements', 'steps'],
  ) + ['.'],

  # License
  license = 'BSD',

  # Pip will block installation on unsupported versions of Python
  python_requires = '>=3.6',

  # Dependencies
  install_requires = [
    'pytest>=4.4',
    'pyyaml>=5.0',
  ],

  # Classifiers
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

  # Include non-Python files seen by Git
  include_package_data = True,

  # Executable scripts
  entry_points = {
    'console_scripts': [
      'mflowgen        = mflowgen.cli:main',
      'mflowgen-python = mflowgen.mflowgen_python:_mflowgen_python_main',
#      'mflowgen-info = mflowgen.scripts:main' # use MFLOWGEN_HOME for now
    ]
  },

)
