//========================================================================
// ubmark-vvadd
//========================================================================

#include "common.h"
#include "ubmark-vvadd.dat"

//------------------------------------------------------------------------
// vvadd-scalar
//------------------------------------------------------------------------

__attribute__ ((noinline))
void vvadd_scalar( int *dest, int *src0, int *src1, int size )
{
  int i;
  for ( i = 0; i < size; i++ )
    dest[i] = src0[i] + src1[i];
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
  vvadd_scalar( dest, src0, src1, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}
