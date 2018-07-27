//------------------------------------------------------------------------
// GcdSource
//------------------------------------------------------------------------

module GcdSource
(
  input  wire        clk,
  input  wire        reset,
  output wire        req_val,
  input  wire        req_rdy,
  output wire [31:0] req_msg,
  output wire        done
);

  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  reg [2:0] state;

  // State transitions

  localparam REQ0 = 3'd0;
  localparam REQ1 = 3'd1;
  localparam REQ2 = 3'd2;
  localparam REQ3 = 3'd3;
  localparam DONE = 3'd4;

  always @ ( posedge clk ) begin
    if ( reset ) begin
      state <= REQ0;
    end
    // Transition to REQ1 is message is sent
    else if ( state == REQ0 ) begin
      if ( req_val && req_rdy ) begin
        state <= REQ1;
        $display( "%d: Request handshake!", $time );
      end
    end
    // Transition to REQ2 is message is sent
    else if ( state == REQ1 ) begin
      if ( req_val && req_rdy ) begin
        state <= REQ2;
        $display( "%d: Request handshake!", $time );
      end
    end
    // Transition to REQ3 is message is sent
    else if ( state == REQ2 ) begin
      if ( req_val && req_rdy ) begin
        state <= REQ3;
        $display( "%d: Request handshake!", $time );
      end
    end
    // Transition to DONE is message is sent
    else if ( state == REQ3 ) begin
      if ( req_val && req_rdy ) begin
        state <= DONE;
        $display( "%d: Request handshake!", $time );
      end
    end
    // DONE state stays DONE forever
    else if ( state == DONE ) begin
    end
    // Default to REQ0
    else begin
      state <= REQ0;
    end
  end

  // Request control

  assign req_val =  ( state == REQ0 )
                 || ( state == REQ1 )
                 || ( state == REQ2 )
                 || ( state == REQ3 );

  // Done signal

  assign done = ( state == DONE );

  //---------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  // Memory for request packets

  reg [31:0] mem [3:0];

  always @ ( posedge clk ) begin
    if ( reset ) begin
      mem[0] <= { 16'd15, 16'd10 };
      mem[1] <= { 16'd22, 16'd10 };
      mem[2] <= { 16'd36, 16'd18 };
      mem[3] <= { 16'd36, 16'd21 };
    end
  end

  // Request message

  assign req_msg = ( state == REQ0 ) ? mem[0]
                 : ( state == REQ1 ) ? mem[1]
                 : ( state == REQ2 ) ? mem[2]
                 : ( state == REQ3 ) ? mem[3]
                 :                     32'd0;

endmodule

