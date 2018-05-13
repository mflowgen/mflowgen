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
// AUTHOR:    Kyung-Nam Han, Feb. 22, 2006
//
// VERSION:   Verilog Simulation Model for DW_fp_mult
//
// DesignWare_version: 89edc232
// DesignWare_release: M-2016.12-DWBB_201612.0
//
////////////////////////////////////////////////////////////////////////////////

//-----------------------------------------------------------------------------
//
// ABSTRACT: Floating-Point Multiplier
//
//              DW_fp_mult calculates the floating-point multiplication
//              while supporting six rounding modes, including four IEEE
//              standard rounding modes.
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 253 bits
//              exp_width       exponent size,     3 to 31 bits
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
//              b               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              rnd             3 bits
//                              Rounding Mode Input
//              z               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Output
//              status          8 bits
//                              Status Flags Output
//
// Modified:
//     2009.11.12 Kyung-Nam Han
//       Bug fix for STAR9000352662, available from 2009.06-SP4
//     2015.12.10 Kyung-Nam Han
//       Bug fix for STAR9000983334, available from 2015.06-SP5
//-----------------------------------------------------------------------------

// verilator lint_off WIDTH

module DW_fp_mult (a, b, rnd, z, status);

  parameter sig_width = 23;      // RANGE 2 TO 253
  parameter exp_width = 8;       // RANGE 3 TO 31
  parameter ieee_compliance = 0; // RANGE 0 TO 1

  input  [exp_width + sig_width:0] a;
  input  [exp_width + sig_width:0] b;
  input  [2:0] rnd;
  output [exp_width + sig_width:0] z;
  output [7:0] status;

  // synopsys translate_off


  `define Mwidth (2 * sig_width + 3)
  `define Movf   (`Mwidth - 1)
  `define L      (`Movf - 1 - sig_width)
  `define R      (`L - 1)
  `define RND_Width  4
  `define RND_Inc  0
  `define RND_Inexact  1
  `define RND_HugeInfinity  2
  `define RND_TinyminNorm  3
  `define log_awidth ((sig_width + 1>65536)?((sig_width + 1>16777216)?((sig_width + 1>268435456)?((sig_width + 1>536870912)?30:29):((sig_width + 1>67108864)?((sig_width + 1>134217728)?28:27):((sig_width + 1>33554432)?26:25))):((sig_width + 1>1048576)?((sig_width + 1>4194304)?((sig_width + 1>8388608)?24:23):((sig_width + 1>2097152)?22:21)):((sig_width + 1>262144)?((sig_width + 1>524288)?20:19):((sig_width + 1>131072)?18:17)))):((sig_width + 1>256)?((sig_width + 1>4096)?((sig_width + 1>16384)?((sig_width + 1>32768)?16:15):((sig_width + 1>8192)?14:13)):((sig_width + 1>1024)?((sig_width + 1>2048)?12:11):((sig_width + 1>512)?10:9))):((sig_width + 1>16)?((sig_width + 1>64)?((sig_width + 1>128)?8:7):((sig_width + 1>32)?6:5)):((sig_width + 1>4)?((sig_width + 1>8)?4:3):((sig_width + 1>2)?2:1)))))
  `define ez_msb ((exp_width >= `log_awidth) ? exp_width + 1 : `log_awidth + 1)

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

  //-------------------------------------------------------------------------

  //-----------------------------------------------------
  // Usage: rnd_val = rnd_eval(rnd,Sign,L,R,stk);
  // rnd_val has 4 bits:
  // rnd_val[rnd_Inc]
  // rnd_val[rnd_Inexact]
  // rnd_val[rnd_HugeInfinity]
  // rnd_val[rnd_TinyminNorm]
  //----------------------------------------------------
  // Rounding increment equations
  // MODE | Equation   | Description
  // ------------------------------------------------
  // even | R&(L|stk)  | IEEE round to nearest (even)
  // zero | 0          | IEEE round to zero
  // +inf | S'&(R|stk) | IEEE round to positive infinity
  // -inf | S&(R|stk)  | IEEE round to negative infinity
  // up   | R          | round to nearest (up)
  // away | (R|stk)    | round away from zero
  //----------------------------------------------------

  function [`RND_Width-1:0] rnd_eval;

    input [2:0] rnd;
    input [0:0] Sign;
    input [0:0] L,R,stk;

    begin
      rnd_eval[`RND_Inc] = 0;
      rnd_eval[`RND_Inexact] = R|stk;
      rnd_eval[`RND_HugeInfinity] = 0;
      rnd_eval[`RND_TinyminNorm] = 0;

      if ($time > 0)
      begin
        case (rnd)
          3'b000:
          begin
            // round to nearest (even)
            rnd_eval[`RND_Inc] = R&(L|stk);
            rnd_eval[`RND_HugeInfinity] = 1;
            rnd_eval[`RND_TinyminNorm] = 0;
          end
          3'b001:
          begin
            // round to zero
            rnd_eval[`RND_Inc] = 0;
            rnd_eval[`RND_HugeInfinity] = 0;
            rnd_eval[`RND_TinyminNorm] = 0;
          end
          3'b010:
          begin
            // round to positive infinity
            rnd_eval[`RND_Inc] = ~Sign & (R|stk);
            rnd_eval[`RND_HugeInfinity] = ~Sign;
            rnd_eval[`RND_TinyminNorm] = ~Sign;
          end
          3'b011:
          begin
            // round to negative infinity
            rnd_eval[`RND_Inc] = Sign & (R|stk);
            rnd_eval[`RND_HugeInfinity] = Sign;
            rnd_eval[`RND_TinyminNorm] = Sign;
          end
          3'b100:
          begin
            // round to nearest (up)
            rnd_eval[`RND_Inc] = R;
            rnd_eval[`RND_HugeInfinity] = 1;
            rnd_eval[`RND_TinyminNorm] = 0;
          end
          3'b101:
          begin
            // round away form 0
            rnd_eval[`RND_Inc] = R|stk;
            rnd_eval[`RND_HugeInfinity] = 1;
            rnd_eval[`RND_TinyminNorm] = 1;
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



  reg [(exp_width + sig_width):0] z_reg;
  reg [exp_width-1:0] EA;
  reg [exp_width-1:0] EB;
  reg signed [`ez_msb:0] EZ;
  reg signed [`ez_msb:0] Range_Check;
  reg signed [`ez_msb:0] SH_Shift;
  reg signed [`ez_msb:0] EZ_Shift;
  reg [sig_width:0] MA;
  reg [sig_width:0] MB;
  reg [sig_width:0] TMP_MA;
  reg [sig_width:0] TMP_MB;
  reg [`Mwidth-1:0] MZ;
  reg STK;
  reg SIGN;
  reg [`RND_Width-1:0] RND_val;
  reg [8    -1:0] status_reg;
  reg MaxEXP_A;
  reg MaxEXP_B;
  reg InfSIG_A;
  reg InfSIG_B;
  reg Zero_A;
  reg Zero_B;
  reg Denorm_A;
  reg Denorm_B;
  reg [9:0] LZ_INA;
  reg [9:0] LZ_INB;
  reg [9:0] LZ_IN;
  reg [sig_width - 1:0] SIGA;
  reg [sig_width - 1:0] SIGB;
  reg [(exp_width + sig_width):0] NaN_Reg;
  reg [(exp_width + sig_width):0] Inf_Reg;
  reg MZ_Movf1;
  reg EZ_Zero;
  reg STK_PRE;
  reg [sig_width:0] STK_EXT;
  reg [sig_width - 1:0] NaN_Sig;
  reg [sig_width - 1:0] Inf_Sig;
  reg STK_CHECK;
  reg minnorm_case;

  integer i;

  always @(a or b or rnd) begin : a1000_PROC
    SIGN = a[(exp_width + sig_width)] ^ b[(exp_width + sig_width)];
    EA = a[((exp_width + sig_width) - 1):sig_width];
    EB = b[((exp_width + sig_width) - 1):sig_width];
    SIGA = a[(sig_width - 1):0];
    SIGB = b[(sig_width - 1):0];
    status_reg = 0;
    LZ_INA = 0;
    LZ_INB = 0;
    LZ_IN = 0;
    STK_EXT = 0;

    MaxEXP_A = (EA == ((((1 << (exp_width-1)) - 1) * 2) + 1));
    MaxEXP_B = (EB == ((((1 << (exp_width-1)) - 1) * 2) + 1));
    InfSIG_A = (SIGA == 0);
    InfSIG_B = (SIGB == 0);

    // Zero and Denormal
    if (ieee_compliance) begin
      Zero_A = (EA == 0 ) & (SIGA == 0);
      Zero_B = (EB == 0 ) & (SIGB == 0);
      Denorm_A = (EA == 0 ) & (SIGA != 0);
      Denorm_B = (EB == 0 ) & (SIGB != 0);
      // IEEE Standard
      NaN_Sig = 1;
      Inf_Sig = 0;
      NaN_Reg = {1'b0, {(exp_width){1'b1}}, NaN_Sig};
      Inf_Reg = {SIGN, {(exp_width){1'b1}}, Inf_Sig};

      if (Denorm_A) begin
        MA = {1'b0, a[(sig_width - 1):0]};
      end
      else begin
        MA = {1'b1, a[(sig_width - 1):0]};
      end

      if (Denorm_B) begin
        MB = {1'b0, b[(sig_width - 1):0]};
      end
      else begin
        MB = {1'b1, b[(sig_width - 1):0]};
      end

    end
    else begin // ieee_compliance = 0
      Zero_A = (EA == 0 );
      Zero_B = (EB == 0 );
      Denorm_A = 0;
      Denorm_B = 0;
      MA = {1'b1,a[(sig_width - 1):0]};
      MB = {1'b1,b[(sig_width - 1):0]};
      NaN_Sig = 0;
      Inf_Sig = 0;
      // from 0703-SP2, NaN has always + sign.
      NaN_Reg = {1'b0, {(exp_width){1'b1}}, NaN_Sig};
      Inf_Reg = {SIGN, {(exp_width){1'b1}}, Inf_Sig};
    end

    //
    // Infinity & NaN Input
    //
    if (ieee_compliance && ((MaxEXP_A && ~InfSIG_A) || (MaxEXP_B && ~InfSIG_B))) begin
      status_reg[2] = 1;
      z_reg = NaN_Reg;
    end
    else if ( (MaxEXP_A) || (MaxEXP_B) )	begin

      if (ieee_compliance == 0) begin
        status_reg[1] = 1;
      end

      // 0*Inf = NaN
      if ( Zero_A || Zero_B ) begin
        status_reg[2] = 1;
        z_reg = NaN_Reg;
      end
      else begin  // Infinity Case
        status_reg[1] = 1;
        z_reg = Inf_Reg;
      end

    end
    //
    // Zero Input
    //
    else if (Zero_A || Zero_B) begin
      status_reg[0] = 1;
      z_reg = 0;
      z_reg[(exp_width + sig_width)] = SIGN;
    end
    //
    // Normal & Denormal Inputs
    //
    else begin

      // Denormal Check
      TMP_MA = MA;
      if (Denorm_A)
      begin
        while(TMP_MA[sig_width] != 1)
        begin
          TMP_MA = TMP_MA << 1;
          LZ_INA = LZ_INA + 1;
        end
      end

      TMP_MB = MB;
      if (Denorm_B)
      begin
        while(TMP_MB[sig_width] != 1)
        begin
          TMP_MB = TMP_MB << 1;
          LZ_INB = LZ_INB + 1;
        end
      end

      LZ_IN = LZ_INA + LZ_INB;

      EZ = EA + EB - LZ_IN + Denorm_A + Denorm_B;
      MZ = MA * MB;	// Compute with infinite precision.

      // Left shift MZ in case of denormal multiplication
      if (ieee_compliance) begin
        MZ = MZ << LZ_IN;
      end

      // After the computation, left justify the Mantissa to `Movf-1 bit.
      // Note that the normalized Mantissa after computation is in `Movf-2 bit,
      // and now we normalize it to `Movf-1 bit.
      MZ_Movf1 = MZ[`Movf-1];

      if (MZ[`Movf-1] === 1) begin
        EZ = EZ + 1;
        minnorm_case = 0;
      end
      else begin
        MZ = MZ << 1;
        minnorm_case = (EZ - ((1 << (exp_width-1)) - 1) == 0) ? 1 : 0;
      end

      // Denormal Support
      if (ieee_compliance) begin
        Range_Check = EA + EB + Denorm_A + Denorm_B + MZ_Movf1 - ((1 << (exp_width-1)) - 1) - LZ_IN - 1;

        EZ_Shift = -Range_Check;

        if (EZ_Shift >= 0) begin
          for (i = 0; i < EZ_Shift; i = i + 1) begin
            {MZ, STK_CHECK} = {MZ, 1'b0} >> 1;
            STK_EXT = STK_EXT | STK_CHECK;
          end
        end

      end

      if (minnorm_case & ~ieee_compliance) begin
        if ({MZ[`R:0], STK_EXT} === 0) STK = 0;
        else STK = 1;
        RND_val = rnd_eval(rnd, SIGN, MZ[`L+1], MZ[`R+1], STK);
      end
      else begin
        if ({MZ[`R-1:0], STK_EXT} === 0) STK = 0;
        else STK = 1;
        RND_val = rnd_eval(rnd, SIGN, MZ[`L], MZ[`R], STK);
      end

      // Round Addition
      if (RND_val[`RND_Inc] === 1) MZ = MZ + (1<<`L);

      // Normalize the Mantissa for overflow case after rounding.
      if ( (MZ[`Movf] === 1) ) begin
        EZ = EZ + 1;
        MZ = MZ >> 1;
      end

      // Correction of denomal output.
      if (ieee_compliance & (EZ <= ((1 << (exp_width-1)) - 1)) & MZ[`Movf - 1]) EZ = EZ + 1;

      EZ_Zero = (EZ == ((1 << (exp_width-1)) - 1));

      // Adjust Exponent ((1 << (exp_width-1)) - 1).
      // Force EZ = 0 if underflow occurs becuase of subtracting ((1 << (exp_width-1)) - 1),
      if((EZ[`ez_msb] == 0) & (EZ >= ((1 << (exp_width-1)) - 1))) EZ = EZ - ((1 << (exp_width-1)) - 1);
      else EZ = 0;

      //
      // Huge
      //
      if (EZ >= ((((1 << (exp_width-1)) - 1) * 2) + 1)) begin
        status_reg[4] = 1;
        status_reg[5] = 1;

        if(RND_val[`RND_HugeInfinity] === 1) begin
          // Infinity
          MZ[`Movf-2:`L] = Inf_Sig;
          EZ = ((((1 << (exp_width-1)) - 1) * 2) + 1);
          status_reg[1] = 1;
        end
        else begin
          // MaxNorm
          EZ = ((((1 << (exp_width-1)) - 1) * 2) + 1) - 1;
          MZ[`Movf-2:`L] = -1;
        end
      end
      //
      // Tiny
      //
      else if (EZ == 0 ) begin
        status_reg[3] = 1;

        if (ieee_compliance == 0) begin
          status_reg[5] = 1;

          if(RND_val[`RND_TinyminNorm] === 1) begin
            // MinNorm
            MZ[`Movf-2:`L] = 0;
            EZ = 0  + 1;
          end
          else begin
            // 0
            MZ[`Movf-2:`L] = 0;
            EZ = 0 ;
            status_reg[0] = 1;
          end
        end

        if ((MZ[`Movf-2:`L] == 0) & (EZ[exp_width - 1:0] == 0)) begin
          status_reg[0] = 1;
        end

      end

      status_reg[5] = status_reg[5] | RND_val[`RND_Inexact] | (~(Zero_A | Zero_B) & (EZ[exp_width - 1:0] == 0) & (MZ[`Movf - 2:`L] == 0));

      // Reconstruct the floating point format.
      z_reg = {SIGN,EZ[exp_width-1:0],MZ[`Movf-2:`L]};
      end
  end

  assign status = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0) || (^(rnd ^ rnd) !== 1'b0)) ? {8'bX} : status_reg;
  assign z = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0) || (^(rnd ^ rnd) !== 1'b0)) ? {sig_width+exp_width+1{1'bX}} : z_reg;

  `undef Mwidth
  `undef Movf
  `undef L
  `undef R
  `undef RND_Width
  `undef RND_Inc
  `undef RND_Inexact
  `undef RND_HugeInfinity
  `undef RND_TinyminNorm
  `undef log_awidth
  `undef ez_msb

  // synopsys translate_on

endmodule

// verilator lint_on WIDTH

