//========================================================================
// vc-Assert
//========================================================================

`ifndef VC_ASSERT_V
`define VC_ASSERT_V

//------------------------------------------------------------------------
// VC_PROPAGATE_X
//------------------------------------------------------------------------

`define VC_PROPAGATE_X( i_, o_ )                                        \
  if ((|(i_ ^ i_)) == 1'b0);                                            \
  else                                                                  \
    o_ = o_ + 1'bx

//------------------------------------------------------------------------
// VC_ASSERT
//------------------------------------------------------------------------

`define VC_ASSERT( expr_ )                                              \
  if ( expr_ );                                                         \
  else begin                                                            \
    $display( "\n VC_ASSERT FAILED\n  - assertion       :%s\n  - module instance : %m\n  - time            : %0d\n", \
              "expr_", $time );                                         \
    $finish;                                                            \
  end                                                                   \
  if (1)

//------------------------------------------------------------------------
// VC_ASSERT_FAIL
//------------------------------------------------------------------------

`define VC_ASSERT_FAIL( msg_ )                                         \
  $display( "\n VC_ASSERT FAILED\n  - assertion       :%s\n  - module instance : %m\n  - time            : %0d\n", \
            msg_, $time );                                             \
  $finish;                                                             \
  if (1)

//------------------------------------------------------------------------
// VC_ASSERT_NOT_X
//------------------------------------------------------------------------

`define VC_ASSERT_NOT_X( net_ )                                         \
  if ((|(net_ ^ net_)) == 1'b0);                                        \
  else begin                                                            \
    $display( "\n VC_ASSERT FAILED\n  - assertion that net not contain X's failed\n  - module instance : %m\n  - net             :%s\n  - time            : %0d\n", \
              "net_", $time );                                          \
    $finish;                                                            \
  end                                                                   \
  if (1)

`endif /* VC_ASSERT_V */

