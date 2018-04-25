//========================================================================
// mtbmark-sort-v3
//========================================================================
// This version (v3) uses shellsort to sort each fourth of the elements,
// and then run 3 times of two-way merge. The first two merge runs are
// parallelized. This code uses purely pointers to avoid the arithmetics
// to calculate the address based on array indices.
// Shellsort ( O(n^1.5) performs better than quicksort O(nlogn) when the
// array is smaller thanks to the complexity. Quicksort's recursion brings
// overhead as well.
//
// Author : Shunning Jiang
// Date   : Dec 6, 2016

#include "common.h"
#include "mtbmark-sort.dat"

typedef struct
{
  int  *l_idx;
  int  *r_idx;
} s_arg_t;

int gap[] = {13, 4, 1, 0};

// Shunning: I use shellsort to replace quicksort when the list is short

__attribute__ ((noinline))
void shellsort(void* arg_vptr)
{
  s_arg_t* arg_ptr = (s_arg_t*) arg_vptr;

  int *arr     = arg_ptr->l_idx;
  int *arr_end = arg_ptr->r_idx;

  int g, swap;
  int *k = gap, *i, *j, *jj;

  int l = arr_end - arr;
  while (*k >= l) ++k;

  while (g = *(k++))
    for (i=arr+g; i<arr_end; ++i)
    {
      swap = *i;
      jj = i;
      j  = jj-g;
      while (j >= arr)
      {
        l = *j;
        if (l <= swap) break;
        *jj = l;
        jj = j;
        j -= g;
      }
      *jj = swap;
    }
}

//------------------------------------------------------------------------
// Merge sort
//------------------------------------------------------------------------

// merge implementation

void merge_impl( int* dest, int* src0, int* src1, int size0, int size1 )
{
  int *dest_end = dest + (size0 + size1);

  int *src0_end = src0 + size0;
  int *src1_end = src1 + size1;

  for (;;++dest)
  {
    if (src0 == src0_end) // just copy the rest of src1 over
    {
      while (dest < dest_end)
        *(dest++) = *(src1++);
      return;
    }
    
    if (src1 == src1_end) // just copy the rest of src0 over
    {
      while (dest < dest_end)
        *(dest++) = *(src0++);
      return;
    }
    
    if (*src0 < *src1)
      *dest = *(src0++); // src0 has smaller value
    else
      *dest = *(src1++); // src1 has smaller value
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

  // Because we need in-place sorting, we need to create a mutable temp
  // array.

  int block_size = size/4;

  s_arg_t s_arg0 = { src+  0,          src+  block_size };
  s_arg_t s_arg1 = { src+  block_size, src+2*block_size };
  s_arg_t s_arg2 = { src+2*block_size, src+3*block_size };
  s_arg_t s_arg3 = { src+3*block_size, src+size         };

  bthread_spawn( 1, &shellsort, &s_arg1 );
  bthread_spawn( 2, &shellsort, &s_arg2 );
  bthread_spawn( 3, &shellsort, &s_arg3 );

  shellsort( &s_arg0 );

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
