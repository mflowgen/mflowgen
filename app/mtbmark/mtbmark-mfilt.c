//========================================================================
// mtbmark-mfilt
//========================================================================

#include "common.h"
#include "mtbmark-mfilt.dat"

//------------------------------------------------------------------------
// Argument struct
//------------------------------------------------------------------------
// This is used to pass arguments when we spawn work onto the cores.

typedef struct {
  uint* dest;   // pointer to dest array
  uint* mask;   // pointer to mask array
  uint* src;    // pointer to src array
  int   rbegin; // first row this core should process
  int   rend;   // (one past) last row this core should process
  int   ncols;  // number of columns
} arg_t;

//------------------------------------------------------------------------
// masked-filter
//------------------------------------------------------------------------

__attribute__ ((noinline))
void masked_filter_mt( void* arg_vptr )
{
  // Cast void* to argument pointer.

  arg_t* arg_ptr = (arg_t*) arg_vptr;

  // Create local variables for each field of the argument structure.

  uint* dest   = arg_ptr->dest;
  uint* mask   = arg_ptr->mask;
  uint* src    = arg_ptr->src;
  int   rbegin = arg_ptr->rbegin;
  int   rend   = arg_ptr->rend;
  int   ncols  = arg_ptr->ncols;

  // Do the actual work.

  uint coeff0 = 8;
  uint coeff1 = 6;
  uint norm_shamt = 5;

  for ( int ridx = rbegin; ridx < rend; ridx++ ) {
    for ( int cidx = 1; cidx < ncols-1; cidx++ ) {
      if ( mask[ ridx*ncols + cidx ] != 0 ) {
        uint out0 = ( src[ (ridx-1)*ncols + cidx     ] * coeff1 );
        uint out1 = ( src[ ridx*ncols     + (cidx-1) ] * coeff1 );
        uint out2 = ( src[ ridx*ncols     + cidx     ] * coeff0 );
        uint out3 = ( src[ ridx*ncols     + (cidx+1) ] * coeff1 );
        uint out4 = ( src[ (ridx+1)*ncols + cidx     ] * coeff1 );
        uint out  = out0 + out1 + out2 + out3 + out4;
        dest[ ridx*ncols + cidx ] = (byte)(out >> norm_shamt);
      }
      else
        dest[ ridx*ncols + cidx ] = src[ ridx*ncols + cidx ];
    }
  }
}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( uint dest[], uint ref[], int size )
{
  int i;
  for ( i = 0; i < size*size; i++ ) {
    if ( !( dest[i] == ref[i] ) ) {
      test_fail( i, dest[i], ref[i] );
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

  uint dest[size*size];

  for (int i=0;i<size*size;++i)
    dest[i] = 0;

  // Start counting stats.

  test_stats_on();

  // Determine how many elements cores 0, 1, and 2 will process. Core 3
  // will process all of the remaining elements. Core 3 might process a
  // few more elements than the others because size might not be evenly
  // divisible by four.

  int block_size = (size-2)/4;

  // Create four argument structures that include the array pointers and
  // what elements each core should process.

  arg_t arg0 = { dest, mask, src,     1,          1+  block_size, size };
  arg_t arg1 = { dest, mask, src, 1+  block_size, 1+2*block_size, size };
  arg_t arg2 = { dest, mask, src, 1+2*block_size, 1+3*block_size, size };
  arg_t arg3 = { dest, mask, src, 1+3*block_size, size-1,         size };

  // Spawn work onto cores 1, 2, and 3.

  bthread_spawn( 1, &masked_filter_mt, &arg1 );
  bthread_spawn( 2, &masked_filter_mt, &arg2 );
  bthread_spawn( 3, &masked_filter_mt, &arg3 );

  // Have core 0 also do some work.

  masked_filter_mt( &arg0 );

  // Wait for core 1, 2, and 3 to finish.

  bthread_join(1);
  bthread_join(2);
  bthread_join(3);

  // Stop counting stats

  test_stats_off();

  // Core 0 will verify the results.

  if ( bthread_get_core_id() == 0 )
    verify_results( dest, ref, size );

  return 0;

}
