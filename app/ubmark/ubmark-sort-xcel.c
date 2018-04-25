//========================================================================
// ubmark-sort-xcel
//========================================================================

#include "common.h"
#include "ubmark-sort.dat"

//------------------------------------------------------------------------
// sort_xcel
//------------------------------------------------------------------------
// The basic sorting accelerator protocol is in-place (we only give the
// accelerator a single array base pointer), so we first need to copy the
// source to the destination. Note that you are free to change the
// sorting accelerator protocol if you want to use an out-of-place
// algorithm, and you are also free to modify the source array and use it
// for temporary storage. This is what mergesort does.

__attribute__ ((noinline))
void sort_xcel( int *dest, int *src, int size )
{
  // Copy source to destination

  for ( int i = 0; i < size; i++ )
    dest[i] = src[i];

  // Do in-place sort

  asm volatile (
    "csrw 0x7E1, %[dest];\n"
    "csrw 0x7E2, %[size];\n"
    "csrw 0x7E0, x0     ;\n"
    "csrr x0,    0x7E0  ;\n"

    // Outputs from the inline assembly block

    :

    // Inputs to the inline assembly block

    : [dest] "r"(dest),
      [size] "r"(size)

    // Tell the compiler this accelerator read/writes memory

    : "memory"
  );
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
  sort_xcel( dest, src, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}

