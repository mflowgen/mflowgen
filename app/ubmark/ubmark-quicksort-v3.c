//========================================================================
// ubmark-quicksort-v3
//========================================================================
// Same algorithm, implemented by a different person. This code uses
// purely pointers to avoid the arithmetics to calculate the address
// based on array indices.
//
// Author : Shunning Jiang
// Date   : Dec 6, 2016

#include "common.h"
#include "ubmark-sort.dat"

//------------------------------------------------------------------------
// quicksort-scalar
//------------------------------------------------------------------------

void quicksort_inplace( int *l, int *r )
{
  int *i=l, *j=r, k;
  
  int x=*(l+((r-l)>>1));

  while (i<=j)
  {
    while (*i<x) ++i;
    while (*j>x) --j;
    if (i<=j)
    {
      k      = *i;
      *(i++) = *j;
      *(j--) = k;
    }
  }
  if (l<j)  quicksort_inplace(l, j);
  if (i<r)  quicksort_inplace(i, r);
}

__attribute__ ((noinline))
void quicksort_scalar( int* dest, int* src, int size )
{
  int i;

  // we do an in-place quicksort, so we first copy the source to
  // destination

  for ( i = 0; i < size; i++ )
    dest[i] = src[i];

  quicksort_inplace( dest, dest+size-1 );
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

