//========================================================================
// Work-Stealing Runtime: TaskGroup Interface
//========================================================================
// A task-group is a set of tasks spawned together. The function who
// creates the task-group can only return when all tasks in that
// task-group is finished. Task-groups maintains a reference count, which
// is the number of spawned tasks in flight. The task-group has two
// interfaces: run() spawns a task and puts the task into its own task
// queue; wait() blocks the current thread until all spawned tasks are
// fininsed, i.e. its reference count goes down to zero.  Spawned
// functions are available for parallel execution. This does not
// necessarily mean it will be executed in parallel depending on the
// implementation and available resources. A serial execution is
// valid. Useful for recursive divide-and-conquer approaches to
// parallelization.

#ifndef WSRT_TASKGROUP_H
#define WSRT_TASKGROUP_H

#include "wsrt-Task.h"

namespace wsrt {

  class TaskGroup {
  public:
    // we have to make the ref_count public because it may be accessed by
    // another worker
    volatile int m_ref_count;

    TaskGroup();
    void run( TaskDescriptor& task );
    void wait();
    void run_and_wait( TaskDescriptor& task );
  };

}

#endif /* WSRT_TASKGROUP_H */
