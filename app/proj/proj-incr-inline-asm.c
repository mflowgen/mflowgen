//========================================================================
// proj-incr
//========================================================================
// Example C application that increments elements in an array.

#include "common.h"

//------------------------------------------------------------------------
// addu
//------------------------------------------------------------------------
// We usually encapsulate inline assembly in a small inline function.
// Since the _MIPS_ARCH_MAVEN preprocessor macro is only defined when
// cross-compiling, we can use this macro to provide two different
// implementations of the function: one version for when we are compiling
// natively and a different version (using inline assembly) when we are
// cross-compiling.

inline
int addu( int a, int b )
{
#ifdef _RISCV
  int result;
  asm ( "nop; nop; add %0, %1, %2; nop; nop" :
        "=r"(result) : "r"(a), "r"(b) );
  return result;
#else
  return a + b;
#endif
}

//------------------------------------------------------------------------
// Data
//------------------------------------------------------------------------

int array[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,  10, 11, 12, 13, 14, 15 };
int ref[]   = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 };

//------------------------------------------------------------------------
// incr_scalar
//------------------------------------------------------------------------

__attribute__ ((noinline))
void incr_scalar( int array[], int size )
{
  int i;
  for ( i = 0; i < size; i++ )
    array[i] = addu( array[i], 1 );
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
  incr_scalar( array, size );
  test_stats_off();

  verify_results( array, ref, size );

  return 0;
}

