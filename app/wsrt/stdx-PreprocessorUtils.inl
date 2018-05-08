//========================================================================
// stdx-PreprocessorUtils.inl
//========================================================================
// Currently our implmentation makes extensive use of two GNU CPP
// variadic macro extensions: the ability to name variadic arguments and
// the ability for the prepocessor to remove a common preceeding a
// variadic argument use if the variadic argument list is empty. Since
// there seems to be no portable way to achieve the same functionality,
// we have included a check in stdx.ac which will fail if these
// extensions are not available.
//
// To understand these extension assume we have a macro defined as such:
//
//  #define FOO( args_... ) dummy, ## args_
//
// This will expand as follows:
//
//  FOO( a, b, c ) expands to "dummy, a, b, c"
//  FOO( a, b )    expands to "dummy, a, b"
//  FOO( a )       expands to "dummy, a"
//  FOO()          expands to "dummy"
//
// Notice that with no arguments, GNU CPP _removes_ the comma before
// args. This allows us to cleanly differentiate between one and zero
// arguments. For more information on the GNU CPP variadic macro
// extensions see:
// http://gcc.gnu.org/onlinedocs/gcc/Variadic-Macros.html

//------------------------------------------------------------------------
// STDX_PP_CONCAT
//------------------------------------------------------------------------

#define STDX_PP_CONCAT_H1( res_ ) res_

