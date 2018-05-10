//========================================================================
// wsrt-Macros.inl
//========================================================================

#include "stdx-PreprocessorUtils.h"

#include "common.h"

#include "wsrt-Task.h"
#include "wsrt-Runtime.h"
#include "wsrt-TaskGroup.h"

//------------------------------------------------------------------------
// WSRT_PARALLEL loop bodies
//------------------------------------------------------------------------

#define WSRT_PARALLEL_LB0( count_, item_ ) \
  __typeof__ (item_) STDX_PP_CONCAT(item_,_);

#define WSRT_PARALLEL_LB1( count_, item_ ) \
  typedef __typeof__ (item_) STDX_PP_CONCAT(item_,_t_);

#define WSRT_PARALLEL_LB2( count_, item_ ) \
  STDX_PP_CONCAT(item_,_t_) item_ = args_ptr_->STDX_PP_CONCAT(item_,_);

#define WSRT_PARALLEL_LB3( count_, item_ ) \
  args_.STDX_PP_CONCAT(item_,_) = item_;

#define WSRT_PARALLEL_LB4( count_, item_ ) \
  parent_args_.STDX_PP_CONCAT(item_,_) = item_;

#define WSRT_PARALLEL_LB5( count_, item_ ) \
  child_args_.STDX_PP_CONCAT(item_,_) = item_;

//------------------------------------------------------------------------
// WSRT_PARALLEL_RANGE_
//------------------------------------------------------------------------


//------------------------------------------------------------------------
// WSRT_PARALLEL_FOR1
//------------------------------------------------------------------------
// Version without using the range object and no grainsize. This is more
// like parallel do

//------------------------------------------------------------------------
// WSRT_PARALLEL_FOR2
//------------------------------------------------------------------------
// Version without using the range object. Creates two tasks per recursive
// call

#define WSRT_PARALLEL_FOR2( size_, inputs_, body_ )                      \
{                                                                        \
                                                                         \
  struct wsrt_args_ {                                                    \
    wsrt::TaskDescriptor* task;                                          \
    STDX_PP_LIST_MAP( inputs_, WSRT_PARALLEL_LB0 )                       \
  };                                                                     \
                                                                         \
  struct wsrt_ {                                                         \
    STDX_PP_LIST_MAP( inputs_, WSRT_PARALLEL_LB1 )                       \
    __attribute__ ((noinline))                                           \
    static void func( void* args_vptr_, void* task_vptr_ )               \
    {                                                                    \
                                                                         \
      wsrt_args_* args_ptr_                                              \
        = static_cast<wsrt_args_*>(args_vptr_);                          \
      STDX_PP_LIST_MAP( inputs_, WSRT_PARALLEL_LB2 )                     \
                                                                         \
      wsrt::TaskDescriptor* task = args_ptr_->task;                      \
                                                                         \
      int task_size  = task->m_loop_range.size();                        \
      int target_chunk_size = task->m_target_chunk_size;                 \
                                                                         \
      if ( task_size > target_chunk_size ) {                             \
                                                                         \
        wsrt::TaskGroup tg;                                              \
                                                                         \
        wsrt::TaskDescriptor parent;                                     \
        wsrt_args_ parent_args_;                                         \
        STDX_PP_LIST_MAP( inputs_, WSRT_PARALLEL_LB4 )                   \
        parent_args_.task = &parent;                                     \
                                                                         \
        wsrt::TaskDescriptor child;                                      \
        wsrt_args_ child_args_;                                          \
        STDX_PP_LIST_MAP( inputs_, WSRT_PARALLEL_LB5 )                   \
        child_args_.task = &child;                                       \
                                                                         \
        parent.m_func_ptr           = &wsrt_::func;                      \
        parent.m_args_ptr           = static_cast<void*>( &parent_args_ );\
        parent.m_ref_count_ptr      = task->m_ref_count_ptr;             \
        parent.m_loop_range         = task->m_loop_range;                \
        parent.m_target_chunk_size  = task->m_target_chunk_size;         \
                                                                         \
        child.m_func_ptr           = &wsrt_::func;                       \
        child.m_args_ptr           = static_cast<void*>( &child_args_ ); \
        child.m_ref_count_ptr      = task->m_ref_count_ptr;              \
        child.m_loop_range         = task->m_loop_range;                 \
        child.m_target_chunk_size  = task->m_target_chunk_size;          \
                                                                         \
        child.m_loop_range.m_end   =                                     \
          child.m_loop_range.m_begin + ( task_size / 2 );                \
                                                                         \
        parent.m_loop_range.m_begin =                                    \
          task->m_loop_range.m_end - ( task_size - task_size / 2 );      \
                                                                         \
        tg.run( child );                                                 \
        tg.run( parent );                                                \
        tg.wait();                                                       \
                                                                         \
      }                                                                  \
      else {                                                             \
        wsrt::LoopTaskRange range;                                       \
        range.m_begin = task->m_loop_range.m_begin;                      \
        range.m_end   = task->m_loop_range.m_end;                        \
        STDX_PP_STRIP_PAREN(body_);                                      \
      }                                                                  \
                                                                         \
    }                                                                    \
  };                                                                     \
                                                                         \
  wsrt_args_ args_;                                                      \
  STDX_PP_LIST_MAP( inputs_, WSRT_PARALLEL_LB3 )                         \
                                                                         \
  wsrt::TaskGroup tg;                                                    \
  wsrt::TaskDescriptor root;                                             \
                                                                         \
  args_.task = &root;                                                    \
                                                                         \
  int target_chunk_size = 0;                                             \
  int tasks_per_core    = 8;                                             \
                                                                         \
  target_chunk_size = size_ / ( tasks_per_core * bthread_get_num_cores() );\
  if ( target_chunk_size <= 0 ) target_chunk_size = 1;                   \
                                                                         \
  root.m_func_ptr           = &wsrt_::func;                              \
  root.m_args_ptr           = static_cast<void*>( &args_ );              \
  root.m_ref_count_ptr      = &tg.m_ref_count;                           \
  root.m_loop_range.m_begin = 0;                                         \
  root.m_loop_range.m_end   = size_;                                     \
  root.m_target_chunk_size  = target_chunk_size;                         \
                                                                         \
  wsrt::task_scheduler_init();                                           \
  tg.run_and_wait( root );                                               \
  wsrt::task_scheduler_end();                                            \
}                                                                        \

