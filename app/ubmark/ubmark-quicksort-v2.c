//========================================================================
// ubmark-quicksort-v2
//========================================================================
// Same algorithm, implemented by a different person. Nothing fancy; all
// array accesses are based on array indices instead of pointers.
//
// Author : Shunning Jiang
// Date   : Dec 6, 2016

#include "common.h"
#include "ubmark-sort.dat"

//------------------------------------------------------------------------
// quicksort-scalar
//------------------------------------------------------------------------

void quicksort_inplace( int *arr, int l, int r ) {

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

__attribute__ ((noinline))
void quicksort_scalar( int* dest, int* src, int size )
{
  int i;

  // we do an in-place quicksort, so we first copy the source to
  // destination

  for ( i = 0; i < size; i++ )
    dest[i] = src[i];

  quicksort_inplace( dest, 0, size-1 );
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
  int dest[size];

  int i;
  for ( i = 0; i < size; i++ )
    dest[i] = 0;

  test_stats_on();
  quicksort_scalar( dest, src, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}
