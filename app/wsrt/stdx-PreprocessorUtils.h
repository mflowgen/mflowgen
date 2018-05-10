//========================================================================
// stdx-PreprocessorUtils : Preprocessor utilities
//========================================================================
// We have refactored all of the macro implementations into the inline
// header/source file (stdx-PreprocessorUtils.inl) so that this header
// file can serve as clean documentation of the macros the user should
// actually use.
//
// Many of these macros require a fixed upper limit on either the number
// of arguments they can handle or the amount of iteration. Currently
// this limit is 32, and although it can be increased eventually we have
// to ask if the preprocessor is the right tool for the job.
//
// These macros can be used for relatively powerful code generation. For
// example, the following code shows how to compactly define a set of
// ten templated functions. Each function takes a different number of
// arguments and creates a vector with those arguments.
//
//  #define MK_VER_LB1( idx_ )
//    vec.push_back( v ## idx_ );
//
//  #define MK_VEC_LB0( idx_ )
//    template < class T >
//    std::vector<T>
//    mk_vec( STDX_PP_ENUM_PARAMS( STDX_PP_INC(idx_), const T& v ) )
//    {
//      std::vector<T> vec;
//      STDX_PP_LOOP_X1( STDX_PP_INV(idx_), MK_VEC_LB1 );
//      return vec;
//    }
//
//  STDX_PP_LOOP( 10, MK_VEC_LB0 );
//
// Notice that we use a LB# suffix to indicate macros which are used as
// loop bodies. The final STDX_PP_LOOP macro call essentially calls the
// macro MK_VEC_LB0 ten times - each time passing the current loop
// counter in as the only argument to MK_VEC_LB0. The macro MK_VEC_LB0
// expands to be a templated function definition. The parameter list is
// created using the STDX_PP_ENUM_PARAMS macro - this macro creates a
// comma separated list which looks like this:
//
//  std::vector<T> mk_vec( const T& v1, const T& v2, const T& v3 ... )
//
// The calls to push_back are created using STDX_PP_LOOP again which in
// turn calls MK_VEC_LB1 idx+1 times. Note that we must use the explicit
// STDX_PP_LOOP_X1 version of STDX_PP_LOOP. This is because recursive
// definitions will not be properly expanded by the preprocessor. If we
// used STDX_PP_LOOP inside MK_VEC_LB0 then the final call to
// STDX_PP_LOOP would have a second call to STDX_PP_LOOP inside of it
// which would not be properly expanded. There are X1 and X2 versions of
// the preprocessor loop and list map functions to help with this
// problem.
//
// We increment the index with STDX_PP_INC when call the nested macros
// since the index ranges from 0 to count-1, but the argument to the
// various loop macros represents the total number of iterations.
//
// So the end result is ten templated functions which allow one to
// create vectors using the following syntax.
//
//  stdx::vector<int> vec0 = mk_vec( 0 );
//  stdx::vector<int> vec1 = mk_vec( 0, 1 );
//  stdx::vector<int> vec2 = mk_vec( 0, 1, 2 );
//  stdx::vector<int> vec3 = mk_vec( 0, 1, 2, 3 );
//  ...
//
// Now what if we wanted to create these type of make functions for
// vectors, lists, or any other container with push_back defined? We
// could use a template argument of the make function to specify the
// return type, but this creates rather lengthy syntax, and these make
// functions will often be used to create function call arguments
// inline. So instead we can just create separate functions for the key
// container types.
//
//  #define MK_CONT_LB1( idx_ )
//    c.push_back( v ## idx_ );
//
//  #define MK_CONT_LB0( idx_, cont_, func_ )
//    template < class T >
//    container_<T>
//    func_( STDX_PP_PARAM_LIST( STDX_PP_INC(idx_), const T& v ) )
//    {
//      cont_<T> c;
//      STDX_PP_LOOP_X1( STDX_PP_INC(idx_), MK_CONT_LB1 );
//      return c;
//    }
//
//  STDX_PP_LOOP( 10, MK_CONT_LB0, std::vector, mk_vec  );
//  STDX_PP_LOOP( 10, MK_CONT_LB0, std::list,   mk_list );
//
// This code creates ten templated functions to create vectors with one
// to ten elements, and ten templated functions to create lists with one
// to ten elements. Notice that we can pass an arbitrary number of
// arguments into the loop body macro.
//
// The beauty of all this is that using these macros it is trivial to
// generate these kind of "make container" functions for any contianer
// and for one to maybe 10 arguments. There is no other type-safe way to
// do this other than to have all these functions, but the macros reduce
// code duplication.
//
// Note that some of the implementation for these macros was inspired by
// but not copied from the boost preprocessor library.
//

