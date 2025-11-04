README
==========================================================================

**Version Restriction Issues**

Currently we use "calibredrv (...) -in inputs/adk/*.gds* (...)"
instead of "calibredrv (...) -indir inputs/adk (...)" even though
they should be equivalent. This is because using two -indir flags at
once requires Calibre 2019.9.

Here is some of the error info if you try to run with two -indir
arguments in version 2018.8.

    ERROR in command layout filemerge -indir inputs -indir inputs/adk -topcell GcdUnit -out design_merged.gds :
    >>>>> Error: Please specify a valid directory to option '-indir'.

Here is the command that fails:

    calibredrv -a layout filemerge \ -indir inputs \ -indir inputs/adk \ -topcell GcdUnit \ -out design_merged.gds 2>&1 | tee merge.log

If you do not have Calibre 2019.9, you can limit usage to a single
-indir and provide more -in flags instead:

    calibredrv -a layout filemerge \ -indir inputs \ -in inputs/adk/stdcells.gds \ -topcell GcdUnit \ -out design_merged.gds 2>&1 | tee merge.log

Here is the directory tree when this error occurred:

    % tree
    .
    ├── configure.yml
    ├── design_merged.gds
    ├── inputs
    │   ├── adk -> ../../1-freepdk-45nm/outputs/adk
    │   └── design.gds.gz -> ../../6-cadence-innovus-place-route/outputs/design.gds.gz
    ├── merge.log
    ├── mflowgen-debug
    ├── mflowgen-run.log
    ├── mflowgen-run
    └── outputs
        └── design_merged.gds -> ../design_merged.gds

Here is the exact version of calibre:

    % which calibredrv
    /cad/mentor/2018.8/aoi_cal_2018.2_33.24/bin/calibredrv

**Backgrounding problem**

If you put calibredrv in the background it will hang. This is a known
bug documented in the manual, see `calibr_drv_ref.pdf` where it says
"Do not start the tool as a background process or the Tcl shell locks up."

To ameliorate the problem, gdsmerge does `"echo | calibredrv ..."`
instead of `"calibredrv ..."` , this seems to solve the problem.
