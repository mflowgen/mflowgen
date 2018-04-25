//========================================================================
// mtbmark-sort
//========================================================================

#include "common.h"
#include "mtbmark-sort.dat"

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Implement multicore sorting
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

typedef struct
{
  int* arr;
  int  gap;
} arg_t;

__attribute__ ((noinline))
void shell_onepass(void* arg_vptr)
{
  arg_t* arg_ptr = (arg_t*) arg_vptr;

  int *arr    = arg_ptr->arr;
  int gap     = arg_ptr->gap;

  int i,j,jj,k,l,swap;

  for (k=bthread_get_core_id(); k<gap; k+=4)
    for (i=k+gap; i<size; i+=gap)
    {
      swap = arr[i];
      jj = i;
      j  = i-gap;
      while (j>=0)
      {
        l = arr[j];
        if (l<=swap) break;
        arr[jj] = l;
        jj = j;
        j -= gap;
      }
      arr[jj] = swap;
    }
}

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int dest[], int ref[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    if ( !( dest[i] == ref[i] ) ) {
      test_fail( i, dest[i], ref[i] );
    }
  }
  test_pass();
}

//------------------------------------------------------------------------
// Test Harness
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{

  // Initialize the bthread (bare thread)

  bthread_init();

  // Initialize dest array, which stores the final result.

  int dest[size];
  arg_t args;

  //--------------------------------------------------------------------
  // Start counting stats
  //--------------------------------------------------------------------

  test_stats_on();

  // parallel shellsort implementation

  int i, k=0, g;

  int gap[] = {1093, 364, 121, 40, 13, 4, 1, 0};
  while ((gap[k]<<1)>=size) ++k;

  for (i=0; i<size; ++i)
    dest[i] = src[i];

  args.arr = dest;

  while (g=gap[k++])
  {
    args.gap = g;

    for (i=1; i<4; ++i)
      bthread_spawn(i, &shell_onepass, (void*) &args);
    // execute on core 0
    shell_onepass((void*) &(args));

    for (i=1; i<4; ++i)
      bthread_join(i);
  }

  //--------------------------------------------------------------------
  // Stop counting stats
  //--------------------------------------------------------------------

  test_stats_off();

  // verifies solution

  verify_results( dest, ref, size );

  return 0;
}
