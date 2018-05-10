//========================================================================
// Work-Stealing Runtime: Macros
//========================================================================
// Helper classes and macros to simplify creating parallel code regions.

#ifndef WSRT_MACROS_H
#define WSRT_MACROS_H

//------------------------------------------------------------------------
// WSRT_PARALLEL_RANGE
//------------------------------------------------------------------------
// This macro helps execute a set of tasks in parallel across all of the
// bthreads and also takes care of creating evenly partitioned index
// ranges. Pass the size in as the first parameter, and then a special
// local IndexRange will be available in your spawned block called
// "range". range.begin() is the first element that this spawned block
// should process and range.end() is one past the last element this
// spawned block should process. As in BTHREAD_PARALLEL, the second
// argument is a list of variable names (not expressions) which will act
// as inputs to the parallel tasks while the second argument is the body
// of the task to be executed in parallel. See comments for
// BTHREAD_PARALLEL for more information.

// Those macros helps turn a parallel loop into tasks for the work
// stealing scheduler. We chunk multiple iterations into one task to
// reduce overhead. The chunk size is defined as the number of iterations
// per task.

// Turn loop into tasks with the default chunk size. By default, the
// chunk size is ( size / nthreads * 8 )

#define WSRT_PARALLEL_RANGE( size_, inputs_, body_ ) \
  WSRT_PARALLEL_RANGE_( size_, inputs_, body_ )

// For backward compatibility

#define BTHREAD_PARALLEL_RANGE_PULL( size_, inputs_, body_ )  \
  WSRT_PARALLEL_FOR2( size_, inputs_, body_ )

//------------------------------------------------------------------------
// Include inline source files
//------------------------------------------------------------------------

#include "wsrt-Macros.inl"

#endif /* WSRT_MACROS_H */

