//========================================================================
// wprint
//========================================================================

//------------------------------------------------------------------------
// wprintf
//------------------------------------------------------------------------

#ifdef _RISCV

#include "common-wprint.h"
#include <stdarg.h>

void wprintf( const wchar_t* fmt... )
{
  va_list args;
  va_start(args, fmt);

  int flag = 0;
  while (*fmt != '\0') {
    if (*fmt == '%' ) {
      flag = 1;
    }
    else if ( flag && (*fmt == 'd') ) {
      wprint( va_arg(args, int) );
      flag = 0;
    }
    else if ( flag && (*fmt == 'C') ) {
      // note automatic conversion to integral type
      wprint( static_cast<wchar_t>(va_arg(args, int)) );
      flag = 0;
    }
    else if ( flag && (*fmt == 'S') ) {
      wprint( va_arg(args, wchar_t*) );
      flag = 0;
    }
    else {
      wprint( *fmt );
    }
    ++fmt;
  }
  va_end(args);
}

#else

// We always need at least something in an object file, otherwise
// the native build won't work. So we create a dummy function for native
// builds.

int common_( int arg )
{
  return arg;
}

#endif

