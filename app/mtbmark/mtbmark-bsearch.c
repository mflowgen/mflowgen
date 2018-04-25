//========================================================================
// mtbmark-bsearch
//========================================================================

#include "common.h"
#include "mtbmark-bsearch.dat"

typedef struct {
  int* kv;     // pointer to kv array
  int  kv_sz;  // the size of kv array
  int* pos;    // pointer to pos array
  int* keys;   // pointer to keys array
  int  begin;  // first element this core should process
  int  end;    // (one past) last element this core should process
} arg_t;

//------------------------------------------------------------------------
// bin-search
//------------------------------------------------------------------------

__attribute__ ((noinline))
void bin_search_mt( void* arg_vptr )
{
  // Cast void* to argument pointer.

  arg_t* arg_ptr = (arg_t*) arg_vptr;

  // Create local variables for each field of the argument structure.

  int* kv    = arg_ptr->kv;
  int  kv_sz = arg_ptr->kv_sz;
  int* pos   = arg_ptr->pos;
  int* keys  = arg_ptr->keys;
  int  begin = arg_ptr->begin;
  int  end   = arg_ptr->end;

  // Do the actual work.

  for (int i=begin; i<end; ++i)
  {
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
  // Initialize bare threads (bthread). This must happen as the first
  // thing in main()!

  bthread_init();

  // This array will be where the results are stored.

  int pos[keys_sz];

  // Start counting stats.

  test_stats_on();

  // Determine how many elements cores 0, 1, and 2 will process. Core 3
  // will process all of the remaining elements. Core 3 might process a
  // few more elements than the others because size might not be evenly
  // divisible by four.

  int block_size = keys_sz/4;

  // Create four argument structures that include the array pointers and
  // what elements each core should process.

  arg_t arg0 = { kv, kv_sz, pos, keys,   0,            block_size };
  arg_t arg1 = { kv, kv_sz, pos, keys,   block_size, 2*block_size };
  arg_t arg2 = { kv, kv_sz, pos, keys, 2*block_size, 3*block_size };
  arg_t arg3 = { kv, kv_sz, pos, keys, 3*block_size, keys_sz      };

  // Spawn work onto cores 1, 2, and 3.

  bthread_spawn( 1, &bin_search_mt, &arg1 );
  bthread_spawn( 2, &bin_search_mt, &arg2 );
  bthread_spawn( 3, &bin_search_mt, &arg3 );

  // Have core 0 also do some work.

  bin_search_mt( &arg0 );

  // Wait for core 1, 2, and 3 to finish.

  bthread_join(1);
  bthread_join(2);
  bthread_join(3);

  // Stop counting stats

  test_stats_off();

  // Core 0 will verify the results.

  if ( bthread_get_core_id() == 0 )
    verify_results( pos, ref, keys_sz );

  return 0;

}
