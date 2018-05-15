// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*



in_y_of_n                  out_y_of_n_plus_alpha
  ------------------> + ----------------------->
                      ^
                      |
                      |
              alpha 


*/
module add_alpha (
        in_y_of_n,
        in_param_alpha,
        out_y_of_n_plus_alpha
        );

parameter NFRAC = 16;
parameter NINT = 6; 

input in_y_of_n;
input [NFRAC-1:0] in_param_alpha;
output  [NFRAC:0] out_y_of_n_plus_alpha; 

wire signed [NFRAC+1:0] signed_y_of_n_plus_alpha;

                                            
assign signed_y_of_n_plus_alpha = $signed({in_y_of_n,{(NFRAC){1'b0}}}) + $signed({{1{in_param_alpha[NFRAC-1]}},in_param_alpha}); 


assign out_y_of_n_plus_alpha = signed_y_of_n_plus_alpha;  


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*



                                                                        p_of_n_prev_to_sat[22:0]
        (1.0)       ____________                            ________________                                     _____________
  y_of_n           |            | y_of_n_plus_alpha[17:0]  |                |                pre_p_of_n[21:0]   | Clip to     |    
   --------------> | add alpha  | -----------------------> | Accum/Integr   | ---------SAT--------------------->| 5.16 or not |-------------------> p_of_n[21:0]    
                   |____________|                          | Freq to Phase  |                                   |_____________|          |
                         ^                                 |                |                                        ^                   |
                         |                          |----> |________________|                                        |                   |
                      alpha[15:0]                   |                                                      in_param_ena_dco_drift        |
                                                    |    _____________                                                                   |
                                                    |   |             |                                                                  |
                                                    |---|  Flip Flop  |<-----------------------------------------------------------------
                                                        |_____________|
                                p_of_n_minus_1    
                                                               ^
                                                               |
                                                              clk



 - Alpha only takes values of [-0.75 -0.25]: therefore  
                                                         
                                                         e.g    .10100 = -0.5 + 0.125 = -0.375
                                                              11.10100 = -2 + 1 + 0.5 + 0.125 = -0.375

 - y[n] only takes 0 or 1

*/



module alpha_and_accum_top (
        in_rstb,
        in_y_of_n,
        in_param_alpha,
	in_param_ena_dco_drift,
        in_clk,
        out_p_of_n
        );

parameter NFRAC = 16;
parameter NINT = 7;   

input in_rstb;
input in_clk;
input in_y_of_n;
input [NFRAC-1:0] in_param_alpha;  
input in_param_ena_dco_drift;

output [NINT+NFRAC-2:0] out_p_of_n; //  [21:0]

wire [NINT+NFRAC-1:0] p_of_n_prev_to_sat;    //     [22:0]
wire [NINT+NFRAC-2:0] p_of_n_minus_1;    //     [21:0]
wire [NFRAC:0] y_of_n_plus_alpha;    //    [16:0]

wire [NINT+NFRAC-2:0] pre_out_p_of_n; //  [21:0]

add_alpha add_alpha (
        .in_y_of_n(in_y_of_n),
        .in_param_alpha(in_param_alpha),
        .out_y_of_n_plus_alpha(y_of_n_plus_alpha)
        );

freq_to_phase_accum  freq_to_phase_accum (
        .in_y_of_n_plus_alpha(y_of_n_plus_alpha),
        .in_p_of_n_minus_1(p_of_n_minus_1),
        .out_p_of_n(p_of_n_prev_to_sat)
        );

sat_signed_logic #(.NBIT_IN(NINT+NFRAC), .NBIT_OUT(NINT+NFRAC-1)) sat_p_of_n (
        .in_data(p_of_n_prev_to_sat),
        .out_data_sat(pre_out_p_of_n)
        );

register_1_cycle_delay  register_1_cycle_delay(
        .in_rstb(in_rstb),
        .in_D(out_p_of_n),
        .in_clk(in_clk),
        .out_Q(p_of_n_minus_1)
        );

clip_slector clip_slector(
	.in_data(pre_out_p_of_n),
	.in_ena(in_param_ena_dco_drift),
	.out_data(out_p_of_n)
	);


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

            ___________            ___________________         _______
  [21:0]   |           |          |                  |        |       |
---------->| SAT 21    |--------->| Sign Extend 22   |------->|0      |
    |      |___________|          |__________________|        |       |------>  p_of_n 22
    |                                                         |  MUX  |
    --------------------------------------------------------->|1      |
                                                              |_______|
							          ^
								  |
							 in_param_ena_dco_drift	  

*/

module clip_slector (
	in_data,
	in_ena,
	out_data
	);
	
parameter NFRAC = 16;
parameter NINT = 7;   

input [NINT+NFRAC-2:0] in_data;
input  in_ena;
output [NINT+NFRAC-2:0] out_data;


wire [NINT+NFRAC-3:0] sat_out_data;
wire [NINT+NFRAC-2:0] sat_out_data_extended;


sat_signed_logic #(.NBIT_IN(NINT+NFRAC-1), .NBIT_OUT(NINT+NFRAC-2)) sat_p_of_n_num2 (
        .in_data(in_data),
        .out_data_sat(sat_out_data)
        );


assign sat_out_data_extended = {{1{sat_out_data[NINT+NFRAC-3]}},sat_out_data};


assign out_data = (in_ena == 1) ? in_data : sat_out_data_extended;


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

This blocks is implements an integrator (digitally known as accumulator)

              1
   ---->   _______  ------>
                -1
            1 - z

1. When integrating frequency we obtain phase.
2. The input of this block is frequency error.
3. Therefore, the output of this block is phase error.



*/

module freq_to_phase_accum (
        in_y_of_n_plus_alpha,
        in_p_of_n_minus_1,
        out_p_of_n
        );

parameter NFRAC = 16;
parameter NINT = 7;  

input [NFRAC:0] in_y_of_n_plus_alpha;   
input [NINT+NFRAC-2:0] in_p_of_n_minus_1;  
output [NINT+NFRAC-1:0] out_p_of_n;  

wire signed [NINT+NFRAC-1:0] sign_p_of_n;  


assign sign_p_of_n = $signed({{(NINT-2){in_y_of_n_plus_alpha[NFRAC]}},in_y_of_n_plus_alpha}) + $signed(in_p_of_n_minus_1);   

assign out_p_of_n = sign_p_of_n; //signed to unsigned warning will occur

endmodule
module and2_logic (
        in_1,
        in_2,
        out
        );

input in_1, in_2;
output out;

assign out = (in_1 && in_2);

endmodule
module and3_logic (
        in_1,
        in_2,
	in_3,
        out
        );

input in_1, in_2, in_3;
output out;

assign out = (in_1 && in_2 && in_3);

endmodule
module delaying_buffer (
        in,
        out
        );

input in;
output out;

wire dly_1b;
wire dly_2;
wire dly_2b;
wire dly_3;
wire dly_3b;
wire dly_4;
wire dly_4b;
wire dly_5;
wire dly_5b;


inv_logic dly_n1 (
        .in(in),
        .out(dly_1b)
        );

inv_logic dly_n2 (
        .in(dly_1b),
        .out(dly_2)
        );

inv_logic dly_n3 (
        .in(dly_2),
        .out(dly_2b)
        );

inv_logic dly_n4 (
        .in(dly_2b),
        .out(dly_3)
        );

inv_logic dly_n5 (
        .in(dly_3),
        .out(dly_3b)
        );

inv_logic dly_n6 (
        .in(dly_3b),
        .out(dly_4)
        );

inv_logic dly_n7 (
        .in(dly_4),
        .out(dly_4b)
        );

inv_logic dly_n8 (
        .in(dly_4b),
        .out(dly_5)
        );

inv_logic dly_n9 (
        .in(dly_5),
        .out(dly_5b)
        );

inv_logic dly_n10 (
        .in(dly_5b),
        .out(out)
        );

endmodule
// Taken from Sernity DataBase
/*
 * Non-segmenting switching block for requantizing.
 */

module dem_non_seg (
   // Outputs
   o_lsb,
   // Inputs
   i_clk, i_rstb, i_ena, vi_lsb, i_rand
   );
   // Inputs
   input        i_clk;
   input        i_rstb;
   input        i_ena;
   // Signal
   input [1:0]  vi_lsb;
   input        i_rand;
   output       o_lsb;

   // Wires
   wire         input_parity;
   wire         sw;
   wire         swb;

   assign input_parity = ( i_ena ) ? vi_lsb[1] ^ vi_lsb[0] : 1'b0;
   assign o_lsb = ( input_parity ) ? sw : vi_lsb[0];
   // Shaped switching sequence generator
   skr_gen skr_block(.i_clk(i_clk), .i_rstb(i_rstb), .i_in(input_parity),
                         .i_r(i_rand), .o_out(sw), .o_outb(swb));

endmodule
module inv_logic (
        in,
        out
        );

input in;
output out;

assign out = ~in;

endmodule
// Made by Julian Puscar     julianpuscar@gmail.com   jpuscar@eng.ucsd.edu

module mux_3_logic (
        in_sel,
        in_1,
        in_2,
	in_3,
        out
        );



input [1:0] in_sel;
input in_1, in_2, in_3;
output out;

reg out;

always @(*) begin

        case( in_sel )

        0 : out = in_1;
        1 : out = in_2;
	2 : out = in_3;
	default : out = 1'bx;
	
        endcase
end


endmodule
// Made by Julian Puscar     julianpuscar@gmail.com   jpuscar@eng.ucsd.edu

module mux_logic (
        in_param_ena_free_running_dco,
        in_dco_to_fce,
        in_param_spi_to_fce,
        out_to_fce
        );


parameter NBIT = 16;

input [NBIT-1:0] in_dco_to_fce;
input [NBIT-1:0] in_param_spi_to_fce;
input in_param_ena_free_running_dco;

output [NBIT-1:0] out_to_fce;

reg [NBIT-1:0] out_to_fce;

always @(*) begin

        case( in_param_ena_free_running_dco )

        0 : out_to_fce = in_dco_to_fce;
        1 : out_to_fce = in_param_spi_to_fce;

        endcase
end


endmodule
module nand2_logic (
        in_1,
        in_2,
        out
        );

input in_1, in_2;
output out;

assign out = ~(in_1 && in_2);

endmodule
module nand3_logic (
        in_1,
        in_2,
        in_3,
        out
        );

input in_1, in_2, in_3;
output out;


assign out = ~(in_1 && in_2 && in_3);

endmodule
module or2_logic (
        in_1,
        in_2,
        out
        );

input in_1;
input in_2;
output out;


assign out = in_1 || in_2;

endmodule
module or3_logic (
        in_1,
        in_2,
        in_3,
        out
        );

input in_1;
input in_2;
input in_3;
output out;


assign out = in_1 || in_2 || in_3;

endmodule
module register_1_cycle_delay (
        in_rstb,
        in_D,
        in_clk,
        out_Q
        );

parameter NFRAC = 16;
parameter NINT = 7; //6.16

input in_rstb;
input [NINT+NFRAC-2:0] in_D;
input in_clk;
output [NINT+NFRAC-2:0] out_Q;

reg [NINT+NFRAC-2:0] out_Q;

always @(posedge in_clk or negedge in_rstb) begin

        if ( !in_rstb ) begin
                out_Q <= 0;
        end else begin
                out_Q <= in_D;
        end

end


endmodule
module register_div_by_2 (
        in_D,
        in_rstb,
        in_clk,
        out_Q
        );

input in_rstb;
input in_D, in_clk;
output out_Q;

reg out_Q;

always @( posedge in_clk or negedge in_rstb ) begin
        if ( !in_rstb ) begin
                out_Q <= 0;
        end else begin
                out_Q <= in_D;
        end
end

endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

Bits in the output: N

                       N-1 bits
                       ________
                      |        |
Word: MSB  xxxxx...x  yyyyy...y
                                                                                 N-1 bits
                                                                                 yyyy...y
                                 If MSB xx...x != 0 00...0        --->  out = 0  1111...1
                                   (any of this x has a 1
                                   therefore is higher than
                                   yyyy...y)


                                                                                 N-1 bits
                                                                                 yyyy...y
                                 If MSB xx...x != 1 11...1        --->  out = 1  0000...y
                                 (smaller negative number
                                 wanted)



                                                                                   N-1 bits
                                 Else                             --->  out = MSB  yyyy...y
                                 (all of them are 0 or 1)



*/

module sat_signed_logic (
        in_data,
        out_data_sat
        );

   parameter NBIT_IN = 16;
   parameter NBIT_OUT = 8;

   input signed [NBIT_IN-1:0]   in_data;
   output signed [NBIT_OUT-1:0] out_data_sat;

   reg signed [NBIT_OUT-1:0]    out_data_sat;

   always @(*) begin
      if ( !in_data[NBIT_IN-1]
           && ( in_data[NBIT_IN-2:NBIT_OUT-1] != {(NBIT_IN-NBIT_OUT){1'b0}} ))
         out_data_sat = $signed({1'b0, {(NBIT_OUT-1){1'b1}}});
      else if ( in_data[NBIT_IN-1]
           && ( in_data[NBIT_IN-2:NBIT_OUT-1] != {(NBIT_IN-NBIT_OUT){1'b1}} ))
        out_data_sat = $signed({1'b1, {(NBIT_OUT-1){1'b0}}});
      else
        out_data_sat = $signed({in_data[NBIT_IN-1], in_data[NBIT_OUT-2:0]});
   end

endmodule
// Verilog HDL for "dig_core", "dem_skr_gen" "verilog"
// cven_skrGen.v
//
// DEM first-order noise shaping skr generator
//     -No delays
//     -Resetb active low
//     -Unsigned input, signed output
//
// Taken from Titanium Database
//

module skr_gen (i_clk, i_rstb, i_in, i_r, o_out, o_outb);
   // Input signals
   input  i_in, i_r;
   // Output signals
   output o_out, o_outb;
   // Clock and resetb
   input  i_clk, i_rstb;

   // Intermediate signals
   reg    mux_sel, ff2_out;
   wire   ff2_in;
   // Multiplexer
   assign ff2_in = mux_sel ? i_r : ~ff2_out;
   // Output logic
   assign o_out = i_in && ff2_out;
   assign o_outb = !o_out;
   // Flip-flops
   always @( posedge i_clk or negedge i_rstb ) begin : skr_gen_ff
      if( !i_rstb ) begin
         mux_sel <= 0;
         ff2_out <= 0;
      end
      else if( i_in ) begin
         mux_sel <= ~mux_sel;
         ff2_out <= ff2_in;
      end
   end


endmodule
module small_delaying_buffer (
        in,
        out
        );

input in;
output out;

wire dly_1b;
wire dly_2;


inv_logic dly_n1 (
        .in(in),
        .out(dly_1b)
        );

inv_logic dly_n2 (
        .in(dly_1b),
        .out(dly_2)
        );

assign out = dly_2;

endmodule
// Taken from Serenity DataBase
/*
 * Parameterizable successive requantizer. Reduces an input with
 * NBIT_IN bits to NBIT_OUT bits with first order shaping.
 *
 * Requires NBIT_IN - NBIT_OUT uncorrelated random bits.
 *
 */


module successive_requant (
   // Outputs
   vo_requant_data,
   // Inputs
   in_clk, in_rstb, i_ena, vi_input_data, vi_rand
   );
   parameter NBIT_IN = 16;
   parameter NBIT_OUT = 7;
   // Inputs
   input                        in_clk;
   input                        in_rstb;
   input                        i_ena;
   input [NBIT_IN-1:0]          vi_input_data;
   input [NBIT_IN-NBIT_OUT-1:0] vi_rand;
   // Outputs
   output [NBIT_OUT-1:0]        vo_requant_data;

   wire [NBIT_IN-NBIT_OUT:0]    v_lsb_carry;
   genvar                       cc;

   //Set the initial carry-in to 0
   assign v_lsb_carry[0] = 1'b0;
   // Create a chain of switching blocks. Final carry is in v_lsb_carry[ii+1]
   generate
      for ( cc = 0 ; cc < NBIT_IN - NBIT_OUT ; cc = cc + 1 ) begin : seg
         dem_non_seg
           squant(.i_clk(in_clk), .i_rstb(in_rstb), .i_ena(i_ena),
                  .i_rand(vi_rand[cc]),
                  .vi_lsb({vi_input_data[cc],v_lsb_carry[cc]}),
                  .o_lsb(v_lsb_carry[cc+1]));
      end
   endgenerate
   // Add the final carry bit to the truncated MSBs for shaped dither
   assign vo_requant_data = vi_input_data[NBIT_IN-1:NBIT_IN-NBIT_OUT]
                          + v_lsb_carry[NBIT_IN-NBIT_OUT];

endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

This block implements a thermometer encoder.
(This is a "segmented" thermometer encoder
in the sense that not all of the outputs
have the same weight).

     6 bits
13 = 001101 --->6=00110 --> 0          #63-----------------
          |                 .                    |
          |                 .                    |
          |                 .                    |
          |                 0           #16      |
          |                 0           #15      |
          |                 0           #14      |
          |                 0           #13      |
          |                 0           #12      |
          |                 0           #11      |
          |                 0           #10    1x FCEs
          |                 0           #9       ^
          |                 0           #8       |
          |                 0           #7       |
          |                 1           #6       |
          |                 1           #5       |
          |                 1           #4       |
          |                 1           #3       |
          |                 1           #2       |
          |                 1           #1       |
          |------------->   1           #0       |

Finally:  6x2 + 1 correspond to 13 as it was expected.

*/

module convert_to_thermometer_code (
        input_integer_dco_inp,
        output_integer_dco_therm_coded
        );


parameter num_of_integer_FCE = 64;

input [5:0] input_integer_dco_inp;
output [num_of_integer_FCE-1:0] output_integer_dco_therm_coded;


reg [num_of_integer_FCE-1:0] x2_FCE_ctrl;

integer ii;

always @(*) begin

        for ( ii = 0 ; ii < num_of_integer_FCE ; ii = ii + 1 ) begin

                if ( input_integer_dco_inp[5:0] >= $unsigned(ii) ) begin

                        x2_FCE_ctrl[ii] <= 1'b1;

                end else begin

                        x2_FCE_ctrl[ii] <= 1'b0;

                end

        end

end

assign output_integer_dco_therm_coded[num_of_integer_FCE-1:0] = x2_FCE_ctrl;


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

                                                                    _____
                                  _______ freeRunningDCOintCtrl--->|     |
         ______      [5:0]       | conv. |                         |     |
 [13:0] |      | --------------> | therm.| ------------------------| Mux |-------->REG ---> 64 Integer FCEs
 ---->  | IBA  |                 | code  |                         |_____|          ^
        |______| ---              -------                                           |
                    |                                                             clk_fce
                    |
                    |             _____          ______        _____      _____
                    |   [8:0]    |     | [3:0]   | Map |      |     |    |     |
                    |----------> | DSM | ------> | to  | ---> | DEM | ---|     |--->REG---> 8 Fractional FCEs (Max 6 FCEs on at the same time)
                                 |_____|         | DEM |      |_____|    | Mux |     ^
                                                  ------                 |     |     |
                                              freeRunningDCOfracCtrl---->|_____|   clk_fce


                ___________
               |
clk_fce _______|
                  _________
                 |
clk_dco _________|


clk_fce samples the "thermometer encoder" and the "DEM" from previous cycle [n-1] as it is needed (paper Delta
Sigma FDC Based Fractional-N PLLS)
                                                     -2
This way the transfer function of the loop has the  z   factor.

Also it brings the benefit that: the FCEs input are not changing all the time

*/


module dco_top (
        in_rstb,
        in_clk_dco,
        in_clk_fce,
        in_dco,
        in_random_bit,
        in_param_ena_free_running_DCO_int_part,
        in_param_ena_free_running_DCO_frac_part,
        in_param_spi_to_fce_int_part,
        in_param_spi_to_fce_frac_part,
	out_iba_to_therm,
	out_iba_to_dsm,
        out_frac_FCEs_ctrl,
        out_int_FCEs_ctrl
        );

input in_rstb;
input in_clk_dco;
input in_clk_fce;
input [13:0] in_dco;
input [3:0] in_random_bit;

input in_param_ena_free_running_DCO_int_part;
input in_param_ena_free_running_DCO_frac_part;
input [63:0] in_param_spi_to_fce_int_part;
input [7:0] in_param_spi_to_fce_frac_part;

output [5:0] out_iba_to_therm;
output [8:0] out_iba_to_dsm;

output [63:0] out_int_FCEs_ctrl;
output [7:0] out_frac_FCEs_ctrl;

wire [63:0] b_out_int_FCEs_ctrl;
wire [7:0] b_out_frac_FCEs_ctrl;

wire [63:0] pre_reg_int_FCEs_ctrl;
wire [7:0] pre_reg_frac_FCEs_ctrl;

wire [63:0] therm_to_mux;
wire [7:0] dem_to_mux;

wire [5:0] iba_to_therm_encoder;
wire [8:0] iba_to_dsm;
wire [3:0] dsm_to_map_dem;
wire [3:0] map_to_dem;


assign out_iba_to_therm = iba_to_therm_encoder;
assign out_iba_to_dsm = iba_to_dsm;

integer_boundary_avoider integer_boundary_avoider(
        .in_rstb(in_rstb),
        .in_clk(in_clk_dco),
        .in_int_bound_avoid(in_dco),
        .out_to_dco_int(iba_to_therm_encoder),
        .out_to_dco_frac(iba_to_dsm)
        );


convert_to_thermometer_code convert_to_thermometer_code(
        .input_integer_dco_inp(iba_to_therm_encoder),
        .output_integer_dco_therm_coded(therm_to_mux)
        );


dsm_2nd_order dsm_2nd_order(
        .out_dsm(dsm_to_map_dem),
        .in_clk(in_clk_dco),
        .in_rstb(in_rstb),
        .in_lsb_dither(in_random_bit[3]),
        .in_dsm(iba_to_dsm)
        );

map_dsm_to_dem map_dsm_to_dem(
        .in_dsm_output(dsm_to_map_dem),
        .out_dsm_mapped_to_dem(map_to_dem)
        );

dem dem (
        .in_dem(map_to_dem),
        .in_random_bit(in_random_bit[2:0]),
        .out_frac_FCEs_ctrl(dem_to_mux)
        );


mux_logic #(.NBIT(64)) select_int_fce_ctrl (
        .in_param_ena_free_running_dco(in_param_ena_free_running_DCO_int_part),
        .in_dco_to_fce(therm_to_mux),
        .in_param_spi_to_fce(in_param_spi_to_fce_int_part),
        .out_to_fce(pre_reg_int_FCEs_ctrl)
        );

mux_logic #(.NBIT(8)) select_frac_fce_ctrl (
        .in_param_ena_free_running_dco(in_param_ena_free_running_DCO_frac_part),
        .in_dco_to_fce(dem_to_mux),
        .in_param_spi_to_fce(in_param_spi_to_fce_frac_part),
        .out_to_fce(pre_reg_frac_FCEs_ctrl)
        );




register_1_cycle_delay #(.NFRAC(0), .NINT(63+2))  register_INT_part(
        .in_rstb(in_rstb),
        .in_D(pre_reg_int_FCEs_ctrl),
        .in_clk(in_clk_fce),
        .out_Q(b_out_int_FCEs_ctrl)
        );

register_1_cycle_delay #(.NFRAC(7+2), .NINT(0))  register_FRAC_part(
        .in_rstb(in_rstb),
        .in_D(pre_reg_frac_FCEs_ctrl),
        .in_clk(in_clk_fce),
        .out_Q(b_out_frac_FCEs_ctrl)
        );



inv_logic inv_logic_0(
        .in(b_out_frac_FCEs_ctrl[0]),
        .out(out_frac_FCEs_ctrl[0])
        );
inv_logic inv_logic_1(
        .in(b_out_frac_FCEs_ctrl[1]),
        .out(out_frac_FCEs_ctrl[1])
        );
inv_logic inv_logic_2(
        .in(b_out_frac_FCEs_ctrl[2]),
        .out(out_frac_FCEs_ctrl[2])
        );
inv_logic inv_logic_3(
        .in(b_out_frac_FCEs_ctrl[3]),
        .out(out_frac_FCEs_ctrl[3])
        );
inv_logic inv_logic_4(
        .in(b_out_frac_FCEs_ctrl[4]),
        .out(out_frac_FCEs_ctrl[4])
        );
inv_logic inv_logic_5(
        .in(b_out_frac_FCEs_ctrl[5]),
        .out(out_frac_FCEs_ctrl[5])
        );
inv_logic inv_logic_6(
        .in(b_out_frac_FCEs_ctrl[6]),
        .out(out_frac_FCEs_ctrl[6])
        );
inv_logic inv_logic_7(
        .in(b_out_frac_FCEs_ctrl[7]),
        .out(out_frac_FCEs_ctrl[7])
        );
	
	
	
inv_logic inv_logic_int_0(
        .in(b_out_int_FCEs_ctrl[0]),
        .out(out_int_FCEs_ctrl[0])
        );
inv_logic inv_logic_int_1(
        .in(b_out_int_FCEs_ctrl[1]),
        .out(out_int_FCEs_ctrl[1])
        );
inv_logic inv_logic_int_2(
        .in(b_out_int_FCEs_ctrl[2]),
        .out(out_int_FCEs_ctrl[2])
        );
inv_logic inv_logic_int_3(
        .in(b_out_int_FCEs_ctrl[3]),
        .out(out_int_FCEs_ctrl[3])
        );
inv_logic inv_logic_int_4(
        .in(b_out_int_FCEs_ctrl[4]),
        .out(out_int_FCEs_ctrl[4])
        );
inv_logic inv_logic_int_5(
        .in(b_out_int_FCEs_ctrl[5]),
        .out(out_int_FCEs_ctrl[5])
        );
inv_logic inv_logic_int_6(
        .in(b_out_int_FCEs_ctrl[6]),
        .out(out_int_FCEs_ctrl[6])
        );
inv_logic inv_logic_int_7(
        .in(b_out_int_FCEs_ctrl[7]),
        .out(out_int_FCEs_ctrl[7])
        );
inv_logic inv_logic_int_8(
        .in(b_out_int_FCEs_ctrl[8]),
        .out(out_int_FCEs_ctrl[8])
        );
inv_logic inv_logic_int_9(
        .in(b_out_int_FCEs_ctrl[9]),
        .out(out_int_FCEs_ctrl[9])
        );
inv_logic inv_logic_int_10(
        .in(b_out_int_FCEs_ctrl[10]),
        .out(out_int_FCEs_ctrl[10])
        );
inv_logic inv_logic_int_11(
        .in(b_out_int_FCEs_ctrl[11]),
        .out(out_int_FCEs_ctrl[11])
        );
inv_logic inv_logic_int_12(
        .in(b_out_int_FCEs_ctrl[12]),
        .out(out_int_FCEs_ctrl[12])
        );
inv_logic inv_logic_int_13(
        .in(b_out_int_FCEs_ctrl[13]),
        .out(out_int_FCEs_ctrl[13])
        );
inv_logic inv_logic_int_14(
        .in(b_out_int_FCEs_ctrl[14]),
        .out(out_int_FCEs_ctrl[14])
        );
inv_logic inv_logic_int_15(
        .in(b_out_int_FCEs_ctrl[15]),
        .out(out_int_FCEs_ctrl[15])
        );
inv_logic inv_logic_int_16(
        .in(b_out_int_FCEs_ctrl[16]),
        .out(out_int_FCEs_ctrl[16])
        );
inv_logic inv_logic_int_17(
        .in(b_out_int_FCEs_ctrl[17]),
        .out(out_int_FCEs_ctrl[17])
        );
inv_logic inv_logic_int_18(
        .in(b_out_int_FCEs_ctrl[18]),
        .out(out_int_FCEs_ctrl[18])
        );
inv_logic inv_logic_int_19(
        .in(b_out_int_FCEs_ctrl[19]),
        .out(out_int_FCEs_ctrl[19])
        );
inv_logic inv_logic_int_20(
        .in(b_out_int_FCEs_ctrl[20]),
        .out(out_int_FCEs_ctrl[20])
        );
inv_logic inv_logic_int_21(
        .in(b_out_int_FCEs_ctrl[21]),
        .out(out_int_FCEs_ctrl[21])
        );
inv_logic inv_logic_int_22(
        .in(b_out_int_FCEs_ctrl[22]),
        .out(out_int_FCEs_ctrl[22])
        );
inv_logic inv_logic_int_23(
        .in(b_out_int_FCEs_ctrl[23]),
        .out(out_int_FCEs_ctrl[23])
        );
inv_logic inv_logic_int_24(
        .in(b_out_int_FCEs_ctrl[24]),
        .out(out_int_FCEs_ctrl[24])
        );
inv_logic inv_logic_int_25(
        .in(b_out_int_FCEs_ctrl[25]),
        .out(out_int_FCEs_ctrl[25])
        );
inv_logic inv_logic_int_26(
        .in(b_out_int_FCEs_ctrl[26]),
        .out(out_int_FCEs_ctrl[26])
        );
inv_logic inv_logic_int_27(
        .in(b_out_int_FCEs_ctrl[27]),
        .out(out_int_FCEs_ctrl[27])
        );
inv_logic inv_logic_int_28(
        .in(b_out_int_FCEs_ctrl[28]),
        .out(out_int_FCEs_ctrl[28])
        );
inv_logic inv_logic_int_29(
        .in(b_out_int_FCEs_ctrl[29]),
        .out(out_int_FCEs_ctrl[29])
        );
inv_logic inv_logic_int_30(
        .in(b_out_int_FCEs_ctrl[30]),
        .out(out_int_FCEs_ctrl[30])
        );
inv_logic inv_logic_int_31(
        .in(b_out_int_FCEs_ctrl[31]),
        .out(out_int_FCEs_ctrl[31])
        );
inv_logic inv_logic_int_32(
        .in(b_out_int_FCEs_ctrl[32]),
        .out(out_int_FCEs_ctrl[32])
        );		
inv_logic inv_logic_int_33(
        .in(b_out_int_FCEs_ctrl[33]),
        .out(out_int_FCEs_ctrl[33])
        );
inv_logic inv_logic_int_34(
        .in(b_out_int_FCEs_ctrl[34]),
        .out(out_int_FCEs_ctrl[34])
        );
inv_logic inv_logic_int_35(
        .in(b_out_int_FCEs_ctrl[35]),
        .out(out_int_FCEs_ctrl[35])
        );
inv_logic inv_logic_int_36(
        .in(b_out_int_FCEs_ctrl[36]),
        .out(out_int_FCEs_ctrl[36])
        );
inv_logic inv_logic_int_37(
        .in(b_out_int_FCEs_ctrl[37]),
        .out(out_int_FCEs_ctrl[37])
        );
inv_logic inv_logic_int_38(
        .in(b_out_int_FCEs_ctrl[38]),
        .out(out_int_FCEs_ctrl[38])
        );
inv_logic inv_logic_int_39(
        .in(b_out_int_FCEs_ctrl[39]),
        .out(out_int_FCEs_ctrl[39])
        );
inv_logic inv_logic_int_40(
        .in(b_out_int_FCEs_ctrl[40]),
        .out(out_int_FCEs_ctrl[40])
        );
inv_logic inv_logic_int_41(
        .in(b_out_int_FCEs_ctrl[41]),
        .out(out_int_FCEs_ctrl[41])
        );
inv_logic inv_logic_int_42(
        .in(b_out_int_FCEs_ctrl[42]),
        .out(out_int_FCEs_ctrl[42])
        );
inv_logic inv_logic_int_43(
        .in(b_out_int_FCEs_ctrl[43]),
        .out(out_int_FCEs_ctrl[43])
        );
inv_logic inv_logic_int_44(
        .in(b_out_int_FCEs_ctrl[44]),
        .out(out_int_FCEs_ctrl[44])
        );
inv_logic inv_logic_int_45(
        .in(b_out_int_FCEs_ctrl[45]),
        .out(out_int_FCEs_ctrl[45])
        );
inv_logic inv_logic_int_46(
        .in(b_out_int_FCEs_ctrl[46]),
        .out(out_int_FCEs_ctrl[46])
        );
inv_logic inv_logic_int_47(
        .in(b_out_int_FCEs_ctrl[47]),
        .out(out_int_FCEs_ctrl[47])
        );
inv_logic inv_logic_int_48(
        .in(b_out_int_FCEs_ctrl[48]),
        .out(out_int_FCEs_ctrl[48])
        );
inv_logic inv_logic_int_49(
        .in(b_out_int_FCEs_ctrl[49]),
        .out(out_int_FCEs_ctrl[49])
        );
inv_logic inv_logic_int_50(
        .in(b_out_int_FCEs_ctrl[50]),
        .out(out_int_FCEs_ctrl[50])
        );
inv_logic inv_logic_int_51(
        .in(b_out_int_FCEs_ctrl[51]),
        .out(out_int_FCEs_ctrl[51])
        );
inv_logic inv_logic_int_52(
        .in(b_out_int_FCEs_ctrl[52]),
        .out(out_int_FCEs_ctrl[52])
        );
inv_logic inv_logic_int_53(
        .in(b_out_int_FCEs_ctrl[53]),
        .out(out_int_FCEs_ctrl[53])
        );
inv_logic inv_logic_int_54(
        .in(b_out_int_FCEs_ctrl[54]),
        .out(out_int_FCEs_ctrl[54])
        );
inv_logic inv_logic_int_55(
        .in(b_out_int_FCEs_ctrl[55]),
        .out(out_int_FCEs_ctrl[55])
        );
inv_logic inv_logic_int_56(
        .in(b_out_int_FCEs_ctrl[56]),
        .out(out_int_FCEs_ctrl[56])
        );
inv_logic inv_logic_int_57(
        .in(b_out_int_FCEs_ctrl[57]),
        .out(out_int_FCEs_ctrl[57])
        );
inv_logic inv_logic_int_58(
        .in(b_out_int_FCEs_ctrl[58]),
        .out(out_int_FCEs_ctrl[58])
        );
inv_logic inv_logic_int_59(
        .in(b_out_int_FCEs_ctrl[59]),
        .out(out_int_FCEs_ctrl[59])
        );
inv_logic inv_logic_int_60(
        .in(b_out_int_FCEs_ctrl[60]),
        .out(out_int_FCEs_ctrl[60])
        );
inv_logic inv_logic_int_61(
        .in(b_out_int_FCEs_ctrl[61]),
        .out(out_int_FCEs_ctrl[61])
        );
inv_logic inv_logic_int_62(
        .in(b_out_int_FCEs_ctrl[62]),
        .out(out_int_FCEs_ctrl[62])
        );
inv_logic inv_logic_int_63(
        .in(b_out_int_FCEs_ctrl[63]),
        .out(out_int_FCEs_ctrl[63])
        );


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

Dynamic Element Matching (DEM) is used to scramble the usage pattern of the
FCE and transform the nonlinearities into noise. (This noise is not shaped,
since the Switchig Blocks (SB) used don't have shape random sequences).


We are going to use segmenting switching blocks, so the DEM is going to
have a tree structure.


   1st stage             2nd stage      3rd stage    FCEs

                        _____
                       |    | ---->     ...
              -------> |    |
             |         |____| ---->     ...
     ____    |
    |   |  --|
--> |   |
    |___|  --
             |
             |          _____
             |         |    | --->     ...
              -------> |    |
                       |____| --->     ...




Altough there are 8 FCEs.
Only 6 FCEs are going to be used. Since we have 7 levels at the output of the DSM.
It is possible to implement a DEM that drives only 6 FCEs but it has a more
difficult implementation than the tree structer.

*/


module dem (
        in_dem,
        in_random_bit,
        out_frac_FCEs_ctrl
        );


input [3:0] in_dem;
input [2:0] in_random_bit;

output [7:0] out_frac_FCEs_ctrl;

wire [1:0] sb_1_1;
wire [1:0] sb_2_1;
wire [1:0] sb_2_2;
wire [1:0] sb_3_1;
wire [1:0] sb_3_2;
wire [1:0] sb_3_3;
wire [1:0] sb_3_4;



//STAGE #1
switching_block_non_segmented SB_num1 (
        .in_lsb(in_dem[1:0]),
        .in_random_bit(in_random_bit[0]),
        .out(sb_1_1)
        );


//STAGE #2
switching_block_non_segmented SB_num2 (
        .in_lsb({in_dem[2],sb_1_1[0]}),
        .in_random_bit(in_random_bit[1]),
        .out(sb_2_1)
        );

switching_block_non_segmented SB_num3 (
        .in_lsb({in_dem[2],sb_1_1[1]}),
        .in_random_bit(in_random_bit[1]),
        .out(sb_2_2)
        );



//STAGE #3
switching_block_non_segmented SB_num4 (
        .in_lsb({in_dem[3],sb_2_1[0]}),
        .in_random_bit(in_random_bit[2]),
        .out(sb_3_1)
        );

switching_block_non_segmented SB_num5 (
        .in_lsb({in_dem[3],sb_2_1[1]}),
        .in_random_bit(in_random_bit[2]),
        .out(sb_3_2)
        );

switching_block_non_segmented SB_num6 (
        .in_lsb({in_dem[3],sb_2_2[0]}),
        .in_random_bit(in_random_bit[2]),
        .out(sb_3_3)
        );

switching_block_non_segmented SB_num7 (
        .in_lsb({in_dem[3],sb_2_2[1]}),
        .in_random_bit(in_random_bit[2]),
        .out(sb_3_4)
        );


assign out_frac_FCEs_ctrl [0] = sb_3_1[0];
assign out_frac_FCEs_ctrl [1] = sb_3_1[1];
assign out_frac_FCEs_ctrl [2] = sb_3_2[0];
assign out_frac_FCEs_ctrl [3] = sb_3_2[1];
assign out_frac_FCEs_ctrl [4] = sb_3_3[0];
assign out_frac_FCEs_ctrl [5] = sb_3_3[1];
assign out_frac_FCEs_ctrl [6] = sb_3_4[0];
assign out_frac_FCEs_ctrl [7] = sb_3_4[1];


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

The integer part of the DCO input word is used to control Frequency
Control Elements (FCEs) with a large frequency step.

Since a smaller frequency step is wanted. The fractional part of the DCO input word is
passed through a Delta Sigma Modulator (DSM):

        1) It has an output that on average is equal to the input signal.

        2) The output has fewer bits than the input. Thus, a quantization
        takes place.

        3) Such quantization consist of droping LSBs
        (this is equivalent to divide by 2^[num_of_lsb_dropped]).
                Example:   8bits --> to --> 4 bits
                23 = 0001 0111   --> quantize to 4 bits --> 0001 = 1
                which is 23/2^4= = 23/16 = 1.4375
                The DSM make sure the 4 LSBs dropped, are on average
                accounted in the 4 MSBs.

        4) The quantization noise at the output is shaped with its peak
        at clock_frequency / 2.

        5) For this system not to have loss of information, it needs to be
        oversampled:
        The PLL BW is about 100kHz, and the sample rate is 26MHz. Thus, there
        is oversample. (The higher the sample rate, the better the noise behaves)


        6) The DSM limits its output to a certain range depending on the
        input range. eg:
                1)   input [-1 1] --> output [-2 2]
                2)   input [-2 2] --> output [-3 3]
                3)   input [-4 4] --> output [-5 5]
                4)   input [-8 8] --> output [-9 9]


        7) Block diagram of DSM is shown below:


  input[8:0]    [9:0]           not_yet_quantized_signal[10:0]
