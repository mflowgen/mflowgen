
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
// AUTHOR:    Kyung-Nam Han, Mar. 22, 2006
//
// VERSION:   Verilog Simulation Model for DW_fp_div
//
// DesignWare_version: f5eace03
// DesignWare_release: M-2016.12-DWBB_201612.0
//
////////////////////////////////////////////////////////////////////////////////

//-------------------------------------------------------------------------------
//
// ABSTRACT: Floating-Point Divider
//
//              DW_fp_div calculates the floating-point division
//              while supporting six rounding modes, including four IEEE
//              standard rounding modes.
//
//              parameters      valid values (defined in the DW manual)
//              ==========      ============
//              sig_width       significand size,  2 to 253 bits
//              exp_width       exponent size,     3 to 31 bits
//              ieee_compliance support the IEEE Compliance 
//                              0 - IEEE 754 compatible without denormal support
//                                  (NaN becomes Infinity, Denormal becomes Zero)
//                              1 - IEEE 754 compatible with denormal support
//                                  (NaN and denormal numbers are supported)
//              faithful_round  select the faithful_rounding that admits 1 ulp error
//                              0 - default value. it keeps all rounding modes
//                              1 - z has 1 ulp error. RND input does not affect
//                                  the output
//
//              Input ports     Size & Description
//              ===========     ==================
//              a               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              b               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Input
//              rnd             3 bits
//                              Rounding Mode Input
//
//              Output ports    Size & Description
//              ============    ==================
//              z               (sig_width + exp_width + 1)-bits
//                              Floating-point Number Output
//              status          8 bits
//                              Status Flags Output
//
// MODIFIED: May   7. 2007 Kyung-Nam Han (from 0703-SP2)
//             Fixed the rounding error of denormal numbers 
//             when ieee_compliance = 1
//           Oct. 18. 2007 Kyung-Nam Han from 0712
//             Fixed the 'divide by zero' flag when 0/0 
//           Jan.  2. 2008 Kyung-Nam Han from 0712-SP1
//             New parameter, faithful_round, is introduced
//           Jun.  4. 2010 Kyung-Nam Han (from D-2010.03-SP3)
//             Removed VCS error [IRIPS] when sig_width = 2 and 3.
//
//-----------------------------------------------------------------------------

