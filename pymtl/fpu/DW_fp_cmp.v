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
// AUTHOR:    Alexandre Tenca, March 2006
//
// VERSION:   Verilog Simulation Model for FP Comparator
//
// DesignWare_version: 58e94b19
// DesignWare_release: M-2016.12-DWBB_201612.0
//
////////////////////////////////////////////////////////////////////////////////
//-------------------------------------------------------------------------------
//
// ABSTRACT: Floating-point Comparator
//           Compares two FP numbers and generates outputs that indicate when 
//           A>B, A<B and A=B. The component also provides outputs for MAX and 
//           MIN values, with corresponding status flags.
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 253 bits
//              exp_width       exponent size,     3 to 31 bits
//              ieee_compliance 0 or 1
//
//              Input ports     Size & Description
//              ===========     ==================
//              a               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              b               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              zctr            1 bit
//                              defines the min/max operation of z0 and z1
//
//              Output ports    Size & Description
//              ===========     ==================
//              aeqb            1 bit
//                              has value 1 when a=b
//              altb            1 bit
//                              has value 1 when a<b
//              agtb            1 bit
//                              has value 1 when a>b
//              unordered       1 bit
//                              one of the inputs is NaN
//              z0              (sig_width + exp_width + 1) bits
//                              Floating-point Number that has max(a,b) when
//                              zctr=1, and min(a,b) otherwise
//              z1              (sig_width + exp_width + 1) bits
//                              Floating-point Number that has max(a,b) when
//                              zctr=0, and min(a,b) otherwise
//              status0         byte
//                              info about FP value in z0
//              status1         byte
//                              info about FP value in z1
//
// MODIFIED: 
//    4/18 - the ieee_compliance parameter is also controlling the use of nans
//           When 0, the component behaves as the MC component (no denormals
//           and no NaNs).
//
//-------------------------------------------------------------------------------

module DW_fp_cmp (a, b, zctr, aeqb, altb, agtb, unordered, z0, z1, status0, status1);
parameter sig_width=23;
parameter exp_width=8;
parameter ieee_compliance=0;

// declaration of inputs and outputs
input  [sig_width + exp_width:0] a,b;
input  zctr;
output aeqb, altb, agtb, unordered;
output [sig_width + exp_width:0] z0, z1;
output [7:0] status0, status1;

// synopsys translate_off
  //-------------------------------------------------------------------------
  // Parameter legality check
  //-------------------------------------------------------------------------
  
 
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


// definitions used in the code
 
reg [0:0] sign;
reg [exp_width-1:0] Ea,Eb;
reg [sig_width:0] Ma,Mb;
reg [sig_width-1:0] Fa,Fb;
reg [(exp_width + sig_width):0] z0_int,z1_int;
reg [8    -1:0] status0_int,status1_int;
reg [0:0] agtb_int,aeqb_int,altb_int, unordered_int;
reg [1:0] chk;
reg zer_a, zer_b;