-------------> + ----> + -------------------------------------------> Quantizer -------->  output[3:0]
               |       ^                                       |                  |
               |       |                                       |                  |
            dither     |        -1         -1                  |                  |
                       |______ z   (2 - z )   <--------------- + <-----------------
                                                                -
                    fb_error[9:0]            quantization_error[6:0]



             Design
        ---------------

Example 1:
        1) How many 'fractional' FCEs are needed?
                A/ 4 FCES
        2) How many levels are needed to drive 4 FCEs?
                A/ 5 levels,  (0 on, 1 on, 2 on,..., 5 on)
                -2 -1 0 1 2
        3) What is the input range needed for "2)"?
                A/ [-1, 1]
        4) How many bits are needed for 5 levels?
                A/ 3 bits     (2^3 = up to 8 levels)
        5) How many bits are dropped?
                A/ If not_yet_quantized_signal have
                11 bits: 11-3 = 8 bits to be dropped
                Which is equivalent to divde by 2^8

Example 2:
        1) How many 'fractional' FCEs are needed?
                A/ 6 FCES
        2) How many levels are needed to drive 6 FCEs?
                A/ 7 levels,  (0 on, 1 on, 2 on,..., 6 on)
                -3 -2 -1 0 1 2 3
        3) What is the input range needed for "2)"?
                A/ [-2, 2]
        4) How many bits are dropped?
                A/ The input is twice as example 1.
                Input_Example_1 * 2 / 2^8 = Input_Example_1 /2^7
                Drop: 7 bits
        5) How many bits are need at output?
                A/ If not_yet_quantized_signal have
                11 bits: 11-7 = 4 bits at output.
                Which is equivalent to divde by 2^4=16
                levels which is more than 7.

Example 3:
        1) How many 'fractional' FCEs are needed?
                A/ 8 FCES
        2) How many levels are needed to drive 6 FCEs?
                A/ 7 levels,  (0 on, 1 on, 2 on,..., 8 on)
                -4 -3 -2 -1 0 1 2 3 4
        3) What is the input range needed for "2)"?
                A/ [-3, 3]
        4) How many bits are dropped?
                A/ The input is 3 times as example 1/
                Input_Example_1 * 3 / 2^8
                --> Not an integer = PROBLEM
        5) How many bits are need at output?
                A/ PROBLEM

Example 4:
        1) How many 'fractional' FCEs are needed?
                A/ 10 FCES
        2) How many levels are needed to drive 10 FCEs?
                A/ 11 levels,  (0 on, 1 on, 2 on,..., 10 on)
                -5 -4 -3 -2 -1 0 1 2 3 4 5
        3) What is the input range needed for "2)"?
                A/ [-4, 4]
        4) How many bits are dropped?
                A/ The input is 4 times as example 1,
                Input_Example_1 *4 / 2^8 = Input_Example_1 / 2^6
                Drop: 6 bits
        5) How many bits are need at output?
                A/ If not_yet_quantized_signal have
                11 bits: 11-6 = 5 bits at output.
                Which is equivalent to divde by 2^5=32
                levels which is more than 11.

        NOTE: even if this design was made for 10 FCEs, you can
        use only 8 of those FCEs.

Another way to understand the design:
        The input is a 9 bits signed signal --> [-256 255]
        If we divide it by 2^8 the input signal covers --> [-1 1)
        then it goes through the same DSM with a quantization
        step of 1.




Summary:

Input is 9 bits signed taking the range [-1,+1).
Output is 4 bits signed, restricted to the range [-3,3].
Quantization error over [0,+1).
Feedback (fb_error) path spans (-1,+2).


*/


module dsm_2nd_order (
   out_dsm,
   in_clk,
   in_rstb,
   in_lsb_dither,
   in_dsm
   );

input in_rstb;
input in_lsb_dither, in_clk;
input [8:0] in_dsm;

output [3:0] out_dsm;

wire signed [10:0] not_yet_quantized_signal;
wire signed [9:0] fb_error;

reg [6:0] dsm_reg_num1;
reg [6:0] dsm_reg_num2;


                                            // x2
