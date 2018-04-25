//========================================================================
// ubmark-null-xcel
//========================================================================
// This is a test, not really a ubmark. It assumes we have a NullXcel
// accelerator and illustrates how we can read and write the xr0 register
// in the NullXcel using inline assembly.

#include "common.h"

//------------------------------------------------------------------------
// null_xcel
//------------------------------------------------------------------------

__attribute__ ((noinline))
unsigned int null_xcel( unsigned int in )
{
  unsigned int result;
  asm volatile (
    "csrw 0x7E0,     %[in];\n"
    "csrr %[result], 0x7E0;\n"

    // Outputs from the inline assembly block

    : [result] "=r"(result)

    // Inputs to the inline assembly block

    : [in] "r"(in)

  );
  return result;
}

//------------------------------------------------------------------------
// Test Harness
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  unsigned int result = null_xcel( 0xdeadbeef );

  if ( result == 0xdeadbeef )
    test_pass();
  else
    test_fail( 0, result, 0xdeadbeef );

  return 0;
}