always @(a or b or zctr) 
begin

  Ea = a[((exp_width + sig_width) - 1):sig_width];
  Eb = b[((exp_width + sig_width) - 1):sig_width];
  Fa = a[(sig_width - 1):0];
  Fb = b[(sig_width - 1):0];
  zer_a = 0;
  zer_b = 0;

  if (ieee_compliance === 1 && Ea === 0)
    begin
      zer_a = Fa === 0;
      Ma = {1'b0,a[(sig_width - 1):0]};
    end
  else if (ieee_compliance === 0 && Ea === 0)
    begin
      Ma = 0;
      zer_a = 1;
    end
  else
    Ma = {1'b1,a[(sig_width - 1):0]};
  if (ieee_compliance === 1 && Eb === 0)
    begin
      zer_b = Fb === 0;
      Mb = {1'b0,b[(sig_width - 1):0]};
    end
  else if (ieee_compliance === 0 && Eb === 0)
    begin
      Mb = 0;
      zer_b = 1;
    end
  else
    Mb = {1'b1,b[(sig_width - 1):0]};
  
  sign = (a[(exp_width + sig_width)] && !zer_a) ^ (b[(exp_width + sig_width)] && !zer_b);

  status0_int = 0;
  status1_int = 0;
  z0_int = 0;
  z1_int = 0;
  agtb_int = 0;
  aeqb_int = 0;
  altb_int = 0;
  unordered_int = 0;

  //
  // NaN input
  //
  if (((Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa !== 0)||		// a or b are NaN.
       (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fb !== 0)) && (ieee_compliance === 1))
  begin
    // nothing to do
    // z0 and z1 get the values of a and b
    unordered_int = 1;
  end
  //
  // Infinity Input
  //
  else if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1))	// a and b are Infinity.
  begin
    if (sign === 0) aeqb_int = 1;
    else if (a[(exp_width + sig_width)] === 0) agtb_int = 1;
    else altb_int = 1;
  end
  else if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1))			// Only a is Infinity.
  begin
    if (a[(exp_width + sig_width)] === 0) agtb_int = 1;
    else altb_int = 1;
  end
  else if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1))			// Only b is Infinity.
  begin
    if (b[(exp_width + sig_width)] === 0) altb_int = 1;
    else agtb_int = 1;
  end
  //
  // Zero Input
  //
  else if (zer_a && zer_b)			// a and b are Zero.
    aeqb_int = 1;	// +0 == -0
  else if (zer_a) 				// Only a is Zero.
  begin
    if (b[(exp_width + sig_width)] === 0) altb_int = 1;
    else agtb_int = 1;
  end
  else if (zer_b)				// Only b is Zero.
  begin
    if (a[(exp_width + sig_width)] === 0) agtb_int = 1;
    else altb_int = 1;
  end
  //
  // Normal/Denormal Inputs
  //
  else if (sign === 1)		// a and b have different sign bit.
  begin
    if (a[(exp_width + sig_width)] === 0) agtb_int = 1;
    else altb_int = 1;
  end
  else if (Ea !== Eb)		// a and b have the same sign, but different exponents
  begin
    if ( (!a[(exp_width + sig_width)] && Ea>Eb) || (a[(exp_width + sig_width)] && Ea<Eb) ) agtb_int = 1;
    else altb_int = 1;
  end
  else 
  begin
    if ( (!a[(exp_width + sig_width)] && Fa>Fb) || (a[(exp_width + sig_width)] && Fa<Fb) ) 
       agtb_int = 1;   // a and b have the same exponent and sign but different fractions
    else if (Fa === Fb) 
       aeqb_int = 1;
    else
       altb_int = 1;
  end

  // Check if agtb_int, aeqb_int, and altb_int are mutually exclusive.
  chk = agtb_int + aeqb_int + altb_int + unordered_int;
  if (chk !== 1) $display ("Error! agtb, aeqb, altb, and unordered are NOT mutually exclusive.");

  // assign a or b to zx outputs according to zctr flag.
  if ( (agtb_int && zctr) || (altb_int && !zctr) || (aeqb_int && !zctr) || (unordered_int) ) 
  begin
    z0_int = a;
    z1_int = b;
    status0_int[7] = 1;
    if (ieee_compliance === 1)
      begin
        if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa !== 0) status0_int[2] = 1;
        if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa === 0) status0_int[1] = 1;
        if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fb !== 0) status1_int[2] = 1;
        if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fb === 0) status1_int[1] = 1;
      end
    else
      begin
        if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1)) status0_int[1] = 1;
        if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1)) status1_int[1] = 1;
      end
    status0_int[0] = zer_a;
    status1_int[0] = zer_b;
  end
  else
  begin
    z0_int = b;
    z1_int = a;
    if (ieee_compliance === 1)
      begin
        if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fb !== 0) status0_int[2] = 1;
        if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fb === 0) status0_int[1] = 1;
        if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa !== 0) status1_int[2] = 1;
        if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1) && Fa === 0) status1_int[1] = 1;
      end
    else
      begin
        if (Eb === ((((1 << (exp_width-1)) - 1) * 2) + 1)) status0_int[1] = 1;
        if (Ea === ((((1 << (exp_width-1)) - 1) * 2) + 1)) status1_int[1] = 1;
      end
    status0_int[0] = zer_b;
    status1_int[0] = zer_a;
    status1_int[7] = 1;
  end

end

assign z0 = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? {exp_width+sig_width+1{1'bx}} : z0_int;
assign z1 = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? {exp_width+sig_width+1{1'bx}} : z1_int;
assign status0 = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? {8'bx} : status0_int;
assign status1 = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? {8'bx} : status1_int;
assign agtb = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? 1'bx : agtb_int;
assign aeqb = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? 1'bx : aeqb_int;
assign altb = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? 1'bx : altb_int;
assign unordered = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0)) ? 1'bx : unordered_int;

// synopsys translate_on

endmodule

