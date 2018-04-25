//========================================================================
// ubmark-vvadd-xcel-strip
//========================================================================

#include "common.h"
#include "ubmark-vvadd.dat"

//------------------------------------------------------------------------
// vvadd-scalar
//------------------------------------------------------------------------

void vvadd_xcel( int *dest, int *src0, int *src1, int size )
{
  asm (
    ".set noat          \n"
    "mtx %[src0], $1, 0 \n"
    "mtx %[src1], $2, 0 \n"
    "mtx %[dest], $3, 0 \n"
    "mtx %[size], $4, 0 \n"
    "mtx $0,      $0, 0 \n"
    "mfx $0,      $0, 0 \n"
    ".set at            \n"

    // Outputs from the inline assembly block

    :

    // Inputs to the inline assembly block

    : [src0] "r"(src0),
      [src1] "r"(src1),
      [dest] "r"(dest),
      [size] "r"(size)

  );
}

__attribute__ ((noinline))
void vvadd_xcel_top( int* dest, int* src0, int* src1, int size ) {

  int iter, i;

  // assume our hardware accel vvadd only supports sizes of exactly 32
  iter = size / 32;

  for ( i = 0; i < iter; i++ )
    vvadd_xcel( dest[32*i], src0[32*i], src1[32*i], 32 );

  // extra cleanup code if iter doesn't evenly divide size
  if ( size > 32*iter ) {

    for ( i = 32*iter; i < size; i++ )
      dest[i] = src0[i] + src1[i];
    
  }
  
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
  vvadd_xcel_top( dest, src0, src1, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}