#ifndef STDX_PREPROCESSOR_UTILS_H
#define STDX_PREPROCESSOR_UTILS_H

//------------------------------------------------------------------------
// STDX_PP_ERROR
//------------------------------------------------------------------------
// We define this macro to itself, but since macros cannot be recursive
// this will essentially evaluate to STDX_PP_ERROR. This will not
// compile and you will get a compile time error. The preprocessor
// utilities sometimes use this as a kind of assertion.

#define STDX_PP_ERROR STDX_PP_ERROR

//------------------------------------------------------------------------
// STDX_PP_EMPTY
//------------------------------------------------------------------------
// This macro is useful sometimes when we want to essentially pass
// nothing as an argument to a macro (eg. one side of a STDX_PP_IF
// should expand to nothing).

#define STDX_PP_EMPTY

//------------------------------------------------------------------------
// STDX_PP_CONCAT
//------------------------------------------------------------------------
// Often we want to use token concatenation operator (##) but we want
// the preprocessor to evaluate the two arguments to the operator
// _before_ actually doing the concatenation. This happens when one of
// the arguments is itself a macro. This macro exploits the fact that
// _macro_ arguments are always evaluated before they are used (in
// contrast to concatenation operator arguments). Essentially we just
// nest some macro calls and the eventually actually use the token
// concatenation operator.

#define STDX_PP_CONCAT( a_, b_ ) \
  STDX_PP_CONCAT_( a_, b_ )

//------------------------------------------------------------------------
// STDX_PP_CONCATN
//------------------------------------------------------------------------
// Compactly concatenate more than two tokens.

#define STDX_PP_CONCAT2( a_, b_ ) \
  STDX_PP_CONCAT2_( a_, b_ )

#define STDX_PP_CONCAT3( a_, b_, c_ ) \
  STDX_PP_CONCAT3_( a_, b_, c_ )

#define STDX_PP_CONCAT4( a_, b_, c_, d_ ) \
  STDX_PP_CONCAT4_( a_, b_, c_, d_ )

#define STDX_PP_CONCAT5( a_, b_, c_, d_, e_ ) \
  STDX_PP_CONCAT5_( a_, b_, c_, d_, e_ )

//------------------------------------------------------------------------
// STDX_PP_STRINGIFY
//------------------------------------------------------------------------
// Often we want to use the stringify operator (#) but we want the
// preprocessor to evaluate the argument to the operator _before_
// actually doing the concatenation. This happens when one of the
// arguments is itself a macro. This macro exploits the fact that
// _macro_ arguments are always evaluated before they are used (in
// contrast to the stringify operator argument). Essentially we just
// nest some macro calls and the eventually actually use the token
// stringify operator.

#define STDX_PP_STRINGIFY( a_ ) \
  STDX_PP_STRINGIFY_( a_ )

//------------------------------------------------------------------------
// STDX_PP_NUM_TO_BOOL
//------------------------------------------------------------------------
// This macro converts a number to a "boolean". If the number is greater
// than zero then it returns 1. If the number is zero it returns zero.

#define STDX_PP_NUM_TO_BOOL( num_ ) \
  STDX_PP_NUM_TO_BOOL_( num_ )

//------------------------------------------------------------------------
// STDX_PP_AND
//------------------------------------------------------------------------
// Return the logical and of the two given conditions after converting
// them into booleans.

#define STDX_PP_AND( cond0_, cond1_ ) \
  STDX_PP_AND_( cond0_, cond1_ )

//------------------------------------------------------------------------
// STDX_PP_OR
//------------------------------------------------------------------------
// Return the logical or of the two given conditions after converting
// them into booleans.

#define STDX_PP_OR( cond0_, cond1_ ) \
  STDX_PP_OR_( cond0_, cond1_ )

