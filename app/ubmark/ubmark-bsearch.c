//========================================================================
// ubmark-bsearch
//========================================================================

#include "common.h"
#include "ubmark-bsearch.dat"

//------------------------------------------------------------------------
// bin_search_scalar
//------------------------------------------------------------------------

__attribute__ ((noinline))
void bin_search_scalar( int pos[], int keys[], int keys_sz,
                        int kv[], int kv_sz )
{
  int i;
  for ( i = 0; i < keys_sz; i++ ) {

    int key     = keys[i];
    int idx_min = 0;
    int idx_mid = kv_sz/2;
    int idx_max = kv_sz-1;

    int done = 0;
    pos[i] = -1;
    do {
      int midkey = kv[idx_mid];

      if ( key == midkey ) {
        pos[i] = idx_mid;
        done = 1;
      }

      if ( key > midkey )
        idx_min = idx_mid + 1;
      else if ( key < midkey )
        idx_max = idx_mid - 1;

      idx_mid = ( idx_min + idx_max ) / 2;

    } while ( !done && (idx_min <= idx_max) );

  }
}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int pos[], int ref[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    if ( !( pos[i] == ref[i] ) ) {
      test_fail( i, pos[i], ref[i] );
    }
  }
  test_pass();
}

//------------------------------------------------------------------------
// Test harness
//------------------------------------------------------------------------

int main( int argc, char* argv[] )
{
  int pos[keys_sz];

  int i;
  for ( i = 0; i < keys_sz; i++ )
    pos[i] = 0;

  test_stats_on();
  bin_search_scalar( pos, keys, keys_sz, kv, kv_sz );
  test_stats_off();

  verify_results( pos, ref, keys_sz );

  return 0;
}
