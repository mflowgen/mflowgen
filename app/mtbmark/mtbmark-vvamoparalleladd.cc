//========================================================================
// mtbmark-vvadd
//========================================================================
// Each core will process one fourth of the src and dest arrays. So for
// example, if the arrays have 100 elements, core 0 will process elements
// 0 through 24, core 1 will process elements 25 through 49, and so on.

#include "common.h"
#include "wsrt.h"
#include "mtbmark-vvadd.dat"
//------------------------------------------------------------------------
// vvadd_wsrt
//------------------------------------------------------------------------

__attribute__ ((noinline))
void vvadd_wsrt( int dest[], int src0[], int src1[], int size )
{
  WSRT_PARALLEL_FOR2( size, (dest,src0,src1),
  ({
    for ( int i = range.begin(); i < range.end(); ++i ) {
      dest[i] = src0[i] + src1[i];
    }
  }));
}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int dest[], int ref[], int size )
{
  for ( int i = 0; i < size; i++ ) {
    if ( !( dest[i] == ref[i] ) ) {
      test_fail( i, dest[i], ref[i] );
    }
  }
  test_pass();
}

//------------------------------------------------------------------------
// main
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  // Initialize bare threads (bthread). This must happen as the first
  // thing in main()!

  bthread_init();

  // This array will be where the results are stored.

  /*
  int size = 100;

  int dest[] = {
     23,   0,  85,  88,  25,  71,  85,  57,   0,  38,
     25,  76,   2,  66,  45,  22,  93,  86,  98, 100,
     34,  57,  85,  55,  83,   3,  40,  98,  53,  43,
     80,  96,   9,  73,  10,  23,  70,  33,   1,  96,
     66,  83,  67,  10,  85,  75,  95,  75,  63,  15,
     37,  11,  10,  81,  55,  87,   3,  33,  91,  26,
     69,  73,  89,  91,  78,  100, 66,  89,  75,  61,
     56,  22,  88,  90,  34,  95,  31,  15,  50,  23,
     15,  47,   4,  91,  55,  19,  91,  82,  45,  67,
     25,  93,  61,  46,  73,   6,   0,   0,  19,  93
  };
  int src0[] = {
     23,   0,  85,  88,  25,  71,  85,  57,   0,  38,
     25,  76,   2,  66,  45,  22,  93,  86,  98, 100,
     34,  57,  85,  55,  83,   3,  40,  98,  53,  43,
     80,  96,   9,  73,  10,  23,  70,  33,   1,  96,
     66,  83,  67,  10,  85,  75,  95,  75,  63,  15,
     37,  11,  10,  81,  55,  87,   3,  33,  91,  26,
     69,  73,  89,  91,  78,  100, 66,  89,  75,  61,
     56,  22,  88,  90,  34,  95,  31,  15,  50,  23,
     15,  47,   4,  91,  55,  19,  91,  82,  45,  67,
     25,  93,  61,  46,  73,   6,   0,   0,  19,  93
  };
  int src1[] = {
     23,   0,  85,  88,  25,  71,  85,  57,   0,  38,
     25,  76,   2,  66,  45,  22,  93,  86,  98, 100,
     34,  57,  85,  55,  83,   3,  40,  98,  53,  43,
     80,  96,   9,  73,  10,  23,  70,  33,   1,  96,
     66,  83,  67,  10,  85,  75,  95,  75,  63,  15,
     37,  11,  10,  81,  55,  87,   3,  33,  91,  26,
     69,  73,  89,  91,  78,  100, 66,  89,  75,  61,
     56,  22,  88,  90,  34,  95,  31,  15,  50,  23,
     15,  47,   4,  91,  55,  19,  91,  82,  45,  67,
     25,  93,  61,  46,  73,   6,   0,   0,  19,  93
  };
  */
  int dest[size];
  int idx = 0;
  for(idx=0;idx<size;idx++)
      dest[idx] = 0;
  // Stop counting stats

  vvadd_wsrt( dest, src0, src1, size );
  // Core 0 will verify the results.

  if ( bthread_get_core_id() == 0 )
    verify_results( dest, ref, size );

  return 0;
}

