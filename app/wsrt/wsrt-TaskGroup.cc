//========================================================================
// wsrt-TaskGroup.cc
//========================================================================

#include "common.h"

#include "wsrt-Task.h"
#include "wsrt-WorkStealing.h"
#include "wsrt-TaskGroup.h"

//------------------------------------------------------------------------
// Global variables defined in bthread-TaskScheduler.cc
//------------------------------------------------------------------------

namespace wsrt    {
namespace details {

  extern CacheLineStorage< WSDeque< TaskDescriptor > > g_task_queues[ 4 ];

}}

namespace wsrt {

  TaskGroup::TaskGroup() : m_ref_count(0) {}

  void TaskGroup::run( TaskDescriptor& task ) {
    int thread_id = bthread_get_core_id();
    task.m_ref_count_ptr = &m_ref_count;

    __sync_fetch_and_add( &m_ref_count, 1 );

    details::g_task_queues[thread_id].data.enqueue_tail( task );

  }

  void TaskGroup::wait()
  {
    // call the work-stealing loop until the reference count goes to zero
    work_stealing_loop( &m_ref_count );
  }

  void TaskGroup::run_and_wait( TaskDescriptor& task ) {

    int thread_id = bthread_get_core_id();

    task.m_ref_count_ptr = &m_ref_count;
    __sync_fetch_and_add( &m_ref_count, 1 );
    execute_task( thread_id, task );
    wait();
  }

}


