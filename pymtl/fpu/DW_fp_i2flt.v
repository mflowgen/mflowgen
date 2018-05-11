
////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2006 - 2016 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Kyung-Nam Han, Jan. 17, 2006
//
// VERSION:   Verilog Simulation Model for DW_fp_i2flt
//
// DesignWare_version: 53eb9285
// DesignWare_release: M-2016.12-DWBB_201612.0
//
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//
// ABSTRACT:  Integer Number Format to Floatin-point Number Format
// Converter
//
//              This converts an integer number to a floating-point
//              number. Both 2's complement signed integer and unsigned
//              integer are supported.
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 253 bits
//              exp_width       exponent size,     3 to 31 bits
//              isize           integer size,      3 to 512 bits
//              isign           signed/unsigned number flag
//                              0 - unsigned, 1 - signed integer (2's complement)
//
//              Input ports     Size & Description
//              ===========     ==================
//              a               (isize)-bits
//                              Integer Input
//              rnd             3 bits
//                              Rounding Mode Input
//              z               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Output
//              status          8 bits
//                              Status Flags Output
//
// MODIFIED:
//
//	8/1/2012    RJK - Tightened isize restriction as per STAR 9000557637
//-----------------------------------------------------------------------------

module DW_fp_i2flt (a, rnd, z, status);

  parameter sig_width = 23;  // RANGE 2 TO 253
  parameter exp_width = 8;   // RANGE 3 TO 31
  parameter isize = 32;      // RANGE 3 TO 512
  parameter isign = 1;	     // RANGE 0 TO 1
                             // 0 : unsigned, 1 : signed
  input  [isize-1:0] a;
  input  [2:0] rnd; 
  output [exp_width + sig_width:0] z;
  output [7:0] status; 

  // synopsys translate_off


  `define Mwidth  (sig_width + 4)
  `define Movf    (`Mwidth - 1)
  `define ML      2
  `define MR      1
  `define MS      0
  `define rnd_Width  4
  `define rnd_Inc  0
  `define rnd_Inexact  1
  `define rnd_HugeInfinity  2
  `define rnd_TinyminNorm  3
  `define ai_lsb ((isize - sig_width - 2 >= 0) ? isize - sig_width - 2 : 0)
	    
  // --------------------------------------------------------------------
  

  //-------------------------------------------------------------------------
  // Parameter legality check
  //-------------------------------------------------------------------------

  // XXX: berkin
  /* verilator lint_off WIDTH */
    
 
  initial begin : parameter_check
    integer param_err_flg;

    param_err_flg = 0;
    
      
    if ( (sig_width < 2) || (sig_width > 253) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter sig_width (legal range: 2 to 253)",
	sig_width );
    end
      
    if ( (exp_width < 3) || (exp_width > 31) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter exp_width (legal range: 3 to 31)",
	exp_width );
    end
     
    if ( (isize < 3+isign) || (isize > 512) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m : Parameter isize must be at least 3+isign and no greater than 512" );
    end 
      
    if ( (isign < 0) || (isign > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter isign (legal range: 0 to 1)",
	isign );
    end
    
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 

  //---------------------------------------------------------------------


  
  function [`rnd_Width-1:0] rnd_eval;
  
    input [2:0] rnd;
    input [0:0] Sign;
    input [0:0] L,R,stk;
    
    
    begin
      rnd_eval[`rnd_Inc] = 0;
      rnd_eval[`rnd_Inexact] = R|stk;
      rnd_eval[`rnd_HugeInfinity] = 0;
      rnd_eval[`rnd_TinyminNorm] = 0;
      
      if ($time > 0) 
      begin
        case (rnd)
          3'b000:
          begin
            // round to nearest (even)
            rnd_eval[`rnd_Inc] = R&(L|stk);
            rnd_eval[`rnd_HugeInfinity] = 1;
            rnd_eval[`rnd_TinyminNorm] = 0;
          end
          3'b001:
          begin
            // round to zero
            rnd_eval[`rnd_Inc] = 0;
            rnd_eval[`rnd_HugeInfinity] = 0;
            rnd_eval[`rnd_TinyminNorm] = 0;
          end
          3'b010:
          begin
            // round to positive infinity
            rnd_eval[`rnd_Inc] = ~Sign & (R|stk);
            rnd_eval[`rnd_HugeInfinity] = ~Sign;
            rnd_eval[`rnd_TinyminNorm] = ~Sign;
          end
          3'b011:
          begin
            // round to negative infinity
            rnd_eval[`rnd_Inc] = Sign & (R|stk);
            rnd_eval[`rnd_HugeInfinity] = Sign;
            rnd_eval[`rnd_TinyminNorm] = Sign;
          end
          3'b100:
          begin
            // round to nearest (up)
            rnd_eval[`rnd_Inc] = R;
            rnd_eval[`rnd_HugeInfinity] = 1;
            rnd_eval[`rnd_TinyminNorm] = 0;
          end
          3'b101:
          begin
            // round away form 0
            rnd_eval[`rnd_Inc] = R|stk;
            rnd_eval[`rnd_HugeInfinity] = 1;
            rnd_eval[`rnd_TinyminNorm] = 1;
          end
          default:
          begin
            $display("Error! illegal rounding mode.\n");
            $display("a : %b", a);
            $display("rnd : %b", rnd);
          end
        endcase
      end
    end
  endfunction

  // --------------------------------------------------------------------
  
  reg [isize-1:0] Ai;
  reg [8    -1:0] status_reg; 
  reg [(exp_width + sig_width):0] z_reg;
  reg [isize-1:0] LZ;
  reg [isize-1:0] num;
  reg [`Mwidth-1:0] Mf;			// Mantissa for floating points.
  reg [exp_width:0] EXP;
  reg [0:0] STK;
  reg [`rnd_Width-1:0] rnd_val;
  
  // --------------------------------------------------------------------
  
  always @(a or rnd)
  begin
    Ai = a;
    status_reg = 0;
    LZ = 0;
    Mf = 0;
    EXP = 0;
    STK = 0;
  
    if (Ai === 0)				// Exact Zero
      begin
      status_reg[0] = 1; z_reg = 0; 
      end 
    else					// Nonzero Integer
      begin
      // Convert signed integer (two's complement) to unsigned magnitude representation.
      // Set the sign bit of Floating Point Number.
      if (isign === 1)		// Signed
        begin
        if(Ai[isize-1] === 1)
          begin
          Ai = ~Ai + 1;
          z_reg[(exp_width + sig_width)] = 1;
          end
        else
          begin
          z_reg[(exp_width + sig_width)] = 0;
          end
        end
      else				// Unsigned
        begin
        z_reg[(exp_width + sig_width)] = 0;
        end
  
      // Convert the unsigned magnitude representation to floating point format.
      // Left shift to normalize Ai.
      while(Ai[isize-1] != 1)
        begin
        Ai = Ai << 1;
        LZ = LZ + 1;
        end
  
      // Calculate the Biased Exponent.
      if(isize - 1 - LZ + ((1 << (exp_width-1)) - 1) >= ((((1 << (exp_width-1)) - 1) * 2) + 1))
        EXP = ((((1 << (exp_width-1)) - 1) * 2) + 1);
      else
        EXP = isize - 1 - LZ + ((1 << (exp_width-1)) - 1);
  
      // Converts integer to fraction.
      if(isize <= sig_width+2)
        // If the Mantissa fraction (sig_width+2) is big enough to hold Ai,
        // Left adjustment at `Movf-1: `Movf-1-(isize-1) = `Movf-isize >= 1
        begin
        Mf[`Movf-1:0] = Ai << (`Movf-isize);
        end
      else
        // If the Mantissa fraction (sig_width+2) is NOT big enough to hold Ai,
        // calculate the STK.
        begin
        Mf[`Movf-1:`MR] = Ai[isize-1:`ai_lsb];
        STK = 0;
        num = isize-sig_width-3;	// the mininum is 0.
        while(num !== 0)
          begin
          STK = STK | Ai[num];
          num = num - 1;
          end
        STK = STK | Ai[num];
        Mf[`MS] = STK;
        end
  
      // Round the Mantissa according to the rounding modes.
      rnd_val = rnd_eval(rnd, z_reg[(exp_width + sig_width)], Mf[`ML], Mf[`MR], Mf[`MS]);
      if (rnd_val[`rnd_Inc] === 1) Mf = Mf + (1<<`ML);
      status_reg[5] = rnd_val[`rnd_Inexact];
  
      // Normalize the Mantissa for overflow case after rounding.
      if ( (Mf[`Movf] === 1) )
        begin
        EXP = EXP + 1;
        Mf = Mf >> 1;
        end
  
      // Note: "Tiny" situation doesn't exist.
      if(EXP >= ((((1 << (exp_width-1)) - 1) * 2) + 1))			// Huge
        begin
        status_reg[4] = 1;
        status_reg[5] = 1;
        if(rnd_val[`rnd_HugeInfinity] === 1)
          begin
          // Infinity
          EXP = ((((1 << (exp_width-1)) - 1) * 2) + 1);
          //Mf[`Movf-2:`ML] = -1;
          Mf[`Movf-2:`ML] = 0;
          status_reg[1] = 1;
          end
        else
          begin
          // MaxNorm
          EXP = ((((1 << (exp_width-1)) - 1) * 2) + 1) - 1;
          Mf[`Movf-2:`ML] = -1;
          end
        end
  
      z_reg = {z_reg[(exp_width + sig_width)],EXP[exp_width-1:0],Mf[`Movf-2:`ML]};
      end
  end
  
  assign status = status_reg;
  assign z = z_reg;

  `undef Mwidth
  `undef Movf
  `undef ML
  `undef MR
  `undef MS
  `undef rnd_Width
  `undef rnd_Inc
  `undef rnd_Inexact
  `undef rnd_HugeInfinity
  `undef rnd_TinyminNorm
  `undef ai_lsb

  // synopsys translate_on
  
 endmodule