//------------------------------------------------------------------------
// STDX_PP_IF
//------------------------------------------------------------------------
// This macro evaluates the condition (cond_) and if it is zero (false)
// then it evaluates m0 while if it is greater than zero (true) it
// evaluates m1. Fixed upper limit of 32 for the condition.

#define STDX_PP_IF( cond_, m0_, m1_ ) \
  STDX_PP_IF_( cond_, m0_, m1_ )

//------------------------------------------------------------------------
// STDX_PP_COMMA
//------------------------------------------------------------------------
// Expanding macros into comma's can be very tricky since the comma
// is a macro argument deliminter. If you are careful you can do it by
// making some macro expand out to STDX_PP_COMMA and then putting the ()
// at the toplevel so that this macro gets expanded last. Usually you
// are better off using STDX_PP_COMMA_IF directly.

#define STDX_PP_COMMA() ,

//------------------------------------------------------------------------
// STDX_PP_COMMA_IF
//------------------------------------------------------------------------
// This macro will expand to a comma only if the condition (which is
// first converted to a boolean) is true.

#define STDX_PP_COMMA_IF( cond_ ) \
  STDX_PP_COMMA_IF_( cond_ )

//------------------------------------------------------------------------
// STDX_PP_STRIP_PAREN
//------------------------------------------------------------------------
// Remove the parentheses around the argument. This is useful for
// removing the parentheses around a list or a code block. In both of
// these cases the parentheses are there to help escape commas. Be
// careful because once you remove the parenthesis and try and pass the
// result to another macro, the items will be parsed as many arguments
// due to the commas (instead of just one which is the case with lists).

#define STDX_PP_STRIP_PAREN( a_ ) \
  STDX_PP_STRIP_PAREN_( a_ )

//------------------------------------------------------------------------
// STDX_PP_LOOP
//------------------------------------------------------------------------
// This macro will call the macro m count times with the given args. The
// loop body macro should take at least one argument which is the
// current count for that iteration. The loop body macro can take
// additional arguments which are passed from the top-level loop macro
// to all loop body calls. There is a fixed upper limit of 32 on count.
// For example, the following code declares four int variables:
//
//  #define LOOP_BODY( count ) STDX_CONCAT( int var, count ) = 0;
//  STDX_PP_LOOP( 4, LOOP_BODY );
//
// This results in the following code. Note that it is all on one line.
//
//  int var1 = 0; int var2 = 0; int var3 = 0; int var4 = 0;
//
// Since macros cannot be recursive we cannot use STDX_PP_LOOP within a
// loop body. So you will can use the _X1 or _X2 variations to create
// nested loops. See the top of this file for an example.