#define STDX_PP_CONCAT_H0( a_, b_ ) \
  STDX_PP_CONCAT_H1( a_ ## b_ )

#define STDX_PP_CONCAT_( a_, b_ ) \
  STDX_PP_CONCAT_H0( a_, b_ )

//------------------------------------------------------------------------
// STDX_PP_CONCATN
//------------------------------------------------------------------------

#define STDX_PP_CONCAT2_( a_, b_ ) \
  STDX_PP_CONCAT( a_, b_ )

#define STDX_PP_CONCAT3_( a_, b_, c_ ) \
  STDX_PP_CONCAT( STDX_PP_CONCAT2( a_, b_ ), c_ )

#define STDX_PP_CONCAT4_( a_, b_, c_, d_ ) \
  STDX_PP_CONCAT( STDX_PP_CONCAT3( a_, b_, c_ ), d_ )

#define STDX_PP_CONCAT5_( a_, b_, c_, d_, e_ ) \
  STDX_PP_CONCAT( STDX_PP_CONCAT4( a_, b_, c_, d_ ), e_ )

//------------------------------------------------------------------------
// STDX_PP_STRINGIFY
//------------------------------------------------------------------------

#define STDX_PP_STRINGIFY_H0( a_ ) #a_

#define STDX_PP_STRINGIFY_( a_ ) \
  STDX_PP_STRINGIFY_H0( a_ )

//------------------------------------------------------------------------
// STDX_PP_NUM_TO_BOOL
//------------------------------------------------------------------------

#define STDX_PP_NUM_TO_BOOL_0  0
#define STDX_PP_NUM_TO_BOOL_1  1
#define STDX_PP_NUM_TO_BOOL_2  1
#define STDX_PP_NUM_TO_BOOL_3  1
#define STDX_PP_NUM_TO_BOOL_4  1
#define STDX_PP_NUM_TO_BOOL_5  1
#define STDX_PP_NUM_TO_BOOL_6  1
#define STDX_PP_NUM_TO_BOOL_7  1

#define STDX_PP_NUM_TO_BOOL_8  1
#define STDX_PP_NUM_TO_BOOL_9  1
#define STDX_PP_NUM_TO_BOOL_10 1
#define STDX_PP_NUM_TO_BOOL_11 1
#define STDX_PP_NUM_TO_BOOL_12 1
#define STDX_PP_NUM_TO_BOOL_13 1
#define STDX_PP_NUM_TO_BOOL_14 1
#define STDX_PP_NUM_TO_BOOL_15 1

#define STDX_PP_NUM_TO_BOOL_16 1
#define STDX_PP_NUM_TO_BOOL_17 1
#define STDX_PP_NUM_TO_BOOL_18 1
#define STDX_PP_NUM_TO_BOOL_19 1
#define STDX_PP_NUM_TO_BOOL_20 1
#define STDX_PP_NUM_TO_BOOL_21 1
#define STDX_PP_NUM_TO_BOOL_22 1
#define STDX_PP_NUM_TO_BOOL_23 1

#define STDX_PP_NUM_TO_BOOL_24 1
#define STDX_PP_NUM_TO_BOOL_25 1
#define STDX_PP_NUM_TO_BOOL_26 1
#define STDX_PP_NUM_TO_BOOL_27 1
#define STDX_PP_NUM_TO_BOOL_28 1
#define STDX_PP_NUM_TO_BOOL_29 1
#define STDX_PP_NUM_TO_BOOL_30 1
#define STDX_PP_NUM_TO_BOOL_31 1

#define STDX_PP_NUM_TO_BOOL_32 1

#define STDX_PP_NUM_TO_BOOL_( num_ ) \
  STDX_PP_CONCAT( STDX_PP_NUM_TO_BOOL_, num_ )

//------------------------------------------------------------------------
// STDX_PP_AND
//------------------------------------------------------------------------

#define STDX_PP_AND_00 0
#define STDX_PP_AND_01 0
#define STDX_PP_AND_10 0
#define STDX_PP_AND_11 1

#define STDX_PP_AND_( cond0_, cond1_ )                                  \
  STDX_PP_CONCAT( STDX_PP_AND_,                                         \
    STDX_PP_CONCAT( STDX_PP_NUM_TO_BOOL( cond0_ ),                      \
                     STDX_PP_NUM_TO_BOOL( cond1_ ) ))                   \

//------------------------------------------------------------------------
// STDX_PP_OR
//------------------------------------------------------------------------

#define STDX_PP_OR_00 0
#define STDX_PP_OR_01 1
#define STDX_PP_OR_10 1
#define STDX_PP_OR_11 1

#define STDX_PP_OR_( cond0_, cond1_ )                                   \
  STDX_PP_CONCAT( STDX_PP_OR_,                                          \
    STDX_PP_CONCAT( STDX_PP_NUM_TO_BOOL( cond0_ ),                      \
                    STDX_PP_NUM_TO_BOOL( cond1_ ) ))                    \

//------------------------------------------------------------------------
// STDX_PP_IF
//------------------------------------------------------------------------

#define STDX_PP_IF_0( m0_, m1_ ) m1_
#define STDX_PP_IF_1( m0_, m1_ ) m0_

#define STDX_PP_IF_( cond_, m0_, m1_ )                                  \
  STDX_PP_CONCAT( STDX_PP_IF_, STDX_PP_NUM_TO_BOOL( cond_ ) )           \
    ( m0_, m1_ )                                                        \

//------------------------------------------------------------------------
// STDX_PP_COMMA_IF
//------------------------------------------------------------------------

#define STDX_PP_COMMA_IF_H0()

#define STDX_PP_COMMA_IF_( cond_ ) \
  STDX_PP_IF( cond_, STDX_PP_COMMA, STDX_PP_COMMA_IF_H0 ) ()

//------------------------------------------------------------------------
// STDX_PP_STRIP_PAREN
//------------------------------------------------------------------------

#define STDX_PP_STRIP_PAREN_H0( items_... ) items_

#define STDX_PP_STRIP_PAREN_( a_ ) \
  STDX_PP_STRIP_PAREN_H0 a_

//------------------------------------------------------------------------
// STDX_PP_LOOP_X0
//------------------------------------------------------------------------

#define STDX_PP_LOOP_X0_0(m,a...)
#define STDX_PP_LOOP_X0_1(m,a...)                            m(0,##a)
#define STDX_PP_LOOP_X0_2(m,a...)  STDX_PP_LOOP_X0_1(m,##a)  m(1,##a)
#define STDX_PP_LOOP_X0_3(m,a...)  STDX_PP_LOOP_X0_2(m,##a)  m(2,##a)
#define STDX_PP_LOOP_X0_4(m,a...)  STDX_PP_LOOP_X0_3(m,##a)  m(3,##a)
#define STDX_PP_LOOP_X0_5(m,a...)  STDX_PP_LOOP_X0_4(m,##a)  m(4,##a)
#define STDX_PP_LOOP_X0_6(m,a...)  STDX_PP_LOOP_X0_5(m,##a)  m(5,##a)
#define STDX_PP_LOOP_X0_7(m,a...)  STDX_PP_LOOP_X0_6(m,##a)  m(6,##a)

#define STDX_PP_LOOP_X0_8(m,a...)  STDX_PP_LOOP_X0_7(m,##a)  m(7,##a)
#define STDX_PP_LOOP_X0_9(m,a...)  STDX_PP_LOOP_X0_8(m,##a)  m(8,##a)
#define STDX_PP_LOOP_X0_10(m,a...) STDX_PP_LOOP_X0_9(m,##a)  m(9,##a)
#define STDX_PP_LOOP_X0_11(m,a...) STDX_PP_LOOP_X0_10(m,##a) m(10,##a)
#define STDX_PP_LOOP_X0_12(m,a...) STDX_PP_LOOP_X0_11(m,##a) m(11,##a)
#define STDX_PP_LOOP_X0_13(m,a...) STDX_PP_LOOP_X0_12(m,##a) m(12,##a)
#define STDX_PP_LOOP_X0_14(m,a...) STDX_PP_LOOP_X0_13(m,##a) m(13,##a)
#define STDX_PP_LOOP_X0_15(m,a...) STDX_PP_LOOP_X0_14(m,##a) m(14,##a)

#define STDX_PP_LOOP_X0_16(m,a...) STDX_PP_LOOP_X0_15(m,##a) m(15,##a)
#define STDX_PP_LOOP_X0_17(m,a...) STDX_PP_LOOP_X0_16(m,##a) m(16,##a)
#define STDX_PP_LOOP_X0_18(m,a...) STDX_PP_LOOP_X0_17(m,##a) m(17,##a)
#define STDX_PP_LOOP_X0_19(m,a...) STDX_PP_LOOP_X0_18(m,##a) m(18,##a)
#define STDX_PP_LOOP_X0_20(m,a...) STDX_PP_LOOP_X0_19(m,##a) m(19,##a)
#define STDX_PP_LOOP_X0_21(m,a...) STDX_PP_LOOP_X0_20(m,##a) m(20,##a)
#define STDX_PP_LOOP_X0_22(m,a...) STDX_PP_LOOP_X0_21(m,##a) m(21,##a)
#define STDX_PP_LOOP_X0_23(m,a...) STDX_PP_LOOP_X0_22(m,##a) m(22,##a)

#define STDX_PP_LOOP_X0_24(m,a...) STDX_PP_LOOP_X0_23(m,##a) m(23,##a)
#define STDX_PP_LOOP_X0_25(m,a...) STDX_PP_LOOP_X0_24(m,##a) m(24,##a)
#define STDX_PP_LOOP_X0_26(m,a...) STDX_PP_LOOP_X0_25(m,##a) m(25,##a)
#define STDX_PP_LOOP_X0_27(m,a...) STDX_PP_LOOP_X0_26(m,##a) m(26,##a)
#define STDX_PP_LOOP_X0_28(m,a...) STDX_PP_LOOP_X0_27(m,##a) m(27,##a)
#define STDX_PP_LOOP_X0_29(m,a...) STDX_PP_LOOP_X0_28(m,##a) m(28,##a)
#define STDX_PP_LOOP_X0_30(m,a...) STDX_PP_LOOP_X0_29(m,##a) m(29,##a)
#define STDX_PP_LOOP_X0_31(m,a...) STDX_PP_LOOP_X0_30(m,##a) m(30,##a)

#define STDX_PP_LOOP_X0_32(m,a...) STDX_PP_LOOP_X0_31(m,##a) m(31,##a)

#define STDX_PP_LOOP_X0_( count_, m_, args_... ) \
  STDX_PP_CONCAT( STDX_PP_LOOP_X0_, count_ ) ( m_, ## args_)

#define STDX_PP_LOOP_X0( count_, m_, args_... ) \
  STDX_PP_LOOP_X0_( count_, m_, ## args_ )

#define STDX_PP_LOOP_( count_, m_, args_... ) \
  STDX_PP_LOOP_X0_( count_, m_, ## args_ )

//------------------------------------------------------------------------
// STDX_PP_LOOP_X1
//------------------------------------------------------------------------

#define STDX_PP_LOOP_X1_0(m,a...)
#define STDX_PP_LOOP_X1_1(m,a...)                            m(0,##a)
#define STDX_PP_LOOP_X1_2(m,a...)  STDX_PP_LOOP_X1_1(m,##a)  m(1,##a)
#define STDX_PP_LOOP_X1_3(m,a...)  STDX_PP_LOOP_X1_2(m,##a)  m(2,##a)
#define STDX_PP_LOOP_X1_4(m,a...)  STDX_PP_LOOP_X1_3(m,##a)  m(3,##a)
#define STDX_PP_LOOP_X1_5(m,a...)  STDX_PP_LOOP_X1_4(m,##a)  m(4,##a)
#define STDX_PP_LOOP_X1_6(m,a...)  STDX_PP_LOOP_X1_5(m,##a)  m(5,##a)
#define STDX_PP_LOOP_X1_7(m,a...)  STDX_PP_LOOP_X1_6(m,##a)  m(6,##a)

#define STDX_PP_LOOP_X1_8(m,a...)  STDX_PP_LOOP_X1_7(m,##a)  m(7,##a)
#define STDX_PP_LOOP_X1_9(m,a...)  STDX_PP_LOOP_X1_8(m,##a)  m(8,##a)
#define STDX_PP_LOOP_X1_10(m,a...) STDX_PP_LOOP_X1_9(m,##a)  m(9,##a)
#define STDX_PP_LOOP_X1_11(m,a...) STDX_PP_LOOP_X1_10(m,##a) m(10,##a)
#define STDX_PP_LOOP_X1_12(m,a...) STDX_PP_LOOP_X1_11(m,##a) m(11,##a)
#define STDX_PP_LOOP_X1_13(m,a...) STDX_PP_LOOP_X1_12(m,##a) m(12,##a)
#define STDX_PP_LOOP_X1_14(m,a...) STDX_PP_LOOP_X1_13(m,##a) m(13,##a)
#define STDX_PP_LOOP_X1_15(m,a...) STDX_PP_LOOP_X1_14(m,##a) m(14,##a)

#define STDX_PP_LOOP_X1_16(m,a...) STDX_PP_LOOP_X1_15(m,##a) m(15,##a)
#define STDX_PP_LOOP_X1_17(m,a...) STDX_PP_LOOP_X1_16(m,##a) m(16,##a)
#define STDX_PP_LOOP_X1_18(m,a...) STDX_PP_LOOP_X1_17(m,##a) m(17,##a)
#define STDX_PP_LOOP_X1_19(m,a...) STDX_PP_LOOP_X1_18(m,##a) m(18,##a)
#define STDX_PP_LOOP_X1_20(m,a...) STDX_PP_LOOP_X1_19(m,##a) m(19,##a)
#define STDX_PP_LOOP_X1_21(m,a...) STDX_PP_LOOP_X1_20(m,##a) m(20,##a)
#define STDX_PP_LOOP_X1_22(m,a...) STDX_PP_LOOP_X1_21(m,##a) m(21,##a)
#define STDX_PP_LOOP_X1_23(m,a...) STDX_PP_LOOP_X1_22(m,##a) m(22,##a)

#define STDX_PP_LOOP_X1_24(m,a...) STDX_PP_LOOP_X1_23(m,##a) m(23,##a)
#define STDX_PP_LOOP_X1_25(m,a...) STDX_PP_LOOP_X1_24(m,##a) m(24,##a)
#define STDX_PP_LOOP_X1_26(m,a...) STDX_PP_LOOP_X1_25(m,##a) m(25,##a)
#define STDX_PP_LOOP_X1_27(m,a...) STDX_PP_LOOP_X1_26(m,##a) m(26,##a)
#define STDX_PP_LOOP_X1_28(m,a...) STDX_PP_LOOP_X1_27(m,##a) m(27,##a)
#define STDX_PP_LOOP_X1_29(m,a...) STDX_PP_LOOP_X1_28(m,##a) m(28,##a)
#define STDX_PP_LOOP_X1_30(m,a...) STDX_PP_LOOP_X1_29(m,##a) m(29,##a)
#define STDX_PP_LOOP_X1_31(m,a...) STDX_PP_LOOP_X1_30(m,##a) m(30,##a)

#define STDX_PP_LOOP_X1_32(m,a...) STDX_PP_LOOP_X1_31(m,##a) m(31,##a)

#define STDX_PP_LOOP_X1_( count_, m_, args_... ) \
  STDX_PP_CONCAT( STDX_PP_LOOP_X1_, count_ ) ( m_, ## args_)

//------------------------------------------------------------------------
// STDX_PP_LOOP_X2
//------------------------------------------------------------------------

#define STDX_PP_LOOP_X2_0(m,a...)
#define STDX_PP_LOOP_X2_1(m,a...)                            m(0,##a)
#define STDX_PP_LOOP_X2_2(m,a...)  STDX_PP_LOOP_X2_1(m,##a)  m(1,##a)
#define STDX_PP_LOOP_X2_3(m,a...)  STDX_PP_LOOP_X2_2(m,##a)  m(2,##a)
#define STDX_PP_LOOP_X2_4(m,a...)  STDX_PP_LOOP_X2_3(m,##a)  m(3,##a)
#define STDX_PP_LOOP_X2_5(m,a...)  STDX_PP_LOOP_X2_4(m,##a)  m(4,##a)
#define STDX_PP_LOOP_X2_6(m,a...)  STDX_PP_LOOP_X2_5(m,##a)  m(5,##a)
#define STDX_PP_LOOP_X2_7(m,a...)  STDX_PP_LOOP_X2_6(m,##a)  m(6,##a)

#define STDX_PP_LOOP_X2_8(m,a...)  STDX_PP_LOOP_X2_7(m,##a)  m(7,##a)
#define STDX_PP_LOOP_X2_9(m,a...)  STDX_PP_LOOP_X2_8(m,##a)  m(8,##a)
#define STDX_PP_LOOP_X2_10(m,a...) STDX_PP_LOOP_X2_9(m,##a)  m(9,##a)
#define STDX_PP_LOOP_X2_11(m,a...) STDX_PP_LOOP_X2_10(m,##a) m(10,##a)
#define STDX_PP_LOOP_X2_12(m,a...) STDX_PP_LOOP_X2_11(m,##a) m(11,##a)
#define STDX_PP_LOOP_X2_13(m,a...) STDX_PP_LOOP_X2_12(m,##a) m(12,##a)
#define STDX_PP_LOOP_X2_14(m,a...) STDX_PP_LOOP_X2_13(m,##a) m(13,##a)
#define STDX_PP_LOOP_X2_15(m,a...) STDX_PP_LOOP_X2_14(m,##a) m(14,##a)

#define STDX_PP_LOOP_X2_16(m,a...) STDX_PP_LOOP_X2_15(m,##a) m(15,##a)
#define STDX_PP_LOOP_X2_17(m,a...) STDX_PP_LOOP_X2_16(m,##a) m(16,##a)
#define STDX_PP_LOOP_X2_18(m,a...) STDX_PP_LOOP_X2_17(m,##a) m(17,##a)
#define STDX_PP_LOOP_X2_19(m,a...) STDX_PP_LOOP_X2_18(m,##a) m(18,##a)
#define STDX_PP_LOOP_X2_20(m,a...) STDX_PP_LOOP_X2_19(m,##a) m(19,##a)
#define STDX_PP_LOOP_X2_21(m,a...) STDX_PP_LOOP_X2_20(m,##a) m(20,##a)
#define STDX_PP_LOOP_X2_22(m,a...) STDX_PP_LOOP_X2_21(m,##a) m(21,##a)
#define STDX_PP_LOOP_X2_23(m,a...) STDX_PP_LOOP_X2_22(m,##a) m(22,##a)

#define STDX_PP_LOOP_X2_24(m,a...) STDX_PP_LOOP_X2_23(m,##a) m(23,##a)
#define STDX_PP_LOOP_X2_25(m,a...) STDX_PP_LOOP_X2_24(m,##a) m(24,##a)
#define STDX_PP_LOOP_X2_26(m,a...) STDX_PP_LOOP_X2_25(m,##a) m(25,##a)
#define STDX_PP_LOOP_X2_27(m,a...) STDX_PP_LOOP_X2_26(m,##a) m(26,##a)
#define STDX_PP_LOOP_X2_28(m,a...) STDX_PP_LOOP_X2_27(m,##a) m(27,##a)
#define STDX_PP_LOOP_X2_29(m,a...) STDX_PP_LOOP_X2_28(m,##a) m(28,##a)
#define STDX_PP_LOOP_X2_30(m,a...) STDX_PP_LOOP_X2_29(m,##a) m(29,##a)
#define STDX_PP_LOOP_X2_31(m,a...) STDX_PP_LOOP_X2_30(m,##a) m(30,##a)

#define STDX_PP_LOOP_X2_32(m,a...) STDX_PP_LOOP_X2_31(m,##a) m(31,##a)

#define STDX_PP_LOOP_X2_( count_, m_, args_... ) \
  STDX_PP_CONCAT( STDX_PP_LOOP_X2_, count_ ) ( m_, ## args_)

//------------------------------------------------------------------------
// STDX_PP_LOOP_C_X0
//------------------------------------------------------------------------

#define STDX_PP_LOOP_C_X0_0(m,a...)
#define STDX_PP_LOOP_C_X0_1(m,a...)                               m(0,##a)
#define STDX_PP_LOOP_C_X0_2(m,a...)  STDX_PP_LOOP_C_X0_1(m,##a),  m(1,##a)
#define STDX_PP_LOOP_C_X0_3(m,a...)  STDX_PP_LOOP_C_X0_2(m,##a),  m(2,##a)
#define STDX_PP_LOOP_C_X0_4(m,a...)  STDX_PP_LOOP_C_X0_3(m,##a),  m(3,##a)
#define STDX_PP_LOOP_C_X0_5(m,a...)  STDX_PP_LOOP_C_X0_4(m,##a),  m(4,##a)
#define STDX_PP_LOOP_C_X0_6(m,a...)  STDX_PP_LOOP_C_X0_5(m,##a),  m(5,##a)
#define STDX_PP_LOOP_C_X0_7(m,a...)  STDX_PP_LOOP_C_X0_6(m,##a),  m(6,##a)

#define STDX_PP_LOOP_C_X0_8(m,a...)  STDX_PP_LOOP_C_X0_7(m,##a),  m(7,##a)
#define STDX_PP_LOOP_C_X0_9(m,a...)  STDX_PP_LOOP_C_X0_8(m,##a),  m(8,##a)
#define STDX_PP_LOOP_C_X0_10(m,a...) STDX_PP_LOOP_C_X0_9(m,##a),  m(9,##a)
#define STDX_PP_LOOP_C_X0_11(m,a...) STDX_PP_LOOP_C_X0_10(m,##a), m(10,##a)
#define STDX_PP_LOOP_C_X0_12(m,a...) STDX_PP_LOOP_C_X0_11(m,##a), m(11,##a)
#define STDX_PP_LOOP_C_X0_13(m,a...) STDX_PP_LOOP_C_X0_12(m,##a), m(12,##a)
#define STDX_PP_LOOP_C_X0_14(m,a...) STDX_PP_LOOP_C_X0_13(m,##a), m(13,##a)
#define STDX_PP_LOOP_C_X0_15(m,a...) STDX_PP_LOOP_C_X0_14(m,##a), m(14,##a)

#define STDX_PP_LOOP_C_X0_16(m,a...) STDX_PP_LOOP_C_X0_15(m,##a), m(15,##a)
#define STDX_PP_LOOP_C_X0_17(m,a...) STDX_PP_LOOP_C_X0_16(m,##a), m(16,##a)
#define STDX_PP_LOOP_C_X0_18(m,a...) STDX_PP_LOOP_C_X0_17(m,##a), m(17,##a)
#define STDX_PP_LOOP_C_X0_19(m,a...) STDX_PP_LOOP_C_X0_18(m,##a), m(18,##a)
#define STDX_PP_LOOP_C_X0_20(m,a...) STDX_PP_LOOP_C_X0_19(m,##a), m(19,##a)
#define STDX_PP_LOOP_C_X0_21(m,a...) STDX_PP_LOOP_C_X0_20(m,##a), m(20,##a)
#define STDX_PP_LOOP_C_X0_22(m,a...) STDX_PP_LOOP_C_X0_21(m,##a), m(21,##a)
#define STDX_PP_LOOP_C_X0_23(m,a...) STDX_PP_LOOP_C_X0_22(m,##a), m(22,##a)

#define STDX_PP_LOOP_C_X0_24(m,a...) STDX_PP_LOOP_C_X0_23(m,##a), m(23,##a)
#define STDX_PP_LOOP_C_X0_25(m,a...) STDX_PP_LOOP_C_X0_24(m,##a), m(24,##a)
#define STDX_PP_LOOP_C_X0_26(m,a...) STDX_PP_LOOP_C_X0_25(m,##a), m(25,##a)
#define STDX_PP_LOOP_C_X0_27(m,a...) STDX_PP_LOOP_C_X0_26(m,##a), m(26,##a)
#define STDX_PP_LOOP_C_X0_28(m,a...) STDX_PP_LOOP_C_X0_27(m,##a), m(27,##a)
#define STDX_PP_LOOP_C_X0_29(m,a...) STDX_PP_LOOP_C_X0_28(m,##a), m(28,##a)
#define STDX_PP_LOOP_C_X0_30(m,a...) STDX_PP_LOOP_C_X0_29(m,##a), m(29,##a)
#define STDX_PP_LOOP_C_X0_31(m,a...) STDX_PP_LOOP_C_X0_30(m,##a), m(30,##a)

#define STDX_PP_LOOP_C_X0_32(m,a...) STDX_PP_LOOP_C_X0_31(m,##a), m(31,##a)

#define STDX_PP_LOOP_C_X0_( count_, m_, args_... ) \
  STDX_PP_CONCAT( STDX_PP_LOOP_C_X0_, count_ ) ( m_, ## args_)

#define STDX_PP_LOOP_C_X0( count_, m_, args_... ) \
  STDX_PP_LOOP_C_X0_( count_, m_, ## args_ )

#define STDX_PP_LOOP_C_( count_, m_, args_... ) \
  STDX_PP_LOOP_C_X0_( count_, m_, ## args_ )

//------------------------------------------------------------------------
// STDX_PP_LOOP_C_X1
//------------------------------------------------------------------------

#define STDX_PP_LOOP_C_X1_0(m,a...)
#define STDX_PP_LOOP_C_X1_1(m,a...)                               m(0,##a)
#define STDX_PP_LOOP_C_X1_2(m,a...)  STDX_PP_LOOP_C_X1_1(m,##a),  m(1,##a)
#define STDX_PP_LOOP_C_X1_3(m,a...)  STDX_PP_LOOP_C_X1_2(m,##a),  m(2,##a)
#define STDX_PP_LOOP_C_X1_4(m,a...)  STDX_PP_LOOP_C_X1_3(m,##a),  m(3,##a)
#define STDX_PP_LOOP_C_X1_5(m,a...)  STDX_PP_LOOP_C_X1_4(m,##a),  m(4,##a)
#define STDX_PP_LOOP_C_X1_6(m,a...)  STDX_PP_LOOP_C_X1_5(m,##a),  m(5,##a)
#define STDX_PP_LOOP_C_X1_7(m,a...)  STDX_PP_LOOP_C_X1_6(m,##a),  m(6,##a)

#define STDX_PP_LOOP_C_X1_8(m,a...)  STDX_PP_LOOP_C_X1_7(m,##a),  m(7,##a)
#define STDX_PP_LOOP_C_X1_9(m,a...)  STDX_PP_LOOP_C_X1_8(m,##a),  m(8,##a)
#define STDX_PP_LOOP_C_X1_10(m,a...) STDX_PP_LOOP_C_X1_9(m,##a),  m(9,##a)
#define STDX_PP_LOOP_C_X1_11(m,a...) STDX_PP_LOOP_C_X1_10(m,##a), m(10,##a)
#define STDX_PP_LOOP_C_X1_12(m,a...) STDX_PP_LOOP_C_X1_11(m,##a), m(11,##a)
#define STDX_PP_LOOP_C_X1_13(m,a...) STDX_PP_LOOP_C_X1_12(m,##a), m(12,##a)
#define STDX_PP_LOOP_C_X1_14(m,a...) STDX_PP_LOOP_C_X1_13(m,##a), m(13,##a)
#define STDX_PP_LOOP_C_X1_15(m,a...) STDX_PP_LOOP_C_X1_14(m,##a), m(14,##a)

#define STDX_PP_LOOP_C_X1_16(m,a...) STDX_PP_LOOP_C_X1_15(m,##a), m(15,##a)
#define STDX_PP_LOOP_C_X1_17(m,a...) STDX_PP_LOOP_C_X1_16(m,##a), m(16,##a)
#define STDX_PP_LOOP_C_X1_18(m,a...) STDX_PP_LOOP_C_X1_17(m,##a), m(17,##a)
#define STDX_PP_LOOP_C_X1_19(m,a...) STDX_PP_LOOP_C_X1_18(m,##a), m(18,##a)
#define STDX_PP_LOOP_C_X1_20(m,a...) STDX_PP_LOOP_C_X1_19(m,##a), m(19,##a)
#define STDX_PP_LOOP_C_X1_21(m,a...) STDX_PP_LOOP_C_X1_20(m,##a), m(20,##a)
#define STDX_PP_LOOP_C_X1_22(m,a...) STDX_PP_LOOP_C_X1_21(m,##a), m(21,##a)
#define STDX_PP_LOOP_C_X1_23(m,a...) STDX_PP_LOOP_C_X1_22(m,##a), m(22,##a)

#define STDX_PP_LOOP_C_X1_24(m,a...) STDX_PP_LOOP_C_X1_23(m,##a), m(23,##a)
#define STDX_PP_LOOP_C_X1_25(m,a...) STDX_PP_LOOP_C_X1_24(m,##a), m(24,##a)
#define STDX_PP_LOOP_C_X1_26(m,a...) STDX_PP_LOOP_C_X1_25(m,##a), m(25,##a)
#define STDX_PP_LOOP_C_X1_27(m,a...) STDX_PP_LOOP_C_X1_26(m,##a), m(26,##a)
#define STDX_PP_LOOP_C_X1_28(m,a...) STDX_PP_LOOP_C_X1_27(m,##a), m(27,##a)
#define STDX_PP_LOOP_C_X1_29(m,a...) STDX_PP_LOOP_C_X1_28(m,##a), m(28,##a)
#define STDX_PP_LOOP_C_X1_30(m,a...) STDX_PP_LOOP_C_X1_29(m,##a), m(29,##a)
#define STDX_PP_LOOP_C_X1_31(m,a...) STDX_PP_LOOP_C_X1_30(m,##a), m(30,##a)

#define STDX_PP_LOOP_C_X1_32(m,a...) STDX_PP_LOOP_C_X1_31(m,##a), m(31,##a)

#define STDX_PP_LOOP_C_X1_( count_, m_, args_... ) \
  STDX_PP_CONCAT( STDX_PP_LOOP_C_X1_, count_ ) ( m_, ## args_)

//------------------------------------------------------------------------
// STDX_PP_LOOP_C_X2
//------------------------------------------------------------------------

#define STDX_PP_LOOP_C_X2_0(m,a...)
#define STDX_PP_LOOP_C_X2_1(m,a...)                               m(0,##a)
#define STDX_PP_LOOP_C_X2_2(m,a...)  STDX_PP_LOOP_C_X2_1(m,##a),  m(1,##a)
#define STDX_PP_LOOP_C_X2_3(m,a...)  STDX_PP_LOOP_C_X2_2(m,##a),  m(2,##a)
#define STDX_PP_LOOP_C_X2_4(m,a...)  STDX_PP_LOOP_C_X2_3(m,##a),  m(3,##a)
#define STDX_PP_LOOP_C_X2_5(m,a...)  STDX_PP_LOOP_C_X2_4(m,##a),  m(4,##a)
#define STDX_PP_LOOP_C_X2_6(m,a...)  STDX_PP_LOOP_C_X2_5(m,##a),  m(5,##a)
#define STDX_PP_LOOP_C_X2_7(m,a...)  STDX_PP_LOOP_C_X2_6(m,##a),  m(6,##a)

#define STDX_PP_LOOP_C_X2_8(m,a...)  STDX_PP_LOOP_C_X2_7(m,##a),  m(7,##a)
#define STDX_PP_LOOP_C_X2_9(m,a...)  STDX_PP_LOOP_C_X2_8(m,##a),  m(8,##a)
#define STDX_PP_LOOP_C_X2_10(m,a...) STDX_PP_LOOP_C_X2_9(m,##a),  m(9,##a)
#define STDX_PP_LOOP_C_X2_11(m,a...) STDX_PP_LOOP_C_X2_10(m,##a), m(10,##a)
#define STDX_PP_LOOP_C_X2_12(m,a...) STDX_PP_LOOP_C_X2_11(m,##a), m(11,##a)
#define STDX_PP_LOOP_C_X2_13(m,a...) STDX_PP_LOOP_C_X2_12(m,##a), m(12,##a)
#define STDX_PP_LOOP_C_X2_14(m,a...) STDX_PP_LOOP_C_X2_13(m,##a), m(13,##a)
#define STDX_PP_LOOP_C_X2_15(m,a...) STDX_PP_LOOP_C_X2_14(m,##a), m(14,##a)

#define STDX_PP_LOOP_C_X2_16(m,a...) STDX_PP_LOOP_C_X2_15(m,##a), m(15,##a)
#define STDX_PP_LOOP_C_X2_17(m,a...) STDX_PP_LOOP_C_X2_16(m,##a), m(16,##a)
#define STDX_PP_LOOP_C_X2_18(m,a...) STDX_PP_LOOP_C_X2_17(m,##a), m(17,##a)
#define STDX_PP_LOOP_C_X2_19(m,a...) STDX_PP_LOOP_C_X2_18(m,##a), m(18,##a)
#define STDX_PP_LOOP_C_X2_20(m,a...) STDX_PP_LOOP_C_X2_19(m,##a), m(19,##a)
#define STDX_PP_LOOP_C_X2_21(m,a...) STDX_PP_LOOP_C_X2_20(m,##a), m(20,##a)
#define STDX_PP_LOOP_C_X2_22(m,a...) STDX_PP_LOOP_C_X2_21(m,##a), m(21,##a)
#define STDX_PP_LOOP_C_X2_23(m,a...) STDX_PP_LOOP_C_X2_22(m,##a), m(22,##a)

#define STDX_PP_LOOP_C_X2_24(m,a...) STDX_PP_LOOP_C_X2_23(m,##a), m(23,##a)
#define STDX_PP_LOOP_C_X2_25(m,a...) STDX_PP_LOOP_C_X2_24(m,##a), m(24,##a)
#define STDX_PP_LOOP_C_X2_26(m,a...) STDX_PP_LOOP_C_X2_25(m,##a), m(25,##a)
#define STDX_PP_LOOP_C_X2_27(m,a...) STDX_PP_LOOP_C_X2_26(m,##a), m(26,##a)
#define STDX_PP_LOOP_C_X2_28(m,a...) STDX_PP_LOOP_C_X2_27(m,##a), m(27,##a)
#define STDX_PP_LOOP_C_X2_29(m,a...) STDX_PP_LOOP_C_X2_28(m,##a), m(28,##a)
#define STDX_PP_LOOP_C_X2_30(m,a...) STDX_PP_LOOP_C_X2_29(m,##a), m(29,##a)
#define STDX_PP_LOOP_C_X2_31(m,a...) STDX_PP_LOOP_C_X2_30(m,##a), m(30,##a)

#define STDX_PP_LOOP_C_X2_32(m,a...) STDX_PP_LOOP_C_X2_31(m,##a), m(31,##a)

#define STDX_PP_LOOP_C_X2_( count_, m_, args_... ) \
  STDX_PP_CONCAT( STDX_PP_LOOP_C_X2_, count_ ) ( m_, ## args_)

//------------------------------------------------------------------------
// STDX_PP_ENUM_PARAMS
//------------------------------------------------------------------------

#define STDX_PP_ENUM_PARAMS_0(p)
#define STDX_PP_ENUM_PARAMS_1(p)                             STDX_PP_CONCAT(p,0)
#define STDX_PP_ENUM_PARAMS_2(p)  STDX_PP_ENUM_PARAMS_1(p),  STDX_PP_CONCAT(p,1)
#define STDX_PP_ENUM_PARAMS_3(p)  STDX_PP_ENUM_PARAMS_2(p),  STDX_PP_CONCAT(p,2)
#define STDX_PP_ENUM_PARAMS_4(p)  STDX_PP_ENUM_PARAMS_3(p),  STDX_PP_CONCAT(p,3)
#define STDX_PP_ENUM_PARAMS_5(p)  STDX_PP_ENUM_PARAMS_4(p),  STDX_PP_CONCAT(p,4)
#define STDX_PP_ENUM_PARAMS_6(p)  STDX_PP_ENUM_PARAMS_5(p),  STDX_PP_CONCAT(p,5)
#define STDX_PP_ENUM_PARAMS_7(p)  STDX_PP_ENUM_PARAMS_6(p),  STDX_PP_CONCAT(p,6)

#define STDX_PP_ENUM_PARAMS_8(p)  STDX_PP_ENUM_PARAMS_7(p),  STDX_PP_CONCAT(p,7)
#define STDX_PP_ENUM_PARAMS_9(p)  STDX_PP_ENUM_PARAMS_8(p),  STDX_PP_CONCAT(p,8)
#define STDX_PP_ENUM_PARAMS_10(p) STDX_PP_ENUM_PARAMS_9(p),  STDX_PP_CONCAT(p,9)
#define STDX_PP_ENUM_PARAMS_11(p) STDX_PP_ENUM_PARAMS_10(p), STDX_PP_CONCAT(p,10)
#define STDX_PP_ENUM_PARAMS_12(p) STDX_PP_ENUM_PARAMS_11(p), STDX_PP_CONCAT(p,11)
#define STDX_PP_ENUM_PARAMS_13(p) STDX_PP_ENUM_PARAMS_12(p), STDX_PP_CONCAT(p,12)
#define STDX_PP_ENUM_PARAMS_14(p) STDX_PP_ENUM_PARAMS_13(p), STDX_PP_CONCAT(p,13)
#define STDX_PP_ENUM_PARAMS_15(p) STDX_PP_ENUM_PARAMS_14(p), STDX_PP_CONCAT(p,14)

#define STDX_PP_ENUM_PARAMS_16(p) STDX_PP_ENUM_PARAMS_15(p), STDX_PP_CONCAT(p,15)
#define STDX_PP_ENUM_PARAMS_17(p) STDX_PP_ENUM_PARAMS_16(p), STDX_PP_CONCAT(p,16)
#define STDX_PP_ENUM_PARAMS_18(p) STDX_PP_ENUM_PARAMS_17(p), STDX_PP_CONCAT(p,17)
#define STDX_PP_ENUM_PARAMS_19(p) STDX_PP_ENUM_PARAMS_18(p), STDX_PP_CONCAT(p,18)
#define STDX_PP_ENUM_PARAMS_20(p) STDX_PP_ENUM_PARAMS_19(p), STDX_PP_CONCAT(p,19)
#define STDX_PP_ENUM_PARAMS_21(p) STDX_PP_ENUM_PARAMS_20(p), STDX_PP_CONCAT(p,20)
#define STDX_PP_ENUM_PARAMS_22(p) STDX_PP_ENUM_PARAMS_21(p), STDX_PP_CONCAT(p,21)
#define STDX_PP_ENUM_PARAMS_23(p) STDX_PP_ENUM_PARAMS_22(p), STDX_PP_CONCAT(p,22)

#define STDX_PP_ENUM_PARAMS_24(p) STDX_PP_ENUM_PARAMS_23(p), STDX_PP_CONCAT(p,23)
#define STDX_PP_ENUM_PARAMS_25(p) STDX_PP_ENUM_PARAMS_24(p), STDX_PP_CONCAT(p,24)
#define STDX_PP_ENUM_PARAMS_26(p) STDX_PP_ENUM_PARAMS_25(p), STDX_PP_CONCAT(p,25)
#define STDX_PP_ENUM_PARAMS_27(p) STDX_PP_ENUM_PARAMS_26(p), STDX_PP_CONCAT(p,26)
#define STDX_PP_ENUM_PARAMS_28(p) STDX_PP_ENUM_PARAMS_27(p), STDX_PP_CONCAT(p,27)
#define STDX_PP_ENUM_PARAMS_29(p) STDX_PP_ENUM_PARAMS_28(p), STDX_PP_CONCAT(p,28)
#define STDX_PP_ENUM_PARAMS_30(p) STDX_PP_ENUM_PARAMS_29(p), STDX_PP_CONCAT(p,29)
#define STDX_PP_ENUM_PARAMS_31(p) STDX_PP_ENUM_PARAMS_30(p), STDX_PP_CONCAT(p,30)

#define STDX_PP_ENUM_PARAMS_32(p) STDX_PP_ENUM_PARAMS_31(p), STDX_PP_CONCAT(p,31)

#define STDX_PP_ENUM_PARAMS_( count_, pfx_ ) \
  STDX_PP_CONCAT( STDX_PP_ENUM_PARAMS_, count_ ) ( pfx_ )

//------------------------------------------------------------------------
// STDX_PP_PARAM_LIST
//------------------------------------------------------------------------

#define STDX_PP_PARAM_LIST_LB( count_, pfx_ ) \
  STDX_PP_CONCAT( pfx_, count_ )

#define STDX_PP_PARAM_LIST_( count_, pfx_ ) \
  STDX_PP_LOOP_C_X0( count_, STDX_PP_PARAM_LIST_LB, pfx_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_SIZE
//------------------------------------------------------------------------
// This macro returns the size of the list passed to it. This is
// (relatively) straightforward if we can assume the list always has at
// least one item. Unfortunately things become more complicated if we
// want to allow calling this macro with an empty list. Although there
// is a portable way to do this, it is quite tricky. So for now we use
// the GNU CPP variadic macro extensions which eliminates a preceding
// comma when using token concatenation and variable arguments.
//
// Some of this was inspired from discussions with Benjamin Hindman
// (benh@berkeley.edu). The code for counting greater than or equal to
// one item up to some limit comes from:
// http://groups.google.com/group/comp.std.c/browse_thread/thread/77ee8c8f92e4a3fb/346fc464319b1ee5
// except that what I am really counting here is the number of items
// minus one (because I want to ignore the dummy_ item). The dummy_
// items means that we never pass zero arguments to
// STDX_PP_LIST_SIZE_H0.

#define STDX_PP_LIST_SIZE_SEQ() \
  64, 63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, \
  48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, \
  32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, \
  16, 15, 14, 13, 12, 11, 10,  9,  8,  7,  6,  5,  4,  3,  2,  1, 0

#define STDX_PP_LIST_SIZE_H3( \
   n0_,  n1_,  n2_,  n3_,  n4_,  n5_,  n6_,  n7_,  n8_,  n9_, \
  n10_, n11_, n12_, n13_, n14_, n15_, n16_, n17_, n18_, n19_, \
  n20_, n21_, n22_, n23_, n24_, n25_, n26_, n27_, n28_, n29_, \
  n30_, n31_, n32_, n33_, n34_, n35_, n36_, n37_, n38_, n39_, \
  n40_, n41_, n42_, n43_, n44_, n45_, n46_, n47_, n48_, n49_, \
  n50_, n51_, n52_, n53_, n54_, n55_, n56_, n57_, n58_, n59_, \
  n60_, n61_, n62_, n63_, n64_, n, ... ) n

#define STDX_PP_LIST_SIZE_H2( items_... ) \
  STDX_PP_LIST_SIZE_H3( items_ )

#define STDX_PP_LIST_SIZE_H1( items_... ) \
  STDX_PP_LIST_SIZE_H2( items_, STDX_PP_LIST_SIZE_SEQ() )

#define STDX_PP_LIST_SIZE_H0( items_... ) \
  STDX_PP_LIST_SIZE_H1( dummy_, ## items_ )

#define STDX_PP_LIST_SIZE_( list_ ) \
  STDX_PP_LIST_SIZE_H0 list_

//------------------------------------------------------------------------
// STDX_PP_LIST_APPEND
//------------------------------------------------------------------------

#define STDX_PP_LIST_APPEND_( list0_, list1_ )                          \
  ( STDX_PP_STRIP_PAREN( list0_ )                                       \
    STDX_PP_COMMA_IF(                                                   \
      STDX_PP_AND( STDX_PP_LIST_SIZE(list0_),                           \
                   STDX_PP_LIST_SIZE(list1_) ))                         \
    STDX_PP_STRIP_PAREN( list1_ ) )                                     \

//------------------------------------------------------------------------
// STDX_PP_LIST_PUSH
//------------------------------------------------------------------------

#define STDX_PP_LIST_PUSH_H0( list_, item_ ) \
  ( item_, STDX_PP_STRIP_PAREN( list_ ) )

#define STDX_PP_LIST_PUSH_( list_, item_ ) \
  STDX_PP_IF( STDX_PP_LIST_SIZE( list_ ),  \
    STDX_PP_LIST_PUSH_H0( list_, item_ ),  \
    ( item_ ) )

//------------------------------------------------------------------------
// STDX_PP_LIST_FIRST
//------------------------------------------------------------------------

#define STDX_PP_LIST_FIRST_H1( first_, rest_... ) first_

#define STDX_PP_LIST_FIRST_H0( list_ ) \
  STDX_PP_LIST_FIRST_H1 list_

#define STDX_PP_LIST_FIRST_( list_ )      \
  STDX_PP_IF( STDX_PP_LIST_SIZE( list_ ), \
    STDX_PP_LIST_FIRST_H0( list_ ),       \
    STDX_PP_EMPTY )

//------------------------------------------------------------------------
// STDX_PP_LIST_REST
//------------------------------------------------------------------------

#define STDX_PP_LIST_REST_H1( first_, rest_... ) ( rest_ )

#define STDX_PP_LIST_REST_H0( list_ ) \
  STDX_PP_LIST_REST_H1 list_

#define STDX_PP_LIST_REST_( list_ )       \
  STDX_PP_IF( STDX_PP_LIST_SIZE( list_ ), \
    STDX_PP_LIST_REST_H0( list_ ),        \
    STDX_PP_LIST_EMPTY )

//------------------------------------------------------------------------
// STDX_PP_LIST_AT
//------------------------------------------------------------------------

#define STDX_PP_LIST_AT_0(x_)  STDX_PP_LIST_FIRST(x_)
#define STDX_PP_LIST_AT_1(x_)  STDX_PP_LIST_AT_0(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_2(x_)  STDX_PP_LIST_AT_1(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_3(x_)  STDX_PP_LIST_AT_2(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_4(x_)  STDX_PP_LIST_AT_3(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_5(x_)  STDX_PP_LIST_AT_4(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_6(x_)  STDX_PP_LIST_AT_5(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_7(x_)  STDX_PP_LIST_AT_6(  STDX_PP_LIST_REST(x_) )

#define STDX_PP_LIST_AT_8(x_)  STDX_PP_LIST_AT_7(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_9(x_)  STDX_PP_LIST_AT_8(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_10(x_) STDX_PP_LIST_AT_9(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_11(x_) STDX_PP_LIST_AT_10( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_12(x_) STDX_PP_LIST_AT_11( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_13(x_) STDX_PP_LIST_AT_12( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_14(x_) STDX_PP_LIST_AT_13( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_15(x_) STDX_PP_LIST_AT_14( STDX_PP_LIST_REST(x_) )

#define STDX_PP_LIST_AT_16(x_) STDX_PP_LIST_AT_15( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_17(x_) STDX_PP_LIST_AT_16( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_18(x_) STDX_PP_LIST_AT_17( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_19(x_) STDX_PP_LIST_AT_18( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_20(x_) STDX_PP_LIST_AT_19( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_21(x_) STDX_PP_LIST_AT_20( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_22(x_) STDX_PP_LIST_AT_21( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_23(x_) STDX_PP_LIST_AT_22( STDX_PP_LIST_REST(x_) )

#define STDX_PP_LIST_AT_24(x_) STDX_PP_LIST_AT_23( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_25(x_) STDX_PP_LIST_AT_24( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_26(x_) STDX_PP_LIST_AT_25( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_27(x_) STDX_PP_LIST_AT_26( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_28(x_) STDX_PP_LIST_AT_27( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_29(x_) STDX_PP_LIST_AT_28( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_30(x_) STDX_PP_LIST_AT_29( STDX_PP_LIST_REST(x_) )
#define STDX_PP_LIST_AT_31(x_) STDX_PP_LIST_AT_30( STDX_PP_LIST_REST(x_) )

#define STDX_PP_LIST_AT_32(x_) STDX_PP_LIST_AT_31( STDX_PP_LIST_REST(x_) )

#define STDX_PP_LIST_AT_( list_, index_ ) \
  STDX_PP_CONCAT_( STDX_PP_LIST_AT_, index_ ) ( list_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_MAP
//------------------------------------------------------------------------

#define STDX_PP_LIST_MAP_LB( count_, list_, m_, args_... ) \
  m_ ( count_, STDX_PP_LIST_AT( list_, count_ ), ## args_ )

#define STDX_PP_LIST_MAP_( list_, m_, args_... )                        \
  STDX_PP_LOOP( STDX_PP_LIST_SIZE( list_ ),                             \
                STDX_PP_LIST_MAP_LB, list_, m_, ## args_ )              \

#define STDX_PP_LIST_MAP_X1_LB( count_, list_, m_, args_... ) \
  m_ ( count_, STDX_PP_LIST_AT( list_, count_ ), ## args_ )

#define STDX_PP_LIST_MAP_X1_( list_, m_, args_... )                     \
  STDX_PP_LOOP_X1( STDX_PP_LIST_SIZE( list_ ),                          \
                   STDX_PP_LIST_MAP_X1_LB, list_, m_, ## args_ )        \

#define STDX_PP_LIST_MAP_X2_LB( count_, list_, m_, args_... ) \
  m_ ( count_, STDX_PP_LIST_AT( list_, count_ ), ## args_ )

#define STDX_PP_LIST_MAP_X2_( list_, m_, args_... )                     \
  STDX_PP_LOOP_X2( STDX_PP_LIST_SIZE( list_ ),                          \
                   STDX_PP_LIST_MAP_X1_LB, list_, m_, ## args_ )        \

//------------------------------------------------------------------------
// STDX_PP_LIST_MAP_C
//------------------------------------------------------------------------

#define STDX_PP_LIST_MAP_C_LB( count_, list_, m_, args_... ) \
  m_ ( count_, STDX_PP_LIST_AT( list_, count_ ), ## args_ )

#define STDX_PP_LIST_MAP_C_( list_, m_, args_... )                      \
  STDX_PP_LOOP_C( STDX_PP_LIST_SIZE( list_ ),                           \
                  STDX_PP_LIST_MAP_C_LB, list_, m_, ## args_ )          \

#define STDX_PP_LIST_MAP_C_X1_LB( count_, list_, m_, args_... ) \
  m_ ( count_, STDX_PP_LIST_AT( list_, count_ ), ## args_ )

#define STDX_PP_LIST_MAP_C_X1_( list_, m_, args_... )                   \
  STDX_PP_LOOP_C_X1( STDX_PP_LIST_SIZE( list_ ),                        \
                     STDX_PP_LIST_MAP_C_X1_LB, list_, m_, ## args_ )    \

#define STDX_PP_LIST_MAP_C_X2_LB( count_, list_, m_, args_... ) \
  m_ ( count_, STDX_PP_LIST_AT( list_, count_ ), ## args_ )

#define STDX_PP_LIST_MAP_C_X2_( list_, m_, args_... )                   \
  STDX_PP_LOOP_C_X2( STDX_PP_LIST_SIZE( list_ ),                        \
                     STDX_PP_LIST_MAP_C_X2_LB, list_, m_, ## args_ )    \

//------------------------------------------------------------------------
// STDX_PP_NUM
//------------------------------------------------------------------------
// Both STDX_PP_ADD and STDX_PP_SUB use this macro in their
// implementation to create a comma separated list of dummy arguments
// which represents the given number n_.

#define STDX_PP_NUM_LB( count_ ) n ## count_
#define STDX_PP_NUM( n_ ) \
  STDX_PP_LOOP_C( n_, STDX_PP_NUM_LB )

//------------------------------------------------------------------------
// STDX_PP_ADD
//------------------------------------------------------------------------

#define STDX_PP_ADD_0(x_)  x_
#define STDX_PP_ADD_1(x_)  STDX_PP_ADD_0(  STDX_PP_LIST_PUSH( x_, n0_ ) )
#define STDX_PP_ADD_2(x_)  STDX_PP_ADD_1(  STDX_PP_LIST_PUSH( x_, n1_ ) )
#define STDX_PP_ADD_3(x_)  STDX_PP_ADD_2(  STDX_PP_LIST_PUSH( x_, n2_ ) )
#define STDX_PP_ADD_4(x_)  STDX_PP_ADD_3(  STDX_PP_LIST_PUSH( x_, n3_ ) )
#define STDX_PP_ADD_5(x_)  STDX_PP_ADD_4(  STDX_PP_LIST_PUSH( x_, n4_ ) )
#define STDX_PP_ADD_6(x_)  STDX_PP_ADD_5(  STDX_PP_LIST_PUSH( x_, n5_ ) )
#define STDX_PP_ADD_7(x_)  STDX_PP_ADD_6(  STDX_PP_LIST_PUSH( x_, n6_ ) )

#define STDX_PP_ADD_8(x_)  STDX_PP_ADD_7(  STDX_PP_LIST_PUSH( x_, n7_ ) )
#define STDX_PP_ADD_9(x_)  STDX_PP_ADD_8(  STDX_PP_LIST_PUSH( x_, n8_ ) )
#define STDX_PP_ADD_10(x_) STDX_PP_ADD_9(  STDX_PP_LIST_PUSH( x_, n9_ ) )
#define STDX_PP_ADD_11(x_) STDX_PP_ADD_10( STDX_PP_LIST_PUSH( x_, n10_ ) )
#define STDX_PP_ADD_12(x_) STDX_PP_ADD_11( STDX_PP_LIST_PUSH( x_, n11_ ) )
#define STDX_PP_ADD_13(x_) STDX_PP_ADD_12( STDX_PP_LIST_PUSH( x_, n12_ ) )
#define STDX_PP_ADD_14(x_) STDX_PP_ADD_13( STDX_PP_LIST_PUSH( x_, n13_ ) )
#define STDX_PP_ADD_15(x_) STDX_PP_ADD_14( STDX_PP_LIST_PUSH( x_, n14_ ) )

#define STDX_PP_ADD_16(x_) STDX_PP_ADD_15( STDX_PP_LIST_PUSH( x_, n15_ ) )
#define STDX_PP_ADD_17(x_) STDX_PP_ADD_16( STDX_PP_LIST_PUSH( x_, n16_ ) )
#define STDX_PP_ADD_18(x_) STDX_PP_ADD_17( STDX_PP_LIST_PUSH( x_, n17_ ) )
#define STDX_PP_ADD_19(x_) STDX_PP_ADD_18( STDX_PP_LIST_PUSH( x_, n18_ ) )
#define STDX_PP_ADD_20(x_) STDX_PP_ADD_19( STDX_PP_LIST_PUSH( x_, n19_ ) )
#define STDX_PP_ADD_21(x_) STDX_PP_ADD_20( STDX_PP_LIST_PUSH( x_, n20_ ) )
#define STDX_PP_ADD_22(x_) STDX_PP_ADD_21( STDX_PP_LIST_PUSH( x_, n21_ ) )
#define STDX_PP_ADD_23(x_) STDX_PP_ADD_22( STDX_PP_LIST_PUSH( x_, n22_ ) )

#define STDX_PP_ADD_24(x_) STDX_PP_ADD_23( STDX_PP_LIST_PUSH( x_, n23_ ) )
#define STDX_PP_ADD_25(x_) STDX_PP_ADD_24( STDX_PP_LIST_PUSH( x_, n24_ ) )
#define STDX_PP_ADD_26(x_) STDX_PP_ADD_25( STDX_PP_LIST_PUSH( x_, n25_ ) )
#define STDX_PP_ADD_27(x_) STDX_PP_ADD_26( STDX_PP_LIST_PUSH( x_, n26_ ) )
#define STDX_PP_ADD_28(x_) STDX_PP_ADD_27( STDX_PP_LIST_PUSH( x_, n27_ ) )
#define STDX_PP_ADD_29(x_) STDX_PP_ADD_28( STDX_PP_LIST_PUSH( x_, n28_ ) )
#define STDX_PP_ADD_30(x_) STDX_PP_ADD_29( STDX_PP_LIST_PUSH( x_, n29_ ) )
#define STDX_PP_ADD_31(x_) STDX_PP_ADD_30( STDX_PP_LIST_PUSH( x_, n30_ ) )

#define STDX_PP_ADD_32(x_) STDX_PP_ADD_31( STDX_PP_LIST_PUSH( x_, n31_ ) )

#define STDX_PP_ADD_( num0_, num1_ ) \
  STDX_PP_LIST_SIZE( \
    STDX_PP_CONCAT( STDX_PP_ADD_, num1_ ) ((STDX_PP_NUM(num0_))) )

//------------------------------------------------------------------------
// STDX_PP_INC
//------------------------------------------------------------------------

#define STDX_PP_INC_0  1
#define STDX_PP_INC_1  2
#define STDX_PP_INC_2  3
#define STDX_PP_INC_3  4
#define STDX_PP_INC_4  5
#define STDX_PP_INC_5  6
#define STDX_PP_INC_6  7
#define STDX_PP_INC_7  8

#define STDX_PP_INC_8  9
#define STDX_PP_INC_9  10
#define STDX_PP_INC_10 11
#define STDX_PP_INC_11 12
#define STDX_PP_INC_12 13
#define STDX_PP_INC_13 14
#define STDX_PP_INC_14 15
#define STDX_PP_INC_15 16

#define STDX_PP_INC_16 17
#define STDX_PP_INC_17 18
#define STDX_PP_INC_18 19
#define STDX_PP_INC_19 20
#define STDX_PP_INC_20 21
#define STDX_PP_INC_21 22
#define STDX_PP_INC_22 23
#define STDX_PP_INC_23 24

#define STDX_PP_INC_24 25
#define STDX_PP_INC_25 26
#define STDX_PP_INC_26 27
#define STDX_PP_INC_27 28
#define STDX_PP_INC_28 29
#define STDX_PP_INC_29 30
#define STDX_PP_INC_30 31
#define STDX_PP_INC_31 32

#define STDX_PP_INC_( num_ ) \
  STDX_PP_CONCAT( STDX_PP_INC_, num_ )

//------------------------------------------------------------------------
// STDX_PP_SUB
//------------------------------------------------------------------------

#define STDX_PP_SUB_0(x_)  x_
#define STDX_PP_SUB_1(x_)  STDX_PP_SUB_0(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_2(x_)  STDX_PP_SUB_1(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_3(x_)  STDX_PP_SUB_2(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_4(x_)  STDX_PP_SUB_3(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_5(x_)  STDX_PP_SUB_4(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_6(x_)  STDX_PP_SUB_5(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_7(x_)  STDX_PP_SUB_6(  STDX_PP_LIST_REST(x_) )

#define STDX_PP_SUB_8(x_)  STDX_PP_SUB_7(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_9(x_)  STDX_PP_SUB_8(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_10(x_) STDX_PP_SUB_9(  STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_11(x_) STDX_PP_SUB_10( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_12(x_) STDX_PP_SUB_11( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_13(x_) STDX_PP_SUB_12( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_14(x_) STDX_PP_SUB_13( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_15(x_) STDX_PP_SUB_14( STDX_PP_LIST_REST(x_) )

#define STDX_PP_SUB_16(x_) STDX_PP_SUB_15( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_17(x_) STDX_PP_SUB_16( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_18(x_) STDX_PP_SUB_17( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_19(x_) STDX_PP_SUB_18( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_20(x_) STDX_PP_SUB_19( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_21(x_) STDX_PP_SUB_20( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_22(x_) STDX_PP_SUB_21( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_23(x_) STDX_PP_SUB_22( STDX_PP_LIST_REST(x_) )

#define STDX_PP_SUB_24(x_) STDX_PP_SUB_23( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_25(x_) STDX_PP_SUB_24( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_26(x_) STDX_PP_SUB_25( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_27(x_) STDX_PP_SUB_26( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_28(x_) STDX_PP_SUB_27( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_29(x_) STDX_PP_SUB_28( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_30(x_) STDX_PP_SUB_29( STDX_PP_LIST_REST(x_) )
#define STDX_PP_SUB_31(x_) STDX_PP_SUB_30( STDX_PP_LIST_REST(x_) )

#define STDX_PP_SUB_32(x_) STDX_PP_SUB_31( STDX_PP_LIST_REST(x_) )

#define STDX_PP_SUB_( num0_, num1_ ) \
  STDX_PP_LIST_SIZE( \
    STDX_PP_CONCAT( STDX_PP_SUB_, num1_ ) ((STDX_PP_NUM(num0_))) )

//------------------------------------------------------------------------
// STDX_PP_DEC
//------------------------------------------------------------------------

#define STDX_PP_DEC_0
#define STDX_PP_DEC_1  0
#define STDX_PP_DEC_2  1
#define STDX_PP_DEC_3  2
#define STDX_PP_DEC_4  3
#define STDX_PP_DEC_5  4
#define STDX_PP_DEC_6  5
#define STDX_PP_DEC_7  6

#define STDX_PP_DEC_8  7
#define STDX_PP_DEC_9  8
#define STDX_PP_DEC_10 9
#define STDX_PP_DEC_11 10
#define STDX_PP_DEC_12 11
#define STDX_PP_DEC_13 12
#define STDX_PP_DEC_14 13
#define STDX_PP_DEC_15 14

#define STDX_PP_DEC_16 15
#define STDX_PP_DEC_17 16
#define STDX_PP_DEC_18 17
#define STDX_PP_DEC_19 18
#define STDX_PP_DEC_20 19
#define STDX_PP_DEC_21 20
#define STDX_PP_DEC_22 21
#define STDX_PP_DEC_23 22

#define STDX_PP_DEC_24 23
#define STDX_PP_DEC_25 24
#define STDX_PP_DEC_26 25
#define STDX_PP_DEC_27 26
#define STDX_PP_DEC_28 27
#define STDX_PP_DEC_29 28
#define STDX_PP_DEC_30 29
#define STDX_PP_DEC_31 30

#define STDX_PP_DEC_32 31

#define STDX_PP_DEC_( num_ ) \
  STDX_PP_CONCAT( STDX_PP_DEC_, num_ )

