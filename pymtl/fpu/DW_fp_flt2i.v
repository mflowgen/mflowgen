
////////////////////////////////////////////////////////////////////////////////
//
//       This confidential and proprietary software may be used only
//     as authorized by a licensing agreement from Synopsys Inc.
//     In the event of publication, the following notice is applicable:
//
//                    (C) COPYRIGHT 2005 - 2016 SYNOPSYS INC.
//                           ALL RIGHTS RESERVED
//
//       The entire notice above must be reproduced on all authorized
//     copies.
//
// AUTHOR:    Kyung-Nam Han, Oct. 31, 2005
//
// VERSION:   Verilog Simulation Model for DW_fp_flt2i
//
// DesignWare_version: 3b5d9457
// DesignWare_release: M-2016.12-DWBB_201612.0
//
////////////////////////////////////////////////////////////////////////////////

//
// ABSTRACT:  Floating-point Number Format to Integer Number Format
//            Converter
//
//              This converts a floating-point number to a signed
//              integer number.
//              Conversion to a unsigned integer number is not supported.
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 253 bits
//              exp_width       exponent size,     3 to 31 bits
//              isize           integer size,      3 to 512 bits
//              ieee_compliance support the IEEE Compliance 
//                              including NaN and denormal expressions.
//                              0 - IEEE 754 compatible without denormal support
//                                  (NaN becomes Infinity, Denormal becomes Zero)
//                              1 - IEEE 754 standard compatible
//                                  (NaN and denormal numbers are supported)
//
//              Input ports     Size & Description
//              ===========     ==================
//              a               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              rnd             3 bits
//                              Rounding Mode Input
//              z               (isize)-bits
//                              Converted Integer Output
//              status          8 bits
//                              Status Flags Output
//
// Modified:
//  Mar. 13. 2008 Kyung-Nam Han (from 0712-SP3)
//    Removed VCS Warning Message (STAR 9000232556) 
//  Sep. 09. 2009 Kyung-Nam Han (0903-SP3)
//    Added ieee_compliance parameter
//-----------------------------------------------------------------------------

