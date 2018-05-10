//========================================================================
// Work-Stealing Runtime
//========================================================================
// TBB-inspired light-weight work-stealing runtime.
// Work-stealing task scheduler management.

#ifndef WSRT_RUNTIME_H
#define WSRT_RUNTIME_H

namespace wsrt {

  // We use a counting semaphore to represent the state of the task scheduler
  // Calling task_scheduler_init(); will increase that semaphore (P) while
  // calling task_scheduler_end(); will decrease that semaphore (V)
  // The scheduler is running if semaphore > 0.
  //
  // IMPORTANT: task_scheduler_init(); and task_scheduler_end(); MUST be
  // paired up!

  // Initialization function This functtion will spawn N (number of
  // threads) worker function to core 1 to core (N-1). One can also pass
  // one initial task for each worker so that workers can begin the task
  // execution without stealing once they are spawned.
  bool task_scheduler_init();

  // End the task scheduler. This function will signal the ending of
  // parallel section such that the workers will finish their jobs.  stop
  // the work-stealing scheduler, wait for all worker thread to join.
  bool task_scheduler_end();

}

#endif /* WSRT_RUNTIME_H */