module DW_fp_div (a, b, rnd, z, status);

  parameter sig_width = 23;      // range 2 to 253
  parameter exp_width = 8;       // range 3 to 31
  parameter ieee_compliance = 0; // range 0 to 1
  parameter faithful_round = 0;  // range 0 to 1

  input  [sig_width + exp_width:0] a;
  input  [sig_width + exp_width:0] b;
  input  [2:0] rnd;
  output [sig_width + exp_width:0] z;
  output [7:0] status;

  // synopsys translate_off



  //-------------------------------------------------------------------------
  // parameter legality check
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
      
    if ( (faithful_round < 0) || (faithful_round > 1) ) begin
      param_err_flg = 1;
      $display(
	"ERROR: %m :\n  Invalid value (%d) for parameter faithful_round (legal range: 0 to 1)",
	faithful_round );
    end
    
    if ( param_err_flg == 1) begin
      $display(
        "%m :\n  Simulation aborted due to invalid parameter value(s)");
      $finish;
    end

  end // parameter_check 

  //-------------------------------------------------------------------------


  function [4-1:0] OIIlOlO1;
  
    input [2:0] rnd;
    input [0:0] I101O11O;
    input [0:0] I11110O0,O10110O1,O011IOO0;

    begin
      OIIlOlO1[0] = 0;
      OIIlOlO1[1] = O10110O1|O011IOO0;
      OIIlOlO1[2] = 0;
      OIIlOlO1[3] = 0;
      
      if ($time > 0)
      begin
        case (rnd)
          3'b000:
          begin
            // round to nearest (even)
            OIIlOlO1[0] = O10110O1&(I11110O0|O011IOO0);
            OIIlOlO1[2] = 1;
            OIIlOlO1[3] = 0;
          end
          3'b001:
          begin
            // round to zero
            OIIlOlO1[0] = 0;
            OIIlOlO1[2] = 0;
            OIIlOlO1[3] = 0;
          end
          3'b010:
          begin
            // round to positive infinity
            OIIlOlO1[0] = ~I101O11O & (O10110O1|O011IOO0);
            OIIlOlO1[2] = ~I101O11O;
            OIIlOlO1[3] = ~I101O11O;
          end
          3'b011:
          begin
            // round to negative infinity
            OIIlOlO1[0] = I101O11O & (O10110O1|O011IOO0);
            OIIlOlO1[2] = I101O11O;
            OIIlOlO1[3] = I101O11O;
          end
          3'b100:
          begin
            // round to nearest (up)
            OIIlOlO1[0] = O10110O1;
            OIIlOlO1[2] = 1;
            OIIlOlO1[3] = 0;
          end
          3'b101:
          begin
            // round away form 0
            OIIlOlO1[0] = O10110O1|O011IOO0;
            OIIlOlO1[2] = 1;
            OIIlOlO1[3] = 1;
          end
          default:
          begin
            $display("error! illegal rounding mode.\n");
            $display("a : %b", a);
            $display("rnd : %b", rnd);
          end
        endcase
      end
    end
  endfunction

  reg [(exp_width + sig_width):0] IOOIlI0I;
  reg [exp_width-1:0] l1l1O100,lO101111;
  reg [exp_width+1:0] lI00O00I;
  reg IOO1O01O;
  reg [exp_width+1:0] O10101O1;
  reg I1O1O11O;
  reg [exp_width+1:0] lO1O0OI1;
  reg signed [exp_width+1:0] IO10IOO1;
  reg l10OO10O;
  reg [sig_width:0] OlOO00lO,OOIl0010,IOOl0lII,l11Illl0,lO001Ol0;
  reg [sig_width:0] I0OI1lO0;
  reg [(2 * sig_width + 2)  :0] IOIlII10;
  reg [sig_width:0] O10110O1;
  reg O011IOO0,I101O11O;
  reg [1:0] lO011100;
  reg [4-1:0] I11IO1I1;
  reg [8    -1:0] OO000O0O;
  reg [(exp_width + sig_width):0] O00OO1I0;
  reg [(exp_width + sig_width):0] IIl1O10O;
  reg I00lIO1l;
  reg lOI111I1;
  reg O100O11l;
  reg l10OO1I0;
  reg l1O1Ol0O;
  reg I000lO00;
  reg l1OllI0I;
  reg lO00I10I;
  reg IIIl11O1;
  reg [sig_width - 1:0] OOO111OO;
  reg [sig_width - 1:0] l000I1O0;
  reg [7:0] O00O1Ol1;
  reg [7:0] II01O1O0;
  reg [exp_width + 1:0] OIIO0OOl;
  reg [sig_width:0] l0III011;
  reg [sig_width:0] OO0lIO1O;
  reg [sig_width:0] II0IIO1O;
  reg [8:0] O1lO00O0;
  reg [8:0] I0I0Il0O;
  reg [9:0] l110l11I;
  reg [sig_width + 9:0] IO00O1O1;
  reg IOOlIOOO;
  reg [8:0] OOI10OIO;
  reg [sig_width + 9:0] l0IO1lOO;
  reg [sig_width + 1:0] OO0OO1I0;
  reg [2 * sig_width - 7:0] O00OI010;
  reg [sig_width + 3:0] IOIlOO00;
  reg [sig_width + 3:0] O0O0IIII;
  reg [sig_width + 3:0] II11llO0;
  reg l0101100;
  reg [sig_width + 3:0] l0I1OOll;
  reg [((sig_width >= 11) ? 2 * sig_width - 21 : 0):0] OIlI10I1;
  reg [((sig_width >= 11) ? sig_width - 11 : 0):0] Ol1O10O0;
  reg [((sig_width >= 11) ? 2 * sig_width - 21 : 0):0] O1l11OIO;
  reg [sig_width + 3:0] Il101Il1;
  reg IOll10OO;
  reg [sig_width + 3:0] O0l0O011;
  reg [((sig_width >= 25) ? sig_width - 25 : 0):0] OOO01OO1;
  reg [((sig_width >= 24) ? 2 * sig_width - 47 : 0):0] O0O1011O;
  reg [((sig_width >= 24) ? 2 * sig_width - 47 : 0):0] llOO0II1;
  reg [((sig_width >= 25) ? sig_width - 25 : 0):0] O010I0IO;
  reg [sig_width + 3:0] OOOl110I;
  reg O00O00O1;
  reg [sig_width + 3:0] lI100I0I;
  reg [8:0] I10l01Il;
  reg [sig_width + 3:0] O1O0011O;
  reg [sig_width + 3:0] O1O1O01l;
  reg [sig_width + 3:0] l0I1OI0l;
  reg [8:8 - sig_width] IIOI0lOO;
  reg [sig_width:0] O11OOOOl;
  reg [sig_width:0] OO1110O0;
  reg [sig_width:0] I01II0I0;
  reg [sig_width:0] IOIOI010;
  reg IOO101lO;
  reg OlIlOOIO;
  reg I010IlI0;
  reg I11OIl0O;
  reg Ol01O010;


  always @(a or b or rnd) begin : a1000_PROC
    I101O11O = a[(exp_width + sig_width)] ^ b[(exp_width + sig_width)];
    l1l1O100 = a[((exp_width + sig_width) - 1):sig_width];
    lO101111 = b[((exp_width + sig_width) - 1):sig_width];
    OOO111OO = a[(sig_width - 1):0];
    l000I1O0 = b[(sig_width - 1):0];
    O00O1Ol1 = 0;
    II01O1O0 = 0;
    I0OI1lO0 = 0;

    OO000O0O = 0;

    // division table for special inputs
    //
    //  -------------------------------------------------
    //         a      /       b      |       result
    //  -------------------------------------------------
    //        nan     |      any     |        nan
    //        any     |      nan     |        nan
    //        inf     |      inf     |        nan
    //         0      |       0      |        nan
    //        inf     |      any     |        inf
    //        any     |       0      |        inf
    //         0      |      any     |         0
    //        any     |      inf     |         0
    //  -------------------------------------------------
    // when ieee_compliance = 0, 
    // denormal numbers are considered as zero and 
    // nans are considered as infinity

    if (ieee_compliance)
    begin
      I00lIO1l = (l1l1O100 == ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (OOO111OO == 0);
      lOI111I1 = (lO101111 == ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (l000I1O0 == 0);
      O100O11l = (l1l1O100 == ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (OOO111OO != 0);
      l10OO1I0 = (lO101111 == ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (l000I1O0 != 0);
      l1O1Ol0O = (l1l1O100 == 0) & (OOO111OO == 0);
      I000lO00 = (lO101111 == 0) & (l000I1O0 == 0);
      l1OllI0I = (l1l1O100 == 0) & (OOO111OO != 0);
      lO00I10I = (lO101111 == 0) & (l000I1O0 != 0);

      O00OO1I0 = {I101O11O, {(exp_width){1'b1}}, {(sig_width){1'b0}}}; 
      IIl1O10O = {1'b0, {(exp_width){1'b1}}, {(sig_width - 1){1'b0}}, 1'b1};
    end
    else
    begin
      I00lIO1l = (l1l1O100 == ((((1 << (exp_width-1)) - 1) * 2) + 1));
      lOI111I1 = (lO101111 == ((((1 << (exp_width-1)) - 1) * 2) + 1));
      O100O11l = 0;
      l10OO1I0 = 0;
      l1O1Ol0O = (l1l1O100 == 0);
      I000lO00 = (lO101111 == 0);
      l1OllI0I = 0;
      lO00I10I = 0;

      O00OO1I0 = {I101O11O, {(exp_width){1'b1}}, {(sig_width){1'b0}}};
      IIl1O10O = {1'b0, {(exp_width){1'b1}}, {(sig_width){1'b0}}};
    end

    //OO000O0O[7] = I000lO00 & ~l1O1Ol0O; 
    OO000O0O[7] = (ieee_compliance) ?
            I000lO00 & ~(l1O1Ol0O | O100O11l | I00lIO1l) :
            I000lO00 & ~(l1O1Ol0O | O100O11l); 

    if (O100O11l || l10OO1I0 || (I00lIO1l && lOI111I1) || (l1O1Ol0O && I000lO00))
    begin
      IOOIlI0I = IIl1O10O;
      OO000O0O[2] = 1;
    end
    else if (I00lIO1l || I000lO00)
    begin
      IOOIlI0I = O00OO1I0;
      OO000O0O[1] = 1;
    end
    else if (l1O1Ol0O || lOI111I1)
    begin
      OO000O0O[0] = 1;
      IOOIlI0I = 0;
      IOOIlI0I[(exp_width + sig_width)] = I101O11O;
    end
  
    else
    begin
      if (ieee_compliance) 
      begin

        if (l1OllI0I) 
        begin
          OlOO00lO = {1'b0, a[(sig_width - 1):0]};

          while(OlOO00lO[sig_width] != 1)
          begin
            OlOO00lO = OlOO00lO << 1;
            O00O1Ol1 = O00O1Ol1 + 1;
          end
        end 
        else
        begin
          OlOO00lO = {1'b1, a[(sig_width - 1):0]};
        end

        if (lO00I10I) 
        begin
          OOIl0010 = {1'b0, b[(sig_width - 1):0]};
          while(OOIl0010[sig_width] != 1)
          begin
            OOIl0010 = OOIl0010 << 1;
            II01O1O0 = II01O1O0 + 1;
          end
        end 
        else
        begin
          OOIl0010 = {1'b1, b[(sig_width - 1):0]};
        end
      end
      else
      begin
        OlOO00lO = {1'b1, a[(sig_width - 1):0]};
        OOIl0010 = {1'b1, b[(sig_width - 1):0]};
      end

      // XXX: berkin
      /* verilator lint_off WIDTH */

      I010IlI0 = (OlOO00lO == OOIl0010);
      Ol01O010 = (OOIl0010[sig_width - 1:0] == 0);
      l0III011 = OlOO00lO;
      OO0lIO1O = (ieee_compliance) ? OOIl0010 : {1'b1, l000I1O0};
      II0IIO1O = (faithful_round) ? OO0lIO1O : {OO0lIO1O, 1'b0};
      O1lO00O0 = (sig_width >= 9) ? II0IIO1O[sig_width - 1:((sig_width >= 9) ? sig_width - 9 : 0)] : {II0IIO1O[sig_width - 1:0], {(((sig_width >= 9) ? 1 : 9 - sig_width)){1'b0}}};
      l110l11I = {1'b1, O1lO00O0[8:0]};
      I0I0Il0O = {1'b1, 18'b0} / (l110l11I + 1);
      IO00O1O1 = I0I0Il0O * l0III011;
      IOOlIOOO = IO00O1O1[sig_width + 9];
      OOI10OIO = (IOOlIOOO) ? IO00O1O1[sig_width + 9:sig_width + 1] : IO00O1O1[sig_width + 8:sig_width];
      l0IO1lOO = II0IIO1O * I0I0Il0O;
      OO0OO1I0 = ~l0IO1lOO[sig_width + 1:0];
      O00OI010 = IO00O1O1[((sig_width <= 3) ? 0 : sig_width + 9):((sig_width <= 3) ? 0 : 13)] * OO0OO1I0[((sig_width <= 3) ? 0 : sig_width + 1):((sig_width <= 3) ? 0 : 5)];
      IOIlOO00 = IO00O1O1[sig_width + 9:6];
      O0O0IIII = {6'b0, O00OI010[2 * (sig_width - 3) - 1:2 * (sig_width - 3) - 1 - sig_width + 5 - 1]};
      II11llO0 = IOIlOO00 + O0O0IIII;
      l0101100 = II11llO0[sig_width + 3];
      l0I1OOll = (sig_width <= 14) ? ((l0101100) ? II11llO0 : {II11llO0[sig_width + 2:0], 1'b0}) : II11llO0;
      OIlI10I1 = (sig_width >= 11) ? OO0OO1I0[((sig_width >= 11) ? sig_width + 1 : 0):((sig_width >= 11) ? 12 : 0)] * OO0OO1I0[((sig_width >= 11) ? sig_width + 1 : 0):((sig_width >= 11) ? 12 : 0)] : 0;
      Ol1O10O0 = (sig_width >= 11) ? OIlI10I1[((sig_width >= 11) ? 2 * sig_width - 21 : 0):((sig_width >= 11) ? sig_width - 10 : 0)] : 0;
      O1l11OIO = (sig_width >= 11) ? l0I1OOll[((sig_width >= 11) ? sig_width + 3 : 0):((sig_width >= 11) ? 14 : 0)] * Ol1O10O0 : 0;
      Il101Il1 = l0I1OOll + O1l11OIO[((sig_width >= 11) ? 2 * sig_width - 21 : 0):((sig_width >= 11) ? sig_width - 10 : 0)];
      IOll10OO = Il101Il1[sig_width + 3];
      O0l0O011 = (sig_width <= 30) ? ((IOll10OO) ? Il101Il1 : {Il101Il1[sig_width + 2:0], 1'b0}) : Il101Il1;
      OOO01OO1 = (sig_width >= 25) ? Ol1O10O0[((sig_width >= 25) ? sig_width - 11 : 0):((sig_width >= 25) ? 13 : 0)] : 0;
      O0O1011O = OOO01OO1 * OOO01OO1;
      llOO0II1 = (sig_width >= 25) ? O0l0O011[((sig_width >= 25) ? sig_width + 3 : 0):((sig_width >= 25) ? 27 : 0)] * O0O1011O[((sig_width >= 25) ? 2 * sig_width - 47 : 0):((sig_width >= 25) ? sig_width - 23 : 0)] : 0;
      O010I0IO = (sig_width >= 25) ? llOO0II1[((sig_width >= 25) ? 2 * sig_width - 47 : 0):((sig_width >= 25) ? sig_width - 22 : 0)] : 0;
      OOOl110I = O0l0O011 + O010I0IO;
      O00O00O1 = OOOl110I[sig_width + 3];
      lI100I0I = ((O00O00O1) ? OOOl110I : {OOOl110I[sig_width + 2:0], 1'b0});
      I10l01Il = (sig_width == 8) ? OOI10OIO + 1 : 
               (sig_width < 8)  ? OOI10OIO + {1'b1, {(((sig_width >= 8) ? 1 : ((sig_width >= 8) ? 0 : 8 - sig_width - 1) + 1)){1'b0}}} : 
                                  0;
      O1O0011O = l0I1OOll + 4'b1000;
      O1O1O01l = O0l0O011 + 4'b1000;
      l0I1OI0l = lI100I0I + 4'b1000;
      IIOI0lOO = (sig_width == 8)  ? OOI10OIO[8:0] : 
                   (OOI10OIO[((sig_width >= 8) ? 0 : 8 - sig_width - 1)]) ? I10l01Il[8:((sig_width >= 8) ? 0 : 8 - sig_width - 1) + 1] : 
                                       OOI10OIO[8:((sig_width >= 8) ? 0 : 8 - sig_width - 1) + 1];
      O11OOOOl = (l0I1OOll[2]) ? O1O0011O[sig_width + 3:3] : l0I1OOll[sig_width + 3:3];
      OO1110O0 = (O0l0O011[2]) ? O1O1O01l[sig_width + 3:3] : O0l0O011[sig_width + 3:3];
      I01II0I0 = (lI100I0I[2]) ? l0I1OI0l[sig_width + 3:3] : lI100I0I[sig_width + 3:3];
      IOIOI010 = (sig_width <= 8) ? IIOI0lOO : (sig_width <= 14) ? O11OOOOl : (sig_width <= 30) ? OO1110O0 : I01II0I0;
      I11OIl0O = (faithful_round) ? (IOIOI010 == 0) : 0;
      IOO101lO = (sig_width <= 8) ? IOOlIOOO: (sig_width <= 14) ? l0101100 : (sig_width <= 30) ? IOll10OO : O00O00O1;
      OlIlOOIO = ~I010IlI0 & (l000I1O0 != 0);

      IOIlII10 = {OlOO00lO,{(sig_width + 2){1'b0}}} / OOIl0010;
      O10110O1 = (faithful_round) ? OlIlOOIO : {OlOO00lO,{(sig_width + 2){1'b0}}} % OOIl0010;

      lI00O00I = (l1l1O100 - O00O1Ol1 + l1OllI0I) - (lO101111 - II01O1O0 + lO00I10I) + ((1 << (exp_width-1)) - 1);
      O10101O1 = lI00O00I-1;

      l11Illl0 = (faithful_round) ?
                   ((Ol01O010 & ~ieee_compliance) ? l0III011 : IOIOI010) :
                   ((~IOIlII10[(sig_width + 2)]) ? IOIlII10[(sig_width + 2) - 1:1] : IOIlII10[(sig_width + 2):2]);
      lO011100 = ~IOIlII10[(sig_width + 2)] ? IOIlII10[1:0] : IOIlII10[2:1];
      IO10IOO1 = ~IOIlII10[(sig_width + 2)] ? O10101O1 : lI00O00I;
      IIIl11O1 = ((IO10IOO1 <= 0) | (IO10IOO1[exp_width + 1] == 1));
      O011IOO0 = (faithful_round) ? 
              ((Ol01O010 | I010IlI0) & ~IIIl11O1 ? 0 : 1) :
              ((O10110O1===0)?1'b0:1'b1); 


      if (ieee_compliance) begin
        if ((IO10IOO1 <= 0) | (IO10IOO1[exp_width + 1] == 1)) begin

          OIIO0OOl = 1 - IO10IOO1;
        
          {l11Illl0, I0OI1lO0} = {l11Illl0, {(sig_width + 1){1'b0}}} >> OIIO0OOl;

          if (OIIO0OOl > sig_width + 1) begin
            O011IOO0 = 1;
          end

          lO011100[1] = l11Illl0[0];
          lO011100[0] = I0OI1lO0[sig_width];

          if (I0OI1lO0[sig_width - 1:0] != 0) begin
            O011IOO0 = 1;
          end
        end
      end

      I11IO1I1 = OIIlOlO1(rnd, I101O11O, lO011100[1], lO011100[0], O011IOO0);
   
      lO001Ol0 = (faithful_round) ? l11Illl0 :
                    (I11IO1I1[0] === 1)? (l11Illl0+1):l11Illl0;

      if ((IO10IOO1 >= ((((1 << (exp_width-1)) - 1) * 2) + 1)) & (IO10IOO1[exp_width+1] === 1'b0))
      begin
        OO000O0O[4] = 1;
        OO000O0O[5] = 1;
        if(I11IO1I1[2] === 1)
        begin
          IOOl0lII = O00OO1I0[sig_width:0];
          lO1O0OI1 = ((((1 << (exp_width-1)) - 1) * 2) + 1);
          OO000O0O[1] = 1;
        end
        else
        begin
          IOOl0lII = -1;
          lO1O0OI1 = ((((1 << (exp_width-1)) - 1) * 2) + 1) - 1;
        end
      end
  
      else if ((IO10IOO1 <= 0) | (IO10IOO1[exp_width+1] === 1'b1)) begin
        OO000O0O[3] = 1;

        if (ieee_compliance == 0) begin
          OO000O0O[5] = 1;

          if(I11IO1I1[3] === 1) begin
            IOOl0lII = 0;
            lO1O0OI1 = 0 + 1;
          end
          else begin
            IOOl0lII = 0;
            lO1O0OI1 = 0;
            OO000O0O[0] = 1;
          end
        end
        else begin
          IOOl0lII = lO001Ol0;

          lO1O0OI1 = lO001Ol0[sig_width];

        end
      end
      else begin
        IOOl0lII = (I010IlI0 & faithful_round) ? 0 : lO001Ol0;
        lO1O0OI1 = IO10IOO1;
      end

      if ((IOOl0lII[sig_width - 1:0] == 0) & (lO1O0OI1[exp_width - 1:0] == 0)) begin
        OO000O0O[0] = 1;
      end
  
      OO000O0O[5] = OO000O0O[5] | I11IO1I1[1];
   
      IOOIlI0I = {I101O11O,lO1O0OI1[exp_width-1:0],IOOl0lII[sig_width-1:0]};
    end
  end
   
  assign status = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0) || (^(rnd ^ rnd) !== 1'b0)) ? {8'bx} : OO000O0O;
  assign z = ((^(a ^ a) !== 1'b0) || (^(b ^ b) !== 1'b0) || (^(rnd ^ rnd) !== 1'b0)) ? {8'bx} : IOOIlI0I;

  // synopsys translate_on

endmodule
  
  
  
