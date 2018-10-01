# Save design so that the checkpoint can be reopened even if the directory
# name or location changes. This portability is very useful if renaming
# build directories during design space exploration.
#
#     -libs    : copies the lib file instead of using a symlink
#     -lib2ldb : converts the lib to a compact / unreadable Innovus format
#     -relativePath : tries to use relative paths from the cwd
#     -tgz     : compress into tarball with gzip (implies -libs)
#
# Also related is setImportMode -syncRelativePath true

saveDesign $vars(dbs_dir)/$vars(step).enc -relativePath

