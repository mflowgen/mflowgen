//------------------------------------------------------------------------
// GcdSink
//------------------------------------------------------------------------

module GcdSink
(
  input  wire        clk,
  input  wire        reset,
  input  wire        resp_val,
  output wire        resp_rdy,
  input  wire [15:0] resp_msg,
  output wire        done
);

  // Memory for response packets

  reg [15:0] mem [3:0];

  //----------------------------------------------------------------------
  // Control
  //----------------------------------------------------------------------

  reg [2:0] state;

  // State transitions

  localparam RESP0 = 3'd0;
  localparam RESP1 = 3'd1;
  localparam RESP2 = 3'd2;
  localparam RESP3 = 3'd3;
  localparam DONE  = 3'd4;

  always @ ( posedge clk ) begin
    if ( reset ) begin
      state <= RESP0;
    end
    // Transition to RESP1 is message is sent
    else if ( state == RESP0 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= RESP1;
        if ( resp_msg == mem[0] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[0] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[0] );
        end
      end
    end
    // Transition to RESP2 is message is sent
    else if ( state == RESP1 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= RESP2;
        if ( resp_msg == mem[1] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[1] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[1] );
        end
      end
    end
    // Transition to RESP3 is message is sent
    else if ( state == RESP2 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= RESP3;
        if ( resp_msg == mem[2] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[2] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[2] );
        end
      end
    end
    // Transition to DONE is message is sent
    else if ( state == RESP3 ) begin
      if ( resp_val && resp_rdy ) begin
        state <= DONE;
        if ( resp_msg == mem[3] ) begin
          $display( "%d: Response correct! (actual %d, expected %d)", $time, resp_msg, mem[3] );
        end
        else begin
          $display( "%d: Response INCORRECT! (actual %d, expected %d)", $time, resp_msg, mem[3] );
        end
      end
    end
    // DONE state stays DONE forever
    else if ( state == DONE ) begin
    end
    // Default to RESP0
    else begin
      state <= RESP0;
    end
  end

  // Response control -- always ready

  assign resp_rdy = 1'b1;

  // Done signal

  assign done = ( state == DONE );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  always @ ( posedge clk ) begin
    if ( reset ) begin
      mem[0] <= { 16'd5  };
      mem[1] <= { 16'd2  };
      mem[2] <= { 16'd18 };
      mem[3] <= { 16'd3  };
    end
  end

endmodule

