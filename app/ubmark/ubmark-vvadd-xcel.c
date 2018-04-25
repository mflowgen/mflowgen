//========================================================================
// ubmark-vvadd-xcel
//========================================================================

#include "common.h"
#include "ubmark-vvadd.dat"

//------------------------------------------------------------------------
// vvadd_xcel
//------------------------------------------------------------------------

#ifdef _RISCV

__attribute__ ((noinline))
void vvadd_xcel( int *dest, int *src0, int *src1, int size )
{

  asm volatile (
    "csrw 0x7E1, %[src0];\n"
    "csrw 0x7E2, %[src1];\n"
    "csrw 0x7E3, %[dest];\n"
    "csrw 0x7E4, %[size];\n"
    "csrw 0x7E0, x0     ;\n"
    "csrr x0,    0x7E0  ;\n"

    // Outputs from the inline assembly block

    :

    // Inputs to the inline assembly block

    : [src0] "r"(src0),
      [src1] "r"(src1),
      [dest] "r"(dest),
      [size] "r"(size)

    // Tell the compiler this accelerator read/writes memory

    : "memory"
  );
}

#else

// for native

__attribute__ ((noinline))
void vvadd_xcel( int *dest, int *src0, int *src1, int size )
{
  int i;
  for ( i = 0; i < size; i++ )
    dest[i] = src0[i] + src1[i];
}

#endif

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
  vvadd_xcel( dest, src0, src1, size );
  test_stats_off();

  verify_results( dest, ref, size );

  return 0;
}