assign fb_error = $signed({2'b0,dsm_reg_num1,1'b0}) - $signed({3'b0,dsm_reg_num2}); // 2z^-1 - z^-2
                          //always positive                  //always positive


assign not_yet_quantized_signal = $signed({{(2){in_dsm[8]}},in_dsm}) + $signed({fb_error[9],fb_error}) + $signed({10'b0,in_lsb_dither});
                                                                                                                //always positive


assign out_dsm = not_yet_quantized_signal[10:7];



//Registers
always @(posedge in_clk or negedge in_rstb) begin

        if ( !in_rstb ) begin

                dsm_reg_num1 <= 0;
                dsm_reg_num2 <= 0;

        end else begin

                dsm_reg_num1 <= not_yet_quantized_signal[6:0]; // this 7 bits are the quantization error (there is no need for implementing the subtraction)
                dsm_reg_num2 <= dsm_reg_num1;
        end


end


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*


We don't want to be switching the integer-FCE-bank.
        Ideally, once the PLL is locked, we want the integer-FCE-bank to mantain the
        same value, and the only control over the frequency is made through the
        fractional-FCE-bank.

The Integer Boundary Avoider (IBA) presents a mechanisim that allows a solution for the situation in
which the the PLL locks for a integer-DCO-input very close to an integer boundary.
And prevents it to toggle within two different integer-FCE-bank value.


             DCO input
              ^
              |      _____    __    __    __    __
int boundary  |   __/     \__/  \__/  \__/  \__/  \   : we don't want this dancing around boundary
              |__/
              |
              |________________________________________ > time



This block doesn't allow for the integer-DCO-input to be dancing arround one integer boundary.
But it does allows it to cross the bounday in one direction.

             DCO input
              ^
              |      _______________________________
int boundary  |   __/
              |__/
              |
              |________________________________________ > time




This blocks adds an offset of -1:

         ________
        |        |
K ----> | I.B.A  |--> K - 1
        |________|

The "-1" happens on the integer-DCO-input or on the fractional-DCO-input.
        a) if the input to the I.B.A is the largest value we have every run into -->  integer_DCO_input - 1
        b) if the input to the I.B.A is not the largest value so far --> fractional_DCO_inpt - 256  (256 frac == 1 int)



Example:


input K-1   |   input K       |   input K       |    input K-1     |   input K     |   input K+1
frac m      |   sub to int    |   sub to int    |    sub to frac   |   sub to int  |   sub to int
            |   out_int K-1   |   out_int K-1   |    out_int K-1   |   out K-1     |   out K
            |   out_frac m    |   out_frac m    |    out_frac m-1  |   out_frac m  |   out_frac m
            |   tot K-1+m     |   tot K-1+m     |    tot K-2+m     |   tot K-1+m   |   tot K+m


A consequence of the IBA is that the fractional-DCO-input covers [-256 255] instead of [0 255]
                                             Which represents    [-1   1)   instead of [0  1)

*/



module integer_boundary_avoider (
        in_rstb,
        in_clk,
        in_int_bound_avoid,
        out_to_dco_int,
        out_to_dco_frac
        );

input in_rstb;
input in_clk;
input [13:0] in_int_bound_avoid;

output [5:0] out_to_dco_int;     // 6.0
output [8:0] out_to_dco_frac;    // 1.8


wire sub_one;
wire [5:0] v_int;
wire [7:0] v_frac;

reg [5:0] v_int_prev;
reg [5:0] v_max;
reg [5:0] v_max_prev;



// Split input    //takes the signed and converts it to unsigned
assign v_int = {!in_int_bound_avoid[13], in_int_bound_avoid[12:8]};
assign v_frac = in_int_bound_avoid[7:0];


// Compute current max integer
always @(*) begin
      if ( v_int == v_int_prev )

        v_max = v_max_prev;

      else if ( v_int < v_int_prev )

        v_max = v_int_prev;

      else

        v_max = v_int;
end


assign sub_one = ( 6'b0 != v_int ) && ( v_int == v_max );


// Assign outputs
assign out_to_dco_int = v_int - sub_one;
assign out_to_dco_frac = {!sub_one,v_frac};


 // Registers
always @( posedge in_clk or negedge in_rstb ) begin

      if ( !in_rstb ) begin

         v_int_prev <= 0;
         v_max_prev <= 0;

      end else begin

         v_int_prev <= v_int;
         v_max_prev <= v_max;

      end
end



endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

The output of the DSM takes the values:    -3, -2, -1, 0, 1, 2, 3
This goes through a DEM that needs to read: 0,  1,  2, 3, 4, 5, 6

Therfore this block implements the mapping from DSM to obtain the desiered
DEM input range.

Let's express the output in "extra LSB coding" that will be used in the
following non-segmenting DEM.
        Remember: extra LSB coding implies that the last 2 LSBs has the same
                  weight = 2^0 = 1
                  Example:   111 = 1(2^1) + 1(2^0) + 1(2^0) = 4
                             110 = 1(2^1) + 1(2^0) + 0(2^0) = 3
                             010 = 0(2^1) + 1(2^0) + 0(2^0) = 1

Extra LSB coding allows for simpler Switching Blocks, without the need
for implementing adders. Thus, is a much faster block.

*/

module map_dsm_to_dem (
        in_dsm_output,
        out_dsm_mapped_to_dem
        );

input [3:0] in_dsm_output;
output [3:0] out_dsm_mapped_to_dem;

reg [3:0] out_dsm_mapped_to_dem;

always @(*) begin

        case (in_dsm_output)
                4'b1101 : out_dsm_mapped_to_dem = 4'b0000; // -3 --> 0
                4'b1110 : out_dsm_mapped_to_dem = 4'b0001; // -2 --> 1
                4'b1111 : out_dsm_mapped_to_dem = 4'b0100; // -1 --> 2
                4'b0000 : out_dsm_mapped_to_dem = 4'b0101; //  0 --> 3
                4'b0001 : out_dsm_mapped_to_dem = 4'b0111; //  1 --> 4    0(2^2) + 1(2^1) + 1(2^0) + 1(2^0) = 4
                4'b0010 : out_dsm_mapped_to_dem = 4'b1001; //  2 --> 5
                4'b0011 : out_dsm_mapped_to_dem = 4'b1100; //  3 --> 6    1(2^2) + 1(2^1) + 0(2^0) + 0(2^0) = 6
                // The following cases never happen because of the DSM
                // range, but since this block is NOT clocked: the 4 input
                // bits don't change at the same time. Thus, sometimes can
                // lead to not wanted states. (These cases aren't taken at the
                // fractional FCEs output becuase they are clock, but never
                // the less, we should make those states as known states)
                4'b1000 : out_dsm_mapped_to_dem = 4'b0000; // -8
                4'b1001 : out_dsm_mapped_to_dem = 4'b0000; // -7
                4'b1010 : out_dsm_mapped_to_dem = 4'b0000; // -6
                4'b1011 : out_dsm_mapped_to_dem = 4'b0000; // -5
                4'b1100 : out_dsm_mapped_to_dem = 4'b0000; // -4
                4'b0100 : out_dsm_mapped_to_dem = 4'b0000; //  4
                4'b0101 : out_dsm_mapped_to_dem = 4'b0000; //  5
                4'b0110 : out_dsm_mapped_to_dem = 4'b0000; //  6
                4'b0111 : out_dsm_mapped_to_dem = 4'b0000; //  7
        endcase

end



endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*
This block implements a non segmenting switching block.
It uses extra LSB encoder in order to get rid of the adders
that are very slow and consume lots of power.

If the input is 00    out_1=0    out_2=0
If the input is 11    out_1=1    out_2=1
If the input is 10    out_1=rand    out_2=!rand
If the input is 01    out_1=rand    out_2=!rand
*/

module switching_block_non_segmented (
        in_lsb,
        in_random_bit,
        out
        );

input [1:0] in_lsb;
input in_random_bit;
output [1:0] out;


reg [1:0] out;


always @(*) begin

        case(in_lsb)

                2'b00 : out = 2'b00; //even
                2'b01 : out = {in_random_bit,!in_random_bit}; //odd
                2'b10 : out = {in_random_bit,!in_random_bit}; //odd
                2'b11 : out = 2'b11; //even

        endcase
end


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

This block implements a thermometer encoder.


     7 bits
6 = 0000110 -->6=00110 --> 0          #37-----------------
                           .                    |
                           .                    |
                           .                    |
                           0           #16      |
                           0           #15      |
                           0           #14      |
                           0           #13      |
                           0           #12      |
                           0           #11      |
                           0           #10      |
                           0           #9       |
                           0           #8       |
                           0           #7       |
                           1           #6       |
                           1           #5       |
                           1           #4       |
                           1           #3       |
                           1           #2       |
                           1           #1_______|______



*/

module dco_drift_comp_conv_to_therm_encoder(
        in_therm_encod,
        out_therm_encod
        );

parameter num_of_integer_FCE = 37;


input [5:0] in_therm_encod;
output [num_of_integer_FCE-1:0] out_therm_encod;

reg [num_of_integer_FCE-1:0] x2_FCE_ctrl;
integer ii;

always @(*) begin

        for ( ii = 0 ; ii < num_of_integer_FCE ; ii = ii + 1 ) begin

                if ( in_therm_encod[5:0] >= $unsigned(ii) ) begin

                        x2_FCE_ctrl[ii] <= 1'b1;

                end else begin

                        x2_FCE_ctrl[ii] <= 1'b0;

                end

        end

end


assign out_therm_encod[num_of_integer_FCE-1:0] = x2_FCE_ctrl;


endmodule
/* Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu


  											         __________             ____
      6bits		6bits 								        |          |    37     |    |
     ------> + -------------------------------------------------------------------------------->| Conv to  |-----------| FF |---> out_additional_freq_ctrl
             ^										        | Therm    |           |____|
	     | -                    							        | Code     |              ^
	     |                                                                                  |__________|              |
             |         ena_dco_drift                                                                               clk_additional_fce
	     |           ___|_
	     |          |     |<------ 0                     _______________________________
	     -----------| MUX |                   i[n]      |                               |
             |          |_____| <---------------------------|  t[n]>=13      i[n+1]=i[n]-1  |
             |                                              |  t[n]<=-13     i[n+1]=i[n]+1  |
	     |                                              |_______________________________|
	     |                                                             ^
	     |                                                             |
 15  6MSBs  |       t[n]    5bits                                         |                                 6.8
-----------> + --------------------------------------------------------------------------------------------------> out_dco_drift
     |                                                                                                  |
     |                                                                                                  |
     |__________________________________________________________________________________________________|
              9LSBs
*/


module dco_drift_compensator (
	in_dco_drift_comp,
	in_rstb,
	in_param_additional_freq_ctrl,
	in_param_ena_dco_drift,
	in_clk_dco_drift_comp,
	in_clk_additional_fce,
	out_additional_freq_ctrl,
	out_dco_drift
	);
	
	
input in_rstb;
input in_clk_additional_fce;
input in_clk_dco_drift_comp;
input [14:0] in_dco_drift_comp;
input [5:0] in_param_additional_freq_ctrl;
input in_param_ena_dco_drift;
output [36:0] out_additional_freq_ctrl;
output [13:0] out_dco_drift;

wire signed[5:0] compensation_signal;
wire signed [5:0] pll_control_signal;
wire signed [6:0] adder_out_extra_bit;  
wire signed [4:0] adder_out;  //t[n]
wire [6:0] adder2_out_extra_bit;
wire [5:0] adder2_out;
reg signed [5:0] compensation_signal_pre_mux;  //i[n]
reg signed [5:0] compensation_signal_pre_mux_reg;  //i[n-1]
wire [36:0] additional_freq_ctrl;
reg [36:0] out_additional_freq_ctrl;



assign pll_control_signal = in_dco_drift_comp[14:9];
assign compensation_signal = (in_param_ena_dco_drift == 1) ? compensation_signal_pre_mux : 0;
assign adder_out_extra_bit = $signed(pll_control_signal) + $signed(compensation_signal);
assign adder_out = adder_out_extra_bit[4:0];
assign adder2_out_extra_bit = $unsigned(in_param_additional_freq_ctrl) - $signed({{1{compensation_signal[5]}},compensation_signal});
assign adder2_out = adder2_out_extra_bit[5:0];



always @(negedge in_clk_dco_drift_comp or negedge in_rstb) begin
	if ( !in_rstb ) begin
		compensation_signal_pre_mux_reg <= 0;
	end else begin
		compensation_signal_pre_mux_reg <= compensation_signal_pre_mux;
	end
end



always @(posedge in_clk_dco_drift_comp or negedge in_rstb) begin
	if ( !in_rstb ) begin
		compensation_signal_pre_mux <=  0;
	end else if ($signed(adder_out) >= 13) begin
		compensation_signal_pre_mux <= $signed(compensation_signal_pre_mux_reg) - 1;
	end else if ($signed(adder_out) <= -13) begin
		compensation_signal_pre_mux <= $signed(compensation_signal_pre_mux_reg) + 1;
	end
end



assign out_dco_drift[13:9] =  adder_out;
assign out_dco_drift[8:0] =  in_dco_drift_comp[8:0];


dco_drift_comp_conv_to_therm_encoder dco_drift_comp_conv_to_therm_encoder(
	.in_therm_encod(adder2_out),
	.out_therm_encod(additional_freq_ctrl)
	);


always @(posedge in_clk_additional_fce or negedge in_rstb) begin
	if ( !in_rstb ) begin
		out_additional_freq_ctrl <= 0;
	end else begin
		out_additional_freq_ctrl <= additional_freq_ctrl;
	end
end

endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

The DLC gain is adjustable.
It can be multiplied by:
        1, 1.25, 1.5 or 1.75


How to multiply by 1.5?
 X/2 + X = 1.5 X

How to multiply by 1.25?
 X/4 + X = 1.25 X

How to multiply by 1.75?
 X/2 + X/4 + X = 1.75 X

How to multiply by 0.75?
 X/2 + X/4  = 0.75 X

How to multiply by 0.5?
 X/2  = 0.5 X

Note: When we divide by 2 we drop the LSB.
      When we divide by 4 we drop the 2 LSBS.
      The lost of information is neglegible.


The output has to have 1 more bit than input because of the addition implemented.

*/

module dlc_gain_selector (
        in_to_dlc,
        in_param_dlc_gain_sel,
        out_to_dlc
        );


   parameter DBUS_WIDTH = 22;

   input [DBUS_WIDTH-1:0]  in_to_dlc;  // = The output of "alpha_and_accum_top":  out_p_of_n[24:0]  
   input [2:0]             in_param_dlc_gain_sel;
   output [DBUS_WIDTH:0]   out_to_dlc;

   reg [DBUS_WIDTH:0]      out_to_dlc; // The output has to have 1 more bit than input because of the addition implemented.

   wire [DBUS_WIDTH:0]     signal_mult_by_1;
   wire [DBUS_WIDTH:0]     signal_mult_by_1_25;
   wire [DBUS_WIDTH:0]     signal_mult_by_1_5;
   wire [DBUS_WIDTH:0]     signal_mult_by_1_75;
   wire [DBUS_WIDTH:0]     signal_mult_by_0_75;
   wire [DBUS_WIDTH:0]     signal_mult_by_0_5;
   wire [DBUS_WIDTH:0]     signal_divided_by_2;
   wire [DBUS_WIDTH:0]     signal_divided_by_4;

   // Calcuate divided by 2 and 4 data                                                       //   bit_n  bit_n-1   .... bit4 bit3 bit2 bi1 bit0
   assign signal_divided_by_4 = {{3{in_to_dlc[DBUS_WIDTH-1]}},in_to_dlc[DBUS_WIDTH-1:2]};    //   divide by 4:                         |--> drop 2 LSB

   assign signal_divided_by_2 = {{2{in_to_dlc[DBUS_WIDTH-1]}},in_to_dlc[DBUS_WIDTH-1:1]};    //   divide by 2:                            |--> drop 1 LSB


   // Perform signed multiply by shifted adds
   assign signal_mult_by_1 = {in_to_dlc[DBUS_WIDTH-1],in_to_dlc};
   assign signal_mult_by_1_25 = signal_mult_by_1 + signal_divided_by_4;
   assign signal_mult_by_1_5 = signal_mult_by_1 + signal_divided_by_2;
   assign signal_mult_by_1_75 = signal_mult_by_1 + signal_divided_by_2 + signal_divided_by_4;
   assign signal_mult_by_0_75 = signal_divided_by_2 + signal_divided_by_4;
   assign signal_mult_by_0_5 = signal_divided_by_2;

   // Assign multiplied value
   always @(*) begin
      case ( in_param_dlc_gain_sel )
        0 : out_to_dlc = signal_mult_by_1;
        1 : out_to_dlc = signal_mult_by_1_25;
        2 : out_to_dlc = signal_mult_by_1_5;
        3 : out_to_dlc = signal_mult_by_1_75;
        4 : out_to_dlc = signal_mult_by_0_75;
        5 : out_to_dlc = signal_mult_by_0_5;
        default : out_to_dlc = {DBUS_WIDTH{1'bx}};
      endcase // case ( in_param_dlc_gain_sel )
   end

endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

*/

module dlc_top (
        in_dlc,
        in_clk,
        in_rstb,
        in_param_dlc_gain_sel,
        in_param_pole_location_shift_IIR_0,
        in_param_pole_location_shift_IIR_1,
        in_param_pole_location_shift_IIR_2,
        in_param_pole_location_shift_IIR_3,
        in_param_ena_IIR_0,
        in_param_ena_IIR_1,
        in_param_ena_IIR_2,
        in_param_ena_IIR_3,
        in_param_ena_requantizer_IIR_0,
        in_param_ena_requantizer_IIR_1,
        in_param_ena_requantizer_IIR_2,
        in_param_ena_requantizer_IIR_3,
        in_param_k_p,
        in_param_k_i,
        in_param_ena_pi_requant,
        in_rand_num,
        out_dlc
        );


input [21:0] in_dlc;
input in_clk;
input in_rstb;
input [2:0] in_param_dlc_gain_sel;
input [2:0] in_param_pole_location_shift_IIR_0;
input [2:0] in_param_pole_location_shift_IIR_1;
input [2:0] in_param_pole_location_shift_IIR_2;
input [2:0] in_param_pole_location_shift_IIR_3;
input in_param_ena_IIR_0;
input in_param_ena_IIR_1;
input in_param_ena_IIR_2;
input in_param_ena_IIR_3;
input in_param_ena_requantizer_IIR_0;
input in_param_ena_requantizer_IIR_1;
input in_param_ena_requantizer_IIR_2;
input in_param_ena_requantizer_IIR_3;
input [3:0] in_param_k_p;
input [3:0] in_param_k_i;
input in_param_ena_pi_requant;
input [22:0] in_rand_num;
output [14:0] out_dlc;

wire [22:0] in_dlc_scaled;

wire [22:0] iir0_out;
wire [22:0] iir1_out;
wire [22:0] iir2_out;
wire [22:0] iir3_out;


dlc_gain_selector dlc_gain_selector(
        .in_to_dlc(in_dlc),
        .in_param_dlc_gain_sel(in_param_dlc_gain_sel),
        .out_to_dlc(in_dlc_scaled)
        );



iir_filter_logic #(.DWIDTH(23)) iir0_logic (
        .out_of_iir_stage(iir0_out),
        .in_clk(in_clk),
        .in_rstb(in_rstb),
        .in_requantizer_ena_iir(in_param_ena_requantizer_IIR_0),
        .in_random_num(in_rand_num[2:0]),
        .in_to_iir_stage(in_dlc_scaled),
        .in_param_pole_location_shift(in_param_pole_location_shift_IIR_0),
        .in_ena_iir(in_param_ena_IIR_0)
        );

iir_filter_logic #(.DWIDTH(23)) iir1_logic (
        .out_of_iir_stage(iir1_out),
        .in_clk(in_clk),
        .in_rstb(in_rstb),
        .in_requantizer_ena_iir(in_param_ena_requantizer_IIR_1),
        .in_random_num(in_rand_num[5:3]),
        .in_to_iir_stage(iir0_out),
        .in_param_pole_location_shift(in_param_pole_location_shift_IIR_1),
        .in_ena_iir(in_param_ena_IIR_1)
        );

iir_filter_logic #(.DWIDTH(23)) iir2_logic (
        .out_of_iir_stage(iir2_out),
        .in_clk(in_clk),
        .in_rstb(in_rstb),
        .in_requantizer_ena_iir(in_param_ena_requantizer_IIR_2),
        .in_random_num(in_rand_num[8:6]),
        .in_to_iir_stage(iir1_out),
        .in_param_pole_location_shift(in_param_pole_location_shift_IIR_2),
        .in_ena_iir(in_param_ena_IIR_2)
        );

iir_filter_logic #(.DWIDTH(23)) iir3_logic (
        .out_of_iir_stage(iir3_out),
        .in_clk(in_clk),
        .in_rstb(in_rstb),
        .in_requantizer_ena_iir(in_param_ena_requantizer_IIR_3),
        .in_random_num(in_rand_num[11:9]),
        .in_to_iir_stage(iir2_out),
        .in_param_pole_location_shift(in_param_pole_location_shift_IIR_3),
        .in_ena_iir(in_param_ena_IIR_3)
        );

pi_control_logic pi_control_logic(
        .out_pi_data(out_dlc),
        .in_clk(in_clk),
        .in_rstb(in_rstb),
        .in_ena_requantization(in_param_ena_pi_requant),
        .in_data(iir3_out),
        .in_param_k_i(in_param_k_i),
        .in_param_k_p(in_param_k_p),
        .in_random_num(in_rand_num[22:12])
        );




endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

Based on Serenity Database: IIR filter.

IIR: infinite impulse response

NOTE: to make it equivalent to ISPG's PLL papers, please note K = lambda.






                                                                                                        _________
                                                                                                       |         |
                   |---------------------------------------------------------------------------------> | 0       |
                   |     _____                                                                         |         | ---> out
                   |    |     |                                                                 y[n]   |    MUX  |
         in  ---------> |  K  |---------------------------> + ------REQUANTIZETR---------------------> | 1       |
         x[n]           |_____|                             ^                     |                    |_________|
                                                            |                     |
                                  _____                     |                     |
                                 |     |       -            |                     |
                             --> |  K  | -------> + ---------                     |
                             |   |_____|          ^                               |
                             |                    |                               |
                             |                    |          ___________          |
                             |                    |         |           |         |
                             -------------------------------| Flip Flop |<---------
                                                     y[n-1] |___________|




 Math behind the Block Diagram:
        y[n] = K*x[n] + y[n-1]*(K-1)

        Z-transform:
        --> Y = K*X + Y*Z^-1*(K-1)

        --> Y (1 - {K-1}Z^-1) = KX
        --> TF:  Y/X = K / (1 - {K-1}Z^-1)     : you'll find this IIR transfer function in many ISPG's PLL papers.





*/


module iir_filter_logic (
   out_of_iir_stage,
   in_clk,
   in_rstb,
   in_requantizer_ena_iir,
   in_random_num,
   in_to_iir_stage,
   in_param_pole_location_shift,
   in_ena_iir
   );


   parameter DWIDTH = 16; // every time an IIR stage is called, this parameter is over-writen



   // Clock and reset
   input                    in_clk;
   input                    in_rstb;
   input                    in_requantizer_ena_iir;
   input [2:0]              in_random_num;
   input [DWIDTH-1:0]       in_to_iir_stage;
   input [2:0]              in_param_pole_location_shift;
   input                    in_ena_iir;


   output [DWIDTH-1:0]      out_of_iir_stage;



   // Forward path
   reg signed [DWIDTH+7:0]  sv_input_shift;
   wire signed [DWIDTH+7:0] sv_input_sum;
   wire [DWIDTH-1:0]        v_sum_requant;
   // Feedback path
   wire signed [DWIDTH+7:0] sv_fb_diff;
   reg signed [DWIDTH+7:0]  sv_fb_shift;

   reg [DWIDTH-1:0] sv_input_sum_reg;


   // Right shift the input by pole_shift places, sign extend an
   // extra 8 fractional bits: computes x[n] * 2^-p
   always @(*) begin
      case ( in_param_pole_location_shift )
        0 : sv_input_shift = $signed({{1{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 7'b0});
        1 : sv_input_shift = $signed({{2{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 6'b0});
        2 : sv_input_shift = $signed({{3{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 5'b0});
        3 : sv_input_shift = $signed({{4{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 4'b0});
        4 : sv_input_shift = $signed({{5{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 3'b0});
        5 : sv_input_shift = $signed({{6{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 2'b0});
        6 : sv_input_shift = $signed({{7{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage, 1'b0});
        7 : sv_input_shift = $signed({{8{in_to_iir_stage[DWIDTH-1]}}, in_to_iir_stage});
        // No default, all cases covered
      endcase // case ( pole_shift )
   end // always @ (*)




   // Input sum: both inputs DWIDTH+8 bits, no need to sign extend
   // computes x[n] * 2^-(p+1) + y[n-1] * (1 - 2^-(p+1))
   assign sv_input_sum = sv_input_shift + sv_fb_diff;




   // Successive requantize DWIDTH+3 down to DWIDTH bits (no saturation needed)
   // Does not change value since we have maintained the decimal place
   // We have truncated (drop) the 5 lsbs
     successive_requant #(.NBIT_IN(DWIDTH+3), .NBIT_OUT(DWIDTH)) requant_iir(
                 .in_clk(in_clk),
                 .in_rstb(in_rstb),
                 .i_ena(in_requantizer_ena_iir),
                 .vi_input_data(sv_input_sum[DWIDTH+7:5]),
                 .vi_rand(in_random_num),
                 .vo_requant_data(v_sum_requant)
                 );




   // Add a mux bypass path, which saves a full adder and barrel shifter
   assign out_of_iir_stage = ( in_ena_iir ) ? v_sum_requant : in_to_iir_stage;



   // Feedback path
   // computes y[n-1] * 2^-(p+1)
   always @(*) begin
      case ( in_param_pole_location_shift )
        0 : sv_fb_shift = $signed({{1{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,7'b0});
        1 : sv_fb_shift = $signed({{2{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,6'b0});
        2 : sv_fb_shift = $signed({{3{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,5'b0});
        3 : sv_fb_shift = $signed({{4{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,4'b0});
        4 : sv_fb_shift = $signed({{5{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,3'b0});
        5 : sv_fb_shift = $signed({{6{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,2'b0});
        6 : sv_fb_shift = $signed({{7{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg,1'b0});
        7 : sv_fb_shift = $signed({{8{sv_input_sum_reg[DWIDTH-1]}},sv_input_sum_reg});
        // no default
      endcase // case ( in_param_pole_location_shift )
   end





   // Take the feedback path difference
   // computes y[n-1] * (1 - 2^-(p+1))
   assign sv_fb_diff = $signed({sv_input_sum_reg,8'b0}) - sv_fb_shift;




   // Flip Flop
   always @(posedge in_clk or negedge in_rstb) begin

        if ( !in_rstb) begin

                sv_input_sum_reg <= 0;
        end else begin

                sv_input_sum_reg <= v_sum_requant;

        end

   end

endmodule
//Taken from Serenity DataBase
/*
 *
 * 
 * the P path varies between 2^7 and 2^-3,
 * the I path varies between 2^0 and 2^-15.
 *
 *
.
 *
 */

module pi_control_logic (
   out_pi_data,
   in_clk,
   in_rstb,
   in_ena_requantization,
   in_data,
   in_param_k_i,
   in_param_k_p,
   in_random_num
   );
   input              in_clk;
   input              in_rstb;

   input              in_ena_requantization;

   input [22:0]       in_data; // 
   input [3:0]        in_param_k_i;
   input [3:0]        in_param_k_p;
   input [10:0]       in_random_num; // 11 random bits
   output [14:0]      out_pi_data; // 
   wire [37:0]      v_to_regs; // 
   reg [37:0]       v_from_regs; // 



   // Proportional path (combinational to output)
   reg [32:0]         v_kp_shift;
   wire signed [32:0] sv_kp_shift; // 
   wire signed [25:0] sv_kp_sat; //
   // Integral path (stops at delaying integrator)
   reg [37:0]         v_ki_shift;
   wire signed [38:0] sv_int_sum;
   wire signed [37:0] sv_int_sat;
   // PI sum
   wire signed [26:0] sv_pi_sum; // 
   wire signed [15:0] sv_pi_quant; // 
   wire signed [14:0] sv_pi_sat; // 

   // Proportional path: shifts -3 to +7
   // Shifted data path is (13.NFRAC) signed
   // 0 corresponds to a left shift of 3 relative to decimal
   // 10 corresponds to a right shift of 7 relative to decimal
   always @(*) begin
      case( in_param_k_p )
        0  : v_kp_shift =  {{10{in_data[22]}}, in_data};
        1  : v_kp_shift =  {{9{in_data[22]}},  in_data, {(1){1'b0}}};
        2  : v_kp_shift =  {{8{in_data[22]}},  in_data, {(2){1'b0}}};
        3  : v_kp_shift =  {{7{in_data[22]}},  in_data, {(3){1'b0}}};
        4  : v_kp_shift =  {{6{in_data[22]}},  in_data, {(4){1'b0}}};
        5  : v_kp_shift =  {{5{in_data[22]}},  in_data, {(5){1'b0}}};
        6  : v_kp_shift =  {{4{in_data[22]}},  in_data, {(6){1'b0}}};
        7  : v_kp_shift =  {{3{in_data[22]}},  in_data, {(7){1'b0}}};
        8  : v_kp_shift =  {{2{in_data[22]}},  in_data, {(8){1'b0}}};
        9  : v_kp_shift =  {{1{in_data[22]}},  in_data, {(9){1'b0}}};
        10 : v_kp_shift =  {in_data, {(10){1'b0}}};
        default : v_kp_shift = {(33){1'bx}};
      endcase // case ( in_param_k_p )
   end // always @ begin
   assign sv_kp_shift = $signed(v_kp_shift);
   // Now saturate the shifted sum
   sat_signed_logic #(.NBIT_IN(33), .NBIT_OUT(26))
     sat_kp(.in_data(sv_kp_shift), .out_data_sat(sv_kp_sat));
   // Integrator path. Input is first shifted right between 0-15 places.
   // Shifter output is (7.31), that goes to the registers
   always @(*) begin
      case ( in_param_k_i )
        0  : v_ki_shift = {{15{in_data[22]}},  in_data};
        1  : v_ki_shift = {{14{in_data[22]}},  in_data, {1{1'b0}}};
        2  : v_ki_shift = {{13{in_data[22]}},  in_data, {2{1'b0}}};
        3  : v_ki_shift = {{12{in_data[22]}},  in_data, {3{1'b0}}};
        4  : v_ki_shift = {{11{in_data[22]}},  in_data, {4{1'b0}}};
        5  : v_ki_shift = {{10{in_data[22]}},  in_data, {5{1'b0}}};
        6  : v_ki_shift = {{9{in_data[22]}},  in_data, {6{1'b0}}};
        7  : v_ki_shift = {{8{in_data[22]}},  in_data, {7{1'b0}}};
        8  : v_ki_shift = {{7{in_data[22]}},  in_data, {8{1'b0}}};
        9  : v_ki_shift = {{6{in_data[22]}},  in_data, {9{1'b0}}};
        10 : v_ki_shift = {{5{in_data[22]}},  in_data, {10{1'b0}}};
        11 : v_ki_shift = {{4{in_data[22]}},  in_data, {11{1'b0}}};
        12 : v_ki_shift = {{3{in_data[22]}},  in_data, {12{1'b0}}};
        13 : v_ki_shift = {{2{in_data[22]}},  in_data, {13{1'b0}}};
        14 : v_ki_shift = {{1{in_data[22]}},  in_data, {14{1'b0}}};
        15 : v_ki_shift = {in_data, {15{1'b0}}};
        // No default case: complete coverage
      endcase // case ( in_param_k_i )
   end // always @ begin
   // Compute the integrating sum, signed variables
   assign sv_int_sum = $signed({v_ki_shift[37], v_ki_shift})
                     + $signed({v_from_regs[37], v_from_regs});
   sat_signed_logic #(.NBIT_IN(39), .NBIT_OUT(38))
     sat_int(.in_data(sv_int_sum), .out_data_sat(sv_int_sat));
   // Send the sum to the delaying integrator register
   assign v_to_regs = $unsigned(sv_int_sat);
   // Sum the proportional and integral paths (8.19)
   // Use only 19 most fractional bits of integral path
   assign sv_pi_sum = $signed({sv_kp_sat[25], sv_kp_sat})
                    + $signed({v_from_regs[37], v_from_regs[37:12]});
   // Requantize this to 8 fractional bits (19 -> 8 fractional)
   successive_requant #(.NBIT_IN(27), .NBIT_OUT(16))
     requant_pi(.in_clk(in_clk), .in_rstb(in_rstb), .i_ena(in_ena_requantization),
                .vi_input_data(sv_pi_sum), .vi_rand(in_random_num),
                .vo_requant_data(sv_pi_quant));
   // Saturate the sum
   sat_signed_logic #(.NBIT_IN(16), .NBIT_OUT(15))
     sat_pi(.in_data(sv_pi_quant), .out_data_sat(sv_pi_sat));
   // Assign upper (7.8) to FCEs
   assign out_pi_data = $unsigned(sv_pi_sat);


   always @(posedge in_clk or negedge in_rstb) begin

        if ( !in_rstb ) begin

                v_from_regs <= 38'b00000000000000000000000000000000000000;

        end else begin

                v_from_regs <= v_to_regs;

        end

   end



endmodule
module comb_logic (
        in_1,
        in_2,
        in_3,
        out
        );

input in_1, in_2, in_3;
output out;

wire or_out;

assign or_out = in_1 || in_2;
assign out = ~(or_out && in_3);

endmodule
//Based on Serenity DataBase       Edited by: julianpuscar@gmail.com     jpuscar@eng.ucsd.edu
/*
 Block div_ctrl : provides the control signal to the
                  prescaler indicating a 8 or 9 division. It also
                  counts how many times the prescaler is going to divide
                  to reach to the final divider modulus. e.g 9(4) + 8(6) = 84

 This block works with the in_clk=clk_rdiv, which is the PLL clock divided by 8 or 9.
 The output signal out_div_by_8_or_9_sel goes to the Prescaler control.     = 1 --> it divides by 9     = 0 --> it divides by 8

 The block count 9 edges X times, then it swithes to count 8 edges Y times. It can cover the following counts of edges (frequency divisions) (9*X + 8*Y):
 8,9   16,17,18   24,25,26,27    32,33,34,35,36    40,41,42,43,44,45    48,49,50,51,52,53,54   56,57,58,59,60,61,62,63,64,.....

 The PLL needs to cover (N+alpha)*f_ref from 1.3GHz to 3GHz  --> 26MHz*50 = 1.3 GHz
--> But there would be a gap at    26MHz*55 = 1.43 GHz   (but this is covered by changing alpha)


 We would like to previously load the divider modulus before clk_rdiv comes, therefore: we create a fake clock to do it.

The output signal that controls the prescale block comes 1 cycle before the last
 count of divide-by-8 (later on we have to add this extra cycle to the divider output)

Issue with existing divider control:
	y[n-1] is used to calculate the module of the divider (it should be y[n]). This delay adds a z^-1 factor to the DSM-FDC loop.
Solution:
	y[n]=0 or 1. So the divider divides by N or N-1.
Therefore, the divider always counts to N-9. Then it reads y[n] (by this time y[n] is ready, so it is no longer y[n-1]), and it decides if there should count an additional 9 or 8. 

*/

module div_ctrl (
        in_div_modulus,
        in_clk,
        in_rstb,
	in_y_of_n,
        out_div_by_8_or_9_sel,
        out_div_edge_ready
        );


input [7:0] in_div_modulus;
input in_clk;
input in_rstb;
input in_y_of_n;

output out_div_by_8_or_9_sel;
output out_div_edge_ready;

reg still_counting_to_N_minus_9;
reg out_div_by_8_or_9_sel;
reg out_div_edge_ready;
reg [2:0] num_of_times_to_divide_by_9;
reg [4:0] num_of_times_to_divide_by_8;

wire clk_fake;
wire clk_fake_gated;
reg [2:0] pre_loaded_num_of_times_to_divide_by_9;
reg [4:0] pre_loaded_num_of_times_to_divide_by_8;


always @(posedge in_clk or negedge in_rstb) begin


        if ( !in_rstb ) begin
                out_div_by_8_or_9_sel <=  0;
                out_div_edge_ready <= 0;

                //Initialize: coming out of reset: it immediately loads the divider
                num_of_times_to_divide_by_9 <= 1;
                num_of_times_to_divide_by_8 <= 0;

        end else begin


                // Assume we are not in the last period
                out_div_edge_ready <= 0;

                // Determine place in the state machine
                if ( (1 == num_of_times_to_divide_by_9)&&(0 == num_of_times_to_divide_by_8)) begin
                        // One divide by 9 and Zero divide by 8
                        out_div_by_8_or_9_sel <=  1;
                        // This is the last period
                        out_div_edge_ready <= 1;
                        // Load in the next count values
                        num_of_times_to_divide_by_9 <= pre_loaded_num_of_times_to_divide_by_9;
                        num_of_times_to_divide_by_8 <= pre_loaded_num_of_times_to_divide_by_8;
                end

                else if ( 0 < num_of_times_to_divide_by_9 ) begin
                        // There are still more divide-by-9 and at least 1 divide-by-8
                        out_div_by_8_or_9_sel <=  1;
                        num_of_times_to_divide_by_9 <= num_of_times_to_divide_by_9 - 1;
                end

                else if ( 0 == num_of_times_to_divide_by_9 ) begin
                        // End of count divide-by-9. Start to count divide-by-8
                        out_div_by_8_or_9_sel <=  0;
                        // Determine how many more divide-by-8 there are

                        if (1 == num_of_times_to_divide_by_8) begin
                                // Last Period
                                out_div_edge_ready <= 1;
                                // Load in the next count values
                                num_of_times_to_divide_by_9 <= pre_loaded_num_of_times_to_divide_by_9;
                                num_of_times_to_divide_by_8 <= pre_loaded_num_of_times_to_divide_by_8;
                        end else begin
                                // Otherwise: there are multiple divide-by-8 to count
                                num_of_times_to_divide_by_8 <= num_of_times_to_divide_by_8 - 1;
                        end

                end // ( 0 == num_of_times_to_divide_by_9 )


        end // !if ( !rstb )

end  // always




// Let's create a fake clock to load the "num_of_times_to_divide_by_8" and "num_of_times_to_divide_by_9"
// one cycle before it is actually latched on clk_rdiv

assign clk_fake = ((1 == num_of_times_to_divide_by_9) && (0 == num_of_times_to_divide_by_8)) || ((0 == num_of_times_to_divide_by_9) && (1 == num_of_times_to_divide_by_8));
assign clk_fake_gated = clk_fake && in_clk;

/*always @(posedge clk_fake_gated or negedge in_rstb) begin
if ( !in_rstb ) begin
                pre_loaded_num_of_times_to_divide_by_9 <= 0;
                pre_loaded_num_of_times_to_divide_by_8 <= 0;
		still_counting_to_N_minus_9 <= 0;
	end else if (still_counting_to_N_minus_9 == 0) begin
		pre_loaded_num_of_times_to_divide_by_9 <= in_div_modulus[2:0];
                pre_loaded_num_of_times_to_divide_by_8 <= in_div_modulus[7:3] - in_div_modulus[2:0];
		still_counting_to_N_minus_9  <= 1;
        end else if (in_y_of_n == 1) begin
		pre_loaded_num_of_times_to_divide_by_9 <= 0;
                pre_loaded_num_of_times_to_divide_by_8 <= 1;
		still_counting_to_N_minus_9  <= 0;
	end else begin
		pre_loaded_num_of_times_to_divide_by_9 <= 1;
                pre_loaded_num_of_times_to_divide_by_8 <= 0;
		still_counting_to_N_minus_9  <= 0;
	end
end*/	

always @(posedge in_clk or negedge in_rstb) begin
if ( !in_rstb ) begin
                pre_loaded_num_of_times_to_divide_by_9 <= 0;
                pre_loaded_num_of_times_to_divide_by_8 <= 0;
		still_counting_to_N_minus_9 <= 0;
	end else if (still_counting_to_N_minus_9 == 0 && clk_fake==1) begin
		pre_loaded_num_of_times_to_divide_by_9 <= in_div_modulus[2:0];
                pre_loaded_num_of_times_to_divide_by_8 <= in_div_modulus[7:3] - in_div_modulus[2:0];
		still_counting_to_N_minus_9  <= 1;
        end else if (in_y_of_n == 1 && still_counting_to_N_minus_9 == 1 && clk_fake==1) begin
		pre_loaded_num_of_times_to_divide_by_9 <= 0;
                pre_loaded_num_of_times_to_divide_by_8 <= 1;
		still_counting_to_N_minus_9  <= 0;
	end else if (in_y_of_n == 0 && still_counting_to_N_minus_9 == 1 && clk_fake==1) begin
		pre_loaded_num_of_times_to_divide_by_9 <= 1;
                pre_loaded_num_of_times_to_divide_by_8 <= 0;
		still_counting_to_N_minus_9  <= 0;
	end
end



endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*

                        clk_rdiv
          ________________________________________________________________________> out_clk_rdiv
          |                                                       |
          |                                   ________________    |
          |                    clk_pll-----> |                |   |    ________
          |     _______                      |   Prescaler    |   |   |       |
          |--> |       | prescale_ctrl_sig   |      8/9       |-----> |       |
               | Div   |-------------------> |________________|       | Pulse |----> out_clk
               | Ctrl  |                                              | Selec |
     --------> | Logic |--------------------------------------------> |       |
   div_modulus |_______|           div_edge_ready                     |_______|




 The divider consist of 3 main blocks

 Block #1: prescaler_8_or_9 : takes the PLL output frequency and
           divides it by 8 or 9 depending on a control signal

 Block #2: div_ctrl : provides the control signal to the
           prescaler indicating a 8 or 9 division. It also
           counts how many times the prescaler is going to divide
           to reach to the final divider modulus. e.g 9(4) + 8(6) = 84

 Block #3: pulse_selector : takes the prescaler_8_or_9 output, but
           filters out all the pulses that don't correspond to the final
           modulus count. e.g: only prints the prescaler output of 84
*/
module div_top (
        in_rstb,
        in_clk_pll,
        in_div_modulus,
	in_y_of_n,
        in_param_sel_width_of_vdiv,
	in_param_sel_width_of_rst,
        out_clk,
        out_clk_rdiv
        );

input in_y_of_n;
input in_rstb, in_clk_pll;
input [7:0] in_div_modulus;
input [1:0] in_param_sel_width_of_vdiv;
input [1:0] in_param_sel_width_of_rst;


output out_clk;
output out_clk_rdiv;

wire prescale_ctrl_signal;
wire div_edge_ready;
wire thin_div_out;

div_ctrl div_ctrl (
        .in_div_modulus(in_div_modulus),
        .in_clk(out_clk_rdiv),
        .in_rstb(in_rstb),
	.in_y_of_n(in_y_of_n),
        .out_div_by_8_or_9_sel(prescale_ctrl_signal),
        .out_div_edge_ready(div_edge_ready)
        );


prescaler prescaler_8_or_9 (
        .in_rstb(in_rstb),
        .in_clk(in_clk_pll),
        .in_div_ctrl(prescale_ctrl_signal),
        .out_clk(out_clk_rdiv)
        );


pulse_selector pulse_selector (
        .in_rstb(in_rstb),
        .in_div_edge_ready(div_edge_ready),
        .in_clk_rdiv(out_clk_rdiv),
        .out_clk(thin_div_out)
        );


pulse_strecher pulse_strecher (
        .in_rstb(in_rstb),
        .in_thin_div_out(thin_div_out),
        .in_param_sel_width_of_vdiv(in_param_sel_width_of_vdiv),
	.in_param_sel_width_of_rst(in_param_sel_width_of_rst),
        .in_clk_pll_gated(in_clk_pll),
        .out_wide_div_out(out_clk)
        );

endmodule
// Block prescaler_8_or_9 : takes the PLL output frequency and
//                          divides it by 8 or 9 depending on a control signal
//
// When the signal in_div_ctrl=1 it adds one extra cycle delay to
// to the path and it divides by 9. If =0 it divides the PLL frequency by 8.

module prescaler (
        in_rstb,
        in_clk,
        in_div_ctrl,
        out_clk
        );


input in_rstb;
input in_clk, in_div_ctrl;
output out_clk;

wire flip_flop1_out;
wire flip_flop2_out;
wire flip_flop3_out;
wire out_clk; // = flip_flop4_out

wire nand_out;
wire flip_flop1_inp;
wire flip_flop2_inp;
wire flip_flop3_inp;

assign flip_flop2_inp = ~flip_flop2_out;
assign flip_flop3_inp = ~flip_flop3_out;

nand3_logic nand3_logic (
        .in_1(in_div_ctrl),
        .in_2(1'b1), //flip_flop1_out
        .in_3(out_clk),
        .out(nand_out)
        );


comb_logic comb_logic (
        .in_1(nand_out),
        .in_2(flip_flop3_out),
        .in_3(flip_flop1_out),
        .out(flip_flop1_inp)
        );


register_div_by_2 Flip_Flop_1 (
        .in_D(flip_flop1_inp),
        .in_rstb(in_rstb),
        .in_clk(in_clk),
        .out_Q(flip_flop1_out)
        );

register_div_by_2 Flip_Flop_2 (
        .in_D(flip_flop2_inp),
        .in_rstb(in_rstb),
        .in_clk(flip_flop1_out),
        .out_Q(flip_flop2_out)
        );

register_div_by_2 Flip_Flop3 (
        .in_D(flip_flop3_inp),
        .in_rstb(in_rstb),
        .in_clk(flip_flop2_out),
        .out_Q(flip_flop3_out)
        );


register_div_by_2 Flip_Flop4 (
        .in_D(flip_flop3_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk),
        .out_Q(out_clk)
        );

endmodule
// Block pulse_selector : takes the prescaler_8_or_9 output, but
//                        filters out all the pulses that don't correspond to the final
//                        modulus count. e.g: only prints the prescaler output of 84
//
// the output of the divider is not "clk_rdiv" (% 8 or 9)
// the clk_rdiv is enable to be the output of the divider every time
// the signal "div_edge_ready" is high, indicating that the counter of
// 9*X + 8*Y is done
//
// Why can't you take in_div_edge_ready to simply be the output of this block?
// Because in_div_edge_ready was set to go high 1 cycle before it ends the last
// count of divide-by-8. So we need to delay in_div_edge_ready by 1 cycle.
// Why can't the state-machine in div_ctrl make the in_div_edge_ready go high
// in the very first divide_by_9 count? Because then the state machine will have
// to make some calculations, that would take time and the signal wouldn't be accurate.

module pulse_selector (
        in_rstb,
        in_div_edge_ready,
        in_clk_rdiv,
        out_clk
        );


input in_rstb;
input in_div_edge_ready, in_clk_rdiv;

output out_clk;

wire clock_reg;
reg and_inp_1;

assign clock_reg = ~(in_clk_rdiv);

always @(posedge clock_reg or negedge in_rstb) begin
        if ( !in_rstb ) begin
                and_inp_1 <= 0;
        end else begin
                and_inp_1 <= in_div_edge_ready;
        end
end

assign out_clk = (and_inp_1 && in_clk_rdiv);

endmodule
module pulse_strecher (
        in_rstb,
        in_thin_div_out,
        in_param_sel_width_of_vdiv,
	in_param_sel_width_of_rst,
        in_clk_pll_gated,
        out_wide_div_out
        );

input in_rstb;
input in_thin_div_out, in_clk_pll_gated;
input [1:0] in_param_sel_width_of_vdiv;
input [1:0] in_param_sel_width_of_rst;

output out_wide_div_out;
reg out_wide_div_out;

wire flip_flop1_inp, flip_flop2_inp, flip_flop3_inp, flip_flop4_inp, flip_flop5_inp, flip_flop6_inp;
wire flip_flop1_out, flip_flop2_out,flip_flop3_out ,flip_flop4_out, flip_flop5_out, flip_flop6_out;

wire flip_flop6_out_last, flip_flop5_out_last, flip_flop7_out_last;

reg feedback_register;

wire clkb_delay;
wire start_clock;
wire nand_2_inp2;
wire rstb_int;
wire and_2_inp2;

wire dly_1;
wire dly_2;
wire dly_3;
wire dly_4;
wire delay_clk_pll_gated;

wire pre_rstb_int;
wire wire_rstb_int_dly_1, wire_rstb_int_dly_2, stb_int_dly_1, rstb_int_dly_2,rstb_int_n2, rstb_int_n3;


delaying_buffer delaying_buffer1 (
        .in(in_clk_pll_gated),
        .out(dly_1)
        );

delaying_buffer delaying_buffer2 (
        .in(dly_1),
       .out(dly_2)
        );

delaying_buffer delaying_buffer3 (
        .in(dly_2),
        .out(dly_3)
        );

delaying_buffer delaying_buffer4 (
        .in(dly_3),
        .out(dly_4)
        );

delaying_buffer delaying_buffer5 (
        .in(dly_4),
        .out(delay_clk_pll_gated)
        );



and2_logic and2_n1 (
        .in_1(in_thin_div_out),
        .in_2(delay_clk_pll_gated),
        .out(start_clock)
        );

and2_logic and2_n2 (
        .in_1(in_rstb),
        .in_2(and_2_inp2),
        .out(pre_rstb_int)
        );

nand2_logic nand2_n1 (
        .in_1(out_wide_div_out),
        .in_2(nand_2_inp2),
        .out(clkb_delay)
        );



assign flip_flop1_inp = ~flip_flop1_out;
assign flip_flop2_inp = ~flip_flop2_out;
assign flip_flop3_inp = ~flip_flop3_out;
assign flip_flop4_inp = ~flip_flop4_out;
assign flip_flop5_inp = ~flip_flop5_out;
assign flip_flop6_inp = ~flip_flop6_out;


assign and_2_inp2 = ~feedback_register;


inv_logic inv_n1 (
        .in(delay_clk_pll_gated),
        .out(nand_2_inp2)
        );



register_div_by_2 Flip_Flop_1 (
        .in_D(flip_flop1_inp),
        .in_rstb(rstb_int),
        .in_clk(clkb_delay),
        .out_Q(flip_flop1_out)
        );

register_div_by_2 Flip_Flop_2 (
        .in_D(flip_flop2_inp),
        .in_rstb(rstb_int),
        .in_clk(flip_flop1_inp),
        .out_Q(flip_flop2_out)
        );

register_div_by_2 Flip_Flop_3 (
        .in_D(flip_flop3_inp),
        .in_rstb(rstb_int),
        .in_clk(flip_flop2_inp),
        .out_Q(flip_flop3_out)
        );

register_div_by_2 Flip_Flop_4 (
        .in_D(flip_flop4_inp),
        .in_rstb(rstb_int),
        .in_clk(flip_flop3_inp),
        .out_Q(flip_flop4_out)
        );

register_div_by_2 Flip_Flop_5 (
        .in_D(flip_flop5_inp),
        .in_rstb(rstb_int),
        .in_clk(flip_flop4_inp),
        .out_Q(flip_flop5_out)
        );

register_div_by_2 Flip_Flop_6 (
        .in_D(flip_flop6_inp),
        .in_rstb(rstb_int),
        .in_clk(flip_flop5_inp),
        .out_Q(flip_flop6_out)
        );


//last_stage
register_div_by_2 Flip_Flop_7_last (
        .in_D(1'b1),
        .in_rstb(rstb_int),
        .in_clk(flip_flop6_inp),
        .out_Q(flip_flop7_out_last)
        );

register_div_by_2 Flip_Flop_6_last (
        .in_D(1'b1),
        .in_rstb(rstb_int),
        .in_clk(flip_flop5_inp),
        .out_Q(flip_flop6_out_last)
        );

register_div_by_2 Flip_Flop_5_last (
        .in_D(1'b1),
        .in_rstb(rstb_int),
        .in_clk(flip_flop4_inp),
        .out_Q(flip_flop5_out_last)
        );


   // Assign feedback register
   always @(*) begin
      case ( in_param_sel_width_of_vdiv )
        0 : feedback_register = flip_flop7_out_last;
        1 : feedback_register = flip_flop6_out_last;
        2 : feedback_register = flip_flop5_out_last;
        default : feedback_register = 1'bx;
      endcase // case ( feedback register )
   end




sel_rst_signal sel_rst_signal (
	.pre_rstb_int(pre_rstb_int),
	.in_param_sel_width_of_rst(in_param_sel_width_of_rst),
	.rstb_int(rstb_int)
	);


		
register_div_by_2 output_resgister (
        .in_D(1'b1),
        .in_rstb(rstb_int),
        .in_clk(start_clock),
        .out_Q(out_wide_div_out)
        );      

endmodule
module sel_rst_signal (
	pre_rstb_int,
	in_param_sel_width_of_rst,
	rstb_int
	);

input pre_rstb_int;
input [1:0] in_param_sel_width_of_rst;
output rstb_int;

wire wire_rstb_int_dly_1, wire_rstb_int_dly_2, rstb_int_n2, rstb_int_n3;

small_delaying_buffer DLY_rst_n1(
        .in(pre_rstb_int),
        .out(wire_rstb_int_dly_1)
        );

small_delaying_buffer DLY_rst_n2(
        .in(wire_rstb_int_dly_1),
        .out(wire_rstb_int_dly_2)
        );	
	
and2_logic AND_rst_n1(
        .in_1(pre_rstb_int),
        .in_2(wire_rstb_int_dly_1),
	.out(rstb_int_n2)
	);
	
and3_logic AND_rst_n2(
        .in_1(pre_rstb_int),
        .in_2(wire_rstb_int_dly_1),
	.in_3(wire_rstb_int_dly_2),
	.out(rstb_int_n3)
	);
	
mux_3_logic mux_logic(
        .in_sel(in_param_sel_width_of_rst),
        .in_1(pre_rstb_int),
        .in_2(rstb_int_n2),
	.in_3(rstb_int_n3),
        .out(rstb_int)
        );
	
	
endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*
               Flip Flop
                ______
               |      |                   1 bit
  -------------|D    Q|-----------------------------------------------> y[n]
 |             |      |                       |
 | clk_ref-----|>CLK  |                       |
 |             |______|                   ____|____
 |                                       |Div Modul|
 |                                       |  Calc   |
 |                                       |_________|
 |                                            |
 |                                            | div_modulus[7:0]
 |                                  __________|_________
 |                                 |                    |
 |_________________________________|    DIVIDER TOP     |<-------- clk_pll
                                   |                    |
                                   |____________________|



*/



module fdc_top (
        in_rstb,
        in_clk_ref,
        in_clk_pll,
        in_param_N,
        in_param_sel_width_of_vdiv,
	in_param_sel_width_of_rst,
        out_y_of_n,
        out_clk_rdiv
        );


input in_rstb;
input in_clk_ref, in_clk_pll;
input [7:0] in_param_N;
input [1:0] in_param_sel_width_of_vdiv;
input [1:0] in_param_sel_width_of_rst;

output out_y_of_n;
output out_clk_rdiv;

wire clk_div;
wire [7:0] div_modulus;

div_top div_top (
        .in_rstb(in_rstb),
        .in_clk_pll(in_clk_pll),
        .in_div_modulus(div_modulus),
	.in_y_of_n(out_y_of_n),
        .in_param_sel_width_of_vdiv(in_param_sel_width_of_vdiv),
	.in_param_sel_width_of_rst(in_param_sel_width_of_rst),
        .out_clk(clk_div),
        .out_clk_rdiv(out_clk_rdiv)
        );


flip_flop flip_flop (
        .in_rstb(in_rstb),
        .in_clk_ref(in_clk_ref),
        .in_clk_div(clk_div),
        .out_y_of_n(out_y_of_n)
        );


modulus_calc modulus_calc (
        .in_param_N(in_param_N),
        .out_modulus_div(div_modulus)
        );

endmodule
module flip_flop (
        in_rstb,
        in_clk_ref,
        in_clk_div,
        out_y_of_n
        );

input in_rstb;
input in_clk_ref, in_clk_div;

output out_y_of_n;
reg reg_y_of_n;


always @(posedge in_clk_ref or negedge in_rstb) begin

        if ( !in_rstb ) begin
                reg_y_of_n <= 1'b0;
        end else begin
                reg_y_of_n <= in_clk_div;
        end

end

assign out_y_of_n = reg_y_of_n;

endmodule
module modulus_calc (
        in_param_N,
        out_modulus_div
        );

input [7:0] in_param_N;

output [7:0] out_modulus_div;

wire signed [7:0] wire_modulus_div;

assign wire_modulus_div = $signed(in_param_N) - 9;
assign out_modulus_div = wire_modulus_div;


endmodule
/*
 * 25-b LFSR for frac DSM and DEM logic. Registers are self-contained,
 * as per convention in clk_r domain blocks.
 */


module lfsr_25b (
   out_dsm_rand,
   out_dem_rand,
   in_clk,
   in_rstb,
   in_rand_ena_dsm,
   in_rand_ena_dem
   );
   // Inputs
   input        in_clk, in_rstb;
   // Enables
   input        in_rand_ena_dsm;
   input        in_rand_ena_dem;
   // Outputs
   output       out_dsm_rand;
   output [2:0] out_dem_rand;

   reg [24:0]   v_x;
   wire [2:0]   v_xor_out;

   // xor gates
   assign v_xor_out = v_x[2:0] ^ v_x[5:3];
   // flops
   always @( posedge in_clk or negedge in_rstb ) begin
      if ( !in_rstb ) begin
         // Note one bit must be set high
         v_x[0] <= 1'b1;
         v_x[24:1] <= 24'b0;
      end
      else begin
         v_x[0] <= v_x[3];
         v_x[21:1] <= v_x[24:4];
         v_x[24:22] <= v_xor_out;
      end
   end // always @ ( posedge in_clk or negedge in_rstb )
   // Assign outputs
   assign out_dsm_rand = ( in_rand_ena_dsm ) ? v_x[24] : 1'b0;
 assign out_dem_rand = ( in_rand_ena_dem ) ? v_x[23:21] : 2'b0;

endmodule
/* Taken from Serenity DataBase
Explanation by Julian Puscar     jpuscar@eng.ucsd.edu   julianpuscar@gmail.com

LFSR acts like a counter.
But it counts in DISorder.

We need a way to make sure the counter goes through
all possible states.

A simple way to do this is to implemenet a shift
register, with a XOR at the input that takes
the output of the last and the previous-last stages
as its inputs.
(Depending on the number of stages you may need more
that just 1 XOR)
--> the simples design has the minimum amount of XOR
        ---> 31 stages (registers) results in a simple design


---> XOR ---> Stage 1 ---> Stage 2 ---> Stage 3 ---> ....

The output of each stage is withe.
But output of stage 1 is correlated to output of stage 2 or 3 or ...

If we want 10 random bits (uncorrelated between them), we can clock
the Shift Register State Machine 10 times, and get then different states.
So  out_stage_1[n] , out_stage_1[n+1], ..., out_stage_1[n+9]
would be the 10 random bits we needed.

But this means that the LFSR requieres:
        1. To be run at a higher speed.
        2. The amount of time that takes the disorder "count"
           to be complete is now less.

In order to avoid this: we modify the stage machine,
such that with each clock period, the state machine
advances 10 states. (Now out_stage_1[n], out_stage_2[n],
... out_stage_10[n] are uncorrealted)


*/
module lfsr_31b (
   out_pi_rand,
   out_rand_iir0,
   out_rand_iir1,
   out_rand_iir2,
   out_rand_iir3,
   in_clk,
   in_rstb,
   in_ena_rand_pi,
   in_ena_rand_iir0,
   in_ena_rand_iir1,
   in_ena_rand_iir2,
   in_ena_rand_iir3
   );
   // Clocks
   input         in_clk;
   input         in_rstb;
   // Enable signals
   input         in_ena_rand_pi;
   input         in_ena_rand_iir0;
   input         in_ena_rand_iir1;
   input         in_ena_rand_iir2;
   input         in_ena_rand_iir3;

   // Output signals
   output [10:0] out_pi_rand;
   output [2:0]  out_rand_iir0;
   output [2:0]  out_rand_iir1;
   output [2:0]  out_rand_iir2;
   output [2:0]  out_rand_iir3;
   // ... add other outputs here ... but no more!

   // Registers
   reg [30:0]    v_reg;

   // Intermediate signals
   wire [23:0]   v_xor;

   // Assign bits to output
   // bit [10:0] : 11 bit
   assign out_pi_rand = ( in_ena_rand_pi ) ? v_reg[10:0] : 11'b0;
   // bit [13:11] : 3 bits
   assign out_rand_iir0 = ( in_ena_rand_iir0 ) ? v_reg[13:11] : 2'b0;
   // bit [16:14] : 3 bits
   assign out_rand_iir1 = ( in_ena_rand_iir1 ) ? v_reg[16:14] : 2'b0;
   // bit [19:17] : 3 bits
   assign out_rand_iir2 = ( in_ena_rand_iir2 ) ? v_reg[19:17] : 2'b0;
   // bit [22:20] : 3 bits
   assign out_rand_iir3 = ( in_ena_rand_iir3 ) ? v_reg[22:20] : 2'b0;


   // 24 XOR gates
   assign v_xor = v_reg[23:0] ^ v_reg[26:3];
   // Register
   always @( posedge in_clk or negedge in_rstb ) begin
      if ( !in_rstb ) begin
         // First flop set high
         v_reg[0] <= 1'b1;
         // All the others reset low
         v_reg[30:1] <= 30'b0;
      end
      else
        v_reg <= {v_xor,v_reg[30:24]};
   end
endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*






                                                                            _________________                         _______                        _______
                                            _________        y_[n]         |                 |      p[n]             |       |                      |       |
                                           |         |-------------------> | Alpha and Accum |---------------------> |  DLC  | -------------------> |  DCO  |---------------> clk_pll
                        clk_ref ---------> |         |                     |_________________|                       |_______|                      |_______|      |
                                   |       |         |                                      ^                           ^ ^                             ^  ^       |    
                                   |       |         |                                      |                           | |                             |  |       |
                                   |       |   FDC   |<------------------------------------------------------------------------------------------------------------|
                                   |       |         |                                      |                           | |                             |  |
                                   |       |         |                  clk_alpha_and_accum |                           | |                             |  |
                                   |       |         |               _____________________  |                   clk_dlc | |             clk_fce/clk_dco |  |            
                                   |       |         |              |                     | |                           | |                             |  |
                                   |       |         |------------> |     Timing Ctrl     |--------------------------------------------------------------  |            
                                   |       |_________|  clk_rdiv    |_____________________|     |                         |                                |
                                   |                                  ^                         |                         |                                |
                                   |__________________________________|                         |      ______             |                                |            
                                                                                                |     |      |            |                                |
                                                                                                |---> | LFSR |---------------------------------------------
                                                                                                      |______|   rand_bits





                                          ^                  ^                  ^                  ^                  ^                  ^
                                          |                  |                  |                  |                  |                  |
                        ______________________________________________________________________________________________________________________________________________
                       |                                                                                                                                              |
                       |                                                                      SPI                                                                     |
                       |______________________________________________________________________________________________________________________________________________| 




*/



module pll_loop (
        in_rstb,
        in_clk_ref,
        in_param_N,
        in_param_alpha,
        in_param_sel_width_of_vdiv,
	in_param_sel_width_of_rst,
	in_param_sel_time_ctrl_clk_alpha_and_accum,
	in_param_sel_time_ctrl_clk_dlc,
	in_param_sel_time_ctrl_clk_dco_drift,
	in_param_sel_time_ctrl_clk_fce,
	in_param_sel_time_ctrl_clk_dco,
	in_param_enable_clk_fce,
	in_param_external_clk_fce,
	in_param_enable_clk_additional_fce,
	in_param_external_clk_additional_fce,
        in_param_dlc_gain_sel,
        in_param_pole_location_shift_IIR_0,
        in_param_pole_location_shift_IIR_1,
        in_param_pole_location_shift_IIR_2,
        in_param_pole_location_shift_IIR_3,
        in_param_ena_IIR_0,
        in_param_ena_IIR_1,
        in_param_ena_IIR_2,
        in_param_ena_IIR_3,
        in_param_ena_requantizer_IIR_0,
        in_param_ena_requantizer_IIR_1,
        in_param_ena_requantizer_IIR_2,
        in_param_ena_requantizer_IIR_3,
        in_param_k_p,
        in_param_k_i,
        in_param_ena_pi_requant,
        in_param_ena_rand_pi,
        in_param_ena_rand_iir0,
        in_param_ena_rand_iir1,
        in_param_ena_rand_iir2,
        in_param_ena_rand_iir3,
        in_param_ena_rand_dsm,
        in_param_ena_rand_dem,
        in_param_ena_free_running_DCO_int_part,
        in_param_ena_free_running_DCO_frac_part,
        in_param_spi_to_fce_int_part,
        in_param_spi_to_fce_frac_part,
	in_param_ena_dco_drift,
	in_param_enable_n1,
	in_param_enable_n2,
	in_param_enable_n3,
	in_param_enable_n4,
	in_param_enable_n5,
	in_param_enable_n6,
	in_param_enable_n7,
	in_param_enable_n8,
	in_param_enable_n9,
	in_param_enable_n10,
	in_param_enable_n11,
	in_param_enable_n12,
	in_param_enable_n13,
	in_param_enable_n14,
	in_param_enable_n15,
	in_param_enable_n16,
	in_param_sel_ring,
	in_param_sel_divider_modulus,
        in_param_sel_re_time_version,
	in_param_additional_freq_ctrl,
	in_param_read_p_of_n,
	in_param_read_iba_to_therm_enc,
	in_param_read_iba_to_dsm,
	in_param_read_y_of_n,
	out_to_spi_p_of_n,
	out_to_spi_iba_to_therm_encod,
	out_to_spi_iba_to_dsm,
	out_to_spi_y_of_n,
        out_clk
        );

parameter NFRAC = 16;
parameter NINT = 7; 

input in_rstb;
input in_clk_ref;
input [7:0] in_param_N;
input [NFRAC-1:0] in_param_alpha;
input [1:0] in_param_sel_width_of_vdiv;
input [1:0] in_param_sel_width_of_rst;
input [2:0] in_param_dlc_gain_sel;
input [2:0] in_param_pole_location_shift_IIR_0;
input [2:0] in_param_pole_location_shift_IIR_1;
input [2:0] in_param_pole_location_shift_IIR_2;
input [2:0] in_param_pole_location_shift_IIR_3;
input in_param_ena_IIR_0;
input in_param_ena_IIR_1;
input in_param_ena_IIR_2;
input in_param_ena_IIR_3;
input in_param_ena_requantizer_IIR_0;
input in_param_ena_requantizer_IIR_1;
input in_param_ena_requantizer_IIR_2;
input in_param_ena_requantizer_IIR_3;
input [3:0] in_param_k_p;
input [3:0] in_param_k_i;
input in_param_ena_pi_requant;
input in_param_ena_rand_pi;
input in_param_ena_rand_iir0;
input in_param_ena_rand_iir1;
input in_param_ena_rand_iir2;
input in_param_ena_rand_iir3;
input in_param_ena_rand_dsm;
input in_param_ena_rand_dem;
input [2:0] in_param_sel_time_ctrl_clk_alpha_and_accum;
input [2:0] in_param_sel_time_ctrl_clk_dlc;
input [2:0] in_param_sel_time_ctrl_clk_dco_drift;
input [2:0] in_param_sel_time_ctrl_clk_fce;
input [2:0] in_param_sel_time_ctrl_clk_dco;
input in_param_enable_clk_fce;
input in_param_external_clk_fce;
input in_param_enable_clk_additional_fce;
input in_param_external_clk_additional_fce;
input in_param_ena_free_running_DCO_int_part;
input in_param_ena_free_running_DCO_frac_part;
input [63:0] in_param_spi_to_fce_int_part;
input [7:0] in_param_spi_to_fce_frac_part;
input in_param_enable_n1;
input in_param_enable_n2;
input in_param_enable_n3;
input in_param_enable_n4;
input in_param_enable_n5;
input in_param_enable_n6;
input in_param_enable_n7;
input in_param_enable_n8;
input in_param_enable_n9;
input in_param_enable_n10;
input in_param_enable_n11;
input in_param_enable_n12;
input in_param_enable_n13;
input in_param_enable_n14;
input in_param_enable_n15;
input in_param_enable_n16;
input [3:0] in_param_sel_ring;
input [2:0] in_param_sel_divider_modulus;
input in_param_sel_re_time_version;
input in_param_ena_dco_drift;
input [5:0] in_param_additional_freq_ctrl;

input in_param_read_p_of_n;
input in_param_read_iba_to_therm_enc;
input in_param_read_iba_to_dsm;
input in_param_read_y_of_n;

output [23:0] out_to_spi_p_of_n;
output [7:0]  out_to_spi_iba_to_therm_encod;
output [15:0]  out_to_spi_iba_to_dsm;
output [7:0]  out_to_spi_y_of_n;

output out_clk;

wire ring_oscillator_out;
wire buf_wire;

wire [14:0] out_dlc;
wire [13:0] out_dco_drift;
wire [NINT+NFRAC-2:0] p_of_n;
wire y_of_n;
wire clk_alpha_and_accum;
wire clk_dlc;
wire clk_dco_drift;
wire clk_dco;
wire clk_fce;
wire clk_fast;
wire clk_additional_fce;

wire [5:0] iba_to_therm;
wire [8:0] iba_to_dsm;

wire [26:0] in_rand_num;

wire pll_clk;

wire [7:0] frac_FCEs_ctrl;
wire [63:0] int_FCEs_ctrl;

wire [36:0] additional_freq_ctrl;


testing_block testing_block (
	.in_rstb(in_rstb),
	.in_param_read_p_of_n(in_param_read_p_of_n),
	.in_param_read_iba_to_therm_enc(in_param_read_iba_to_therm_enc),
	.in_param_read_iba_to_dsm(in_param_read_iba_to_dsm),
	.in_param_read_y_of_n(in_param_read_y_of_n),
	.in_p_of_n(p_of_n),
	.in_iba_to_therm(iba_to_therm),
	.in_iba_to_dsm(iba_to_dsm),
	.in_y_of_n(y_of_n),
	.out_to_spi_p_of_n(out_to_spi_p_of_n),
	.out_to_spi_iba_to_therm_encod(out_to_spi_iba_to_therm_encod),
	.out_to_spi_iba_to_dsm(out_to_spi_iba_to_dsm),
	.out_to_spi_y_of_n(out_to_spi_y_of_n)
	);


fdc_top fdc_top (
        .in_rstb(in_rstb),
        .in_clk_ref(in_clk_ref),
        .in_clk_pll(pll_clk),
        .in_param_N(in_param_N),
        .in_param_sel_width_of_vdiv(in_param_sel_width_of_vdiv),
	.in_param_sel_width_of_rst(in_param_sel_width_of_rst),
        .out_y_of_n(y_of_n),
        .out_clk_rdiv(clk_fast)
        );


alpha_and_accum_top alpha_and_accum_top (
        .in_rstb(in_rstb),
        .in_y_of_n(y_of_n),
        .in_param_alpha(in_param_alpha),
	.in_param_ena_dco_drift(in_param_ena_dco_drift),
        .in_clk(clk_alpha_and_accum),
        .out_p_of_n(p_of_n)
        );


dlc_top dlc_top (
        .in_dlc(p_of_n),
        .in_clk(clk_dlc),
        .in_rstb(in_rstb),
        .in_param_dlc_gain_sel(in_param_dlc_gain_sel),
        .in_param_pole_location_shift_IIR_0(in_param_pole_location_shift_IIR_0),
        .in_param_pole_location_shift_IIR_1(in_param_pole_location_shift_IIR_1),
        .in_param_pole_location_shift_IIR_2(in_param_pole_location_shift_IIR_2),
        .in_param_pole_location_shift_IIR_3(in_param_pole_location_shift_IIR_3),
        .in_param_ena_IIR_0(in_param_ena_IIR_0),
        .in_param_ena_IIR_1(in_param_ena_IIR_1),
        .in_param_ena_IIR_2(in_param_ena_IIR_2),
        .in_param_ena_IIR_3(in_param_ena_IIR_3),
        .in_param_ena_requantizer_IIR_0(in_param_ena_requantizer_IIR_0),
        .in_param_ena_requantizer_IIR_1(in_param_ena_requantizer_IIR_1),
        .in_param_ena_requantizer_IIR_2(in_param_ena_requantizer_IIR_2),
        .in_param_ena_requantizer_IIR_3(in_param_ena_requantizer_IIR_3),
        .in_param_k_p(in_param_k_p),
        .in_param_k_i(in_param_k_i),
        .in_param_ena_pi_requant(in_param_ena_pi_requant),
        .in_rand_num(in_rand_num[22:0]),
        .out_dlc(out_dlc)
        );

dco_drift_compensator dco_drift_compensator(
	.in_dco_drift_comp(out_dlc),
	.in_rstb(in_rstb),
	.in_param_additional_freq_ctrl(in_param_additional_freq_ctrl),
	.in_param_ena_dco_drift(in_param_ena_dco_drift),
	.in_clk_dco_drift_comp(clk_dco_drift),
	.in_clk_additional_fce(clk_additional_fce),
	.out_additional_freq_ctrl(additional_freq_ctrl),
	.out_dco_drift(out_dco_drift)
	);


dco_top dco_top (
        .in_rstb(in_rstb),
        .in_clk_dco(clk_dco),
        .in_clk_fce(clk_fce),
        .in_dco(out_dco_drift),
        .in_random_bit(in_rand_num[26:23]),
        .in_param_ena_free_running_DCO_int_part(in_param_ena_free_running_DCO_int_part),
        .in_param_ena_free_running_DCO_frac_part(in_param_ena_free_running_DCO_frac_part),
        .in_param_spi_to_fce_int_part(in_param_spi_to_fce_int_part),
        .in_param_spi_to_fce_frac_part(in_param_spi_to_fce_frac_part),
	.out_iba_to_therm(iba_to_therm),
	.out_iba_to_dsm(iba_to_dsm),
        .out_frac_FCEs_ctrl(frac_FCEs_ctrl),
        .out_int_FCEs_ctrl(int_FCEs_ctrl)
        );




lfsr_31b lfsr_31b (
        .out_pi_rand(in_rand_num[22:12]),
        .out_rand_iir0(in_rand_num[2:0]),
        .out_rand_iir1(in_rand_num[5:3]),
        .out_rand_iir2(in_rand_num[8:6]),
        .out_rand_iir3(in_rand_num[11:9]),
        .in_clk(clk_alpha_and_accum),
        .in_rstb(in_rstb),
        .in_ena_rand_pi(in_param_ena_rand_pi),
        .in_ena_rand_iir0(in_param_ena_rand_iir0),
        .in_ena_rand_iir1(in_param_ena_rand_iir1),
        .in_ena_rand_iir2(in_param_ena_rand_iir2),
        .in_ena_rand_iir3(in_param_ena_rand_iir3)
        );


lfsr_25b lfsr_25b (
        .out_dsm_rand(in_rand_num[23]),
        .out_dem_rand(in_rand_num[26:24]),
        .in_clk(clk_alpha_and_accum),
        .in_rstb(in_rstb),
        .in_rand_ena_dsm(in_param_ena_rand_dsm),
        .in_rand_ena_dem(in_param_ena_rand_dem)
        );


timing_ctrl timing_ctrl (
        .in_rstb(in_rstb),
        .in_clk_ref(in_clk_ref),
        .in_clk_fast(clk_fast),
	.in_param_sel_time_ctrl_clk_alpha_and_accum(in_param_sel_time_ctrl_clk_alpha_and_accum),
	.in_param_sel_time_ctrl_clk_dlc(in_param_sel_time_ctrl_clk_dlc),
	.in_param_sel_time_ctrl_clk_dco_drift(in_param_sel_time_ctrl_clk_dco_drift),
	.in_param_sel_time_ctrl_clk_fce(in_param_sel_time_ctrl_clk_fce),
	.in_param_sel_time_ctrl_clk_dco(in_param_sel_time_ctrl_clk_dco),
	.in_param_enable_clk_fce(in_param_enable_clk_fce),
	.in_param_external_clk_fce(in_param_external_clk_fce),
	.in_param_enable_clk_additional_fce(in_param_enable_clk_additional_fce),
	.in_param_external_clk_additional_fce(in_param_external_clk_additional_fce),
        .out_clk_alpha_and_accum(clk_alpha_and_accum),
        .out_clk_dlc(clk_dlc),
	.out_clk_dco_drift(clk_dco_drift),
        .out_clk_dco(clk_dco),
        .out_clk_fce(clk_fce),
	.out_clk_additional_fce(clk_additional_fce)
        );
	

ring_oscillator_top ring_oscillator_top(
	.in_param_enable_n1(in_param_enable_n1),
	.in_param_enable_n2(in_param_enable_n2),
	.in_param_enable_n3(in_param_enable_n3),
	.in_param_enable_n4(in_param_enable_n4),
	.in_param_enable_n5(in_param_enable_n5),
	.in_param_enable_n6(in_param_enable_n6),
	.in_param_enable_n7(in_param_enable_n7),
	.in_param_enable_n8(in_param_enable_n8),
	.in_param_enable_n9(in_param_enable_n9),
	.in_param_enable_n10(in_param_enable_n10),
	.in_param_enable_n11(in_param_enable_n11),
	.in_param_enable_n12(in_param_enable_n12),
	.in_param_enable_n13(in_param_enable_n13),
	.in_param_enable_n14(in_param_enable_n14),
	.in_param_enable_n15(in_param_enable_n15),
	.in_param_enable_n16(in_param_enable_n16),
	.in_param_sel_ring(in_param_sel_ring),
	.in_param_sel_divider_modulus(in_param_sel_divider_modulus),
        .in_param_sel_re_time_version(in_param_sel_re_time_version),
        .in_rstb(in_rstb),
	.in_ctrl_FCE_integer(int_FCEs_ctrl),
	.in_ctrl_FCE_frac(frac_FCEs_ctrl),
	.in_param_FCE_additional_ctrl(additional_freq_ctrl),
	.out_pll_clk(pll_clk),
	.out_clk(out_clk)
	);


endmodule
module mux_sel_ring_oscillator (
	in_param_sel_ring,
	in_ring_n1,
	in_ring_n2,
	in_ring_n3,
	in_ring_n4,
	in_ring_n5,
	in_ring_n6,
	in_ring_n7,
	in_ring_n8,
	in_ring_n9,
	in_ring_n10,
	in_ring_n11,
	in_ring_n12,
	in_ring_n13,
	in_ring_n14,
	in_ring_n15,
	in_ring_n16,
	out
	);

input [3:0] in_param_sel_ring;
input in_ring_n1;
input in_ring_n2;
input in_ring_n3;
input in_ring_n4;
input in_ring_n5;
input in_ring_n6;
input in_ring_n7;
input in_ring_n8;
input in_ring_n9;
input in_ring_n10;
input in_ring_n11;
input in_ring_n12;
input in_ring_n13;
input in_ring_n14;
input in_ring_n15;
input in_ring_n16;

output out;

reg out;

always @(*) begin
	case( in_param_sel_ring )
	0  : out = in_ring_n1;
	1  : out = in_ring_n2;
	2  : out = in_ring_n3;
	3  : out = in_ring_n4;
	4  : out = in_ring_n5;
	5  : out = in_ring_n6;
	6  : out = in_ring_n7;
	7  : out = in_ring_n8;
	8  : out = in_ring_n9;
	9  : out = in_ring_n10;
	10  : out = in_ring_n11;
	11  : out = in_ring_n12;
	12  : out = in_ring_n13;
	13  : out = in_ring_n14;
	14  : out = in_ring_n15;
	15  : out = in_ring_n16;
	default : out = in_ring_n1;
	endcase
end

endmodule
module mux_sel_div_modulus_programmable_div (
	in_param_sel_divider_modulus,
	in_div_by_1,
	in_div_by_2,
	in_div_by_4,
	in_div_by_8,
	in_div_by_16,
	in_div_by_32,
	in_div_by_64,
	in_div_by_128,
	out
	);

input [2:0] in_param_sel_divider_modulus;
input in_div_by_1;
input in_div_by_2;
input in_div_by_4;
input in_div_by_8;
input in_div_by_16;
input in_div_by_32;
input in_div_by_64;
input in_div_by_128;

output out;

reg out;

always @(*) begin
	case( in_param_sel_divider_modulus )
	0  : out = in_div_by_1;
	1  : out = in_div_by_2;
	2  : out = in_div_by_4;
	3  : out = in_div_by_8;
	4  : out = in_div_by_16;
	5  : out = in_div_by_32;
	6  : out = in_div_by_64;
	7  : out = in_div_by_128;
	default : out = in_div_by_1;
	endcase
end

endmodule
module mux_sel_div_re_timed (
	in_param_sel_re_time_version,
	in_clk_1,
	in_clk_2,
	out
	);

input in_param_sel_re_time_version;
input in_clk_1;
input in_clk_2;

output out;

reg out;

always @(*) begin
	case( in_param_sel_re_time_version )
	0  : out = in_clk_1;
	1  : out = in_clk_2;
	default : out = in_clk_1;
	endcase
end

endmodule

module programmable_divider_output (
	in_pll_output,
	in_param_sel_divider_modulus,
	in_param_sel_re_time_version,
	in_rstb,
	out_clk
	);

input in_rstb;
input in_pll_output;
input [2:0] in_param_sel_divider_modulus;
input in_param_sel_re_time_version;
output out_clk;


wire FF_num_1_out;
wire FF_num_2_out;
wire FF_num_3_out;
wire FF_num_4_out;
wire FF_num_5_out;
wire FF_num_6_out;
wire FF_num_7_out;


wire neg_FF_num_1_out;
wire neg_FF_num_2_out;
wire neg_FF_num_3_out;
wire neg_FF_num_4_out;
wire neg_FF_num_5_out;
wire neg_FF_num_6_out;
wire neg_FF_num_7_out;

assign neg_FF_num_1_out = ~FF_num_1_out;
assign neg_FF_num_2_out = ~FF_num_2_out;
assign neg_FF_num_3_out = ~FF_num_3_out;
assign neg_FF_num_4_out = ~FF_num_4_out;
assign neg_FF_num_5_out = ~FF_num_5_out;
assign neg_FF_num_6_out = ~FF_num_6_out;
assign neg_FF_num_7_out = ~FF_num_7_out;


wire divider_output;
wire divider_output_re_timed;

register_div_by_2 FF_num_1 (
	.in_D(neg_FF_num_1_out),
	.in_rstb(in_rstb),
	.in_clk(in_pll_output),
	.out_Q(FF_num_1_out)
	);

register_div_by_2 FF_num_2 (
	.in_D(neg_FF_num_2_out),
	.in_rstb(in_rstb),
	.in_clk(FF_num_1_out),
	.out_Q(FF_num_2_out)
	);

register_div_by_2 FF_num_3 (
	.in_D(neg_FF_num_3_out),
	.in_rstb(in_rstb),
	.in_clk(FF_num_2_out),
	.out_Q(FF_num_3_out)
	);

register_div_by_2 FF_num_4 (
	.in_D(neg_FF_num_4_out),
	.in_rstb(in_rstb),
	.in_clk(FF_num_3_out),
	.out_Q(FF_num_4_out)
	);

register_div_by_2 FF_num_5 (
	.in_D(neg_FF_num_5_out),
	.in_rstb(in_rstb),
	.in_clk(FF_num_4_out),
	.out_Q(FF_num_5_out)
	);

register_div_by_2 FF_num_6 (
	.in_D(neg_FF_num_6_out),
	.in_rstb(in_rstb),
	.in_clk(FF_num_5_out),
	.out_Q(FF_num_6_out)
	);

register_div_by_2 FF_num_7 (
	.in_D(neg_FF_num_7_out),
	.in_rstb(in_rstb),
	.in_clk(FF_num_6_out),
	.out_Q(FF_num_7_out)
	);


mux_sel_div_modulus_programmable_div mux_sel_div_modulus_programmable_div(
	.in_param_sel_divider_modulus(in_param_sel_divider_modulus),
	.in_div_by_1(in_pll_output),
	.in_div_by_2(FF_num_1_out),
	.in_div_by_4(FF_num_2_out),
	.in_div_by_8(FF_num_3_out),
	.in_div_by_16(FF_num_4_out),
	.in_div_by_32(FF_num_5_out),
	.in_div_by_64(FF_num_6_out),
	.in_div_by_128(FF_num_7_out),
	.out(divider_output)
	);


register_div_by_2 FF_re_time_output(
	.in_D(divider_output),
	.in_rstb(in_rstb),
	.in_clk(in_pll_output),
	.out_Q(divider_output_re_timed)
	);




mux_sel_div_re_timed mux_sel_div_re_timed(
	.in_param_sel_re_time_version(in_param_sel_re_time_version),
	.in_clk_1(divider_output),
	.in_clk_2(divider_output_re_timed),
	.out(out_clk)
	);


endmodule


module inv_logic_n1 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n1 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n1 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n1 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n1 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n10 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n10 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n10 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n10 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n10 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n11 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n11 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n11 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n11 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n11 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n12 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n12 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n12 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n12 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n12 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n13 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n13 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n13 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n13 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n13 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n14 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n14 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n14 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n14 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n14 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n15 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n15 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n15 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n15 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n15 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n16 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n16 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n16 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n16 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n16 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n2 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n2 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n2 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n2 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n2 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n3 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n3 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n3 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n3 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n3 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n4 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n4 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n4 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n4 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n4 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n5 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n5 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n5 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n5 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n5 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n6 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n6 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n6 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n6 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n6 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n7 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n7 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n7 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n7 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n7 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n8 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n8 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n8 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n8 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n8 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module inv_logic_n9 #(parameter N_LOADS_PER_STAGE = 24)(
input	in,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );


assign out = ~in;


genvar cc;
generate
for ( cc = 0 ; cc < N_LOADS_PER_STAGE ; cc = cc + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[cc]),
	.out()
	);
end
endgenerate


endmodule

module nand2_stage_ring_n9 #(parameter N_LOADS_PER_STAGE = 24)(
input	in_1,
input	in_2,
input	[N_LOADS_PER_STAGE-1:0] in_ctrl,
output	out );

nand2_logic stage_num_1 (
	.in_1(in_1),
	.in_2(in_2),
	.out(out)
	);

//LOADS
genvar dd;
generate
for ( dd = 0 ; dd < N_LOADS_PER_STAGE ; dd = dd + 1 ) begin
nand2_logic load (
	.in_1(out),
	.in_2(in_ctrl[dd]),
	.out()
	);
end
endgenerate


endmodule

module ring_oscillator_top_n9 #(parameter N_DELAY_STAGE = 3, parameter N_LOADS_PER_STAGE = 24)(
input	in_enable,
input	[N_LOADS_PER_STAGE*(N_DELAY_STAGE)-1:0] in_ctrl,
output	out );


wire pre_out1;
wire pre_out2;
wire [N_DELAY_STAGE:0] pin_in_of_dly_stage;

//First stage is NAND
nand2_stage_ring_n9 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) stage_num_1 (
	.in_1(in_enable),
	.in_2(pin_in_of_dly_stage[0]),
	.in_ctrl(in_ctrl[N_LOADS_PER_STAGE-1:0]),
	.out(pin_in_of_dly_stage[1])
	);

//Further stages are INV
genvar cc;
generate
for ( cc = 1 ; cc < N_DELAY_STAGE ; cc = cc + 1 ) begin
inv_logic_n9 #(.N_LOADS_PER_STAGE(N_LOADS_PER_STAGE)) delaying_stage (
	.in(pin_in_of_dly_stage[cc]),
	.in_ctrl(in_ctrl[(N_LOADS_PER_STAGE*cc)+(N_LOADS_PER_STAGE-1):N_LOADS_PER_STAGE*cc]),
	.out(pin_in_of_dly_stage[cc+1])
	);
end
endgenerate

 //Feedback of the ring oscillator
assign pin_in_of_dly_stage[0] = pin_in_of_dly_stage[N_DELAY_STAGE];

//Assign stage of the ring oscillator to output
assign pre_out1 = pin_in_of_dly_stage[0];

//Inverters at output of RO
inv_logic inv_at_out_n1(
        .in(pre_out1),
        .out(pre_out2)
        );
inv_logic inv_at_out_n2(
        .in(pre_out2),
        .out(out)
        );


endmodule

module ring_oscillator_top (
	in_param_enable_n1,
	in_param_enable_n2,
	in_param_enable_n3,
	in_param_enable_n4,
	in_param_enable_n5,
	in_param_enable_n6,
	in_param_enable_n7,
	in_param_enable_n8,
	in_param_enable_n9,
	in_param_enable_n10,
	in_param_enable_n11,
	in_param_enable_n12,
	in_param_enable_n13,
	in_param_enable_n14,
	in_param_enable_n15,
	in_param_enable_n16,
	in_param_sel_ring,
	in_param_sel_divider_modulus,
        in_param_sel_re_time_version,
        in_rstb,
	in_ctrl_FCE_integer,
	in_ctrl_FCE_frac,
	in_param_FCE_additional_ctrl,
	out_pll_clk,
	out_clk
	);


input in_param_enable_n1;
input in_param_enable_n2;
input in_param_enable_n3;
input in_param_enable_n4;
input in_param_enable_n5;
input in_param_enable_n6;
input in_param_enable_n7;
input in_param_enable_n8;
input in_param_enable_n9;
input in_param_enable_n10;
input in_param_enable_n11;
input in_param_enable_n12;
input in_param_enable_n13;
input in_param_enable_n14;
input in_param_enable_n15;
input in_param_enable_n16;
input [3:0] in_param_sel_ring;
input [2:0] in_param_sel_divider_modulus;
input in_param_sel_re_time_version;
input in_rstb;
input [63:0] in_ctrl_FCE_integer;
input [7:0] in_ctrl_FCE_frac;
input [36:0] in_param_FCE_additional_ctrl;


output out_pll_clk;
output out_clk;

wire ro_out_n1;
wire ro_out_n2;
wire ro_out_n3;
wire ro_out_n4;
wire ro_out_n5;
wire ro_out_n6;
wire ro_out_n7;
wire ro_out_n8;
wire ro_out_n9;
wire ro_out_n10;
wire ro_out_n11;
wire ro_out_n12;
wire ro_out_n13;
wire ro_out_n14;
wire ro_out_n15;
wire ro_out_n16;

wire [71 :0] ctrl_n1  ;
wire [71 :0] ctrl_n2  ;
wire [89 :0] ctrl_n3  ;
wire [95 :0] ctrl_n4  ;
wire [107:0] ctrl_n5  ;
wire [74 :0] ctrl_n6  ;
wire [104:0] ctrl_n7  ;
wire [76 :0] ctrl_n8  ;
wire [104:0] ctrl_n9  ;
wire [71 :0] ctrl_n10 ;
wire [107:0] ctrl_n11 ;
wire [76 :0] ctrl_n12 ;
wire [98 :0] ctrl_n13 ;
wire [103:0] ctrl_n14 ;
wire [89 :0] ctrl_n15 ;
wire [101:0] ctrl_n16 ;


assign ctrl_n1[63:0] = in_ctrl_FCE_integer;
assign ctrl_n2[63:0] = in_ctrl_FCE_integer;
assign ctrl_n3[63:0] = in_ctrl_FCE_integer;
assign ctrl_n4[63:0] = in_ctrl_FCE_integer;
assign ctrl_n5[63:0] = in_ctrl_FCE_integer;
assign ctrl_n6[63:0] = in_ctrl_FCE_integer;
assign ctrl_n7[63:0] = in_ctrl_FCE_integer;
assign ctrl_n8[63:0] = in_ctrl_FCE_integer;
assign ctrl_n9[63:0] = in_ctrl_FCE_integer;
assign ctrl_n10[63:0] = in_ctrl_FCE_integer;
assign ctrl_n11[63:0] = in_ctrl_FCE_integer;
assign ctrl_n12[63:0] = in_ctrl_FCE_integer;
assign ctrl_n13[63:0] = in_ctrl_FCE_integer;
assign ctrl_n14[63:0] = in_ctrl_FCE_integer;
assign ctrl_n15[63:0] = in_ctrl_FCE_integer;
assign ctrl_n16[63:0] = in_ctrl_FCE_integer;

assign ctrl_n1[71:64] = in_ctrl_FCE_frac;
assign ctrl_n2[71:64] = in_ctrl_FCE_frac;
assign ctrl_n3[71:64] = in_ctrl_FCE_frac;
assign ctrl_n4[71:64] = in_ctrl_FCE_frac;
assign ctrl_n5[71:64] = in_ctrl_FCE_frac;
assign ctrl_n6[71:64] = in_ctrl_FCE_frac;
assign ctrl_n7[71:64] = in_ctrl_FCE_frac;
assign ctrl_n8[71:64] = in_ctrl_FCE_frac;
assign ctrl_n9[71:64] = in_ctrl_FCE_frac;
assign ctrl_n10[71:64] = in_ctrl_FCE_frac;
assign ctrl_n11[71:64] = in_ctrl_FCE_frac;
assign ctrl_n12[71:64] = in_ctrl_FCE_frac;
assign ctrl_n13[71:64] = in_ctrl_FCE_frac;
assign ctrl_n14[71:64] = in_ctrl_FCE_frac;
assign ctrl_n15[71:64] = in_ctrl_FCE_frac;
assign ctrl_n16[71:64] = in_ctrl_FCE_frac;

//assign ctrl_n1  [71 :72] = in_param_FCE_additional_ctrl[-1:0];
//assign ctrl_n2  [71 :72] = in_param_FCE_additional_ctrl[-1:0];
assign ctrl_n3  [89 :72] = in_param_FCE_additional_ctrl[17:0];
assign ctrl_n4  [95 :72] = in_param_FCE_additional_ctrl[23:0];
assign ctrl_n5  [107:72] = in_param_FCE_additional_ctrl[35:0];
assign ctrl_n6  [74 :72] = in_param_FCE_additional_ctrl[2 :0];
assign ctrl_n7  [104:72] = in_param_FCE_additional_ctrl[32:0];
assign ctrl_n8  [76 :72] = in_param_FCE_additional_ctrl[4 :0];
assign ctrl_n9  [104:72] = in_param_FCE_additional_ctrl[32:0];
//assign ctrl_n10 [71 :72] = in_param_FCE_additional_ctrl[-1:0];
assign ctrl_n11 [107:72] = in_param_FCE_additional_ctrl[35:0];
assign ctrl_n12 [76 :72] = in_param_FCE_additional_ctrl[4 :0];
assign ctrl_n13 [98 :72] = in_param_FCE_additional_ctrl[26:0];
assign ctrl_n14 [103:72] = in_param_FCE_additional_ctrl[31:0];
assign ctrl_n15 [89 :72] = in_param_FCE_additional_ctrl[17:0];
assign ctrl_n16 [101:72] = in_param_FCE_additional_ctrl[29:0];

ring_oscillator_top_n1 #(.N_DELAY_STAGE(3), .N_LOADS_PER_STAGE(24)) ring_oscillator_top_n1 (   //3*24=72
        .in_enable(in_param_enable_n1),
        .in_ctrl(ctrl_n1),
        .out(ro_out_n1)
        );

ring_oscillator_top_n2 #(.N_DELAY_STAGE(3), .N_LOADS_PER_STAGE(24)) ring_oscillator_top_n2 (   //3*24=72
        .in_enable(in_param_enable_n2),
        .in_ctrl(ctrl_n2),
        .out(ro_out_n2)
        );

ring_oscillator_top_n3 #(.N_DELAY_STAGE(3), .N_LOADS_PER_STAGE(30)) ring_oscillator_top_n3 (  //3*30=90
        .in_enable(in_param_enable_n3),
        .in_ctrl(ctrl_n3),
        .out(ro_out_n3)
        );

ring_oscillator_top_n4 #(.N_DELAY_STAGE(3), .N_LOADS_PER_STAGE(32)) ring_oscillator_top_n4 (  //3*32=96
        .in_enable(in_param_enable_n4),
        .in_ctrl(ctrl_n4),
        .out(ro_out_n4)
        );

ring_oscillator_top_n5 #(.N_DELAY_STAGE(3), .N_LOADS_PER_STAGE(36)) ring_oscillator_top_n5 (  //3*36=108
        .in_enable(in_param_enable_n5),
        .in_ctrl(ctrl_n5),
        .out(ro_out_n5)
        );

ring_oscillator_top_n6 #(.N_DELAY_STAGE(5), .N_LOADS_PER_STAGE(15)) ring_oscillator_top_n6 (  //5*15=75
        .in_enable(in_param_enable_n6),
        .in_ctrl(ctrl_n6),
        .out(ro_out_n6)
        );
	
ring_oscillator_top_n7 #(.N_DELAY_STAGE(5), .N_LOADS_PER_STAGE(21)) ring_oscillator_top_n7 (  //5*21=105
        .in_enable(in_param_enable_n7),
        .in_ctrl(ctrl_n7),
        .out(ro_out_n7)
        );

ring_oscillator_top_n8 #(.N_DELAY_STAGE(7), .N_LOADS_PER_STAGE(11)) ring_oscillator_top_n8 (  //7*11=77
        .in_enable(in_param_enable_n8),
        .in_ctrl(ctrl_n8),
        .out(ro_out_n8)
        );

ring_oscillator_top_n9 #(.N_DELAY_STAGE(7), .N_LOADS_PER_STAGE(15)) ring_oscillator_top_n9 (  //7*15=105
        .in_enable(in_param_enable_n9),
        .in_ctrl(ctrl_n9),
        .out(ro_out_n9)
        );

ring_oscillator_top_n10 #(.N_DELAY_STAGE(9), .N_LOADS_PER_STAGE(8)) ring_oscillator_top_n10 (  //9*8=72
        .in_enable(in_param_enable_n10),
        .in_ctrl(ctrl_n10),
        .out(ro_out_n10)
        );

ring_oscillator_top_n11 #(.N_DELAY_STAGE(9), .N_LOADS_PER_STAGE(12)) ring_oscillator_top_n11 (  //9*12=108
        .in_enable(in_param_enable_n11),
        .in_ctrl(ctrl_n11),
        .out(ro_out_n11)
        );

ring_oscillator_top_n12 #(.N_DELAY_STAGE(11), .N_LOADS_PER_STAGE(7)) ring_oscillator_top_n12 (  //11*7=77
        .in_enable(in_param_enable_n12),
        .in_ctrl(ctrl_n12),
        .out(ro_out_n12)
        );

ring_oscillator_top_n13 #(.N_DELAY_STAGE(11), .N_LOADS_PER_STAGE(9)) ring_oscillator_top_n13 (  //11*9=99
        .in_enable(in_param_enable_n13),
        .in_ctrl(ctrl_n13),
        .out(ro_out_n13)
        );

ring_oscillator_top_n14 #(.N_DELAY_STAGE(13), .N_LOADS_PER_STAGE(8)) ring_oscillator_top_n14 (  //13*8=104
        .in_enable(in_param_enable_n14),
        .in_ctrl(ctrl_n14),
        .out(ro_out_n14)
        );

ring_oscillator_top_n15 #(.N_DELAY_STAGE(15), .N_LOADS_PER_STAGE(6)) ring_oscillator_top_n15 (  //15*6=90
        .in_enable(in_param_enable_n15),
        .in_ctrl(ctrl_n15),
        .out(ro_out_n15)
        );

ring_oscillator_top_n16 #(.N_DELAY_STAGE(17), .N_LOADS_PER_STAGE(6)) ring_oscillator_top_n16 (  //17*6=102
        .in_enable(in_param_enable_n16),
        .in_ctrl(ctrl_n16),
        .out(ro_out_n16)
        );


mux_sel_ring_oscillator mux_sel_ring_oscillator (
	.in_param_sel_ring(in_param_sel_ring),
	.in_ring_n1(ro_out_n1),
	.in_ring_n2(ro_out_n2),
	.in_ring_n3(ro_out_n3),
	.in_ring_n4(ro_out_n4),
	.in_ring_n5(ro_out_n5),
	.in_ring_n6(ro_out_n6),
	.in_ring_n7(ro_out_n7),
	.in_ring_n8(ro_out_n8),
	.in_ring_n9(ro_out_n9),
	.in_ring_n10(ro_out_n10),
	.in_ring_n11(ro_out_n11),
	.in_ring_n12(ro_out_n12),
	.in_ring_n13(ro_out_n13),
	.in_ring_n14(ro_out_n14),
	.in_ring_n15(ro_out_n15),
	.in_ring_n16(ro_out_n16),
	.out(out_pll_clk)
	);
	

programmable_divider_output programmable_divider_output(
        .in_pll_output(out_pll_clk),
        .in_param_sel_divider_modulus(in_param_sel_divider_modulus),
        .in_param_sel_re_time_version(in_param_sel_re_time_version),
        .in_rstb(in_rstb),
        .out_clk(out_clk)
        );

endmodule
module map_spi (
    //Outputs
  vo_data_to_core,
  vo_dlc_gain_sel_rw,
   vo_frac_alpha_rw,
   vo_integer_n_rw,
   vo_k_i_rw,
   vo_k_p_rw,
   vo_pole_location_shift_IIR_0_rw,
   vo_pole_location_shift_IIR_1_rw,
   vo_pole_location_shift_IIR_2_rw,
   vo_pole_location_shift_IIR_3_rw,
   vo_sel_time_ctrl_clk_alpha_and_accum_rw,
   vo_sel_time_ctrl_clk_dlc_rw,
   vo_sel_time_ctrl_clk_dco_drift_rw,
   vo_sel_time_ctrl_clk_fce_rw,
   vo_sel_time_ctrl_clk_dco_rw,
   vo_sel_width_of_vdiv_rw,
   vo_sel_width_of_rst_rw,
   vo_spi_to_fce_frac_part_rw,
   vo_spi_to_fce_int_part_rw,
   vo_additional_freq_ctrl_rw,
 o_ena_IIR_0_rw,
 o_ena_IIR_1_rw,
 o_ena_IIR_2_rw,
 o_ena_IIR_3_rw,
 o_ena_free_running_DCO_frac_part_rw,
 o_ena_free_running_DCO_int_part_rw,
 o_ena_dco_drift_rw,
 o_ena_pi_requant_rw,
 o_ena_rand_dem_rw,
 o_ena_rand_dsm_rw,
 o_ena_rand_iir0_rw,
 o_ena_rand_iir1_rw,
 o_ena_rand_iir2_rw,
 o_ena_rand_iir3_rw,
 o_ena_rand_pi_rw,
 o_ena_requantizer_IIR_0_rw,
 o_ena_requantizer_IIR_1_rw,
 o_ena_requantizer_IIR_2_rw,
 o_ena_requantizer_IIR_3_rw,
 o_enable_clk_fce_from_timing_ctrl_blk_rw,
 o_external_clk_fce_rw,
 o_enable_clk_additional_fce_from_timing_ctrl_blk_rw,
 o_external_clk_additional_fce_rw,
 o_rst_pll_rw,
 o_param_enable_n1_rw,
 o_param_enable_n2_rw,
 o_param_enable_n3_rw,
 o_param_enable_n4_rw,
 o_param_enable_n5_rw,
 o_param_enable_n6_rw,
 o_param_enable_n7_rw,
 o_param_enable_n8_rw,
 o_param_enable_n9_rw,
 o_param_enable_n10_rw,
 o_param_enable_n11_rw,
 o_param_enable_n12_rw,
 o_param_enable_n13_rw,
 o_param_enable_n14_rw,
 o_param_enable_n15_rw,
 o_param_enable_n16_rw,
 vo_param_sel_ring_rw,
 vo_param_sel_divider_modulus_rw,
 o_param_sel_re_time_version_rw,
 o_param_enable_tst_clk_rw,
 o_read_p_of_n_rw,
 o_read_iba_to_therm_enc_rw,
 o_read_iba_to_dsm_rw,
 o_read_y_of_n_rw,
   // Reading Inputs
 in_p_of_n, in_iba_to_therm_encod, in_iba_to_dsm, in_y_of_n,
   // Inputs
 i_rx_valid, vi_data_from_core, vi_counter_byte, i_rstb, i_sck
 );
 
//Outputs Declaration
output  [7:0] vo_data_to_core;


output [2:0]  vo_dlc_gain_sel_rw;
output [15:0]  vo_frac_alpha_rw;
output [7:0]  vo_integer_n_rw;
output [3:0]  vo_k_i_rw;
output [3:0]  vo_k_p_rw;
output [2:0]  vo_pole_location_shift_IIR_0_rw;
output [2:0]  vo_pole_location_shift_IIR_1_rw;
output [2:0]  vo_pole_location_shift_IIR_2_rw;
output [2:0]  vo_pole_location_shift_IIR_3_rw;
output [2:0]  vo_sel_time_ctrl_clk_alpha_and_accum_rw;
output [2:0]  vo_sel_time_ctrl_clk_dlc_rw;
output [2:0]  vo_sel_time_ctrl_clk_dco_drift_rw;
output [2:0]  vo_sel_time_ctrl_clk_fce_rw;
output [2:0]  vo_sel_time_ctrl_clk_dco_rw;
output [1:0]  vo_sel_width_of_vdiv_rw;
output [1:0]  vo_sel_width_of_rst_rw;
output [7:0]  vo_spi_to_fce_frac_part_rw;
output [63:0]  vo_spi_to_fce_int_part_rw;
output [5:0] vo_additional_freq_ctrl_rw;
output o_ena_IIR_0_rw;
output o_ena_IIR_1_rw;
output o_ena_IIR_2_rw;
output o_ena_IIR_3_rw;
output o_ena_free_running_DCO_frac_part_rw;
output o_ena_free_running_DCO_int_part_rw;
output o_ena_dco_drift_rw;
output o_ena_pi_requant_rw;
output o_ena_rand_dem_rw;
output o_ena_rand_dsm_rw;
output o_ena_rand_iir0_rw;
output o_ena_rand_iir1_rw;
output o_ena_rand_iir2_rw;
output o_ena_rand_iir3_rw;
output o_ena_rand_pi_rw;
output o_ena_requantizer_IIR_0_rw;
output o_ena_requantizer_IIR_1_rw;
output o_ena_requantizer_IIR_2_rw;
output o_ena_requantizer_IIR_3_rw;
output o_enable_clk_fce_from_timing_ctrl_blk_rw;
output o_external_clk_fce_rw;
output o_enable_clk_additional_fce_from_timing_ctrl_blk_rw;
output o_external_clk_additional_fce_rw;
output o_rst_pll_rw;
output o_param_enable_n1_rw;
output o_param_enable_n2_rw;
output o_param_enable_n3_rw;
output o_param_enable_n4_rw;
output o_param_enable_n5_rw;
output o_param_enable_n6_rw;
output o_param_enable_n7_rw;
output o_param_enable_n8_rw;
output o_param_enable_n9_rw;
output o_param_enable_n10_rw;
output o_param_enable_n11_rw;
output o_param_enable_n12_rw;
output o_param_enable_n13_rw;
output o_param_enable_n14_rw;
output o_param_enable_n15_rw;
output o_param_enable_n16_rw;
output [3:0] vo_param_sel_ring_rw;
output [2:0] vo_param_sel_divider_modulus_rw;
output o_param_sel_re_time_version_rw;
output o_param_enable_tst_clk_rw;
output o_read_p_of_n_rw;
output o_read_iba_to_therm_enc_rw;
output o_read_iba_to_dsm_rw;
output o_read_y_of_n_rw;

//Input Declaration
input i_rstb;          
input i_sck;
input i_rx_valid; 
input [7:0] vi_data_from_core;
input [2:0] vi_counter_byte;


input [23:0] in_p_of_n;
input [7:0]  in_iba_to_therm_encod;
input [15:0]  in_iba_to_dsm;
input [7:0]  in_y_of_n;

	

localparam MEM_SIZE_minus_1=48; 
//Registers and Wires Declaration
   reg [7:0] 	 mem_regs[0:MEM_SIZE_minus_1];
   
   reg [7:0]     opcode;
   reg [7:0]     address; 
   reg [7:0]     data;
   
   reg pulse; //used to create the pulse for write_only
//REG Declaration
reg  [7:0] vo_data_to_core; 
  

reg [2:0]  vo_dlc_gain_sel_rw;
reg [15:0]  vo_frac_alpha_rw;
reg [7:0]  vo_integer_n_rw;
reg [3:0]  vo_k_i_rw;
reg [3:0]  vo_k_p_rw;
reg [2:0]  vo_pole_location_shift_IIR_0_rw;
reg [2:0]  vo_pole_location_shift_IIR_1_rw;
reg [2:0]  vo_pole_location_shift_IIR_2_rw;
reg [2:0]  vo_pole_location_shift_IIR_3_rw;
reg [2:0]  vo_sel_time_ctrl_clk_alpha_and_accum_rw;
reg [2:0]  vo_sel_time_ctrl_clk_dlc_rw;
reg [2:0]  vo_sel_time_ctrl_clk_dco_drift_rw;
reg [2:0]  vo_sel_time_ctrl_clk_fce_rw;
reg [2:0]  vo_sel_time_ctrl_clk_dco_rw;
reg [1:0]  vo_sel_width_of_vdiv_rw;
reg [1:0]  vo_sel_width_of_rst_rw;
reg [7:0]  vo_spi_to_fce_frac_part_rw;
reg [63:0]  vo_spi_to_fce_int_part_rw;
reg [5:0]  vo_additional_freq_ctrl_rw;
reg o_ena_IIR_0_rw;
reg o_ena_IIR_1_rw;
reg o_ena_IIR_2_rw;
reg o_ena_IIR_3_rw;
reg o_ena_free_running_DCO_frac_part_rw;
reg o_ena_free_running_DCO_int_part_rw;
reg o_ena_dco_drift_rw;
reg o_ena_pi_requant_rw;
reg o_ena_rand_dem_rw;
reg o_ena_rand_dsm_rw;
reg o_ena_rand_iir0_rw;
reg o_ena_rand_iir1_rw;
reg o_ena_rand_iir2_rw;
reg o_ena_rand_iir3_rw;
reg o_ena_rand_pi_rw;
reg o_ena_requantizer_IIR_0_rw;
reg o_ena_requantizer_IIR_1_rw;
reg o_ena_requantizer_IIR_2_rw;
reg o_ena_requantizer_IIR_3_rw;
reg o_enable_clk_fce_from_timing_ctrl_blk_rw;
reg o_external_clk_fce_rw;
reg o_enable_clk_additional_fce_from_timing_ctrl_blk_rw;
reg o_external_clk_additional_fce_rw;
reg o_rst_pll_rw;
reg o_param_enable_n1_rw;
reg o_param_enable_n2_rw;
reg o_param_enable_n3_rw;
reg o_param_enable_n4_rw;
reg o_param_enable_n5_rw;
reg o_param_enable_n6_rw;
reg o_param_enable_n7_rw;
reg o_param_enable_n8_rw;
reg o_param_enable_n9_rw;
reg o_param_enable_n10_rw;
reg o_param_enable_n11_rw;
reg o_param_enable_n12_rw;
reg o_param_enable_n13_rw;
reg o_param_enable_n14_rw;
reg o_param_enable_n15_rw;
reg o_param_enable_n16_rw;
reg [3:0] vo_param_sel_ring_rw;
reg [2:0] vo_param_sel_divider_modulus_rw;
reg o_param_sel_re_time_version_rw;
reg o_param_enable_tst_clk_rw;
reg o_read_p_of_n_rw;
reg o_read_iba_to_therm_enc_rw;
reg o_read_iba_to_dsm_rw;
reg o_read_y_of_n_rw;


always @(negedge i_rx_valid or negedge i_rstb) begin
  if (!i_rstb) begin
  	opcode <= 0;
	address <= 0;
	data <= 0;
  end else begin
  		if (vi_counter_byte == 1) begin
			opcode <= vi_data_from_core;
		end else if (vi_counter_byte == 2 ) begin
			address <= vi_data_from_core;
		end else if (vi_counter_byte == 3 ) begin
			data <= vi_data_from_core;
		end
  end
end 




//When we write:
always @(posedge i_sck or negedge i_rstb)  begin //always @(negedge i_rx_valid or negedge i_rstb)   begin //always @(*)  begin
if (!i_rstb) begin 

mem_regs[0]<=0;
mem_regs[1]<=0;
mem_regs[2]<=0;
mem_regs[3]<=0;
mem_regs[4]<=0;
mem_regs[5]<=0;
mem_regs[6]<=0;
mem_regs[7]<=0;
mem_regs[8]<=0;
mem_regs[9]<=0;
mem_regs[10]<=0;
mem_regs[11]<=0;
mem_regs[12]<=0;
mem_regs[13]<=0;
mem_regs[14]<=0;
mem_regs[15]<=0;
mem_regs[16]<=0;
mem_regs[17]<=0;
mem_regs[18]<=0;
mem_regs[19]<=0;
mem_regs[20]<=0;
mem_regs[21]<=0;
mem_regs[22]<=0;
mem_regs[23]<=0;
mem_regs[24]<=0;
mem_regs[25]<=0;
mem_regs[26]<=0;
mem_regs[27]<=0;
mem_regs[28]<=0;
mem_regs[29]<=0;
mem_regs[30]<=0;
mem_regs[31]<=0;
mem_regs[32]<=0;
mem_regs[33]<=0;
mem_regs[34]<=0;
mem_regs[35]<=0;
mem_regs[36]<=0;
mem_regs[37]<=0;
mem_regs[38]<=0;
mem_regs[39]<=0;
mem_regs[40]<=0;
mem_regs[41]<=0;
mem_regs[42]<=0;
mem_regs[43]<=0;
mem_regs[44]<=0;
mem_regs[45]<=0;
mem_regs[46]<=0;
mem_regs[47]<=0;


end else begin
  if (opcode == 32 && vi_counter_byte==3) begin    // wirte: 0010  | 0000    read: 0011  | 0000
	mem_regs[address][7:0] <= data;
	

	//Reading Words
	mem_regs[42][7:0] <= in_p_of_n[7:0];
	mem_regs[43][7:0] <= in_p_of_n[15:8];
	mem_regs[44][7:0] <= in_p_of_n[23:16];

	mem_regs[45][7:0] <= in_iba_to_therm_encod;

	mem_regs[46][7:0] <= in_iba_to_dsm[7:0];
	mem_regs[47][7:0] <= in_iba_to_dsm[15:8];

	mem_regs[48][7:0] <= in_y_of_n;

  end 
 end //if not reset
end //always (posedge



reg [7:0] pre_vo_data_to_core;
always @(address) begin
	pre_vo_data_to_core <= mem_regs[address][7:0];
end

always @(*) begin
	if (vi_counter_byte != 0 && vi_counter_byte != 1 && vi_counter_byte != 2) begin
	vo_data_to_core <= pre_vo_data_to_core;
	end
	else begin
	vo_data_to_core <= 0;
	end
end





    //Register Assignments 
always @(*) begin

vo_integer_n_rw[0] <= mem_regs[0][0];
vo_integer_n_rw[1] <= mem_regs[0][1];
vo_integer_n_rw[2] <= mem_regs[0][2];
vo_integer_n_rw[3] <= mem_regs[0][3];
vo_integer_n_rw[4] <= mem_regs[0][4];
vo_integer_n_rw[5] <= mem_regs[0][5];
vo_integer_n_rw[6] <= mem_regs[0][6];
vo_integer_n_rw[7] <= mem_regs[0][7];

vo_frac_alpha_rw[0] <= mem_regs[1][0];
vo_frac_alpha_rw[1] <= mem_regs[1][1];
vo_frac_alpha_rw[2] <= mem_regs[1][2];
vo_frac_alpha_rw[3] <= mem_regs[1][3];
vo_frac_alpha_rw[4] <= mem_regs[1][4];
vo_frac_alpha_rw[5] <= mem_regs[1][5];
vo_frac_alpha_rw[6] <= mem_regs[1][6];
vo_frac_alpha_rw[7] <= mem_regs[1][7];

vo_frac_alpha_rw[8] <= mem_regs[2][0];
vo_frac_alpha_rw[9] <= mem_regs[2][1];
vo_frac_alpha_rw[10] <= mem_regs[2][2];
vo_frac_alpha_rw[11] <= mem_regs[2][3];
vo_frac_alpha_rw[12] <= mem_regs[2][4];
vo_frac_alpha_rw[13] <= mem_regs[2][5];
vo_frac_alpha_rw[14] <= mem_regs[2][6];
vo_frac_alpha_rw[15] <= mem_regs[2][7];

vo_sel_width_of_vdiv_rw[0] <= mem_regs[3][0];
vo_sel_width_of_vdiv_rw[1] <= mem_regs[3][1];
vo_sel_width_of_rst_rw[0] <= mem_regs[3][2];
vo_sel_width_of_rst_rw[1] <= mem_regs[3][3];

vo_dlc_gain_sel_rw[0] <= mem_regs[4][0];
vo_dlc_gain_sel_rw[1] <= mem_regs[4][1];
vo_dlc_gain_sel_rw[2] <= mem_regs[4][2];

vo_pole_location_shift_IIR_0_rw[0] <= mem_regs[5][0];
vo_pole_location_shift_IIR_0_rw[1] <= mem_regs[5][1];
vo_pole_location_shift_IIR_0_rw[2] <= mem_regs[5][2];

vo_pole_location_shift_IIR_1_rw[0] <= mem_regs[6][0];
vo_pole_location_shift_IIR_1_rw[1] <= mem_regs[6][1];
vo_pole_location_shift_IIR_1_rw[2] <= mem_regs[6][2];

vo_pole_location_shift_IIR_2_rw[0] <= mem_regs[7][0];
vo_pole_location_shift_IIR_2_rw[1] <= mem_regs[7][1];
vo_pole_location_shift_IIR_2_rw[2] <= mem_regs[7][2];

vo_pole_location_shift_IIR_3_rw[0] <= mem_regs[8][0];
vo_pole_location_shift_IIR_3_rw[1] <= mem_regs[8][1];
vo_pole_location_shift_IIR_3_rw[2] <= mem_regs[8][2];

o_ena_IIR_0_rw <= mem_regs[9][0];
o_ena_IIR_1_rw <= mem_regs[9][1];
o_ena_IIR_2_rw <= mem_regs[9][2];
o_ena_IIR_3_rw <= mem_regs[9][3];

o_ena_requantizer_IIR_0_rw <= mem_regs[10][0];
o_ena_requantizer_IIR_1_rw <= mem_regs[10][1];
o_ena_requantizer_IIR_2_rw <= mem_regs[10][2];
o_ena_requantizer_IIR_3_rw <= mem_regs[10][3];

vo_k_p_rw[0] <= mem_regs[11][0];
vo_k_p_rw[1] <= mem_regs[11][1];
vo_k_p_rw[2] <= mem_regs[11][2];
vo_k_p_rw[3] <= mem_regs[11][3];

vo_k_i_rw[0] <= mem_regs[12][0];
vo_k_i_rw[1] <= mem_regs[12][1];
vo_k_i_rw[2] <= mem_regs[12][2];
vo_k_i_rw[3] <= mem_regs[12][3];

o_ena_rand_dem_rw <= mem_regs[13][0];
o_ena_rand_dsm_rw <= mem_regs[13][1];
o_ena_rand_iir0_rw <= mem_regs[13][5];
o_ena_rand_iir1_rw <= mem_regs[13][4];
o_ena_rand_iir2_rw <= mem_regs[13][3];
o_ena_rand_iir3_rw <= mem_regs[13][2];
o_ena_rand_pi_rw <= mem_regs[13][6];
o_ena_pi_requant_rw <= mem_regs[13][7];

vo_sel_time_ctrl_clk_alpha_and_accum_rw[0] <= mem_regs[14][0];
vo_sel_time_ctrl_clk_alpha_and_accum_rw[1] <= mem_regs[14][1];
vo_sel_time_ctrl_clk_alpha_and_accum_rw[2] <= mem_regs[14][2];

vo_sel_time_ctrl_clk_dlc_rw[0] <= mem_regs[15][0];
vo_sel_time_ctrl_clk_dlc_rw[1] <= mem_regs[15][1];
vo_sel_time_ctrl_clk_dlc_rw[2] <= mem_regs[15][2];

vo_sel_time_ctrl_clk_dco_drift_rw[0] <= mem_regs[16][0];
vo_sel_time_ctrl_clk_dco_drift_rw[1] <= mem_regs[16][1];
vo_sel_time_ctrl_clk_dco_drift_rw[2] <= mem_regs[16][2];

vo_sel_time_ctrl_clk_fce_rw[0] <= mem_regs[17][0];
vo_sel_time_ctrl_clk_fce_rw[1] <= mem_regs[17][1];
vo_sel_time_ctrl_clk_fce_rw[2] <= mem_regs[17][2];

o_external_clk_fce_rw <= mem_regs[18][0];
o_enable_clk_fce_from_timing_ctrl_blk_rw <= mem_regs[18][1];
o_external_clk_additional_fce_rw <= mem_regs[18][2];
o_enable_clk_additional_fce_from_timing_ctrl_blk_rw <= mem_regs[18][3];

o_ena_free_running_DCO_frac_part_rw <= mem_regs[19][0];
o_ena_free_running_DCO_int_part_rw <= mem_regs[19][1];
o_param_enable_tst_clk_rw <= mem_regs[19][2];


vo_spi_to_fce_int_part_rw[0] <= mem_regs[20][0];
vo_spi_to_fce_int_part_rw[1] <= mem_regs[20][1];
vo_spi_to_fce_int_part_rw[2] <= mem_regs[20][2];
vo_spi_to_fce_int_part_rw[3] <= mem_regs[20][3];
vo_spi_to_fce_int_part_rw[4] <= mem_regs[20][4];
vo_spi_to_fce_int_part_rw[5] <= mem_regs[20][5];
vo_spi_to_fce_int_part_rw[6] <= mem_regs[20][6];
vo_spi_to_fce_int_part_rw[7] <= mem_regs[20][7];

vo_spi_to_fce_int_part_rw[8] <= mem_regs[21][0];
vo_spi_to_fce_int_part_rw[9] <= mem_regs[21][1];
vo_spi_to_fce_int_part_rw[10] <= mem_regs[21][2];
vo_spi_to_fce_int_part_rw[11] <= mem_regs[21][3];
vo_spi_to_fce_int_part_rw[12] <= mem_regs[21][4];
vo_spi_to_fce_int_part_rw[13] <= mem_regs[21][5];
vo_spi_to_fce_int_part_rw[14] <= mem_regs[21][6];
vo_spi_to_fce_int_part_rw[15] <= mem_regs[21][7];

vo_spi_to_fce_int_part_rw[16] <= mem_regs[22][0];
vo_spi_to_fce_int_part_rw[17] <= mem_regs[22][1];
vo_spi_to_fce_int_part_rw[18] <= mem_regs[22][2];
vo_spi_to_fce_int_part_rw[19] <= mem_regs[22][3];
vo_spi_to_fce_int_part_rw[20] <= mem_regs[22][4];
vo_spi_to_fce_int_part_rw[21] <= mem_regs[22][5];
vo_spi_to_fce_int_part_rw[22] <= mem_regs[22][6];
vo_spi_to_fce_int_part_rw[23] <= mem_regs[22][7];

vo_spi_to_fce_int_part_rw[24] <= mem_regs[23][0];
vo_spi_to_fce_int_part_rw[25] <= mem_regs[23][1];
vo_spi_to_fce_int_part_rw[26] <= mem_regs[23][2];
vo_spi_to_fce_int_part_rw[27] <= mem_regs[23][3];
vo_spi_to_fce_int_part_rw[28] <= mem_regs[23][4];
vo_spi_to_fce_int_part_rw[29] <= mem_regs[23][5];
vo_spi_to_fce_int_part_rw[30] <= mem_regs[23][6];
vo_spi_to_fce_int_part_rw[31] <= mem_regs[23][7];

vo_spi_to_fce_int_part_rw[32] <= mem_regs[24][0];
vo_spi_to_fce_int_part_rw[33] <= mem_regs[24][1];
vo_spi_to_fce_int_part_rw[34] <= mem_regs[24][2];
vo_spi_to_fce_int_part_rw[35] <= mem_regs[24][3];
vo_spi_to_fce_int_part_rw[36] <= mem_regs[24][4];
vo_spi_to_fce_int_part_rw[37] <= mem_regs[24][5];
vo_spi_to_fce_int_part_rw[38] <= mem_regs[24][6];
vo_spi_to_fce_int_part_rw[39] <= mem_regs[24][7];

vo_spi_to_fce_int_part_rw[40] <= mem_regs[25][0];
vo_spi_to_fce_int_part_rw[41] <= mem_regs[25][1];
vo_spi_to_fce_int_part_rw[42] <= mem_regs[25][2];
vo_spi_to_fce_int_part_rw[43] <= mem_regs[25][3];
vo_spi_to_fce_int_part_rw[44] <= mem_regs[25][4];
vo_spi_to_fce_int_part_rw[45] <= mem_regs[25][5];
vo_spi_to_fce_int_part_rw[46] <= mem_regs[25][6];
vo_spi_to_fce_int_part_rw[47] <= mem_regs[25][7];

vo_spi_to_fce_int_part_rw[48] <= mem_regs[26][0];
vo_spi_to_fce_int_part_rw[49] <= mem_regs[26][1];
vo_spi_to_fce_int_part_rw[50] <= mem_regs[26][2];
vo_spi_to_fce_int_part_rw[51] <= mem_regs[26][3];
vo_spi_to_fce_int_part_rw[52] <= mem_regs[26][4];
vo_spi_to_fce_int_part_rw[53] <= mem_regs[26][5];
vo_spi_to_fce_int_part_rw[54] <= mem_regs[26][6];
vo_spi_to_fce_int_part_rw[55] <= mem_regs[26][7];

vo_spi_to_fce_int_part_rw[56] <= mem_regs[27][0];
vo_spi_to_fce_int_part_rw[57] <= mem_regs[27][1];
vo_spi_to_fce_int_part_rw[58] <= mem_regs[27][2];
vo_spi_to_fce_int_part_rw[59] <= mem_regs[27][3];
vo_spi_to_fce_int_part_rw[60] <= mem_regs[27][4];
vo_spi_to_fce_int_part_rw[61] <= mem_regs[27][5];
vo_spi_to_fce_int_part_rw[62] <= mem_regs[27][6];
vo_spi_to_fce_int_part_rw[63] <= mem_regs[27][7];

vo_spi_to_fce_frac_part_rw[0] <= mem_regs[28][0];
vo_spi_to_fce_frac_part_rw[1] <= mem_regs[28][1];
vo_spi_to_fce_frac_part_rw[2] <= mem_regs[28][2];
vo_spi_to_fce_frac_part_rw[3] <= mem_regs[28][3];
vo_spi_to_fce_frac_part_rw[4] <= mem_regs[28][4];
vo_spi_to_fce_frac_part_rw[5] <= mem_regs[28][5];
vo_spi_to_fce_frac_part_rw[6] <= mem_regs[28][6];
vo_spi_to_fce_frac_part_rw[7] <= mem_regs[28][7];

vo_sel_time_ctrl_clk_dco_rw[0] <= mem_regs[29][0];
vo_sel_time_ctrl_clk_dco_rw[1] <= mem_regs[29][1];
vo_sel_time_ctrl_clk_dco_rw[2] <= mem_regs[29][2];

vo_additional_freq_ctrl_rw[0] <= mem_regs[30][0];
vo_additional_freq_ctrl_rw[1] <= mem_regs[30][1];
vo_additional_freq_ctrl_rw[2] <= mem_regs[30][2];
vo_additional_freq_ctrl_rw[3] <= mem_regs[30][3];
vo_additional_freq_ctrl_rw[4] <= mem_regs[30][4];
vo_additional_freq_ctrl_rw[5] <= mem_regs[30][5];


o_ena_dco_drift_rw <= mem_regs[31][0];


o_param_enable_n1_rw <= mem_regs[32][0];
o_param_enable_n2_rw <= mem_regs[32][1];
o_param_enable_n3_rw <= mem_regs[32][2];
o_param_enable_n4_rw <= mem_regs[32][3];
o_param_enable_n5_rw <= mem_regs[32][4];
o_param_enable_n6_rw <= mem_regs[32][5];
o_param_enable_n7_rw <= mem_regs[32][6];
o_param_enable_n8_rw <= mem_regs[32][7];

o_param_enable_n9_rw <= mem_regs[33][0];
o_param_enable_n10_rw <= mem_regs[33][1];
o_param_enable_n11_rw <= mem_regs[33][2];
o_param_enable_n12_rw <= mem_regs[33][3];
o_param_enable_n13_rw <= mem_regs[33][4];
o_param_enable_n14_rw <= mem_regs[33][5];
o_param_enable_n15_rw <= mem_regs[33][6];
o_param_enable_n16_rw <= mem_regs[33][7];

vo_param_sel_ring_rw[0] <= mem_regs[34][0];
vo_param_sel_ring_rw[1] <= mem_regs[34][1];
vo_param_sel_ring_rw[2] <= mem_regs[34][2];
vo_param_sel_ring_rw[3] <= mem_regs[34][3];

vo_param_sel_divider_modulus_rw[0] <= mem_regs[35][0];
vo_param_sel_divider_modulus_rw[1] <= mem_regs[35][1];
vo_param_sel_divider_modulus_rw[2] <= mem_regs[35][2];

o_param_sel_re_time_version_rw <= mem_regs[36][0];

o_rst_pll_rw <= mem_regs[37][0];

//Reading Controls
o_read_p_of_n_rw <= mem_regs[38][0];

o_read_iba_to_therm_enc_rw <= mem_regs[39][0];

o_read_iba_to_dsm_rw <= mem_regs[40][0];

o_read_y_of_n_rw <= mem_regs[41][0];

end



endmodule 
/*
 * General SPI interface
 * Services the 4 SPI modes defined as (CPOL,CPHA)
 * See: http://en.wikipedia.org/wiki/Serial_Peripheral_Interface_Bus
 * 
 * CPOL = 0: Base value of clock is 0
 * -- CPHA = 0: SDI sampled on rising edge, SDO changes on falling edge
 * -- CPHA = 1: SDO changes on rising edge, SDI sampled on falling edge
 * CPOL = 1: Base value of clock is 1
 * -- CPHA = 0: SDI sampled on falling edge, SDO changes on rising edge
 * -- CPHA = 1: SDO changes on falling edge, SDI sampled on rising edge
 * 
 * The signals i_epol, i_cpol, i_cpha configure the chip select polarity,
 * the clock polarity, and the clock phase respectively.
 * 
 * BITS_IN_BYTE determines how many bits form a single byte (serial to perallel
 * conversion)
 * 
 * NBIT_BIT_CTR needs to be ceil(log2(BITS_IN_BYTE)) e.g. the counter needs
 * enough bits to be able to reach a count of BITS_IN_BYTE maximum count.
 * 
 * NBIT_BYTE_CTR needs to be able to count up to the maximum number of bytes
 * expected in one CS period. For example, if we are expecting up to 56 bytes,
 * NBIT_BYTE_CTR needs to be at least 6.
 * 
 * The output byte_num indicates the number of successfully received bytes
 * on the SPI interface for the current chip select period.
 * 
 * The output o_rx_valid goes high as the LSB of the current byte is latched;
 * therefore it would make sense to delay rx_valid slightly before sampling
 * o_data.
 * 
 * The data on vi_data is latched into the SPI interface on the opposite
 * polarity clock edge, when the bit counter is equal to the MSB.
 * 
 */

module spi_core (/*AUTOARG*/
   // Outputs
   o_sdo, o_rx_valid, vo_byte_num, vo_data,
   // Inputs
   i_cs, i_sck, i_sdi, i_epol, i_cpol, i_cpha, vi_data
   );
   parameter BITS_IN_BYTE = 8;
   parameter NBIT_BIT_CTR = 3;
   parameter NBIT_BYTE_CTR = 3;
   // spi wires
   input 		      i_cs; // Chip select
   input 		      i_sck; // SPI clock
   input 		      i_sdi; // SPI data input
   output 		      o_sdo; // SPI data output
   // spi configuration
   input 		      i_epol; // 1 = inverted chip select
   input 		      i_cpol; // SPI mode configuration
   input 		      i_cpha;
   // parallel interface
   output 		      o_rx_valid; // When high, indicates valid data
   output [2:0] vo_byte_num; // Indicates number of bytes rx'd
   input [7:0]   vi_data; // Data to be transmitted
   output [7:0]  vo_data; // Data received

   // Registered outputs
   reg 			      o_rx_valid;
   reg [NBIT_BYTE_CTR-1:0]    vo_byte_num;
   reg [BITS_IN_BYTE-1:0]     vo_data;
   
   // Mode-agnostic chip select and scan clock
   wire 		      chip_select; // This signal is always active high
   wire 		      sck; // This signal is always rising edge
   wire                       sck_core; //This signal is always rising edge. But is shifted half of period for when CPHA=1
   // Bit-within-byte counter
   reg [NBIT_BIT_CTR-1:0]     rv_bit_ctr;
   // Data shift registers
   reg [BITS_IN_BYTE-1:0]     rv_rx;
   reg [BITS_IN_BYTE-1:0]     rv_tx;
   // Signals related to the latching and clocking of data to be output
   wire 		      load_pulse;
   reg [NBIT_BIT_CTR-1:0]     rv_tx_ptr;
   
   // First generate an active high chip select, and rising edge clock
   assign chip_select = i_epol ? !i_cs : i_cs;
   assign sck = i_cpol ? !i_sck : i_sck;
   assign sck_core = i_cpha ? !sck : sck;
   
   
   // Generate the pulse signal which latches data into the output shift reg
   assign load_pulse = sck_core && ( $unsigned(BITS_IN_BYTE - 1) == rv_bit_ctr );

   // State machine for RX shift register
   always @( posedge sck_core or negedge chip_select ) begin : rx_fsm
      if ( !chip_select ) begin
	 // Clear RX register
	 rv_rx <= 0;
         // Set bit counter to N-1
         rv_bit_ctr <= $unsigned(BITS_IN_BYTE - 1);
         // Set byte counter to 0
         vo_byte_num <= 0;
         // Clear data output
         vo_data <= 0;
         // Clear valid bit
         o_rx_valid <= 0;
      end else begin
	 // If the LSB is being read, latch that in parallel to the output
	 if ( 0 == rv_bit_ctr ) begin
	    // Data on i_sdi is the LSB of current byte
	    vo_data <= {rv_rx[BITS_IN_BYTE-2:0],i_sdi};
	    // Reset the bit counter
	    rv_bit_ctr <= $unsigned(BITS_IN_BYTE - 1);
	    // Increment the byte counter
	    vo_byte_num <= vo_byte_num + 1;
	    // Set RX valid high
	    o_rx_valid <= 1;   
	 end else begin
	    // RX is not valid
	    o_rx_valid <= 0;
            // Begin clocking in data, MSB first
	    rv_rx[BITS_IN_BYTE-1:1] <= rv_rx[BITS_IN_BYTE-2:0];
	    rv_rx[0] <= i_sdi;
	    // Decrement the bit counter
	    rv_bit_ctr <= rv_bit_ctr - 1;
	 end // else: !if( 0 == rv_bit_ctr )
      end // else: !if( !chip_select )
   end // block: rx_fsm

   // Loading of TX shift register
   always @( posedge load_pulse or negedge chip_select ) begin : tx_load
      if ( !chip_select ) begin
	 // Clear TX register
	 rv_tx <= 0;
      end else begin
	 // Load data at port into transmit register
	 rv_tx <= vi_data;
      end
   end

   // State machine for shifting data out
   always @( negedge sck_core or negedge chip_select ) begin : tx_fsm
      if ( !chip_select ) begin
	 // Set data pointer to the MSB of the shift reg
	 rv_tx_ptr <= $unsigned(BITS_IN_BYTE - 1);
      end else begin
	 // Decerement the data pointer on the opposite clock phase
	 rv_tx_ptr <= rv_bit_ctr;
      end
   end
   // Point the output data to the correct bit in the tx_reg (not true shift)
   assign o_sdo = rv_tx[rv_tx_ptr];
endmodule

 module spi_top (
 i_chip_select,
 i_scn_clk,
 i_sdi,
 i_epol,
 i_cpol,
 i_cpha,
 i_rstb,
 in_p_of_n, in_iba_to_therm_encod, in_iba_to_dsm, in_y_of_n,
 o_sdo,
 vo_dlc_gain_sel_rw,
 vo_frac_alpha_rw,
 vo_integer_n_rw,
 vo_k_i_rw,
 vo_k_p_rw,
 vo_pole_location_shift_IIR_0_rw,
 vo_pole_location_shift_IIR_1_rw,
 vo_pole_location_shift_IIR_2_rw,
 vo_pole_location_shift_IIR_3_rw,
 vo_sel_time_ctrl_clk_alpha_and_accum_rw,
 vo_sel_time_ctrl_clk_dlc_rw,
 vo_sel_time_ctrl_clk_dco_drift_rw,
 vo_sel_time_ctrl_clk_fce_rw,
 vo_sel_time_ctrl_clk_dco_rw,
 vo_sel_width_of_vdiv_rw,
 vo_sel_width_of_rst_rw,
 vo_spi_to_fce_frac_part_rw,
 vo_spi_to_fce_int_part_rw,
 o_ena_IIR_0_rw,
 o_ena_IIR_1_rw,
 o_ena_IIR_2_rw,
 o_ena_IIR_3_rw,
 o_ena_free_running_DCO_frac_part_rw,
 o_ena_free_running_DCO_int_part_rw,
 o_ena_dco_drift_rw,
 vo_additional_freq_ctrl_rw,
 o_ena_pi_requant_rw,
 o_ena_rand_dem_rw,
 o_ena_rand_dsm_rw,
 o_ena_rand_iir0_rw,
 o_ena_rand_iir1_rw,
 o_ena_rand_iir2_rw,
 o_ena_rand_iir3_rw,
 o_ena_rand_pi_rw,
 o_ena_requantizer_IIR_0_rw,
 o_ena_requantizer_IIR_1_rw,
 o_ena_requantizer_IIR_2_rw,
 o_ena_requantizer_IIR_3_rw,
 o_enable_clk_fce_from_timing_ctrl_blk_rw,
 o_external_clk_fce_rw,
 o_enable_clk_additional_fce_from_timing_ctrl_blk_rw,
 o_external_clk_additional_fce_rw,
 o_param_enable_n1_rw,
 o_param_enable_n2_rw,
 o_param_enable_n3_rw,
 o_param_enable_n4_rw,
 o_param_enable_n5_rw,
 o_param_enable_n6_rw,
 o_param_enable_n7_rw,
 o_param_enable_n8_rw,
 o_param_enable_n9_rw,
 o_param_enable_n10_rw,
 o_param_enable_n11_rw,
 o_param_enable_n12_rw,
 o_param_enable_n13_rw,
 o_param_enable_n14_rw,
 o_param_enable_n15_rw,
 o_param_enable_n16_rw,
 vo_param_sel_ring_rw,
 vo_param_sel_divider_modulus_rw,
 o_param_sel_re_time_version_rw,
 o_rst_pll_rw,
 o_param_enable_tst_clk_rw,
 o_read_p_of_n_rw,
 o_read_iba_to_therm_enc_rw,
 o_read_iba_to_dsm_rw,
 o_read_y_of_n_rw
 );

//SPI inputs (chip set input)
input i_chip_select;
input i_scn_clk;
input i_sdi;
input i_epol;
input i_cpol;
input i_cpha;
input i_rstb;

input [23:0] in_p_of_n;
input [7:0]  in_iba_to_therm_encod;
input [15:0]  in_iba_to_dsm;
input [7:0]  in_y_of_n;

//SPI outputs (chip set output)
output o_sdo;

 
//Map's outputs 
output [2:0]  vo_dlc_gain_sel_rw;
output [15:0]  vo_frac_alpha_rw;
output [7:0]  vo_integer_n_rw;
output [3:0]  vo_k_i_rw;
output [3:0]  vo_k_p_rw;
output [2:0]  vo_pole_location_shift_IIR_0_rw;
output [2:0]  vo_pole_location_shift_IIR_1_rw;
output [2:0]  vo_pole_location_shift_IIR_2_rw;
output [2:0]  vo_pole_location_shift_IIR_3_rw;
output [2:0]  vo_sel_time_ctrl_clk_alpha_and_accum_rw;
output [2:0]  vo_sel_time_ctrl_clk_dlc_rw;
output [2:0]  vo_sel_time_ctrl_clk_dco_drift_rw;
output [2:0]  vo_sel_time_ctrl_clk_fce_rw;
output [2:0]  vo_sel_time_ctrl_clk_dco_rw;
output [1:0]  vo_sel_width_of_vdiv_rw;
output [1:0]  vo_sel_width_of_rst_rw;
output [7:0]  vo_spi_to_fce_frac_part_rw;
output [63:0]  vo_spi_to_fce_int_part_rw;
output [5:0]  vo_additional_freq_ctrl_rw;
output o_ena_IIR_0_rw;
output o_ena_IIR_1_rw;
output o_ena_IIR_2_rw;
output o_ena_IIR_3_rw;
output o_ena_free_running_DCO_frac_part_rw;
output o_ena_free_running_DCO_int_part_rw;
output o_ena_dco_drift_rw;
output o_ena_pi_requant_rw;
output o_ena_rand_dem_rw;
output o_ena_rand_dsm_rw;
output o_ena_rand_iir0_rw;
output o_ena_rand_iir1_rw;
output o_ena_rand_iir2_rw;
output o_ena_rand_iir3_rw;
output o_ena_rand_pi_rw;
output o_ena_requantizer_IIR_0_rw;
output o_ena_requantizer_IIR_1_rw;
output o_ena_requantizer_IIR_2_rw;
output o_ena_requantizer_IIR_3_rw;
output o_enable_clk_fce_from_timing_ctrl_blk_rw;
output o_external_clk_fce_rw;
output o_enable_clk_additional_fce_from_timing_ctrl_blk_rw;
output o_external_clk_additional_fce_rw;
output o_rst_pll_rw;
output o_param_enable_tst_clk_rw;

output o_param_enable_n1_rw;
output o_param_enable_n2_rw;
output o_param_enable_n3_rw;
output o_param_enable_n4_rw;
output o_param_enable_n5_rw;
output o_param_enable_n6_rw;
output o_param_enable_n7_rw;
output o_param_enable_n8_rw;
output o_param_enable_n9_rw;
output o_param_enable_n10_rw;
output o_param_enable_n11_rw;
output o_param_enable_n12_rw;
output o_param_enable_n13_rw;
output o_param_enable_n14_rw;
output o_param_enable_n15_rw;
output o_param_enable_n16_rw;
output [3:0] vo_param_sel_ring_rw;
output [2:0] vo_param_sel_divider_modulus_rw;
output o_param_sel_re_time_version_rw;

output o_read_p_of_n_rw;
output o_read_iba_to_therm_enc_rw;
output o_read_iba_to_dsm_rw;
output o_read_y_of_n_rw;


wire rst_pll_rw;
assign o_rst_pll_rw = rst_pll_rw && i_rstb;


//Wire to/from core
wire [2:0] byte_num;
wire [7:0] data_from_core;
wire [7:0] data_to_core_from_maps;
wire [7:0] data_to_core_from_regs;

wire  rx_valid; 

wire [7:0] opcode;
wire [7:0] address;
wire [7:0] data;



spi_core core_spi_module (
.o_sdo(o_sdo), 
.o_rx_valid(rx_valid), 
.vo_byte_num(byte_num), 
.vo_data(data_from_core),
.i_cs(i_chip_select), 
.i_sck(i_scn_clk), 
.i_sdi(i_sdi), 
.i_epol(i_epol), 
.i_cpol(i_cpol), 
.i_cpha(i_cpha), 
.vi_data(data_to_core_from_maps)
);



map_spi map_spi_module (
.vo_dlc_gain_sel_rw(vo_dlc_gain_sel_rw),
.vo_frac_alpha_rw(vo_frac_alpha_rw),
.vo_integer_n_rw(vo_integer_n_rw),
.vo_k_i_rw(vo_k_i_rw),
.vo_k_p_rw(vo_k_p_rw),
.vo_pole_location_shift_IIR_0_rw(vo_pole_location_shift_IIR_0_rw),
.vo_pole_location_shift_IIR_1_rw(vo_pole_location_shift_IIR_1_rw),
.vo_pole_location_shift_IIR_2_rw(vo_pole_location_shift_IIR_2_rw),
.vo_pole_location_shift_IIR_3_rw(vo_pole_location_shift_IIR_3_rw),
.vo_sel_time_ctrl_clk_alpha_and_accum_rw(vo_sel_time_ctrl_clk_alpha_and_accum_rw),
.vo_sel_time_ctrl_clk_dlc_rw(vo_sel_time_ctrl_clk_dlc_rw),
.vo_sel_time_ctrl_clk_dco_drift_rw(vo_sel_time_ctrl_clk_dco_drift_rw),
.vo_sel_time_ctrl_clk_fce_rw(vo_sel_time_ctrl_clk_fce_rw),
.vo_sel_time_ctrl_clk_dco_rw(vo_sel_time_ctrl_clk_dco_rw), 
.vo_sel_width_of_vdiv_rw(vo_sel_width_of_vdiv_rw),
.vo_sel_width_of_rst_rw(vo_sel_width_of_rst_rw),
.vo_spi_to_fce_frac_part_rw(vo_spi_to_fce_frac_part_rw),
.vo_spi_to_fce_int_part_rw(vo_spi_to_fce_int_part_rw),
.vo_additional_freq_ctrl_rw(vo_additional_freq_ctrl_rw), 
.o_ena_IIR_0_rw(o_ena_IIR_0_rw),
.o_ena_IIR_1_rw(o_ena_IIR_1_rw),
.o_ena_IIR_2_rw(o_ena_IIR_2_rw),
.o_ena_IIR_3_rw(o_ena_IIR_3_rw),
.o_ena_free_running_DCO_frac_part_rw(o_ena_free_running_DCO_frac_part_rw),
.o_ena_free_running_DCO_int_part_rw(o_ena_free_running_DCO_int_part_rw),
.o_ena_dco_drift_rw(o_ena_dco_drift_rw), //ADD TO MAP
.o_ena_pi_requant_rw(o_ena_pi_requant_rw),
.o_ena_rand_dem_rw(o_ena_rand_dem_rw),
.o_ena_rand_dsm_rw(o_ena_rand_dsm_rw),
.o_ena_rand_iir0_rw(o_ena_rand_iir0_rw),
.o_ena_rand_iir1_rw(o_ena_rand_iir1_rw),
.o_ena_rand_iir2_rw(o_ena_rand_iir2_rw),
.o_ena_rand_iir3_rw(o_ena_rand_iir3_rw),
.o_ena_rand_pi_rw(o_ena_rand_pi_rw),
.o_ena_requantizer_IIR_0_rw(o_ena_requantizer_IIR_0_rw),
.o_ena_requantizer_IIR_1_rw(o_ena_requantizer_IIR_1_rw),
.o_ena_requantizer_IIR_2_rw(o_ena_requantizer_IIR_2_rw),
.o_ena_requantizer_IIR_3_rw(o_ena_requantizer_IIR_3_rw),
.o_enable_clk_fce_from_timing_ctrl_blk_rw(o_enable_clk_fce_from_timing_ctrl_blk_rw),
.o_external_clk_fce_rw(o_external_clk_fce_rw),
.o_enable_clk_additional_fce_from_timing_ctrl_blk_rw(o_enable_clk_additional_fce_from_timing_ctrl_blk_rw),
.o_external_clk_additional_fce_rw(o_external_clk_additional_fce_rw),
.o_rst_pll_rw(rst_pll_rw),
.o_param_enable_n1_rw(o_param_enable_n1_rw),
.o_param_enable_n2_rw(o_param_enable_n2_rw),
.o_param_enable_n3_rw(o_param_enable_n3_rw),
.o_param_enable_n4_rw(o_param_enable_n4_rw),
.o_param_enable_n5_rw(o_param_enable_n5_rw),
.o_param_enable_n6_rw(o_param_enable_n6_rw),
.o_param_enable_n7_rw(o_param_enable_n7_rw),
.o_param_enable_n8_rw(o_param_enable_n8_rw),
.o_param_enable_n9_rw(o_param_enable_n9_rw),
.o_param_enable_n10_rw(o_param_enable_n10_rw),
.o_param_enable_n11_rw(o_param_enable_n11_rw),
.o_param_enable_n12_rw(o_param_enable_n12_rw),
.o_param_enable_n13_rw(o_param_enable_n13_rw),
.o_param_enable_n14_rw(o_param_enable_n14_rw),
.o_param_enable_n15_rw(o_param_enable_n15_rw),
.o_param_enable_n16_rw(o_param_enable_n16_rw),
.vo_param_sel_ring_rw(vo_param_sel_ring_rw),
.vo_param_sel_divider_modulus_rw(vo_param_sel_divider_modulus_rw),
.o_param_sel_re_time_version_rw(o_param_sel_re_time_version_rw),
.o_param_enable_tst_clk_rw(o_param_enable_tst_clk_rw),
.o_read_p_of_n_rw(o_read_p_of_n_rw),
.o_read_iba_to_therm_enc_rw(o_read_iba_to_therm_enc_rw),
.o_read_iba_to_dsm_rw(o_read_iba_to_dsm_rw),
.o_read_y_of_n_rw(o_read_y_of_n_rw),
.in_p_of_n(in_p_of_n),
.in_iba_to_therm_encod(in_iba_to_therm_encod),
.in_iba_to_dsm(in_iba_to_dsm),
.in_y_of_n(in_y_of_n),
.i_rx_valid(rx_valid),
.vi_data_from_core(data_from_core),
.vi_counter_byte(byte_num),
.i_rstb(i_rstb),
.i_sck(i_scn_clk),
.vo_data_to_core(data_to_core_from_maps)
);

endmodule
module testing_block (
	in_rstb,
	in_param_read_p_of_n,
	in_param_read_iba_to_therm_enc,
	in_param_read_iba_to_dsm,
	in_param_read_y_of_n,
	in_p_of_n,
	in_iba_to_therm,
	in_iba_to_dsm,
	in_y_of_n,
	out_to_spi_p_of_n,
	out_to_spi_iba_to_therm_encod,
	out_to_spi_iba_to_dsm,
	out_to_spi_y_of_n
	);

input in_rstb;
input in_param_read_p_of_n;
input in_param_read_iba_to_therm_enc;
input in_param_read_iba_to_dsm;
input in_param_read_y_of_n;

input [21:0] in_p_of_n;
input [5:0] in_iba_to_therm;
input [8:0] in_iba_to_dsm;
input in_y_of_n;

output [23:0] out_to_spi_p_of_n;
output [7:0]  out_to_spi_iba_to_therm_encod;
output [15:0]  out_to_spi_iba_to_dsm;
output [7:0]  out_to_spi_y_of_n;


reg [23:0] out_to_spi_p_of_n;
reg [7:0]  out_to_spi_iba_to_therm_encod;
reg [15:0]  out_to_spi_iba_to_dsm;
reg [7:0]  out_to_spi_y_of_n;


wire [23:0] p_of_n;
	assign p_of_n = $unsigned({{(2){1'b0}},in_p_of_n});
wire [7:0] iba_to_therm;
	assign iba_to_therm = $unsigned({{(2){1'b0}},in_iba_to_therm});
wire [15:0] iba_to_dsm;
	assign iba_to_dsm = $unsigned({{(7){1'b0}},in_iba_to_dsm});
wire [7:0] y_of_n;
	assign y_of_n = $unsigned({{(7){1'b0}},in_y_of_n});


always @(posedge in_param_read_p_of_n or negedge in_rstb) begin 
	if ( !in_rstb ) begin

		out_to_spi_p_of_n <= 0;

	end else begin

		out_to_spi_p_of_n <= p_of_n;

	end
end 




always @(posedge in_param_read_iba_to_therm_enc or negedge in_rstb) begin 
	if ( !in_rstb ) begin

		out_to_spi_iba_to_therm_encod <= 0;

	end else begin

		out_to_spi_iba_to_therm_encod <= iba_to_therm;

	end
end 



always @(posedge in_param_read_iba_to_dsm or negedge in_rstb) begin 
	if ( !in_rstb ) begin

		out_to_spi_iba_to_dsm <= 0;

	end else begin

		out_to_spi_iba_to_dsm <= iba_to_dsm;

	end
end 



always @(posedge in_param_read_y_of_n or negedge in_rstb) begin 
	if ( !in_rstb ) begin

		out_to_spi_y_of_n <= 0;

	end else begin

		out_to_spi_y_of_n <= y_of_n;

	end
end 


endmodule
// Made by Julian Puscar       julianpuscar@gmail.com       jpuscar@eng.ucsd.edu
/*


                                               ______
                     _________________________|     |
                    |          _______________| MUX |---> clk_alpha_and_accum
                    |         |         ______|     |
                    |         |         |     |_____|
clk_ref             |         |         |
    |        ____   |  ____   |  ____   |  ____      ____      ____
    |_______|    |  | |    |  | |    |  | |    |    |    |    |    |
	    |    |----|    |----|    |----|    |----|    |----|    |---> ...
	    |_b__|    |____|    |____|    |____|    |____|    |____|
clk_fast______|_________|__________|_________|_________|________|


Programmable Delay: in order to account for changes on clk_fast (that depends on the frequency of the pll output)






In order to have FREE RUNNING DCOs, there must be a way to externaly clock the FCEs.
As the following figure show: clk_fce can be controlled via spi.  1) enable_clk_fce = 0   2) extranl_clk_fce takes control
Normal opertaion of clk_fce:   1) enable_clk_fce = 1     2) external_clk_fce = 0
                     _____            ____
                    |     |          |    |
pre_out_clk_fce --->| AND |--------->| OR |---> out_clk_fce
                    |     |       __>|____|
enable_clk_fce----->|_____|      |    
                                 |
				 |
                    external_clk_fce






clk_dco needs to happen after clk_fce. In order to assure this happens, it is going to be added some variablity to the delay between these two clocks in case
RC delay was mis calcualted by the APR tool.



out_clk_fce                                       sel_time_ctrl_clk_dco
   |                                                      | 
   |      _____      _____                             ___|____
   |     |     |    |     |                           |        |
   | --->| INV |--->| INV |-------------------------->|        |
   |     |_____|    |_____|                           |        |
   |                                                  |        |
   |      _____      _____      _____      _____      |  MUX   |----> out_clk_dco
   |     |     |    |     |    |     |    |     |     |        |
   | --->| INV |--->| INV |--->| INV |--->| INV |---->|        |
   .     |_____|    |_____|    |_____|    |_____|     |        |
   .	                                              |________|
   .





*/



module timing_ctrl (
        in_rstb,
        in_clk_ref,
        in_clk_fast,
	in_param_sel_time_ctrl_clk_alpha_and_accum,
	in_param_sel_time_ctrl_clk_dlc,
	in_param_sel_time_ctrl_clk_dco_drift,
	in_param_sel_time_ctrl_clk_fce,
	in_param_sel_time_ctrl_clk_dco,
	in_param_enable_clk_fce,
	in_param_external_clk_fce,
	in_param_enable_clk_additional_fce,
	in_param_external_clk_additional_fce,
        out_clk_alpha_and_accum,
        out_clk_dlc,
	out_clk_dco_drift,
        out_clk_dco,
        out_clk_fce,
	out_clk_additional_fce
        );



input in_rstb;
input in_clk_ref, in_clk_fast;
input [2:0] in_param_sel_time_ctrl_clk_alpha_and_accum;
input [2:0] in_param_sel_time_ctrl_clk_dlc;
input [2:0] in_param_sel_time_ctrl_clk_dco_drift;
input [2:0] in_param_sel_time_ctrl_clk_fce;
input [2:0] in_param_sel_time_ctrl_clk_dco;
input in_param_enable_clk_fce;
input in_param_external_clk_fce;
input in_param_enable_clk_additional_fce;
input in_param_external_clk_additional_fce;
output  out_clk_alpha_and_accum, out_clk_dlc, out_clk_dco, out_clk_fce, out_clk_dco_drift, out_clk_additional_fce;


wire clk_fast_b;
wire register_n1_out, register_n2_out, register_n3_out, register_n4_out,register_n5_out, register_n6_out, register_n7_out;
wire register_n8_out, register_n9_out, register_n10_out, register_n11_out, register_n12_out, register_n13_out;

wire clk_fce_dly1;
wire clk_fce_dly2;
wire clk_fce_dly3;
wire clk_fce_dly4;
wire clk_fce_dly5;
wire clk_fce_dly6;
wire clk_fce_dly7;
wire clk_fce_dly8;
wire clk_fce_dly9;
wire clk_fce_dly10;

wire and_pre_out_clk_fce;
wire and_pre_out_clk_additional_fce;

assign clk_fast_b = ~in_clk_fast;


reg out_clk_alpha_and_accum;
reg out_clk_dlc;
reg pre_out_clk_fce;
reg out_clk_dco;
reg out_clk_dco_drift;


register_div_by_2 register_delay_n1 (
        .in_D(in_clk_ref),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),//(clk_fast_b),
        .out_Q(register_n1_out)
        );

register_div_by_2 register_delay_n2 (
        .in_D(register_n1_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n2_out)
        );
register_div_by_2 register_delay_n3 (
        .in_D(register_n2_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n3_out)
        );

register_div_by_2 register_delay_n4 (
        .in_D(register_n3_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n4_out)
        );

register_div_by_2 register_delay_n5 (
        .in_D(register_n4_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n5_out)
        );

register_div_by_2 register_delay_n6 (
        .in_D(register_n5_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n6_out)
        );

register_div_by_2 register_delay_n7 (
        .in_D(register_n6_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n7_out)
        );

register_div_by_2 register_delay_n8 (
        .in_D(register_n7_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n8_out)
        );

register_div_by_2 register_delay_n9 (
        .in_D(register_n8_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n9_out)
        );

register_div_by_2 register_delay_n10 (
        .in_D(register_n9_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n10_out)
        );

register_div_by_2 register_delay_n11 (
        .in_D(register_n10_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n11_out)
        );

register_div_by_2 register_delay_n12 (
        .in_D(register_n11_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n12_out)
        );

register_div_by_2 register_delay_n13 (
        .in_D(register_n12_out),
        .in_rstb(in_rstb),
        .in_clk(in_clk_fast),
        .out_Q(register_n13_out)
        );




always @(*) begin
	case( in_param_sel_time_ctrl_clk_alpha_and_accum )
        	0  : out_clk_alpha_and_accum = register_n2_out;
        	1  : out_clk_alpha_and_accum = register_n3_out;
		2  : out_clk_alpha_and_accum = register_n4_out;
		3  : out_clk_alpha_and_accum = register_n5_out;
		4  : out_clk_alpha_and_accum = register_n6_out;
		5  : out_clk_alpha_and_accum = register_n7_out;
		6  : out_clk_alpha_and_accum = register_n8_out;
		7  : out_clk_alpha_and_accum = register_n9_out;
        	default : out_clk_alpha_and_accum = register_n3_out;
      endcase 
end


always @(*) begin
	case( in_param_sel_time_ctrl_clk_dlc )
        	0  : out_clk_dlc = register_n4_out;
		1  : out_clk_dlc = register_n5_out;
		2  : out_clk_dlc = register_n6_out;
		3  : out_clk_dlc = register_n7_out;
		4  : out_clk_dlc = register_n8_out;
		5  : out_clk_dlc = register_n9_out;
		6  : out_clk_dlc = register_n10_out;
		7  : out_clk_dlc = register_n11_out;
        	default : out_clk_dlc = register_n9_out;
      endcase 
end



always @(*) begin
	case( in_param_sel_time_ctrl_clk_dco_drift )
        	0  : out_clk_dco_drift = register_n5_out;
		1  : out_clk_dco_drift = register_n6_out;
		2  : out_clk_dco_drift = register_n7_out;
		3  : out_clk_dco_drift = register_n8_out;
		4  : out_clk_dco_drift = register_n9_out;
		5  : out_clk_dco_drift = register_n10_out;
		6  : out_clk_dco_drift = register_n11_out;
		7  : out_clk_dco_drift = register_n12_out;
        	default : out_clk_dco_drift = register_n10_out;
      endcase 
end


always @(*) begin
	case( in_param_sel_time_ctrl_clk_fce )
        	0  : pre_out_clk_fce = register_n6_out;
        	1  : pre_out_clk_fce = register_n7_out;
        	2  : pre_out_clk_fce = register_n8_out;
        	3  : pre_out_clk_fce = register_n9_out;
        	4  : pre_out_clk_fce = register_n10_out;
        	5  : pre_out_clk_fce = register_n11_out;
        	6  : pre_out_clk_fce = register_n12_out;
        	7  : pre_out_clk_fce = register_n13_out;
        	default : pre_out_clk_fce = register_n13_out;
      endcase 
end


 

and2_logic and2_logic_clk_fce(
        .in_1(pre_out_clk_fce),
        .in_2(in_param_enable_clk_fce),
        .out(and_pre_out_clk_fce)
        );
or2_logic or2_logic_clk_fce(
        .in_1(and_pre_out_clk_fce),
        .in_2(in_param_external_clk_fce),
        .out(out_clk_fce)
        );	
		
and2_logic and2_logic_clk_additional_fce(
        .in_1(pre_out_clk_fce),
        .in_2(in_param_enable_clk_additional_fce),
        .out(and_pre_out_clk_additional_fce)
        );
or2_logic or2_logic_clk_additional_fce(
        .in_1(and_pre_out_clk_additional_fce),
        .in_2(in_param_external_clk_additional_fce),
        .out(out_clk_additional_fce)
        );		


inv_logic inv_logic_n1 (
        .in(out_clk_fce),
        .out(clk_fce_dly1)
        );

inv_logic inv_logic_n2 (
        .in(clk_fce_dly1),
        .out(clk_fce_dly2)
        );

inv_logic inv_logic_n3 (
        .in(clk_fce_dly2),
        .out(clk_fce_dly3)
        );

inv_logic inv_logic_n4 (
        .in(clk_fce_dly3),
        .out(clk_fce_dly4)
        );
	
inv_logic inv_logic_n5 (
        .in(clk_fce_dly4),
        .out(clk_fce_dly5)
        );

inv_logic inv_logic_n6 (
        .in(clk_fce_dly5),
        .out(clk_fce_dly6)
        );

inv_logic inv_logic_n7 (
        .in(clk_fce_dly6),
        .out(clk_fce_dly7)
        );

inv_logic inv_logic_n8 (
        .in(clk_fce_dly7),
        .out(clk_fce_dly8)
        );
	
inv_logic inv_logic_n9 (
        .in(clk_fce_dly8),
        .out(clk_fce_dly9)
        );

inv_logic inv_logic_n10 (
        .in(clk_fce_dly9),
        .out(clk_fce_dly10)
        );
	
	
always @(*) begin
	case( in_param_sel_time_ctrl_clk_dco )
        	0  : out_clk_dco = clk_fce_dly2;
        	1  : out_clk_dco = clk_fce_dly4;
        	2  : out_clk_dco = clk_fce_dly6;
        	3  : out_clk_dco = clk_fce_dly8;
        	4  : out_clk_dco = clk_fce_dly10;
		5  : out_clk_dco = clk_fce_dly10;
		6  : out_clk_dco = clk_fce_dly10;
		7  : out_clk_dco = clk_fce_dly10;
        	default : out_clk_dco = clk_fce_dly2;
      endcase 
end	
	
	

endmodule
module pll (
	in_clk_ref,
	in_chip_select,
	in_scn_clk,
	in_sdi,
	in_rstb,
	out_sdo,
	out_clk_tst,
	out_clk
	);


input in_clk_ref;
input in_chip_select;
input in_scn_clk;
input in_sdi;
input in_rstb;
output out_sdo;
output out_clk_tst;
output out_clk;


parameter NFRAC = 16;
parameter NINT = 7; //This means p[n] = 6.15


wire [7:0]  param_N;
wire [NFRAC-1:0]  param_alpha;
wire [1:0]  param_sel_width_of_vdiv;
wire [1:0]  param_sel_width_of_rst;
wire [2:0]  param_dlc_gain_sel;
wire [2:0]  param_pole_location_shift_IIR_0;
wire [2:0]  param_pole_location_shift_IIR_1;
wire [2:0]  param_pole_location_shift_IIR_2;
wire [2:0]  param_pole_location_shift_IIR_3;
wire  param_ena_IIR_0;
wire  param_ena_IIR_1;
wire  param_ena_IIR_2;
wire  param_ena_IIR_3;
wire  param_ena_requantizer_IIR_0;
wire  param_ena_requantizer_IIR_1;
wire  param_ena_requantizer_IIR_2;
wire  param_ena_requantizer_IIR_3;
wire [3:0]  param_k_p;
wire [3:0]  param_k_i;
wire  param_ena_pi_requant;
wire  param_ena_rand_pi;
wire  param_ena_rand_iir0;
wire  param_ena_rand_iir1;
wire  param_ena_rand_iir2;
wire  param_ena_rand_iir3;
wire  param_ena_rand_dsm;
wire  param_ena_rand_dem;
wire [2:0]  param_sel_time_ctrl_clk_alpha_and_accum;
wire [2:0]  param_sel_time_ctrl_clk_dlc;
wire [2:0]  param_sel_time_ctrl_clk_dco_drift;
wire [2:0]  param_sel_time_ctrl_clk_fce;
wire [2:0]  param_sel_time_ctrl_clk_dco;
wire  param_enable_clk_fce;
wire  param_external_clk_fce;
wire param_enable_clk_additional_fce;
wire param_external_clk_additional_fce;
wire  param_ena_free_running_DCO_int_part;
wire  param_ena_free_running_DCO_frac_part;
wire [63:0]  param_spi_to_fce_int_part;
wire [7:0]  param_spi_to_fce_frac_part;
wire param_enable_n1;
wire param_enable_n2;
wire param_enable_n3;
wire param_enable_n4;
wire param_enable_n5;
wire param_enable_n6;
wire param_enable_n7;
wire param_enable_n8;
wire param_enable_n9;
wire param_enable_n10;
wire param_enable_n11;
wire param_enable_n12;
wire param_enable_n13;
wire param_enable_n14;
wire param_enable_n15;
wire param_enable_n16;
wire [3:0] param_sel_ring;
wire [2:0] param_sel_divider_modulus;
wire param_sel_re_time_version;
wire [36:0] param_FCE_additional_ctrl;
wire param_ena_dco_drift;
wire [5:0] param_additional_freq_ctrl;
wire param_rst_pll;
wire param_enable_tst_clk;

wire param_read_p_of_n;
wire param_read_iba_to_therm_enc;
wire param_read_iba_to_dsm;
wire param_read_y_of_n;

wire [23:0] p_of_n; 
wire [7:0]  iba_to_therm_encod;
wire [15:0]  iba_to_dsm;
wire [7:0]  y_of_n;

spi_top spi_top(
	.i_chip_select(in_chip_select),
	.i_scn_clk(in_scn_clk),
	.i_sdi(in_sdi),
	.i_epol(1'b1),
	.i_cpol(1'b1),
	.i_cpha(1'b0),
	.i_rstb(in_rstb),
	.in_p_of_n(p_of_n), 
	.in_iba_to_therm_encod(iba_to_therm_encod), 
	.in_iba_to_dsm(iba_to_dsm), 
	.in_y_of_n(y_of_n),
	.o_sdo(out_sdo),
	.vo_dlc_gain_sel_rw(param_dlc_gain_sel),
	.vo_frac_alpha_rw(param_alpha),
	.vo_integer_n_rw(param_N),
	.vo_k_i_rw(param_k_i),
	.vo_k_p_rw(param_k_p),
	.vo_pole_location_shift_IIR_0_rw(param_pole_location_shift_IIR_0),
	.vo_pole_location_shift_IIR_1_rw(param_pole_location_shift_IIR_1),
	.vo_pole_location_shift_IIR_2_rw(param_pole_location_shift_IIR_2),
	.vo_pole_location_shift_IIR_3_rw(param_pole_location_shift_IIR_3),
	.vo_sel_time_ctrl_clk_alpha_and_accum_rw(param_sel_time_ctrl_clk_alpha_and_accum),
	.vo_sel_time_ctrl_clk_dlc_rw(param_sel_time_ctrl_clk_dlc),
	.vo_sel_time_ctrl_clk_dco_drift_rw(param_sel_time_ctrl_clk_dco_drift),
	.vo_sel_time_ctrl_clk_fce_rw(param_sel_time_ctrl_clk_fce),
	.vo_sel_time_ctrl_clk_dco_rw(param_sel_time_ctrl_clk_dco),
	.vo_sel_width_of_vdiv_rw(param_sel_width_of_vdiv),
	.vo_sel_width_of_rst_rw(param_sel_width_of_rst),
	.vo_spi_to_fce_frac_part_rw(param_spi_to_fce_frac_part),
	.vo_spi_to_fce_int_part_rw(param_spi_to_fce_int_part),
	.o_ena_dco_drift_rw(param_ena_dco_drift),
	.vo_additional_freq_ctrl_rw(param_additional_freq_ctrl),
	.o_ena_IIR_0_rw(param_ena_IIR_0),
	.o_ena_IIR_1_rw(param_ena_IIR_1),
	.o_ena_IIR_2_rw(param_ena_IIR_2),
	.o_ena_IIR_3_rw(param_ena_IIR_3),
	.o_ena_free_running_DCO_frac_part_rw(param_ena_free_running_DCO_frac_part),
	.o_ena_free_running_DCO_int_part_rw(param_ena_free_running_DCO_int_part),
	.o_ena_pi_requant_rw(param_ena_pi_requant),
	.o_ena_rand_dem_rw(param_ena_rand_dem),
	.o_ena_rand_dsm_rw(param_ena_rand_dsm),
	.o_ena_rand_iir0_rw(param_ena_rand_iir0),
	.o_ena_rand_iir1_rw(param_ena_rand_iir1),
	.o_ena_rand_iir2_rw(param_ena_rand_iir2),
	.o_ena_rand_iir3_rw(param_ena_rand_iir3),
	.o_ena_rand_pi_rw(param_ena_rand_pi),
	.o_ena_requantizer_IIR_0_rw(param_ena_requantizer_IIR_0),
	.o_ena_requantizer_IIR_1_rw(param_ena_requantizer_IIR_1),
	.o_ena_requantizer_IIR_2_rw(param_ena_requantizer_IIR_2),
	.o_ena_requantizer_IIR_3_rw(param_ena_requantizer_IIR_3),
	.o_enable_clk_fce_from_timing_ctrl_blk_rw(param_enable_clk_fce),
	.o_external_clk_fce_rw(param_external_clk_fce),
	.o_rst_pll_rw(param_rst_pll),
	.o_read_p_of_n_rw(param_read_p_of_n),
	.o_read_iba_to_therm_enc_rw(param_read_iba_to_therm_enc),
	.o_read_iba_to_dsm_rw(param_read_iba_to_dsm),
	.o_read_y_of_n_rw(param_read_y_of_n),
	.o_enable_clk_additional_fce_from_timing_ctrl_blk_rw(param_enable_clk_additional_fce),
	.o_external_clk_additional_fce_rw(param_external_clk_additional_fce),
	.o_param_enable_n1_rw(param_enable_n1),
 	.o_param_enable_n2_rw(param_enable_n2),
 	.o_param_enable_n3_rw(param_enable_n3),
 	.o_param_enable_n4_rw(param_enable_n4),
 	.o_param_enable_n5_rw(param_enable_n5),
 	.o_param_enable_n6_rw(param_enable_n6),
 	.o_param_enable_n7_rw(param_enable_n7),
 	.o_param_enable_n8_rw(param_enable_n8),
 	.o_param_enable_n9_rw(param_enable_n9),
 	.o_param_enable_n10_rw(param_enable_n10),
 	.o_param_enable_n11_rw(param_enable_n11),
 	.o_param_enable_n12_rw(param_enable_n12),
 	.o_param_enable_n13_rw(param_enable_n13),
 	.o_param_enable_n14_rw(param_enable_n14),
 	.o_param_enable_n15_rw(param_enable_n15),
 	.o_param_enable_n16_rw(param_enable_n16),
 	.vo_param_sel_ring_rw(param_sel_ring),
 	.vo_param_sel_divider_modulus_rw(param_sel_divider_modulus),
 	.o_param_sel_re_time_version_rw(param_sel_re_time_version),
	.o_param_enable_tst_clk_rw(param_enable_tst_clk)
	);


pll_loop pll_loop(
        .in_rstb(param_rst_pll),
        .in_clk_ref(in_clk_ref),
        .in_param_N(param_N),
        .in_param_alpha(param_alpha),
        .in_param_sel_width_of_vdiv(param_sel_width_of_vdiv),
	.in_param_sel_width_of_rst(param_sel_width_of_rst),
	.in_param_sel_time_ctrl_clk_alpha_and_accum(param_sel_time_ctrl_clk_alpha_and_accum),
	.in_param_sel_time_ctrl_clk_dlc(param_sel_time_ctrl_clk_dlc),
	.in_param_sel_time_ctrl_clk_dco_drift(param_sel_time_ctrl_clk_dco_drift),
	.in_param_sel_time_ctrl_clk_fce(param_sel_time_ctrl_clk_fce),
	.in_param_sel_time_ctrl_clk_dco(param_sel_time_ctrl_clk_dco),
	.in_param_enable_clk_fce(param_enable_clk_fce),
	.in_param_external_clk_fce(param_external_clk_fce),
	.in_param_enable_clk_additional_fce(param_enable_clk_additional_fce),
	.in_param_external_clk_additional_fce(param_external_clk_additional_fce),
        .in_param_dlc_gain_sel(param_dlc_gain_sel),
        .in_param_pole_location_shift_IIR_0(param_pole_location_shift_IIR_0),
        .in_param_pole_location_shift_IIR_1(param_pole_location_shift_IIR_1),
        .in_param_pole_location_shift_IIR_2(param_pole_location_shift_IIR_2),
        .in_param_pole_location_shift_IIR_3(param_pole_location_shift_IIR_3),
        .in_param_ena_IIR_0(param_ena_IIR_0),
        .in_param_ena_IIR_1(param_ena_IIR_1),
        .in_param_ena_IIR_2(param_ena_IIR_2),
        .in_param_ena_IIR_3(param_ena_IIR_3),
        .in_param_ena_requantizer_IIR_0(param_ena_requantizer_IIR_0),
        .in_param_ena_requantizer_IIR_1(param_ena_requantizer_IIR_1),
        .in_param_ena_requantizer_IIR_2(param_ena_requantizer_IIR_2),
        .in_param_ena_requantizer_IIR_3(param_ena_requantizer_IIR_3),
        .in_param_k_p(param_k_p),
        .in_param_k_i(param_k_i),
        .in_param_ena_pi_requant(param_ena_pi_requant),
        .in_param_ena_rand_pi(param_ena_rand_pi),
        .in_param_ena_rand_iir0(param_ena_rand_iir0),
        .in_param_ena_rand_iir1(param_ena_rand_iir1),
        .in_param_ena_rand_iir2(param_ena_rand_iir2),
        .in_param_ena_rand_iir3(param_ena_rand_iir3),
        .in_param_ena_rand_dsm(param_ena_rand_dsm),
        .in_param_ena_rand_dem(param_ena_rand_dem),
        .in_param_ena_free_running_DCO_int_part(param_ena_free_running_DCO_int_part),
        .in_param_ena_free_running_DCO_frac_part(param_ena_free_running_DCO_frac_part),
        .in_param_spi_to_fce_int_part(param_spi_to_fce_int_part),
        .in_param_spi_to_fce_frac_part(param_spi_to_fce_frac_part),
	.in_param_ena_dco_drift(param_ena_dco_drift),
	.in_param_enable_n1(param_enable_n1),
	.in_param_enable_n2(param_enable_n2),
	.in_param_enable_n3(param_enable_n3),
	.in_param_enable_n4(param_enable_n4),
	.in_param_enable_n5(param_enable_n5),
	.in_param_enable_n6(param_enable_n6),
	.in_param_enable_n7(param_enable_n7),
	.in_param_enable_n8(param_enable_n8),
	.in_param_enable_n9(param_enable_n9),
	.in_param_enable_n10(param_enable_n10),
	.in_param_enable_n11(param_enable_n11),
	.in_param_enable_n12(param_enable_n12),
	.in_param_enable_n13(param_enable_n13),
	.in_param_enable_n14(param_enable_n14),
	.in_param_enable_n15(param_enable_n15),
	.in_param_enable_n16(param_enable_n16),
	.in_param_sel_ring(param_sel_ring),
	.in_param_sel_divider_modulus(param_sel_divider_modulus),
        .in_param_sel_re_time_version(param_sel_re_time_version),
	.in_param_additional_freq_ctrl(param_additional_freq_ctrl),
	.in_param_read_p_of_n(param_read_p_of_n),
	.in_param_read_iba_to_therm_enc(param_read_iba_to_therm_enc),
	.in_param_read_iba_to_dsm(param_read_iba_to_dsm),
	.in_param_read_y_of_n(param_read_y_of_n),
	.out_to_spi_p_of_n(p_of_n),
	.out_to_spi_iba_to_therm_encod(iba_to_therm_encod),
	.out_to_spi_iba_to_dsm(iba_to_dsm),
	.out_to_spi_y_of_n(y_of_n),
        .out_clk(out_clk)
        );


assign out_clk_tst = (param_enable_tst_clk) ?  out_clk : 1'b0;


endmodule
