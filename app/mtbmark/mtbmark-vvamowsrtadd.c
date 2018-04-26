//========================================================================
// mtbmark-vvadd
//========================================================================
// Each core will process one fourth of the src and dest arrays. So for
// example, if the arrays have 100 elements, core 0 will process elements
// 0 through 24, core 1 will process elements 25 through 49, and so on.

#include "common.h"
#include "wsrt.h"
#include "mtbmark-vvadd.dat"

//------------------------------------------------------------------------
// Argument struct
//------------------------------------------------------------------------
// This is used to pass arguments when we spawn work onto the cores.

typedef struct {
  int* dest;  // pointer to dest array
  int* src0;  // pointer to src0 array
  int* src1;  // pointer to src1 array
  int  begin; // first element this core should process
  int  end;   // (one past) last element this core should process
} arg_t;

//------------------------------------------------------------------------
// vvadd-mt
//------------------------------------------------------------------------
// Each thread uses the argument structure to figure out what part of the
// array it should work on.

__attribute__ ((noinline))
void vvadd_mt( void* arg_vptr, void* null_ptr )
{
  // Cast void* to argument pointer.

  arg_t* arg_ptr = (arg_t*) arg_vptr;

  // Create local variables for each field of the argument structure.

  int* dest  = arg_ptr->dest;
  int* src0  = arg_ptr->src0;
  int* src1  = arg_ptr->src1;
  int  begin = arg_ptr->begin;
  int  end   = arg_ptr->end;

  // Do the actual work.

  for ( int i = begin; i < end; i++ )
    //dest[i] = src0[i] + src1[i];
    __sync_fetch_and_add(&dest[i],(src0[i] + src1[i]));
}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int dest[], int ref[], int size )
{
  for ( int i = 0; i < size; i++ ) {
    if ( !( dest[i] == ref[i] ) ) {
      test_fail( i, dest[i], ref[i] );
    }
  }
  test_pass();
}

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  // Initialize bare threads (bthread). This must happen as the first
  // thing in main()!

  bthread_init();

  // This array will be where the results are stored.

  int dest[size];
  int idx = 0;
  for(idx=0;idx<size;idx++)
      dest[idx] = 0;
  // Init the dest to be 0

  // Start counting stats.


  // Determine how many elements cores 0, 1, and 2 will process. Core 3
  // will process all of the remaining elements. Core 3 might process a
  // few more elements than the others because size might not be evenly
  // divisible by four.

  int block_size = size/4;

  // Create four argument structures that include the array pointers and
  // what elements each core should process.

  arg_t arg0 = { dest, src0, src1,   0,            8 };
  arg_t arg1 = { dest, src0, src1,   8,            19 };
  arg_t arg2 = { dest, src0, src1,   19,           33 };
  arg_t arg3 = { dest, src0, src1,   33,           36 };
  arg_t arg4 = { dest, src0, src1,   36,           42 };
  arg_t arg5 = { dest, src0, src1,   42,           51 };
  arg_t arg6 = { dest, src0, src1,   51,           58 };
  arg_t arg7 = { dest, src0, src1,   58,           60 };
  arg_t arg8 = { dest, src0, src1,   60,           72 };
  arg_t arg9 = { dest, src0, src1,   72,           79 };
  arg_t arg10 = { dest, src0, src1,   79,           84 };
  arg_t arg11 = { dest, src0, src1,   84,           88};
  arg_t arg12 = { dest, src0, src1,   88,           93 };
  arg_t arg13 = { dest, src0, src1,   93,           100 };
  wsrt::TaskGroup tg;
  wsrt::TaskDescriptor task1(&vvadd_mt, &arg0 );
  wsrt::TaskDescriptor task2(&vvadd_mt, &arg1 );
  wsrt::TaskDescriptor task3(&vvadd_mt, &arg2 );
  wsrt::TaskDescriptor task4(&vvadd_mt, &arg3 );
  wsrt::TaskDescriptor task5(&vvadd_mt, &arg4 );
  wsrt::TaskDescriptor task6(&vvadd_mt, &arg5 );
  wsrt::TaskDescriptor task7(&vvadd_mt, &arg6 );
  wsrt::TaskDescriptor task8(&vvadd_mt, &arg7 );
  wsrt::TaskDescriptor task9(&vvadd_mt, &arg8 );
  wsrt::TaskDescriptor task10(&vvadd_mt, &arg9 );
  wsrt::TaskDescriptor task11(&vvadd_mt, &arg10 );
  wsrt::TaskDescriptor task12(&vvadd_mt, &arg11 );
  wsrt::TaskDescriptor task13(&vvadd_mt, &arg12 );
  wsrt::TaskDescriptor task14(&vvadd_mt, &arg13 );

  wsrt::task_scheduler_init();
  test_stats_on();
  tg.run( task1 );
  tg.run( task2 );
  tg.run( task3 );
  tg.run( task4 );
  tg.run( task5 );
  tg.run( task6 );
  tg.run( task7 );
  tg.run( task8 );
  tg.run( task9 );
  tg.run( task10 );
  tg.run( task11 );
  tg.run( task12 );
  tg.run( task13 );
  tg.run( task14 );
  tg.wait();

  test_stats_off();
  wsrt::task_scheduler_end();
  // Stop counting stats

  // Core 0 will verify the results.

  if ( bthread_get_core_id() == 0 )
    verify_results( dest, ref, size );

  return 0;
}