#define STDX_PP_LOOP( count_, m_, args_... ) \
  STDX_PP_LOOP_( count_, m_, ## args_ )

#define STDX_PP_LOOP_X1( count_, m_, args_... ) \
  STDX_PP_LOOP_X1_( count_, m_, ## args_ )

#define STDX_PP_LOOP_X2( count_, m_, args_... ) \
  STDX_PP_LOOP_X2_( count_, m_, ## args_ )

//------------------------------------------------------------------------
// STDX_PP_LOOP_C
//------------------------------------------------------------------------
// This macro will call the macro m count times with the given args. The
// loop body macro should take at least one argument which is the
// current count for that iteration. The loop body macro can take
// additional arguments which are passed from the top-level loop macro
// to all loop body calls. A comma is inserted in between each macro m
// call. Note that there is no "hanging" comma at the end. There is a
// fixed upper limit of 32 on count. For example, the following code
// generates a function declaration with four arguments:
//
//  #define LOOP_BODY( count_ ) STDX_CONCAT( int var, count_ )
//  void foo( STDX_PP_LOOP_C( 4, LOOP_BODY ) );
//
// This results in the following code:
//
//  void foo( int var1, int var2, int var3, int var4 );
//
// Since macros cannot be recursive we cannot use STDX_PP_LOOP_C within
// a loop body. So you will can use the _X1 or _X2 variations to create
// nested loops. See the top of this file for an example.

#define STDX_PP_LOOP_C( count_, m_, args_... ) \
  STDX_PP_LOOP_C_( count_, m_, ## args_ )

#define STDX_PP_LOOP_C_X1( count_, m_, args_... ) \
  STDX_PP_LOOP_C_X1_( count_, m_, ## args_ )

#define STDX_PP_LOOP_C_X2( count_, m_, args_... ) \
  STDX_PP_LOOP_C_X2_( count_, m_, ## args_ )

//------------------------------------------------------------------------
// STDX_PP_ENUM_PARAMS
//------------------------------------------------------------------------
// This macro creates a comma separated list, with each item consisting
// of pfx_ followed by the count_. So the following generates a function
// declaration with four arguments:
//
//  void foo( STDX_PP_ENUM_PARAMS( 4, int var ) );
//
// This results in the following code:
//
//  void foo( int var1, int var2, int var3, int var4 );
//
// Note that this macro does _not_ use the standard STDX_PP_LOOP_C
// macros and instead implements the required iteration itself. This is
// allows this macro the be used within any of the STDX_PP_LOOP macros
// without concernts for recursion.

#define STDX_PP_ENUM_PARAMS( count_, pfx_ ) \
  STDX_PP_ENUM_PARAMS_( count_, pfx_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_EMPTY
//------------------------------------------------------------------------
// This macro creates an empty list. Lists are comma delimited and
// surounded by a set of parenthesis.

#define STDX_PP_LIST_EMPTY ()

//------------------------------------------------------------------------
// STDX_PP_LIST_SIZE
//------------------------------------------------------------------------
// This macro returns the number of items in the given list. It
// correctly handles the tricky case where the list is empty. Using a
// list which is larger than the fixed upper limit of 32 items is
// undefined.

#define STDX_PP_LIST_SIZE( list_ ) \
  STDX_PP_LIST_SIZE_( list_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_AT
//------------------------------------------------------------------------
// Return the item at the given index in the list. The results are
// undefined is the index is negative, equal to the list size, or
// greater than the list size. Using a list which is larger than the
// fixed upper limit of 32 items is undefined.

#define STDX_PP_LIST_AT( list_, index_ ) \
  STDX_PP_LIST_AT_( list_, index_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_PUSH
//------------------------------------------------------------------------
// Push a new item onto the front of a list and return the new list.
// Using a list which is larger than the fixed upper limit of 32 items
// is undefined.

#define STDX_PP_LIST_PUSH( list_, item_ ) \
  STDX_PP_LIST_PUSH_( list_, item_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_FIRST
//------------------------------------------------------------------------
// Return the first item in the given list. If the list is empty then
// expand to nothing. Using a list which is larger than the fixed upper
// limit of 32 items is undefined.

#define STDX_PP_LIST_FIRST( list_ ) \
  STDX_PP_LIST_FIRST_( list_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_REST
//------------------------------------------------------------------------
// Remove the first item in the given list and return a new list which
// includes the rest of the items. If the list is empty then expand to
// an empty list. Using a list which is larger than the fixed upper
// limit of 32 items is undefined.

#define STDX_PP_LIST_REST( list_ ) \
  STDX_PP_LIST_REST_( list_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_STRIP_PAREN
//------------------------------------------------------------------------
// Remove the parenthesis around a list so that the result is a comma
// separated list of elements. Be careful because once you remove the
// parenthesis and try and pass the result to another macro, the items
// will be parsed as many arguments (instead of just one which is the
// case with lists). Lists have a fixed upper limit of 32 items. Using a
// larger list is undefined. Using a list which is larger than the fixed
// upper limit of 32 items is undefined.

#define STDX_PP_LIST_STRIP_PAREN( list_ ) \
  STDX_PP_LIST_STRIP_PAREN_( list_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_APPEND
//------------------------------------------------------------------------
// Append two lists together. Lists have a fixed upper limit of 32
// items, so the resulting size of the new list must be smaller than
// Using lists which result in a new list larger than the fixed upper
// limit of 32 items is undefined.

#define STDX_PP_LIST_APPEND( list0_, list1_ ) \
  STDX_PP_LIST_APPEND_( list0_, list1_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_MAP
//------------------------------------------------------------------------
// This macro will call the macro m once for each item in the list. The
// loop body macro m should take at least two arguments: the current
// count and the current item for that iteration. The loop body macro
// can take additional arguments which are passed from the top-level
// loop macro to all loop body calls. Using a list which is larger than
// the fixed upper limit of 32 items is undefined. For example, the
// following code declares four int variables initialized to increasing
// values.
//
//  #define LOOP_BODY( count_, item_ ) int item_ = count_;
//  STDX_PP_LIST_MAP( (a,b,c,d), LOOP_BODY )
//
// Which expands to this:
//
//  int a = 0; int b = 1; int c = 2; int d = 3;
//
// Since macros cannot be recursive we cannot use STDX_PP_LIST_MAP (or
// STDX_PP_LOOP) within a loop body. So you will can use the _X1 or _X2
// variations to create nested loops. See the top of this file for an
// example.

#define STDX_PP_LIST_MAP( list_, m_, args_... ) \
  STDX_PP_LIST_MAP_( list_, m_, ## args_ )

#define STDX_PP_LIST_MAP_X1( list_, m_, args_... ) \
  STDX_PP_LIST_MAP_X1_( list_, m_, ## args_ )

#define STDX_PP_LIST_MAP_X2( list_, m_, args_... ) \
  STDX_PP_LIST_MAP_X2_( list_, m_, ## args_ )

//------------------------------------------------------------------------
// STDX_PP_LIST_MAP_C
//------------------------------------------------------------------------
// This macro will call the macro m once for each item in the list. The
// loop body macro m should take at least two arguments: the current
// count and the current item for that iteration. The loop body macro
// can take additional arguments which are passed from the top-level
// loop macro to all loop body calls. A comma is inserted in between
// each macro m call. Note that there is no "hanging" comma at the end.
// Using a list which is larger than the fixed upper limit of 32 items
// is undefined. For example, the following code generates a function
// declaration with four arguments.
//
//  #define LOOP_BODY( count_, item_ ) int item_
//  void foo( STDX_PP_LIST_MAP_C( (a,b,c,d), LOOP_BODY ) );
//
// Which expands to this:
//
//  void foo( int a, int b, int c, int d );
//
// Since macros cannot be recursive we cannot use STDX_PP_LIST_MAP_C (or
// STDX_PP_LOOP_C) within a loop body. So you will can use the _X1 or
// _X2 variations to create nested loops. See the top of this file for
// an example.

#define STDX_PP_LIST_MAP_C( list_, m_, args_... ) \
  STDX_PP_LIST_MAP_C_( list_, m_, ## args_ )

#define STDX_PP_LIST_MAP_C_X1( list_, m_, args_... ) \
  STDX_PP_LIST_MAP_C_X1_( list_, m_, ## args_ )

#define STDX_PP_LIST_MAP_C_X2( list_, m_, args_... ) \
  STDX_PP_LIST_MAP_C_X2_( list_, m_, ## args_ )

//------------------------------------------------------------------------
// STDX_PP_ADD
//------------------------------------------------------------------------
// Add the two numbers a and b together. The inputs must be equal to or
// less than 32. The results are undefined if the inputs are greater
// than 32 or if the inputs are not numbers.

#define STDX_PP_ADD( num0_, num1_ ) \
  STDX_PP_ADD_( num0_, num1_ )

//------------------------------------------------------------------------
// STDX_PP_INC
//------------------------------------------------------------------------
// Add the one to the given number. The inputs must be equal to or less
// than 32. The results are undefined if the inputs are greater than 32
// or if the inputs are not numbers.

#define STDX_PP_INC( num_ ) \
  STDX_PP_INC_( num_ )

//------------------------------------------------------------------------
// STDX_PP_SUB
//------------------------------------------------------------------------
// Subtract b from a. The inputs must be equal to or less than 32 and
// the result cannot be negative. The results are undefined if the
// inputs are greater than 32, the result is negative, or if the inputs
// are not numbers.

#define STDX_PP_SUB( num0_, num1_ ) \
  STDX_PP_SUB_( num0_, num1_ )

//------------------------------------------------------------------------
// STDX_PP_DEC
//------------------------------------------------------------------------
// Subtract one from the given number. The inputs must be equal to or
// less than 32 and the result cannot be negative. The results are
// undefined if the inputs are greater than 32, the result is negative,
// or if the inputs are not numbers.

#define STDX_PP_DEC( num_ ) \
  STDX_PP_DEC_( num_ )

#include "stdx-PreprocessorUtils.inl"
#endif /* STDX_PREPROCESSOR_UTILS_H */

