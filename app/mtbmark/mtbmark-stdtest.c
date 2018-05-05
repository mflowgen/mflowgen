//========================================================================
// mtbmark-vvadd
//========================================================================
// Each core will process one fourth of the src and dest arrays. So for
// example, if the arrays have 100 elements, core 0 will process elements
// 0 through 24, core 1 will process elements 25 through 49, and so on.

#include "common.h"
#include "wsrt.h"
#include <vector>
#include "stdlib.h"

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  // Initialize bare threads (bthread). This must happen as the first
  // thing in main()!

  bthread_init();

  // This array will be where the results are stored.
  std::vector<int> test(100);
  int * test2 = (int*)malloc(sizeof(int)*100);
  for(int i=0;i<100;i++) {
      test[i] = i;
      test2[i] = 100 - i;
  }

  for(int i=0;i<100;i++) {
      if ( test[i] != i)
          test_fail( i, test[i], i );
      if( (test2[i] + i) != 100 )
          test_fail( i, test2[i], 100 );
  }
  brg_wprintf(L"malloc addr = %d\n",(int)test2);

  test_pass();

  return 0;
}

