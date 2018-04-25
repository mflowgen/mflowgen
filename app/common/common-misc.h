//========================================================================
// common-misc
//========================================================================

#ifndef COMMON_MISC_H
#define COMMON_MISC_H

#ifndef _RISCV
#include <stdio.h>
#include <stdlib.h>
#endif

//------------------------------------------------------------------------
// Typedefs
//------------------------------------------------------------------------

typedef unsigned char byte;
typedef unsigned int  uint;

//------------------------------------------------------------------------
// exit
//------------------------------------------------------------------------
// exit the program with the given status code

#ifdef _RISCV

inline
void exit( int i )
{
  int msg = 0x00010000 | i;
  asm ( "csrw 0x7C0, %0;" :: "r"(msg) );
}

#endif

//------------------------------------------------------------------------
// test_fail
//------------------------------------------------------------------------

#ifdef _RISCV

inline
void test_fail( int index, int val, int ref )
{
  int status = 0x00020001;
  asm( "csrw 0x7C0, %0;"
       "csrw 0x7C0, %1;"
       "csrw 0x7C0, %2;"
       "csrw 0x7C0, %3;"
       :
       : "r" (status), "r" (index), "r" (val), "r" (ref)
  );
}

#else

inline
void test_fail( int index, int val, int ref )
{
  printf( "\n" );
  printf( "  [ FAILED ] dest[%d] != ref[%d] (%d != %d)\n",
                          index, index, val, ref );
  printf( "\n" );
  exit(1);
}

#endif

//------------------------------------------------------------------------
// test_pass
//------------------------------------------------------------------------

#ifdef _RISCV

inline
void test_pass()
{
  int status = 0x00020000;
  asm( "csrw 0x7C0, %0;"
       :
       : "r" (status)
  );
}

#else

inline
void test_pass()
{
  printf( "\n" );
  printf( "  [ passed ] \n" );
  printf( "\n" );
  exit(0);
}

#endif

//------------------------------------------------------------------------
// test_stats_on
//------------------------------------------------------------------------

#ifdef _RISCV

inline
void test_stats_on()
{
  int status = 1;
  asm( "csrw 0x7C1, %0;"
       :
       : "r" (status)
  );
}

#else

void test_stats_on()
{ }

#endif

//------------------------------------------------------------------------
// test_stats_off
//------------------------------------------------------------------------

#ifdef _RISCV

inline
void test_stats_off()
{
  int status = 0;
  asm( "csrw 0x7C1, %0;"
       :
       : "r" (status)
  );
}

#else

void test_stats_off()
{ }

#endif

#endif /* COMMON_MISC_H */

