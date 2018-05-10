//========================================================================
// Basic schedulter operations for work stealing
//========================================================================
// These are basic operations used by work-stealing scheduler. We refer
// threads as _workers_. Each worker has a task queue and dequeue tasks
// from its task queue to execute. If one's task queue is empty, it
// choose a _victim_ to _steal_ a task from. The stolen task(s) will be
// put onto the task queue of the _thief_.
//
//
// We use stats to keep record of the overhead of the task queue and the
// work-stealing scheduler
//
// mtpull specific stat code:
// see gem5: src/cpu/base.cc
//
// 10: executing the task
// 11: steal-loop
// 12: local dequeue
// 13: local enqueue
// 14: remote dequeue (steal)

#ifndef WSRT_WORKSTEALING_H
#define WSRT_WORKSTEALING_H

#include "common.h"

#include "wsrt-Task.h"
#include "wsrt-WSDeque.h"

//------------------------------------------------------------------------
// Global variables defined in wsrt-Runtime.cc
//------------------------------------------------------------------------

namespace wsrt    {
namespace details {

  extern volatile int  g_task_scheduler_running;
  extern volatile int  g_nested_level;

  extern volatile CacheLineStorage< bool > g_thread_active[ 4 ];

  extern CacheLineStorage< WSDeque< TaskDescriptor > > g_task_queues[ 4 ];

}}

namespace wsrt {

  //----------------------------------------------------------------------
  // Basic schedulter operations for work stealing
  //----------------------------------------------------------------------
  // These are basic operations used by work-stealing scheduler. We refer
  // threads as _workers_. Each worker has a task queue and dequeue tasks
  // from its task queue to execute. If one's task queue is empty, it
  // choose a _victim_ to _steal_ a task from. The stolen task(s) will be
  // put onto the task queue of the _thief_.

  // select_victim:
  // occupancy-based victim select
  // go over all other worker's task queues and find a worker to steal
  // from. Returned value is the thread id of the victim.

  // select_victim:
  // occupancy-based victim select
  // go over all other worker's task queues and find a worker to steal
  // from. Returned value is the thread id of the victim.

  inline int select_victim( int thread_id, int nthreads )
  {
    int ret        = -1;
    int max_ntasks = 0;

    // we choose the victim by finding the worker whose task queue has
    // largest number of tasks.
    for( int i = 0; i < nthreads; i++ ) {
      if( i != thread_id )
        if( details::g_task_queues[i].data.get_ntasks() > max_ntasks ) {
          max_ntasks = details::g_task_queues[i].data.get_ntasks();
          ret = i;
        }
    }

    return ret;
  }

  // steal_task:
  // Given victim id, transfer a single task from the victim. Return true if the steal is successful,
  // otherwise return false.

  inline bool steal_task( const int& victim_id, TaskDescriptor& task_stolen )
  {
    bool steal_success = false;

    steal_success = details::g_task_queues[victim_id].data.dequeue_head( task_stolen );

    return steal_success;
  }

  // steal_half:
  // Given victim id, transfer half the tasks on the victim's queue to the
  // thief's queue.

  inline bool steal_half( const int& victim_id )
  {
    // TO-DO
    return false;
  }

  // execute_task:
  // Execute the given task.
  //
  // UPDATE: October 30th, 2017
  // IMPORTANT: The runtime does not distinguish between loop-tasks vs.
  // general tasks. Everything currently is a task and the parallel-for
  // macros handle the recursive division of a linear integer range.
  //
  // FIXME: Unfortunately, without any dynamic memory allocation supported
  // in the runtime, we can't accept range objects in the runtime! For now
  // my hacks work only a linear integer range

  void execute_task( int thread_id, TaskDescriptor& task );
  //inline void execute_task( int thread_id, TaskDescriptor& task ) {
  //  void* task_vptr = static_cast<void*>( &task );

  //  (*task.m_func_ptr) ( task.m_args_ptr, task_vptr );

  //  if ( task.m_ref_count_ptr != NULL ) {
  //    __sync_fetch_and_sub( task.m_ref_count_ptr, 1 );
  //  }
  //}

  // dequeue_and_execute_task:
  // Execute a task poped from the worker's own task queue. If there is
  // none, return false.
  // for loop-level parallelism, when the worker dequeue a task containing
  // multiple iterations, it only takes a chuck out of iterations in that
  // task, and put the rest back onto the task queue. Chuck size can be
  // changed by the user

  inline bool dequeue_and_execute_task( int thread_id )
  {

    TaskDescriptor task;

    bool dequeue_success = details::g_task_queues[thread_id].data.dequeue_tail( task );

    if ( dequeue_success ) {

      execute_task( thread_id, task );

      return true;

    } else {
      return false;
    }
  }

  inline void work_stealing_loop( volatile int* cond )
  {
    bool steal_success   = true;
    bool dequeue_success = false;

    int victim_id = -1;

    bool steal_stat_on = false;
    bool first_steal_fail = true;

    TaskDescriptor stolen_task;

    int thread_id = bthread_get_core_id();
    int nthreads  = bthread_get_num_cores();

    while ( (__sync_fetch_and_add(cond,0)) > 0 ) {

      if( steal_success )
        dequeue_success = dequeue_and_execute_task( thread_id );

      if( !dequeue_success ) {

        // select a victim worker
        victim_id = select_victim( thread_id, nthreads );
        if( victim_id >= 0 ) {
          steal_success = steal_task( victim_id, stolen_task );
        } else {
          // no worker has avaliable tasks to steal
          steal_success = false;
        }

        if( steal_success ){
          if ( steal_stat_on ) {
            steal_stat_on = false;
            details::g_thread_active[ thread_id ].data = true;
          }
          first_steal_fail = true;

          execute_task( thread_id, stolen_task );

        } else {
          if ( !steal_stat_on && !first_steal_fail ) {
            // turn on stat 11 only if steal fails more than once
            steal_stat_on = true;
            // mark itself as inactive
            details::g_thread_active[ thread_id ].data = false;
          }
          first_steal_fail = false;
        }

      }
    }

    if ( steal_stat_on )
    // restore orignial active state
    details::g_thread_active[ thread_id ].data = true;
  }

}

#endif
