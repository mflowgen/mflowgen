//========================================================================
// matmul example ported from cilk-5.4.6
//========================================================================
// Ported by: Moyang Wang
// Jun. 19, 2015
//========================================================================
// Original Descriptions
//========================================================================
//  Rectangular matrix multiplication.

//  See the paper ``Cache-Oblivious Algorithms'', by
//  Matteo Frigo, Charles E. Leiserson, Harald Prokop, and
//  Sridhar Ramachandran, FOCS 1999, for an explanation of
//  why this algorithm is good for caches.

//  Author: Matteo Frigo

// static const char *ident __attribute__((__unused__))
//   = "$HeadURL: https://bradley.csail.mit.edu/svn/repos/cilk/5.4.3/examples/matmul.cilk $ $LastChangedBy: sukhaj $ $Rev: 517 $ $Date: 2003-10-27 10:05:37 -0500 (Mon, 27 Oct 2003) $";

// Copyright (c) 2003 Massachusetts Institute of Technology

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <cstring>

#include "common.h"
#include "wsrt.h"

#define _MT_PULL 1

// Support for enabling stats
//#ifdef _MIPS_ARCH_MAVEN
//#include <machine/cop0.h>
//#define set_stats_en( value_ ) \
  maven_set_cop0_stats_enable( value_ );
//#else
#define set_stats_en( value_ )
//#endif

typedef float REAL;

void zero(REAL *A, int n)
{
  int i, j;

  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      A[i * n + j] = 0.0;
    }
  }
}

void init(REAL *A, int n)
{
  int i, j;

  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      A[i * n + j] = (double)rand();
    }
  }
}

double maxerror(REAL *A, REAL *B, int n)
{
  int i, j;
  double error = 0.0;

  for (i = 0; i < n; i++) {
    for (j = 0; j < n; j++) {
      double diff = (A[i * n + j] - B[i * n + j]) / A[i * n + j];
      if (diff < 0)
        diff = -diff;
      if (diff > error)
        error = diff;
    }
  }
  return error;
}

void iter_matmul(REAL *A, REAL *B, REAL *C, int n)
{
  int i, j, k;

  for (i = 0; i < n; i++)
    for (k = 0; k < n; k++) {
      REAL c = 0.0;
      for (j = 0; j < n; j++)
        c += A[i * n + j] * B[j * n + k];
      C[i * n + k] = c;
    }
}


// A \in M(m, n)
// B \in M(n, p)
// C \in M(m, p)

#if defined(_RISCV) && defined(_MT_PULL)

struct RArgs {
  REAL *A;
  REAL *B;
  REAL *C;
  int   m;
  int   n;
  int   p;
  int   ld;
  int   add;
  RArgs( REAL* A_, REAL* B_, REAL* C_, int m_, int n_, int p_, int ld_, int add_ )
    : A(A_), B(B_), C(C_), m(m_), n(n_), p(p_), ld(ld_), add(add_) {}
};

