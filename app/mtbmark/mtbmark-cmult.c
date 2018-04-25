//========================================================================
// mtbmark-cmult
//========================================================================

#include "common.h"
#include "mtbmark-cmult.dat"

//------------------------------------------------------------------------
// Argument struct
//------------------------------------------------------------------------
// This is used to pass arguments when we spawn work onto the cores.

typedef struct {
  int* dest;  // pointer to dest array
  int* src0;  // pointer to src0 array
  int* src1;  // pointer to src1 array
  int  begin; // first element this core should process
  int  end;   // (one past) last element this core should process
} arg_t;

//------------------------------------------------------------------------
// cmplx-mult
//------------------------------------------------------------------------

__attribute__ ((noinline))
void cmplx_mult_mt( void* arg_vptr )
{
  // Cast void* to argument pointer.

  arg_t* arg_ptr = (arg_t*) arg_vptr;

  // Create local variables for each field of the argument structure.

  int* dest  = arg_ptr->dest;
  int* src0  = arg_ptr->src0;
  int* src1  = arg_ptr->src1;
  int  begin = arg_ptr->begin;
  int  end   = arg_ptr->end;

  // Do the actual work.

  for ( int i = begin; i < end; i++ ) {
    dest[i*2]   = (src0[i*2] * src1[i*2]) - (src0[i*2+1] * src1[i*2+1]);
    dest[i*2+1] = (src0[i*2] * src1[i*2+1]) + (src0[i*2+1] * src1[i*2]);
  }
}

//------------------------------------------------------------------------
// verify_results
//------------------------------------------------------------------------

void verify_results( int dest[], int ref[], int size )
{
  int i;
  for ( i = 0; i < size; i++ ) {
    if ( dest[i*2] != ref[i*2] )
      test_fail( i*2, dest[i*2], ref[i*2] );
    if ( dest[i*2+1] != ref[i*2+1] )
      test_fail( i*2+1, dest[i*2+1], ref[i*2+1] );
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

  int dest[size*2];

  // Start counting stats.

  test_stats_on();

  // Determine how many elements cores 0, 1, and 2 will process. Core 3
  // will process all of the remaining elements. Core 3 might process a
  // few more elements than the others because size might not be evenly
  // divisible by four.

  int block_size = size/4;

  // Create four argument structures that include the array pointers and
  // what elements each core should process.

  arg_t arg0 = { dest, src0, src1,   0,            block_size };
  arg_t arg1 = { dest, src0, src1,   block_size, 2*block_size };
  arg_t arg2 = { dest, src0, src1, 2*block_size, 3*block_size };
  arg_t arg3 = { dest, src0, src1, 3*block_size, size         };

  // Spawn work onto cores 1, 2, and 3.

  bthread_spawn( 1, &cmplx_mult_mt, &arg1 );
  bthread_spawn( 2, &cmplx_mult_mt, &arg2 );
  bthread_spawn( 3, &cmplx_mult_mt, &arg3 );

  // Have core 0 also do some work.

  cmplx_mult_mt( &arg0 );

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