module DW_fp_flt2i (a, rnd, z, status);

  parameter sig_width=23;        // RANGE 2 TO 253
  parameter exp_width=8;         // RANGE 3 TO 31
  parameter isize=32;            // RANGE 3 TO 512
  parameter ieee_compliance = 0; // RANGE 0 to 1
  
  input  [exp_width + sig_width:0] a;
  input  [2:0] rnd;
  output [isize - 1:0] z;
  output [7:0] status;
  
  // synopsys translate_off


  `define isign               0  // 0 : signed, 1 : unsigned 
  `define rnd_Width           4
  `define rnd_Inc             0
  `define rnd_Inexact         1
  `define rnd_HugeInfinity    2
  `define rnd_TinyminNorm     3
  `define Mwidth              (2 * isize + 2)
  `define Movf                (`Mwidth - 1)
  `define MM                  (`Movf - 1)
  `define ML                  (`Movf - isize)
  `define MR                  (`ML - 1)
  `define MS                  (`ML - 2)
  `define af_lsb              ((sig_width <= isize) ? 0 : (sig_width - 1) - isize + 1)
  `define DW_MI_LSB           ((sig_width <= isize) ? `MR - sig_width + 1 : 0)
  
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
        
    if ( (isize < 3) || (isize > 512) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter isize (legal range: 3 to 512)",
	isize );
    end
        
    if ( (ieee_compliance < 0) || (ieee_compliance > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter ieee_compliance (legal range: 0 to 1)",
	ieee_compliance );
    end
     
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 

  //-----------------------------------------------------  
  
  
  function [`rnd_Width-1:0] rnd_eval;
  
    input [2:0] rnd;
    input [0:0] Sign;
    input [0:0] L,R,stk;
    
    
    begin
      rnd_eval[`rnd_Inc] = 0;
      rnd_eval[`rnd_Inexact] = R|stk;
      rnd_eval[`rnd_HugeInfinity] = 0;
      rnd_eval[`rnd_TinyminNorm] = 0;
      
      if ($time > 0) begin
        case (rnd)
          3'b000:
          begin
            rnd_eval[`rnd_Inc] = R&(L|stk);
            rnd_eval[`rnd_HugeInfinity] = 1;
            rnd_eval[`rnd_TinyminNorm] = 0;
          end
          3'b001:
          begin
            rnd_eval[`rnd_Inc] = 0;
            rnd_eval[`rnd_HugeInfinity] = 0;
            rnd_eval[`rnd_TinyminNorm] = 0;
          end
          3'b010:
          begin
            rnd_eval[`rnd_Inc] = ~Sign & (R|stk);
            rnd_eval[`rnd_HugeInfinity] = ~Sign;
            rnd_eval[`rnd_TinyminNorm] = ~Sign;
          end
          3'b011:
          begin
            rnd_eval[`rnd_Inc] = Sign & (R|stk);
            rnd_eval[`rnd_HugeInfinity] = Sign;
            rnd_eval[`rnd_TinyminNorm] = Sign;
          end
          3'b100:
          begin
            rnd_eval[`rnd_Inc] = R;
            rnd_eval[`rnd_HugeInfinity] = 1;
            rnd_eval[`rnd_TinyminNorm] = 0;
          end
          3'b101:
          begin
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
  
  reg [(exp_width + sig_width):0] af;
  reg [8    -1:0] status_reg;
  reg [isize-1:0] z_reg;
  reg [exp_width-1:0] eaf;
  reg [`Mwidth-1:0] mi;
  reg [exp_width-1:0] exp;
  reg [0:0] stk;
  reg [`rnd_Width-1:0] rnd_val;  
  reg [isize-1:0] maxneg;
  reg [isize-1:0] maxpos;
  reg [(sig_width - 1):0] sig;
  reg inf_input;
  reg denorm_input;
  reg nan_input;
  reg zero_input;

  integer num;
  
  assign status = status_reg;
  assign z = z_reg;
  
  always @(a or rnd) begin : a1000_PROC
    
    af = a;
    status_reg = 0;
    mi = 0;
    exp = 0;
    stk = 0;
    eaf = af[((exp_width + sig_width) - 1):sig_width];
    num = 0;
    sig  = af[(sig_width - 1):0];

    if (ieee_compliance) begin
      inf_input = (eaf == ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (sig == 0);
      nan_input = (eaf == ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (sig != 0);
      denorm_input = (eaf == 0) & (sig != 0);
      zero_input = (eaf == 0) & (sig == 0);
    end
    else begin
      inf_input = (eaf == ((((1 << (exp_width-1)) - 1) * 2) + 1));
      nan_input = 0;
      denorm_input = 0;
      zero_input = (eaf == 0 );
    end
    
    if (inf_input) begin
      
      if (ieee_compliance) begin
        status_reg[2] = 1;
      end
      else begin
        status_reg[6] = 1;
        status_reg[5] = 1;
      end
      
    end
    else if (nan_input) begin
      
      status_reg[2] = 1;

    end
    else if (zero_input) begin
      
      status_reg[0] = 1;
      
    end
    else begin
      
      mi[`ML] = 1;
      
      if (sig_width <= isize) begin
        
        mi[`MR:`DW_MI_LSB] = af[(sig_width - 1):0];
        
      end
      else begin
        

        mi[`MR:`MR-isize+1] = af[(sig_width - 1):`af_lsb];
        num = (sig_width - 1) - isize;  // >= 0
        stk = 0;
        
        while (num != 0) begin
          stk = stk | af[num];
          num = num - 1;
        end
        
        stk = stk | af[num];
        mi[0] = stk;
      end

      if (eaf >= ((1 << (exp_width-1)) - 1)) begin
        exp = eaf - ((1 << (exp_width-1)) - 1);
        
        while (exp !== 0) begin
          if (mi[`Movf] !== 1) begin
            mi = mi << 1;
          end
          
          exp = exp - 1;
        end
      end
      else begin
        
        exp = ((1 << (exp_width-1)) - 1) - eaf;
        
        while (exp != 0) begin
          
          stk = mi[0];
          mi = mi >> 1;
          mi[0] = stk | mi[0];
          exp = exp - 1;
          
        end
      end
      
      
      if (mi[`Movf] === 1) begin
      
        status_reg[6] = 1;
        status_reg[5] = 1;
        
      end
      else begin
      
        stk = 0;
        num = `MS;
        
        while (num != 0) begin
          stk = stk | mi[num];
          num = num - 1;
        end
        
        stk = stk | mi[num];
        mi[`MS] = stk;
        
        rnd_val = rnd_eval(rnd, af[(exp_width + sig_width)], mi[`ML], mi[`MR], mi[`MS]);

        if (rnd_val[`rnd_Inc] === 1) begin
          mi = mi + (1<<`ML);
        end
        
        status_reg[5] =
        status_reg[5] | rnd_val[`rnd_Inexact];
        
        if (mi[`Movf] === 1) begin
          
          status_reg[6] = 1;
          status_reg[5] = 1;
          
        end
        else if (mi[`MM:`ML] === 0) begin
          
          status_reg[0] = 1;

          if (denorm_input) begin
            status_reg[3] = 1;
          end
          
        end
      end
      
    end

    
    
    if (`isign === 0) begin

      maxneg = 0;
      maxneg[isize-1] = 1;
      maxpos = -1;
      maxpos[isize-1] = 0;
      
      if ( (af[(exp_width + sig_width)] === 1 && mi[`MM:`ML] > maxneg) ||
        (af[(exp_width + sig_width)] === 0 && mi[`MM:`ML] > maxpos) ) begin
        
        status_reg[6] = 1;
        status_reg[5] = 1;
        
      end
      
      if (af[(exp_width + sig_width)] === 1) begin
        
        if (status_reg[6] === 1 || 
            status_reg[2] === 1) begin
          z_reg = -maxneg;
        end
        else if (status_reg[0] === 1) begin
          z_reg = 0;
        end
        else begin
          z_reg = -mi[`MM:`ML];
        end
        
      end
      else begin
        
        if (status_reg[6] === 1 ||
            status_reg[2] === 1) begin
          z_reg = maxpos;
        end
        else if (status_reg[0] === 1) begin
          z_reg = 0;
        end
        else begin
          z_reg = mi[`MM:`ML];
        end
        
      end
      
    end
    else begin
      
      $display("Error! Unsigned integer for DW_fp_flt2i is not supported.");
      
    end
  end

  `undef isign
  `undef rnd_Width
  `undef rnd_Inc
  `undef rnd_Inexact
  `undef rnd_HugeInfinity
  `undef rnd_TinyminNorm
  `undef Mwidth
  `undef Movf
  `undef MM
  `undef ML
  `undef MR
  `undef MS
  `undef af_lsb
  `undef DW_MI_LSB

  // synopsys translate_on

endmodule
