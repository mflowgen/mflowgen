//========================================================================
// example of using print
//========================================================================

#include "common-misc.h"
#include "common-wprint.h"

int main( int argc, char* argv[] )
{
  // Print some numbers and characters

  brg_wprint( 42    );
  brg_wprint( L' '  );
  brg_wprint( 13    );
  brg_wprint( L' '  );
  brg_wprint( 57    );
  brg_wprint( L'\n' );

  // Print some strings

  brg_wprint( L"Testing print function: \n" );
  brg_wprint( L"Hello, World!\n" );

  // Use printf

  brg_wprintf( L"number = %d\n", 42 );
  brg_wprintf( L"char   = %C\n", L'a' );
  brg_wprintf( L"string = %S\n", L"foobar" );

  brg_wprintf( L"number = %d, char = %C, string = %S \n", 42, L'a', L"foobar" );

  // Must end program with an exit, pass in status code

  brg_exit(0);
}

