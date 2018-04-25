//========================================================================
// ubmark-cmult
//========================================================================

#include "common.h"
#include "ubmark-cmult.dat"

//------------------------------------------------------------------------
// cmplx-mult-scalar
//------------------------------------------------------------------------

__attribute__ ((noinline))
void cmplx_mult_scalar( int dest[], int src0[],
                        int src1[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    dest[i*2]   = (src0[i*2] * src1[i*2]) - (src0[i*2+1] * src1[i*2+1]);
    dest[i*2+1] = (src0[i*2] * src1[i*2+1]) + (src0[i*2+1] * src1[i*2]);
  }
}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int dest[], int ref[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    if ( dest[i*2] != ref[i*2] )
      test_fail( i*2, dest[i*2], ref[i*2] );
    if ( dest[i*2+1] != ref[i*2+1] )
      test_fail( i*2+1, dest[i*2+1], ref[i*2+1] );
  }
  test_pass();
}

//------------------------------------------------------------------------
// Test harness
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  int dest[size*2];

  int i;
  for ( i = 0; i < size*2; i++ )
    dest[i] = 0;

  test_stats_on();
  cmplx_mult_scalar( dest, src0, src1, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}
