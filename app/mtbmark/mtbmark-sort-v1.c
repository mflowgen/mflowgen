//========================================================================
// mtbmark-sort-v1
//========================================================================
// This version (v1) is brought over directly from Fall 15. It uses
// quicksort to sort each fourth of the elements, and then run 3 times of
// two-way merge. The first two merge runs are parallelized.

#include "common.h"
#include "mtbmark-sort.dat"

// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
// LAB TASK: Implement multicore sorting
// '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

//------------------------------------------------------------------------
// Helper functions
//------------------------------------------------------------------------

// swap two elements in the same array

inline void swap( int *arr, int idx0, int idx1 ) {
  int tmp = arr[idx0];
  arr[idx0] = arr[idx1];
  arr[idx1] = tmp;
}

//------------------------------------------------------------------------
// In-place quicksort
//------------------------------------------------------------------------

// partition an array given a pivot so that elements to the right of the
// pivot are greater than the pivot, and elements to the left are less
// than the pivot.

int partition( int *arr, int left_idx, int right_idx, int pivot_idx ) {

  int i;
  int pivot = arr[pivot_idx];

  // move the pivot to the right
  swap( arr, pivot_idx, right_idx );

  int store_idx = left_idx;

  // swap elements that are less than pivot
  for ( i = left_idx; i < right_idx; i++ )
    if ( arr[i] <= pivot )
      swap( arr, i, store_idx++ );

  // swap back the pivot
  swap( arr, store_idx, right_idx );
  return store_idx;
}

// In-place quick sort

void quicksort_inplace( int *arr, int left_idx, int right_idx ) {

  if ( left_idx < right_idx ) {
    // pick a pivot index
    int pivot_idx = left_idx + ( right_idx - left_idx ) / 2;
    // partition the array using the pivot
    pivot_idx = partition( arr, left_idx, right_idx, pivot_idx );
    // recurse for left and right of the array
    quicksort_inplace( arr, left_idx, pivot_idx - 1 );
    quicksort_inplace( arr, pivot_idx + 1, right_idx );
  }
}

typedef struct {
  int* arr;
  int  l_idx;
  int  r_idx;
} q_arg_t;

__attribute__ ((noinline))
void quicksort( void* arg_vptr ) {
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

  int i;
  for ( i = 0; i < dest_size; i++ ) {

    // if src0_idx == size0, then just copy rest of src1

    if ( src0_idx == size0 ) {
      dest[i] = src1[src1_idx];
      src1_idx++;
    }

    // if src1_idx == size1, then just copy rest of src0

    else if ( src1_idx == size1 ) {
      dest[i] = src0[src0_idx];
      src0_idx++;
    }

    // src0 has smaller value

    else if ( src0[src0_idx] <= src1[src1_idx] ) {
      dest[i] = src0[src0_idx];
      src0_idx++;
    }

    // src1 has smaller value

    else if ( src1[src1_idx] < src0[src0_idx] ) {
      dest[i] = src1[src1_idx];
      src1_idx++;
    }

    // assertion

    else {
      test_fail( -1, 0, 0 );
    }

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

  //--------------------------------------------------------------------
  // Start counting stats
  //--------------------------------------------------------------------

  test_stats_on();

  int i = 0;

  // Because we need in-place sorting, we need to create a mutable temp
  // array.
  int temp0[size];

  for ( i = 0; i < size; i++ ) {
    temp0[i] = src[i];
  }

  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: distribute work and call sort_scalar()
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  // Each core does an independent quicksort

  q_arg_t q_args[4];

  for ( i = 0; i < 4; i++ ) {
    q_args[i].arr   = temp0;
    q_args[i].l_idx = i * size/4;
    q_args[i].r_idx = (i+1) * size/4 - 1;
  }

  for ( i = 1; i < 4; i++ ) {
    bthread_spawn( i, &quicksort, (void*) &(q_args[i]) );
  }

  // execute on core 0
  quicksort( (void*) &(q_args[0]) );

  for ( int i = 1; i < 4; i++ ) {
    bthread_join( i );
  }

  // Let core 1 merge first half

  int temp1[size/2];

  m_arg_t m_arg;

  m_arg.dest  = temp1;
  m_arg.src0  = temp0;
  m_arg.src1  = &(temp0[size/4]);
  m_arg.size0 = size/4;
  m_arg.size1 = size/4;

  bthread_spawn( 1, &merge, &m_arg );

  // core 0 merge the other half

  int temp2[size/2];

  merge_impl( temp2, &(temp0[size/2]), &(temp0[size*3/4]), size/4, size/4 );

  // wait for core 1

  bthread_join( 1 );

  // final merge

  merge_impl( dest, temp1, temp2, size/2, size/2 );

  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
  // LAB TASK: do bthread_join(), do the final reduction step here
  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''\/

  // Control thread serializes the final reduction


  // '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''/\
  //--------------------------------------------------------------------
  // Stop counting stats
  //--------------------------------------------------------------------

  test_stats_off();

  // verifies solution

  verify_results( dest, ref, size );

  return 0;
}
