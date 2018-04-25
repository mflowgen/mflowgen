//========================================================================
// mtbmark-sort-v2
//========================================================================
// This version (v2) uses quicksort to sort each fourth of the elements,
// and then run 3 times of two-way merge. The first two merge runs are
// parallelized. This code has nothing fancy in here. All array accesses
// are based on array indices instead of pointers.
//
// Author : Shunning Jiang
// Date   : Dec 6, 2016

#include "common.h"
#include "mtbmark-sort.dat"

//------------------------------------------------------------------------
// In-place quicksort
//------------------------------------------------------------------------

void quicksort_inplace( int *arr, int l, int r )
{
  int i = l;
  int j = r;
  int x = arr[(l+r)>>1];

  while (i<=j)
  {
    for (; arr[i]<x; ++i);
    for (; arr[j]>x; --j);
    if (i<=j)
    {
      int t = arr[i];
      arr[i] = arr[j];
      arr[j] = t;
      ++i; --j;
    }
  }
  if (l<j)  quicksort_inplace(arr, l, j);
  if (i<r)  quicksort_inplace(arr, i, r);
}

typedef struct {
  int* arr;
  int  l_idx;
  int  r_idx;
} q_arg_t;

__attribute__ ((noinline))
void quicksort( void* arg_vptr )
{
  q_arg_t* arg_ptr = (q_arg_t*) arg_vptr;
  quicksort_inplace( arg_ptr->arr, arg_ptr->l_idx, arg_ptr->r_idx );
}

//------------------------------------------------------------------------
// Merge sort
//------------------------------------------------------------------------

// merge implementation

void merge_impl( int* dest, int* src0, int* src1, int size0, int size1 )
{
  int dest_size = size0 + size1;

  int src0_idx = 0;
  int src1_idx = 0;

  int i=0;

  for (;;++i)
  {
    if (src0_idx == size0) // just copy the rest of src1 over
    {
      while (i<dest_size)
        dest[i++] = src1[src1_idx++];
      return;
    }
    
    if (src1_idx == size1) // just copy the rest of src0 over
    {
      while (i<dest_size)
        dest[i++] = src0[src0_idx++];
      return;
    }
    
    if (src0[src0_idx] < src1[src1_idx])
      dest[i] = src0[src0_idx++]; // src0 has smaller value
    else
      dest[i] = src1[src1_idx++]; // src1 has smaller value
  }
}

typedef struct {
  int* dest;
  int* src0;
  int* src1;
  int  size0;
  int  size1;
} m_arg_t;

__attribute__ ((noinline))
void merge( void* arg_vptr )
{
  m_arg_t* arg_ptr = (m_arg_t*) arg_vptr;
  merge_impl( arg_ptr->dest, arg_ptr->src0, arg_ptr->src1, arg_ptr->size0, arg_ptr->size1 );
}

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

  // Start counting stats

  test_stats_on();

  int block_size = size/4;

  q_arg_t q_arg0 = { src,   0,            block_size-1 };
  q_arg_t q_arg1 = { src,   block_size, 2*block_size-1 };
  q_arg_t q_arg2 = { src, 2*block_size, 3*block_size-1 };
  q_arg_t q_arg3 = { src, 3*block_size, size-1         };

  bthread_spawn( 1, &quicksort, &q_arg1 );
  bthread_spawn( 2, &quicksort, &q_arg2 );
  bthread_spawn( 3, &quicksort, &q_arg3 );

  quicksort( &q_arg0 );

  bthread_join(1);
  bthread_join(2);
  bthread_join(3);

  // Let core 1 merge first half

  int temp1[2*block_size], temp2[size-2*block_size];

  m_arg_t m_arg = { temp1, src, src+block_size, block_size, block_size };

  bthread_spawn( 1, &merge, &m_arg );

  // core 0 merge the other half

  merge_impl( temp2, src+2*block_size, src+3*block_size,
              block_size, size-3*block_size);

  // wait for core 1

  bthread_join( 1 );

  // final merge

  merge_impl( dest, temp1, temp2, 2*block_size, size-2*block_size );

  // Stop counting stats

  test_stats_off();

  // verifies solution

  verify_results( dest, ref, size );

  return 0;
}
