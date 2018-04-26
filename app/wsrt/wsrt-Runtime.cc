//========================================================================
// wsrt-Runtime.cc
//========================================================================

#include "common.h"

#include "wsrt-Task.h"
#include "wsrt-WSDeque.h"
#include "wsrt-WorkStealing.h"
#include "wsrt-Runtime.h"

namespace wsrt    {
namespace details {

  //----------------------------------------------------------------------
  // Scheduler general status
  //----------------------------------------------------------------------

  volatile int  g_task_scheduler_running = 0;
  volatile int  g_nested_level = 0;

  // Worker thread activity
  volatile CacheLineStorage< bool > g_thread_active[ 4 ];

  //----------------------------------------------------------------------
  // Task Queues
  //----------------------------------------------------------------------

  CacheLineStorage< WSDeque< TaskDescriptor > > g_task_queues[ 4 ];

  //----------------------------------------------------------------------
  // Scheduler stats
  //----------------------------------------------------------------------

}}

namespace wsrt {

  void task_scheduler_worker_loop( void* null_ptr ) {

    // simply call the work-stealing loop
    //
    // NOTE: 11/9/2017
    // shreesha: setting the stats region 8 to be toggled here for helper
    // threads to aid the analysis for wsrt runtime loops using pydgin
    // tools, else the threads are busy executing the wait loop in bthreads
    // user thread-pool space
    //__asm__ __volatile__( "stop" );
    work_stealing_loop( &details::g_task_scheduler_running );
    //__asm__ __volatile__( "stop" );
    return;
  }

  bool task_scheduler_init()
  {
    // If the scheduler is initialized for the first time, spawn worker
    // threads and setup the runtime varibles.
    if ( details::g_nested_level == 0 ) {

      // turn on the running bit
      details::g_task_scheduler_running = 1;

      int nthreads = bthread_get_num_cores();

      int ret = -1;
      for(int i=1;i<nthreads;i++) {

        ret = bthread_spawn( i, &task_scheduler_worker_loop, NULL );
        // workers spawned unsuccessfully
        if( ret == -1 )
            return false;
      }

      details::g_thread_active[0].data = true;

      //__asm__ __volatile__( "stop" );
    }

    __sync_fetch_and_add( &details::g_nested_level, 1);
    return true;
  }

  bool task_scheduler_end()
  {
    if ( details::g_nested_level == 0 ) {
      // scheduler NOT running
      details::g_task_scheduler_running = 0;
      return false;
    }

    __sync_fetch_and_sub( &details::g_nested_level, 1);

    if ( details::g_nested_level == 0 ) {

      // Turn off the running bit, when worker threads see it, they will
      // terminate and join with the main thread.
      details::g_task_scheduler_running = 0;

      for( int i = 1; i < bthread_get_num_cores(); i++ ){
        bthread_join( i );
      }

      // mark thread 0 as inactive
      details::g_thread_active[0].data = false;

      // turn off stat8 - end of parallel region
      //__asm__ __volatile__( "stop" );
    }

    return true;
  }

}