void rec_matmul_kernel( void* args_vptr, void* null_ptr )
{
  RArgs* args_ptr = static_cast<RArgs*>( args_vptr );
  REAL* A = args_ptr->A;
  REAL* B = args_ptr->B;
  REAL* C = args_ptr->C;
  int   m = args_ptr->m;
  int   n = args_ptr->n;
  int   p = args_ptr->p;
  int  ld = args_ptr->ld;
  int add = args_ptr->add;

  if ((m + n + p) <= 8) {
    int i, j, k;
    // base case
    if (add) {
      for (i = 0; i < m; i++)
        for (k = 0; k < p; k++) {
          REAL c = 0.0;
          for (j = 0; j < n; j++)
            c += A[i * ld + j] * B[j * ld + k];
          C[i * ld + k] += c;
        }
    } else {
      for (i = 0; i < m; i++)
        for (k = 0; k < p; k++) {
          REAL c = 0.0;
          for (j = 0; j < n; j++)
            c += A[i * ld + j] * B[j * ld + k];
          C[i * ld + k] = c;
        }
    }
    return;
  }


  if (m >= n && n >= p) {

    int m1 = m >> 1;

    wsrt::TaskGroup tg;
    RArgs args1( A, B, C, m1, n, p, ld, add ), args2( A + m1 * ld, B, C + m1 * ld, m - m1, n, p, ld, add );
    wsrt::TaskDescriptor task1( &rec_matmul_kernel, &args1 ), task2( &rec_matmul_kernel, &args2 );
    tg.run( task1 );
    tg.run( task2 );
    tg.wait();
    // spawn rec_matmul(A, B, C, m1, n, p, ld, add);
    // spawn rec_matmul(A + m1 * ld, B, C + m1 * ld, m - m1, n, p, ld, add);
  }
  else if (n >= m && n >= p) {

    int n1 = n >> 1;

    wsrt::TaskGroup tg1;
    RArgs args1( A, B, C, m, n1, p, ld, add );
    wsrt::TaskDescriptor task1( &rec_matmul_kernel, &args1 );
    tg1.run( task1 );
    tg1.wait();

    wsrt::TaskGroup tg2;
    RArgs args2( A + n1, B + n1 * ld, C, m, n - n1, p, ld, 1 );
    wsrt::TaskDescriptor task2( &rec_matmul_kernel, &args2 );
    tg2.run( task2 );
    tg2.wait();
    // spawn rec_matmul(A, B, C, m, n1, p, ld, add);
    // sync;
    // spawn rec_matmul(A + n1, B + n1 * ld, C, m, n - n1, p, ld, 1);
  }
  else {

    int p1 = p >> 1;

    wsrt::TaskGroup tg;
    RArgs args1( A, B, C, m, n, p1, ld, add ), args2( A, B + p1, C + p1, m, n, p - p1, ld, add );
    wsrt::TaskDescriptor task1( &rec_matmul_kernel, &args1 ), task2( &rec_matmul_kernel, &args2 );
    tg.run( task1 );
    tg.run( task2 );
    tg.wait();
    // spawn rec_matmul(A, B, C, m, n, p1, ld, add);
    // spawn rec_matmul(A, B + p1, C + p1, m, n, p - p1, ld, add);
  }
}

void rec_matmul(REAL *A, REAL *B, REAL *C, int m, int n, int p, int ld, int add)
{
  wsrt::TaskGroup tg;
  RArgs args1( A, B, C, m, n, p, ld, add );
  wsrt::TaskDescriptor task1( &rec_matmul_kernel, &args1 );

  wsrt::task_scheduler_init();
  tg.run_and_wait( task1 );
  wsrt::task_scheduler_end();
}

# else

void rec_matmul(REAL *A, REAL *B, REAL *C, int m, int n, int p, int ld, int add)
{
  if ((m + n + p) <= 64) {
    int i, j, k;
    /* base case */
    if (add) {
      for (i = 0; i < m; i++)
        for (k = 0; k < p; k++) {
          REAL c = 0.0;
          for (j = 0; j < n; j++)
            c += A[i * ld + j] * B[j * ld + k];
          C[i * ld + k] += c;
        }
    } else {
      for (i = 0; i < m; i++)
        for (k = 0; k < p; k++) {
          REAL c = 0.0;
          for (j = 0; j < n; j++)
            c += A[i * ld + j] * B[j * ld + k];
          C[i * ld + k] = c;
        }
    }
  } else if (m >= n && n >= p) {
    int m1 = m >> 1;
    rec_matmul(A, B, C, m1, n, p, ld, add);
    rec_matmul(A + m1 * ld, B, C + m1 * ld, m - m1, n, p, ld, add);
  } else if (n >= m && n >= p) {
    int n1 = n >> 1;
    rec_matmul(A, B, C, m, n1, p, ld, add);
    rec_matmul(A + n1, B + n1 * ld, C, m, n - n1, p, ld, 1);
  } else {
    int p1 = p >> 1;
    rec_matmul(A, B, C, m, n, p1, ld, add);
    rec_matmul(A, B + p1, C + p1, m, n, p - p1, ld, add);
  }
}

#endif

int main(int argc, char *argv[])
{
  bthread_init();
  int n;
  double err;

  n = 5;

  REAL A[n*n];
  REAL B[n*n];
  REAL C1[n*n];
  REAL C2[n*n];

  init(A, n);
  init(B, n);
  zero(C1, n);
  zero(C2, n);

  //iter_matmul(A, B, C1, n);

  /* Timing. "Start" timers */
  rec_matmul(A, B, C2, n, n, n, n, 0);
  /* Timing. "Stop" timers */

  err = maxerror(C1, C2, n);

  brg_wprintf(L"err = %d\n",err);
  test_pass();

  return 0;
}
