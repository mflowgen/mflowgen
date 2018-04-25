//========================================================================
// common-bthread
//========================================================================
// We use a very simple "runtime" to parallelize our apps. We called it
// bthread because it is a set of bare minimum "threading" library
// functions to parallelize a program across multiple cores.
//
// All cores start from the main function. We need to call the
// bthread_init() function at the beginning of main(). Basically only
// core 0 can pass through the bthread_init function and continue
// executing. The rest of cores (if any) will be trapped in the
// bthread_init() function, waiting in a loop we call the worker loop. In
// each iteration of the worker loop, a core will check if the flag is
// set by core 0. If it is, then it will execute the function core 0
// stored in a shared location, then reset its flag. Cores other than
// core 0 will stay in the worker loop indefinitely.
//
// We call core 0 the master core, and we call the other cores the worker
// cores. The master core "spawns work" on a worker core using the
// bthread_spawn function. The master core needs the function pointer,
// the argument pointer, and a worker core's ID. It stores the function
// pointer and the argument pointer to a global location, then sets the
// flag for the given worker core.
//
// The master core can wait for a worker core to finish by using the
// bthread_join function. It waits for a designated worker core until the
// worker core finishes executing its function (if any) then returns.

#ifndef COMMON_BTHREAD_H
#define COMMON_BTHREAD_H

//------------------------------------------------------------------------
// Global data structures
//------------------------------------------------------------------------

typedef void (*spawn_func_ptr)(void*);

#ifdef _RISCV

extern spawn_func_ptr g_thread_spawn_func_ptrs[4];
extern void*          g_thread_spawn_func_args[4];

volatile extern int   g_thread_flags[4];

#endif

//------------------------------------------------------------------------
// bthread_get_num_cores
//------------------------------------------------------------------------
// Returns the number of cores.

#ifdef _RISCV

inline
int bthread_get_num_cores()
{
  int num_cores;
  asm( "csrr %0, 0xFC1;"
       : "=r"(num_cores)
       :
  );
  return num_cores;
}

#else

inline
int bthread_get_num_cores()
{
  return 1;
}

#endif

//------------------------------------------------------------------------
// bthread_get_core_id
//------------------------------------------------------------------------
// Returns the core ID.

#ifdef _RISCV

inline
int bthread_get_core_id()
{
  int core_id;
  asm( "csrr %0, 0xF14;"
       : "=r"(core_id)
       :
  );
  return core_id;
}

#else

inline
int bthread_get_core_id()
{
  return 0;
}

#endif

//------------------------------------------------------------------------
// bthread_init
//------------------------------------------------------------------------
// This function _MUST_ be called right at the beginning of the main().
// It will only let core 0 pass through. All other cores will be trapped
// in a worker loop, waiting be woken up by the core 0 (bthread_spawn).

void bthread_init();

//------------------------------------------------------------------------
// bthread_spawn
//------------------------------------------------------------------------
// Spawn a function to a given worker core (thread). Need to provide:
//
//   thread_id     : ID of the thread we are spawning to
//   start_routine : Spawned function
//   arg           : A pointer to the argument.
//

int bthread_spawn( int thread_id, void (*start_routine)(void*), void* arg );

//------------------------------------------------------------------------
// bthread_join
//------------------------------------------------------------------------
// Wait for the given thread to finish executing its work.

int bthread_join( int thread_id );

#endif /* COMMON_BTHREAD_H */

