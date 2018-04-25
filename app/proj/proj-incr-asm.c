//========================================================================
// proj-incr
//========================================================================
// Example C application that increments elements in an array.

#include "common.h"

//------------------------------------------------------------------------
// Data
//------------------------------------------------------------------------

int array[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,  10, 11, 12, 13, 14, 15 };
int ref[]   = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 };

//------------------------------------------------------------------------
// incr_asm
//------------------------------------------------------------------------
// Declare function which is defined using hand-coded assembly in
// proj-incr-asm.S

extern "C" {

  void incr_asm( int* array, int size );

}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int array[], int ref[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    if ( !( array[i] == ref[i] ) ) {
      test_fail( i, array[i], ref[i] );
    }
  }
  test_pass();
}

//------------------------------------------------------------------------
// Test Harness
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  int size = 16;

  test_stats_on();
  incr_asm( array, size );
  test_stats_off();

  verify_results( array, ref, size );

  return 0;
}

