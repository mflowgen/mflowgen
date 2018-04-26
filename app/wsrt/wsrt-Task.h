//========================================================================
// Work-stealing Runtime: Task.h
//========================================================================
// Basic data structure of task

#ifndef WSRT_TASK_H
#define WSRT_TASK_H

namespace wsrt {

  typedef void (*func_ptr_t) (void*, void*);

  //----------------------------------------------------------------------
  // TaskDescriptor
  //----------------------------------------------------------------------
  // Task is simply a tuple of a function pointer, a argument pointer, a
  // pointer to the reference counter in the parent task which spawned it,
  // and a range object. The range object is used for compactly expressing
  // tasks that contains loops with consecutive loop indices.

  // The range objects contains two bounds of iterations.

  class LoopTaskRange {
  public:

    int m_begin;
    int m_end;

    LoopTaskRange();
    LoopTaskRange( int begin, int end );

    int size()  const;
    int begin() const;
    int end()   const;

  };

  // Task objects

  struct TaskDescriptor {
    func_ptr_t    m_func_ptr;
    void*         m_args_ptr;
    volatile int* m_ref_count_ptr;
    LoopTaskRange m_loop_range;
    int           m_target_chunk_size;

    TaskDescriptor();
    TaskDescriptor( func_ptr_t func_ptr, void* args_ptr );
  };

}

//------------------------------------------------------------------------
// Include inline source files
//------------------------------------------------------------------------

#include "wsrt-Task.inl"

#endif /* WSRT_TASK_H */
