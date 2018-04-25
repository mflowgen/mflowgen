//========================================================================
// example of using print
//========================================================================

#include "common-misc.h"
#include "common-wprint.h"

int main( int argc, char* argv[] )
{
  // Print some numbers and characters

  wprint( 42    );
  wprint( L' '  );
  wprint( 13    );
  wprint( L' '  );
  wprint( 57    );
  wprint( L'\n' );

  // Print some strings

  wprint( L"Testing print function: \n" );
  wprint( L"Hello, World!\n" );

  // Use printf

  wprintf( L"number = %d\n", 42 );
  wprintf( L"char   = %C\n", L'a' );
  wprintf( L"string = %S\n", L"foobar" );

  wprintf( L"number = %d, char = %C, string = %S \n", 42, L'a', L"foobar" );

  // Must end program with an exit, pass in status code

  exit(0);
}

