//========================================================================
// common-bthread
//========================================================================

#include "common-bthread.h"

//------------------------------------------------------------------------
// Global data structures
//------------------------------------------------------------------------

#ifdef _RISCV

spawn_func_ptr g_thread_spawn_func_ptrs[4];
void*          g_thread_spawn_func_args[4];

volatile int   g_thread_flags[4] = {0,0,0,0};

#endif

//------------------------------------------------------------------------
// bthread_init
//------------------------------------------------------------------------

#ifdef _RISCV

void bthread_init()
{
  int core_id = bthread_get_core_id();

  // If it's core zero, fall through

  if ( core_id == 0 ) {

    for ( int i = 0; i < 4; i++ )
      g_thread_flags[i] = 0;

    // mark core zero to be 1.

    g_thread_flags[0] = 1;
    return;
  }

  else {

    // Core 1-3 will wait here in the worker loop

    while (1) {

      // Wait until woken up by core 0. We insert some extra nops here to
      // avoid banging on the memory system too hard.

      while( g_thread_flags[core_id] == 0 ) {
        __asm__ __volatile__ ( "nop;"
                               "nop;"
                               "nop;"
                               "nop;"
                               "nop;"
                               "nop;"
                               "nop;"
                               "nop;"
                               "nop;"
                               "nop;": : : "memory" );
      }

      // Execute the spawn function

      (*g_thread_spawn_func_ptrs[core_id])
        ( g_thread_spawn_func_args[core_id] );

      // Unset the flag so the master core knows this work core is done.

      g_thread_flags[core_id] = 0;

    }

  }
}

#else

void bthread_init()
{
}

#endif

//------------------------------------------------------------------------
// bthread_spawn
//------------------------------------------------------------------------
// Spawn a function to a given worker core (thread). Need to provide:
//
//   thread_id     : ID of the thread we are spawning to
//   start_routine : Spawned function
//   arg           : A pointer to the argument.
//

#ifdef _RISCV

int bthread_spawn( int thread_id, void (*start_routine)(void*), void* arg )
{
  int ncores = bthread_get_num_cores();

  // If the master core spawns work onto itself then that is an error.

  if ( thread_id == 0 ) {
    return -1;
  }

  // If thread id is too large return an error

  if ( thread_id >= ncores || thread_id < 0 )
    return -1;

  // Check to see if the thread is already in use. If so, then return
  // an error.

  if ( g_thread_flags[thread_id] )
    return -1;

  // Set function and argument pointer

  g_thread_spawn_func_args[thread_id] = arg;
  g_thread_spawn_func_ptrs[thread_id] = start_routine;

  // Wake up worker thread

  g_thread_flags[thread_id] = 1;

  return 0;
}

#else

int bthread_spawn( int thread_id, void (*start_routine)(void*), void* arg )
{
  (*start_routine) ( arg );
  return 0;
}

#endif

//------------------------------------------------------------------------
// bthread_join
//------------------------------------------------------------------------
// Wait for the given thread to finish executing its work.

#ifdef _RISCV

int bthread_join( int thread_id )
{
  // Thread id out of range, return an error.

  if( thread_id < 1 || thread_id >= 4 )
    return -1;

  // Wait until the given thread is no longer in use.

  while ( g_thread_flags[thread_id] )
    ;

  return 0;
}

#else

int bthread_join( int thread_id )
{
  return 0;
}

#endif

