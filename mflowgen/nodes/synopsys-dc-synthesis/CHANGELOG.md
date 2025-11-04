==========================================================================
Synopsys DC -- Change Log
==========================================================================
Author : Christopher Torng
Date   : September 30, 2018

We use Synopsys DC to synthesize a single RTL netlist file into gates.

This script has evolved over time inspired by (1) the Synopsys reference
methodology scripts that are released year after year on Solvnet, (2)
synthesis scripts from other research groups, as well as (3) reference
papers from user groups online.

If you make a major update to this script (e.g., update inspired by the
latest version of the Synopsys reference methodology), please list the
changeset in the version history below.

--------------------------------------------------------------------------
Version History
--------------------------------------------------------------------------

- 05/05/2020 -- Christopher Torng
    - Submodularize the script into smaller pieces so we can use mflowgen
      (and Python) to easily run the scripts in a different order, insert
      new scripts in between existing ones, etc.

- 09/30/2018 -- Christopher Torng
    - Clean slate DC scripts
    - We are now independent of the Synopsys Reference Methodology
    - Version of Synopsys DC running `% dc_shell -v`:
        dc_shell version    -  M-2016.12
        dc_shell build date -  Nov 21, 2016

- 04/08/2018 -- Christopher Torng
    - Our original version was based on the Synopsys reference
      methodology (D-2010.03-SP1)
    - Big update now inspired by the Celerity Synopsys DC scripts, which
      were in turn also based on the Synopsys reference methodology
      (L-2016.03-SP2)



