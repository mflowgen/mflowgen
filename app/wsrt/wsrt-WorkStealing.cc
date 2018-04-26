#include "wsrt-WorkStealing.h"
#include <assert.h>

namespace wsrt {

  //----------------------------------------------------------------------
  // execute_task
  //----------------------------------------------------------------------

  __attribute__((noinline))
  void execute_task( int thread_id, TaskDescriptor& task )
  {
    void* task_vptr = static_cast<void*>( &task );

    //__asm__ __volatile__( "stop" );

    (*task.m_func_ptr) ( task.m_args_ptr, task_vptr );

    assert(task.m_ref_count_ptr != NULL);
    //if ( task.m_ref_count_ptr != NULL ) {
      __sync_fetch_and_sub( task.m_ref_count_ptr, 1 );
    //}
  }

}
