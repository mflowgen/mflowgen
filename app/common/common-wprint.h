//========================================================================
// wprint
//========================================================================
// A simple subproject that enables TinyRV2 applications to print an
// integer, character, or string to the terminal as well as a _very_
// simple wprintf function.
//
// Note that using chars would require manipulating bytes, but TinyRV2
// only supports lw/sw. So we instead use wchar_t which is a "wide 4B
// character". Technically this is for unicode, but it still works fine
// with ASCII characters. This does mean that all character literals need
// to have the L prefix like this:
//
//  wprint( L'a'); wprint( L'b'); wprint( L'c');
//  wprint( L"abc" );
//  wprintf( L"number=%d, char=%C, string=%S", 42, L'a', L"abc" )
//

#ifndef COMMON_WPRINT_H
#define COMMON_WPRINT_H

#ifndef _RISCV
#include <wchar.h>
#endif

//------------------------------------------------------------------------
// wprint integer
//------------------------------------------------------------------------
// Print a single integer to the terminal in decimal format.

#ifdef _RISCV

inline
void wprint( int i )
{
  asm ( "csrw 0x7C0, %0" :: "r"(0x00030000) );
  asm ( "csrw 0x7C0, %0" :: "r"(i) );
}
#else

inline
void wprint( int i )
{
  wprintf( L"%d", i );
}

#endif

//------------------------------------------------------------------------
// wprint character
//------------------------------------------------------------------------
// Print a single character. As mentioned above, we must use wchar_t
// since TinyRV2 only supports lw/sw.

#ifdef _RISCV

inline
void wprint( wchar_t c )
{
  asm ( "csrw 0x7C0, %0" :: "r"(0x00030001) );
  asm ( "csrw 0x7C0, %0" :: "r"(c) );
}

#else

inline
void wprint( wchar_t c )
{
  wprintf( L"%C", c );
}

#endif

//------------------------------------------------------------------------
// wprint string
//------------------------------------------------------------------------
// Print a string. As mentioned above, we must use wchar_t since TinyRV2
// only supports lw/sw.

#ifdef _RISCV

inline
void wprint( const wchar_t* p )
{
  asm ( "csrw 0x7C0, %0" :: "r"(0x00030002) );
  while ( *p != 0 ) {
    asm ( "csrw 0x7C0, %0" :: "r"(*p) );
    p++;
  }
  asm ( "csrw 0x7C0, %0" :: "r"(*p) );
}

#else

inline
void wprint( const wchar_t* str )
{
  wprintf( L"%S", str );
}

#endif

//------------------------------------------------------------------------
// wprintf
//------------------------------------------------------------------------
// A _very_ simple wprintf. Only supports three format flags:
//
//  %d : integer in decimal format
//  %C : character
//  %S : string
//

#ifdef _RISCV

void wprintf( const wchar_t* fmt... );

#endif

#endif /* COMMON_WPRINT_H */

