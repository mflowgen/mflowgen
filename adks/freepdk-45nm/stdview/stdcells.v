// 
// ******************************************************************************
// *                                                                            *
// *                   Copyright (C) 2004-2010, Nangate Inc.                    *
// *                           All rights reserved.                             *
// *                                                                            *
// * Nangate and the Nangate logo are trademarks of Nangate Inc.                *
// *                                                                            *
// * All trademarks, logos, software marks, and trade names (collectively the   *
// * "Marks") in this program are proprietary to Nangate or other respective    *
// * owners that have granted Nangate the right and license to use such Marks.  *
// * You are not permitted to use the Marks without the prior written consent   *
// * of Nangate or such third party that may own the Marks.                     *
// *                                                                            *
// * This file has been provided pursuant to a License Agreement containing     *
// * restrictions on its use. This file contains valuable trade secrets and     *
// * proprietary information of Nangate Inc., and is protected by U.S. and      *
// * international laws and/or treaties.                                        *
// *                                                                            *
// * The copyright notice(s) in this file does not indicate actual or intended  *
// * publication of this file.                                                  *
// *                                                                            *
// *      NGLibraryCharacterizer, Development_version - build 201012062042      *
// *                                                                            *
// ******************************************************************************
// 
// * Default delays
//   * comb. path delay        : 0.1
//   * seq. path delay         : 0.1
//   * delay cells             : 0.1
//   * timing checks           : 0.1
// 
// * NTC Setup
//   * Export NTC sections     : true
//   * Combine setup / hold    : true
//   * Combine recovery/removal: true
// 
// * Extras
//   * Export `celldefine      : false
//   * Export `timescale       : -
// 

module AND2_X1 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  and(ZN, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND2_X2 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  and(ZN, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND2_X4 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  and(ZN, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND3_X1 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  and(ZN, i_4, A3);
  and(i_4, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND3_X2 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  and(ZN, i_4, A3);
  and(i_4, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND3_X4 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  and(ZN, i_4, A3);
  and(i_4, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND4_X1 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  and(ZN, i_8, A4);
  and(i_8, i_9, A3);
  and(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND4_X2 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  and(ZN, i_8, A4);
  and(i_8, i_9, A3);
  and(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AND4_X4 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  and(ZN, i_8, A4);
  and(i_8, i_9, A3);
  and(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module ANTENNA_X1 (A);
  input A;

endmodule

module AOI211_X1 (A, B, C1, C2, ZN);
  input A;
  input B;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, A);
  or(i_13, i_14, B);
  and(i_14, C1, C2);

  specify
    if((B == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    (C1 => ZN) = (0.1, 0.1);
    (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI211_X2 (A, B, C1, C2, ZN);
  input A;
  input B;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, A);
  or(i_13, i_14, B);
  and(i_14, C1, C2);

  specify
    if((B == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    (C1 => ZN) = (0.1, 0.1);
    (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI211_X4 (A, B, C1, C2, ZN);
  input A;
  input B;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_20);
  not(i_20, i_21);
  not(i_21, i_22);
  or(i_22, i_23, A);
  or(i_23, i_24, B);
  and(i_24, C1, C2);

  specify
    if((B == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    (C1 => ZN) = (0.1, 0.1);
    (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI21_X1 (A, B1, B2, ZN);
  input A;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_8);
  or(i_8, A, i_9);
  and(i_9, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    (B1 => ZN) = (0.1, 0.1);
    (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI21_X2 (A, B1, B2, ZN);
  input A;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_8);
  or(i_8, A, i_9);
  and(i_9, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    (B1 => ZN) = (0.1, 0.1);
    (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI21_X4 (A, B1, B2, ZN);
  input A;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_8);
  or(i_8, A, i_9);
  and(i_9, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    (B1 => ZN) = (0.1, 0.1);
    (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI221_X1 (A, B1, B2, C1, C2, ZN);
  input A;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_16);
  or(i_16, i_17, i_19);
  or(i_17, i_18, A);
  and(i_18, C1, C2);
  and(i_19, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI221_X2 (A, B1, B2, C1, C2, ZN);
  input A;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_16);
  or(i_16, i_17, i_19);
  or(i_17, i_18, A);
  and(i_18, C1, C2);
  and(i_19, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI221_X4 (A, B1, B2, C1, C2, ZN);
  input A;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_24);
  not(i_24, i_25);
  not(i_25, i_26);
  or(i_26, i_27, i_29);
  or(i_27, i_28, A);
  and(i_28, C1, C2);
  and(i_29, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI222_X1 (A1, A2, B1, B2, C1, C2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_20);
  or(i_20, i_21, i_24);
  or(i_21, i_22, i_23);
  and(i_22, A1, A2);
  and(i_23, B1, B2);
  and(i_24, C1, C2);

  specify
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI222_X2 (A1, A2, B1, B2, C1, C2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_20);
  or(i_20, i_21, i_24);
  or(i_21, i_22, i_23);
  and(i_22, A1, A2);
  and(i_23, B1, B2);
  and(i_24, C1, C2);

  specify
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI222_X4 (A1, A2, B1, B2, C1, C2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_28);
  not(i_28, i_29);
  not(i_29, i_30);
  or(i_30, i_31, i_34);
  or(i_31, i_32, i_33);
  and(i_32, A1, A2);
  and(i_33, B1, B2);
  and(i_34, C1, C2);

  specify
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b1)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI22_X1 (A1, A2, B1, B2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, i_14);
  and(i_13, A1, A2);
  and(i_14, B1, B2);

  specify
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI22_X2 (A1, A2, B1, B2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, i_14);
  and(i_13, A1, A2);
  and(i_14, B1, B2);

  specify
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module AOI22_X4 (A1, A2, B1, B2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, i_14);
  and(i_13, A1, A2);
  and(i_14, B1, B2);

  specify
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module BUF_X1 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module BUF_X16 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module BUF_X2 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module BUF_X32 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module BUF_X4 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module BUF_X8 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module CLKBUF_X1 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module CLKBUF_X2 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

module CLKBUF_X3 (A, Z);
  input A;
  output Z;

  buf(Z, A);

  specify
    (A => Z) = (0.1, 0.1);
  endspecify

endmodule

primitive \seq_CLKGATETST_X1  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATETST_X1 (CK, E, SE, GCK);
  input CK;
  input E;
  input SE;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, IQ, CK_d);
    \seq_CLKGATETST_X1 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E_d, SE_d);

  `else
    and(GCK, IQ, CK);
    \seq_CLKGATETST_X1 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E, SE);

  `endif

  specify
    if((E == 1'b0) && (SE == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b0) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b0)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATETST_X2  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATETST_X2 (CK, E, SE, GCK);
  input CK;
  input E;
  input SE;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, IQ, CK_d);
    \seq_CLKGATETST_X2 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E_d, SE_d);

  `else
    and(GCK, IQ, CK);
    \seq_CLKGATETST_X2 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E, SE);

  `endif

  specify
    if((E == 1'b0) && (SE == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b0) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b0)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATETST_X4  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATETST_X4 (CK, E, SE, GCK);
  input CK;
  input E;
  input SE;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, IQ, CK_d);
    \seq_CLKGATETST_X4 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E_d, SE_d);

  `else
    and(GCK, IQ, CK);
    \seq_CLKGATETST_X4 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E, SE);

  `endif

  specify
    if((E == 1'b0) && (SE == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b0) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b0)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATETST_X8  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATETST_X8 (CK, E, SE, GCK);
  input CK;
  input E;
  input SE;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, IQ, CK_d);
    \seq_CLKGATETST_X8 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E_d, SE_d);

  `else
    and(GCK, IQ, CK);
    \seq_CLKGATETST_X8 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    or(nextstate, E, SE);

  `endif

  specify
    if((E == 1'b0) && (SE == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b0) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b0)) (CK => GCK) = (0.1, 0.1);
    if((E == 1'b1) && (SE == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATE_X1  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATE_X1 (CK, E, GCK);
  input CK;
  input E;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, CK_d, IQ);
    \seq_CLKGATE_X1 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E_d);

  `else
    and(GCK, CK, IQ);
    \seq_CLKGATE_X1 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E);

  `endif

  specify
    if((E == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATE_X2  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATE_X2 (CK, E, GCK);
  input CK;
  input E;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, CK_d, IQ);
    \seq_CLKGATE_X2 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E_d);

  `else
    and(GCK, CK, IQ);
    \seq_CLKGATE_X2 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E);

  `endif

  specify
    if((E == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATE_X4  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATE_X4 (CK, E, GCK);
  input CK;
  input E;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, CK_d, IQ);
    \seq_CLKGATE_X4 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E_d);

  `else
    and(GCK, CK, IQ);
    \seq_CLKGATE_X4 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E);

  `endif

  specify
    if((E == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_CLKGATE_X8  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module CLKGATE_X8 (CK, E, GCK);
  input CK;
  input E;
  output GCK;
  reg NOTIFIER;

  `ifdef NTC
    and(GCK, CK_d, IQ);
    \seq_CLKGATE_X8 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E_d);

  `else
    and(GCK, CK, IQ);
    \seq_CLKGATE_X8 (IQ, nextstate, CK, NOTIFIER);
    not(IQn, IQ);
    buf(nextstate, E);

  `endif

  specify
    if((E == 1'b0)) (negedge CK => (GCK +: 1'b0)) = (0.1, 0.1);
    if((E == 1'b1)) (CK => GCK) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER, , ,CK_d, E_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge E, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge E, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFFRS_X1  (IQ, SN, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN          RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           ?           0           r           ?       : ? :           0;
           ?           1           1           r           ?       : ? :           1;
           1           ?           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           1           ?           ?           ?       : ? :           1; // SN activated
           *           1           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           0           ?           ?           ?       : ? :           0; // RN activated
           1           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFFRS_X1 (D, RN, SN, CK, Q, QN);
  input D;
  input RN;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
      buf (RN_d, RN_di);
    `else
      buf (SN_d, SN);
      buf (RN_d, RN);
    `endif
    \seq_DFFRS_X1 (IQ, SN_d, RN_d, nextstate, CK_d, NOTIFIER);
    and(IQN, i_10, i_11);
    not(i_10, IQ);
    not(i_11, i_12);
    and(i_12, i_13, i_14);
    not(i_13, SN_d);
    not(i_14, RN_d);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

    // Delayed data/reference logic
    and(id_14, SN_d, RN_d);
    // SDF Logic
    buf(RNx, RN_d);
    and(RN_AND_SNx, RN_d, SN_d);
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_14, id_14, 1'b1);
    `endif
  `else
    \seq_DFFRS_X1 (IQ, SN, RN, nextstate, CK, NOTIFIER);
    and(IQN, i_10, i_11);
    not(i_10, IQ);
    not(i_11, i_12);
    and(i_12, i_13, i_14);
    not(i_13, SN);
    not(i_14, RN);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

    // Delayed data/reference logic
    and(id_10, SN, RN);
    // SDF Logic
    buf(RNx, RN);
    and(RN_AND_SNx, RN, SN);
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_10, id_10, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK &&& (SN === 1'b1), 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
        $recrem(posedge SN, posedge CK &&& (RN === 1'b1), 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
        $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK &&& (RN === 1'b1), posedge SN, 0.1, NOTIFIER);
      $hold(posedge CK &&& (SN === 1'b1), posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFFRS_X2  (IQ, SN, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN          RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           ?           0           r           ?       : ? :           0;
           ?           1           1           r           ?       : ? :           1;
           1           ?           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           1           ?           ?           ?       : ? :           1; // SN activated
           *           1           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           0           ?           ?           ?       : ? :           0; // RN activated
           1           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFFRS_X2 (D, RN, SN, CK, Q, QN);
  input D;
  input RN;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
      buf (RN_d, RN_di);
    `else
      buf (SN_d, SN);
      buf (RN_d, RN);
    `endif
    \seq_DFFRS_X2 (IQ, SN_d, RN_d, nextstate, CK_d, NOTIFIER);
    and(IQN, i_10, i_11);
    not(i_10, IQ);
    not(i_11, i_12);
    and(i_12, i_13, i_14);
    not(i_13, SN_d);
    not(i_14, RN_d);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

    // Delayed data/reference logic
    and(id_14, SN_d, RN_d);
    // SDF Logic
    buf(RNx, RN_d);
    and(RN_AND_SNx, RN_d, SN_d);
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_14, id_14, 1'b1);
    `endif
  `else
    \seq_DFFRS_X2 (IQ, SN, RN, nextstate, CK, NOTIFIER);
    and(IQN, i_10, i_11);
    not(i_10, IQ);
    not(i_11, i_12);
    and(i_12, i_13, i_14);
    not(i_13, SN);
    not(i_14, RN);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

    // Delayed data/reference logic
    and(id_10, SN, RN);
    // SDF Logic
    buf(RNx, RN);
    and(RN_AND_SNx, RN, SN);
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_10, id_10, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK &&& (SN === 1'b1), 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
        $recrem(posedge SN, posedge CK &&& (RN === 1'b1), 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
        $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK &&& (RN === 1'b1), posedge SN, 0.1, NOTIFIER);
      $hold(posedge CK &&& (SN === 1'b1), posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFFR_X1  (IQ, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           ?           0           r           ?       : ? :           0;
           1           1           r           ?       : ? :           1;
           ?           0           *           ?       : 0 :           0; // reduce pessimism
           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           0; // RN activated
           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFFR_X1 (D, RN, CK, Q, QN);
  input D;
  input RN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (RN_d, RN_di);
    `else
      buf (RN_d, RN);
    `endif
    \seq_DFFR_X1 (IQ, RN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

    // Delayed data/reference logic
    buf(id_8, RN_d);
    // SDF Logic
    buf(RNx, RN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(xid_8, id_8, 1'b1);
    `endif
  `else
    \seq_DFFR_X1 (IQ, RN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

    // Delayed data/reference logic
    buf(id_6, RN);
    // SDF Logic
    buf(RNx, RN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(xid_6, id_6, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK, 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFFR_X2  (IQ, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           ?           0           r           ?       : ? :           0;
           1           1           r           ?       : ? :           1;
           ?           0           *           ?       : 0 :           0; // reduce pessimism
           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           0; // RN activated
           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFFR_X2 (D, RN, CK, Q, QN);
  input D;
  input RN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (RN_d, RN_di);
    `else
      buf (RN_d, RN);
    `endif
    \seq_DFFR_X2 (IQ, RN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

    // Delayed data/reference logic
    buf(id_8, RN_d);
    // SDF Logic
    buf(RNx, RN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(xid_8, id_8, 1'b1);
    `endif
  `else
    \seq_DFFR_X2 (IQ, RN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

    // Delayed data/reference logic
    buf(id_6, RN);
    // SDF Logic
    buf(RNx, RN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(xid_6, id_6, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK, 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFFS_X1  (IQ, SN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           0           r           ?       : ? :           0;
           ?           1           r           ?       : ? :           1;
           1           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           1; // SN activated
           *           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFFS_X1 (D, SN, CK, Q, QN);
  input D;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
    `else
      buf (SN_d, SN);
    `endif
    \seq_DFFS_X1 (IQ, SN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

    // Delayed data/reference logic
    buf(id_8, SN_d);
    // SDF Logic
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_8, id_8, 1'b1);
    `endif
  `else
    \seq_DFFS_X1 (IQ, SN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

    // Delayed data/reference logic
    buf(id_6, SN);
    // SDF Logic
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_6, id_6, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge SN, posedge CK, 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
      $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFFS_X2  (IQ, SN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           0           r           ?       : ? :           0;
           ?           1           r           ?       : ? :           1;
           1           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           1; // SN activated
           *           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFFS_X2 (D, SN, CK, Q, QN);
  input D;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
    `else
      buf (SN_d, SN);
    `endif
    \seq_DFFS_X2 (IQ, SN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

    // Delayed data/reference logic
    buf(id_8, SN_d);
    // SDF Logic
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_8, id_8, 1'b1);
    `endif
  `else
    \seq_DFFS_X2 (IQ, SN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

    // Delayed data/reference logic
    buf(id_6, SN);
    // SDF Logic
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_6, id_6, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge SN, posedge CK, 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
      $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFF_X1  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           r           ?       : ? :           0;
           1           r           ?       : ? :           1;
           0           *           ?       : 0 :           0; // reduce pessimism
           1           *           ?       : 1 :           1; // reduce pessimism
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFF_X1 (D, CK, Q, QN);
  input D;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    \seq_DFF_X1 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

  `else
    \seq_DFF_X1 (IQ, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK, posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DFF_X2  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           r           ?       : ? :           0;
           1           r           ?       : ? :           1;
           0           *           ?       : 0 :           0; // reduce pessimism
           1           *           ?       : 1 :           1; // reduce pessimism
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DFF_X2 (D, CK, Q, QN);
  input D;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    \seq_DFF_X2 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D_d);

  `else
    \seq_DFF_X2 (IQ, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    buf(nextstate, D);

  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK, negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK, posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DLH_X1  (IQ, nextstate, G, NOTIFIER);
  output IQ;
  input nextstate;
  input G;
  input NOTIFIER;
  reg IQ;

  table
// nextstate           G    NOTIFIER     : @IQ :          IQ
           0           1           ?       : ? :           0;
           1           1           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           0           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DLH_X1 (D, G, Q);
  input D;
  input G;
  output Q;
  reg NOTIFIER;

  `ifdef NTC
    \seq_DLH_X1 (IQ, nextstate, G_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D_d);

  `else
    \seq_DLH_X1 (IQ, nextstate, G, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D);

  `endif

  specify
    (D => Q) = (0.1, 0.1);
    (posedge G => (Q +: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(negedge G, negedge D, 0.1, 0.1, NOTIFIER, , ,G_d, D_d);
      $setuphold(negedge G, posedge D, 0.1, 0.1, NOTIFIER, , ,G_d, D_d);
      $width(posedge G, 0.1, 0, NOTIFIER);
    `else
      $setuphold(negedge G, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(negedge G, posedge D, 0.1, 0.1, NOTIFIER);
      $width(posedge G, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DLH_X2  (IQ, nextstate, G, NOTIFIER);
  output IQ;
  input nextstate;
  input G;
  input NOTIFIER;
  reg IQ;

  table
// nextstate           G    NOTIFIER     : @IQ :          IQ
           0           1           ?       : ? :           0;
           1           1           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           0           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DLH_X2 (D, G, Q);
  input D;
  input G;
  output Q;
  reg NOTIFIER;

  `ifdef NTC
    \seq_DLH_X2 (IQ, nextstate, G_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D_d);

  `else
    \seq_DLH_X2 (IQ, nextstate, G, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D);

  `endif

  specify
    (D => Q) = (0.1, 0.1);
    (posedge G => (Q +: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(negedge G, negedge D, 0.1, 0.1, NOTIFIER, , ,G_d, D_d);
      $setuphold(negedge G, posedge D, 0.1, 0.1, NOTIFIER, , ,G_d, D_d);
      $width(posedge G, 0.1, 0, NOTIFIER);
    `else
      $setuphold(negedge G, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(negedge G, posedge D, 0.1, 0.1, NOTIFIER);
      $width(posedge G, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DLL_X1  (IQ, nextstate, GN, NOTIFIER);
  output IQ;
  input nextstate;
  input GN;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          GN    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DLL_X1 (D, GN, Q);
  input D;
  input GN;
  output Q;
  reg NOTIFIER;

  `ifdef NTC
    \seq_DLL_X1 (IQ, nextstate, GN_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D_d);

  `else
    \seq_DLL_X1 (IQ, nextstate, GN, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D);

  `endif

  specify
    (D => Q) = (0.1, 0.1);
    (negedge GN => (Q +: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge GN, negedge D, 0.1, 0.1, NOTIFIER, , ,GN_d, D_d);
      $setuphold(posedge GN, posedge D, 0.1, 0.1, NOTIFIER, , ,GN_d, D_d);
      $width(negedge GN, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge GN, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge GN, posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge GN, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_DLL_X2  (IQ, nextstate, GN, NOTIFIER);
  output IQ;
  input nextstate;
  input GN;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          GN    NOTIFIER     : @IQ :          IQ
           0           0           ?       : ? :           0;
           1           0           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           1           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module DLL_X2 (D, GN, Q);
  input D;
  input GN;
  output Q;
  reg NOTIFIER;

  `ifdef NTC
    \seq_DLL_X2 (IQ, nextstate, GN_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D_d);

  `else
    \seq_DLL_X2 (IQ, nextstate, GN, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(nextstate, D);

  `endif

  specify
    (D => Q) = (0.1, 0.1);
    (negedge GN => (Q +: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge GN, negedge D, 0.1, 0.1, NOTIFIER, , ,GN_d, D_d);
      $setuphold(posedge GN, posedge D, 0.1, 0.1, NOTIFIER, , ,GN_d, D_d);
      $width(negedge GN, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge GN, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge GN, posedge D, 0.1, 0.1, NOTIFIER);
      $width(negedge GN, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

module FA_X1 (A, B, CI, CO, S);
  input A;
  input B;
  input CI;
  output CO;
  output S;

  or(CO, i_16, i_17);
  and(i_16, A, B);
  and(i_17, CI, i_18);
  or(i_18, A, B);
  xor(S, CI, i_22);
  xor(i_22, A, B);

  specify
    if((B == 1'b0) && (CI == 1'b1)) (A => CO) = (0.1, 0.1);
    if((B == 1'b1) && (CI == 1'b0)) (A => CO) = (0.1, 0.1);
    if((A == 1'b0) && (CI == 1'b1)) (B => CO) = (0.1, 0.1);
    if((A == 1'b1) && (CI == 1'b0)) (B => CO) = (0.1, 0.1);
    if((A == 1'b0) && (B == 1'b1)) (CI => CO) = (0.1, 0.1);
    if((A == 1'b1) && (B == 1'b0)) (CI => CO) = (0.1, 0.1);
    if((B == 1'b0) && (CI == 1'b0)) (A => S) = (0.1, 0.1);
    if((B == 1'b0) && (CI == 1'b1)) (A => S) = (0.1, 0.1);
    if((B == 1'b1) && (CI == 1'b0)) (A => S) = (0.1, 0.1);
    if((B == 1'b1) && (CI == 1'b1)) (A => S) = (0.1, 0.1);
    if((A == 1'b0) && (CI == 1'b0)) (B => S) = (0.1, 0.1);
    if((A == 1'b0) && (CI == 1'b1)) (B => S) = (0.1, 0.1);
    if((A == 1'b1) && (CI == 1'b0)) (B => S) = (0.1, 0.1);
    if((A == 1'b1) && (CI == 1'b1)) (B => S) = (0.1, 0.1);
    if((A == 1'b0) && (B == 1'b0)) (CI => S) = (0.1, 0.1);
    if((A == 1'b0) && (B == 1'b1)) (CI => S) = (0.1, 0.1);
    if((A == 1'b1) && (B == 1'b0)) (CI => S) = (0.1, 0.1);
    if((A == 1'b1) && (B == 1'b1)) (CI => S) = (0.1, 0.1);
  endspecify

endmodule

module FILLCELL_X1 ();

endmodule

module FILLCELL_X2 ();

endmodule

module FILLCELL_X4 ();

endmodule

module FILLCELL_X8 ();

endmodule

module FILLCELL_X16 ();

endmodule

module FILLCELL_X32 ();

endmodule

module HA_X1 (A, B, CO, S);
  input A;
  input B;
  output CO;
  output S;

  and(CO, A, B);
  xor(S, A, B);

  specify
    (A => CO) = (0.1, 0.1);
    (B => CO) = (0.1, 0.1);
    if((B == 1'b0)) (A => S) = (0.1, 0.1);
    if((B == 1'b1)) (A => S) = (0.1, 0.1);
    if((A == 1'b0)) (B => S) = (0.1, 0.1);
    if((A == 1'b1)) (B => S) = (0.1, 0.1);
  endspecify

endmodule

module INV_X1 (A, ZN);
  input A;
  output ZN;

  not(ZN, A);

  specify
    (A => ZN) = (0.1, 0.1);
  endspecify

endmodule

module INV_X16 (A, ZN);
  input A;
  output ZN;

  not(ZN, A);

  specify
    (A => ZN) = (0.1, 0.1);
  endspecify

endmodule

module INV_X2 (A, ZN);
  input A;
  output ZN;

  not(ZN, A);

  specify
    (A => ZN) = (0.1, 0.1);
  endspecify

endmodule

module INV_X32 (A, ZN);
  input A;
  output ZN;

  not(ZN, A);

  specify
    (A => ZN) = (0.1, 0.1);
  endspecify

endmodule

module INV_X4 (A, ZN);
  input A;
  output ZN;

  not(ZN, A);

  specify
    (A => ZN) = (0.1, 0.1);
  endspecify

endmodule

module INV_X8 (A, ZN);
  input A;
  output ZN;

  not(ZN, A);

  specify
    (A => ZN) = (0.1, 0.1);
  endspecify

endmodule

module LOGIC0_X1 (Z);
  output Z;

  buf(Z, 0);
endmodule

module LOGIC1_X1 (Z);
  output Z;

  buf(Z, 1);
endmodule

module MUX2_X1 (A, B, S, Z);
  input A;
  input B;
  input S;
  output Z;

  or(Z, i_12, i_13);
  and(i_12, S, B);
  and(i_13, A, i_14);
  not(i_14, S);

  specify
    if((B == 1'b0) && (S == 1'b0)) (A => Z) = (0.1, 0.1);
    if((B == 1'b1) && (S == 1'b0)) (A => Z) = (0.1, 0.1);
    if((A == 1'b0) && (S == 1'b1)) (B => Z) = (0.1, 0.1);
    if((A == 1'b1) && (S == 1'b1)) (B => Z) = (0.1, 0.1);
    if((A == 1'b0) && (B == 1'b1)) (S => Z) = (0.1, 0.1);
    if((A == 1'b1) && (B == 1'b0)) (S => Z) = (0.1, 0.1);
  endspecify

endmodule

module MUX2_X2 (A, B, S, Z);
  input A;
  input B;
  input S;
  output Z;

  or(Z, i_12, i_13);
  and(i_12, S, B);
  and(i_13, A, i_14);
  not(i_14, S);

  specify
    if((B == 1'b0) && (S == 1'b0)) (A => Z) = (0.1, 0.1);
    if((B == 1'b1) && (S == 1'b0)) (A => Z) = (0.1, 0.1);
    if((A == 1'b0) && (S == 1'b1)) (B => Z) = (0.1, 0.1);
    if((A == 1'b1) && (S == 1'b1)) (B => Z) = (0.1, 0.1);
    if((A == 1'b0) && (B == 1'b1)) (S => Z) = (0.1, 0.1);
    if((A == 1'b1) && (B == 1'b0)) (S => Z) = (0.1, 0.1);
  endspecify

endmodule

module NAND2_X1 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  not(ZN, i_10);
  and(i_10, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND2_X2 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  not(ZN, i_22);
  and(i_22, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND2_X4 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  not(ZN, i_10);
  and(i_10, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND3_X1 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  not(ZN, i_8);
  and(i_8, i_9, A3);
  and(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND3_X2 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  not(ZN, i_8);
  and(i_8, i_9, A3);
  and(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND3_X4 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  not(ZN, i_8);
  and(i_8, i_9, A3);
  and(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND4_X1 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, A4);
  and(i_13, i_14, A3);
  and(i_14, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND4_X2 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, A4);
  and(i_13, i_14, A3);
  and(i_14, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NAND4_X4 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, A4);
  and(i_13, i_14, A3);
  and(i_14, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR2_X1 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  not(ZN, i_10);
  or(i_10, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR2_X2 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  not(ZN, i_10);
  or(i_10, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR2_X4 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  not(ZN, i_16);
  or(i_16, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR3_X1 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  not(ZN, i_8);
  or(i_8, i_9, A3);
  or(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR3_X2 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  not(ZN, i_8);
  or(i_8, i_9, A3);
  or(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR3_X4 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  not(ZN, i_8);
  or(i_8, i_9, A3);
  or(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR4_X1 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, A4);
  or(i_13, i_14, A3);
  or(i_14, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR4_X2 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, A4);
  or(i_13, i_14, A3);
  or(i_14, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module NOR4_X4 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  not(ZN, i_12);
  or(i_12, i_13, A4);
  or(i_13, i_14, A3);
  or(i_14, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI211_X1 (A, B, C1, C2, ZN);
  input A;
  input B;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, B);
  and(i_13, i_14, A);
  or(i_14, C1, C2);

  specify
    if((B == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    (C1 => ZN) = (0.1, 0.1);
    (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI211_X2 (A, B, C1, C2, ZN);
  input A;
  input B;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, B);
  and(i_13, i_14, A);
  or(i_14, C1, C2);

  specify
    if((B == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    (C1 => ZN) = (0.1, 0.1);
    (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI211_X4 (A, B, C1, C2, ZN);
  input A;
  input B;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, B);
  and(i_13, i_14, A);
  or(i_14, C1, C2);

  specify
    if((B == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (B => ZN) = (0.1, 0.1);
    (C1 => ZN) = (0.1, 0.1);
    (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI21_X1 (A, B1, B2, ZN);
  input A;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_8);
  and(i_8, A, i_9);
  or(i_9, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    (B1 => ZN) = (0.1, 0.1);
    (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI21_X2 (A, B1, B2, ZN);
  input A;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_8);
  and(i_8, A, i_9);
  or(i_9, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    (B1 => ZN) = (0.1, 0.1);
    (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI21_X4 (A, B1, B2, ZN);
  input A;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_8);
  and(i_8, A, i_9);
  or(i_9, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    (B1 => ZN) = (0.1, 0.1);
    (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI221_X1 (A, B1, B2, C1, C2, ZN);
  input A;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_16);
  and(i_16, i_17, i_19);
  and(i_17, i_18, A);
  or(i_18, C1, C2);
  or(i_19, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI221_X2 (A, B1, B2, C1, C2, ZN);
  input A;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_16);
  and(i_16, i_17, i_19);
  and(i_17, i_18, A);
  or(i_18, C1, C2);
  or(i_19, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI221_X4 (A, B1, B2, C1, C2, ZN);
  input A;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_24);
  not(i_24, i_25);
  not(i_25, i_26);
  and(i_26, i_27, i_29);
  and(i_27, i_28, A);
  or(i_28, C1, C2);
  or(i_29, B1, B2);

  specify
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI222_X1 (A1, A2, B1, B2, C1, C2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_20);
  and(i_20, i_21, i_24);
  and(i_21, i_22, i_23);
  or(i_22, A1, A2);
  or(i_23, B1, B2);
  or(i_24, C1, C2);

  specify
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI222_X2 (A1, A2, B1, B2, C1, C2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_20);
  and(i_20, i_21, i_24);
  and(i_21, i_22, i_23);
  or(i_22, A1, A2);
  or(i_23, B1, B2);
  or(i_24, C1, C2);

  specify
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI222_X4 (A1, A2, B1, B2, C1, C2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  input C1;
  input C2;
  output ZN;

  not(ZN, i_28);
  not(i_28, i_29);
  not(i_29, i_30);
  and(i_30, i_31, i_34);
  and(i_31, i_32, i_33);
  or(i_32, A1, A2);
  or(i_33, B1, B2);
  or(i_34, C1, C2);

  specify
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b1) && (C2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b0) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (C1 == 1'b1) && (C2 == 1'b1)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C2 == 1'b0)) (C1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b0) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b1) && (B2 == 1'b1) && (C1 == 1'b0)) (C2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI22_X1 (A1, A2, B1, B2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, i_14);
  or(i_13, A1, A2);
  or(i_14, B1, B2);

  specify
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI22_X2 (A1, A2, B1, B2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, i_14);
  or(i_13, A1, A2);
  or(i_14, B1, B2);

  specify
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI22_X4 (A1, A2, B1, B2, ZN);
  input A1;
  input A2;
  input B1;
  input B2;
  output ZN;

  not(ZN, i_12);
  and(i_12, i_13, i_14);
  or(i_13, A1, A2);
  or(i_14, B1, B2);

  specify
    if((A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B2 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (B1 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OAI33_X1 (A1, A2, A3, B1, B2, B3, ZN);
  input A1;
  input A2;
  input A3;
  input B1;
  input B2;
  input B3;
  output ZN;

  not(ZN, i_20);
  and(i_20, i_21, i_23);
  or(i_21, i_22, A3);
  or(i_22, A1, A2);
  or(i_23, i_24, B3);
  or(i_24, B1, B2);

  specify
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (B3 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (B3 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (B3 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (B3 == 1'b0)) (A1 => ZN) = (0.1, 0.1);
    if((A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (B3 == 1'b1)) (A1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (B3 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (B3 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (B3 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (B3 == 1'b0)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (B3 == 1'b1)) (A2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0) && (B3 == 1'b1)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (B3 == 1'b0)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b1) && (B3 == 1'b1)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b1)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (B3 == 1'b0)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1) && (B2 == 1'b1) && (B3 == 1'b1)) (A3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (A3 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (A3 == 1'b0) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (A3 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (A3 == 1'b0) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (A3 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (A3 == 1'b0) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (A3 == 1'b1) && (B2 == 1'b0) && (B3 == 1'b0)) (B1 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (A3 == 1'b1) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (A3 == 1'b0) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (A3 == 1'b1) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (A3 == 1'b1) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (A3 == 1'b0) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (A3 == 1'b1) && (B1 == 1'b0) && (B3 == 1'b0)) (B2 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b0) && (A3 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b0) && (A2 == 1'b1) && (A3 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b0) && (A3 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (A3 == 1'b0) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
    if((A1 == 1'b1) && (A2 == 1'b1) && (A3 == 1'b1) && (B1 == 1'b0) && (B2 == 1'b0)) (B3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR2_X1 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  or(ZN, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR2_X2 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  or(ZN, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR2_X4 (A1, A2, ZN);
  input A1;
  input A2;
  output ZN;

  or(ZN, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR3_X1 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  or(ZN, i_4, A3);
  or(i_4, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR3_X2 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  or(ZN, i_4, A3);
  or(i_4, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR3_X4 (A1, A2, A3, ZN);
  input A1;
  input A2;
  input A3;
  output ZN;

  or(ZN, i_4, A3);
  or(i_4, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR4_X1 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  or(ZN, i_8, A4);
  or(i_8, i_9, A3);
  or(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR4_X2 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  or(ZN, i_8, A4);
  or(i_8, i_9, A3);
  or(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

module OR4_X4 (A1, A2, A3, A4, ZN);
  input A1;
  input A2;
  input A3;
  input A4;
  output ZN;

  or(ZN, i_8, A4);
  or(i_8, i_9, A3);
  or(i_9, A1, A2);

  specify
    (A1 => ZN) = (0.1, 0.1);
    (A2 => ZN) = (0.1, 0.1);
    (A3 => ZN) = (0.1, 0.1);
    (A4 => ZN) = (0.1, 0.1);
  endspecify

endmodule

primitive \seq_SDFFRS_X1  (IQ, SN, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN          RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           ?           0           r           ?       : ? :           0;
           ?           1           1           r           ?       : ? :           1;
           1           ?           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           1           ?           ?           ?       : ? :           1; // SN activated
           *           1           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           0           ?           ?           ?       : ? :           0; // RN activated
           1           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFFRS_X1 (D, RN, SE, SI, SN, CK, Q, QN);
  input D;
  input RN;
  input SE;
  input SI;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
      buf (RN_d, RN_di);
    `else
      buf (SN_d, SN);
      buf (RN_d, RN);
    `endif
    \seq_SDFFRS_X1 (IQ, SN_d, RN_d, nextstate, CK_d, NOTIFIER);
    and(IQN, i_32, i_33);
    not(i_32, IQ);
    not(i_33, i_34);
    and(i_34, i_35, i_36);
    not(i_35, SN_d);
    not(i_36, RN_d);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_37, i_38);
    and(i_37, SE_d, SI_d);
    and(i_38, D_d, i_39);
    not(i_39, SE_d);

    // Delayed data/reference logic
    and(id_30, SN_d, RN_d);
    and(id_31, id_30, i_47);
    not(i_47, SE_d);
    and(id_32, id_30, SE_d);
    // SDF Logic
    buf(RNx, RN_d);
    and(RN_AND_NEG_SE_AND_SNx, i_48, SN_d);
    and(i_48, RN_d, i_49);
    not(i_49, SE_d);
    and(RN_AND_SE_AND_SNx, i_50, SN_d);
    and(i_50, RN_d, SE_d);
    and(RN_AND_SNx, RN_d, SN_d);
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE_AND_SN, RN_AND_NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SE_AND_SN, RN_AND_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_30, id_30, 1'b1);
      ng_xbuf(xid_31, id_31, 1'b1);
      ng_xbuf(xid_32, id_32, 1'b1);
    `endif
  `else
    \seq_SDFFRS_X1 (IQ, SN, RN, nextstate, CK, NOTIFIER);
    and(IQN, i_32, i_33);
    not(i_32, IQ);
    not(i_33, i_34);
    and(i_34, i_35, i_36);
    not(i_35, SN);
    not(i_36, RN);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_37, i_38);
    and(i_37, SE, SI);
    and(i_38, D, i_39);
    not(i_39, SE);

    // Delayed data/reference logic
    and(id_22, SN, RN);
    and(id_23, id_22, i_43);
    not(i_43, SE);
    and(id_24, id_22, SE);
    // SDF Logic
    buf(RNx, RN);
    and(RN_AND_NEG_SE_AND_SNx, i_44, SN);
    and(i_44, RN, i_45);
    not(i_45, SE);
    and(RN_AND_SE_AND_SNx, i_46, SN);
    and(i_46, RN, SE);
    and(RN_AND_SNx, RN, SN);
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE_AND_SN, RN_AND_NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SE_AND_SN, RN_AND_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_22, id_22, 1'b1);
      ng_xbuf(xid_23, id_23, 1'b1);
      ng_xbuf(xid_24, id_24, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK &&& (SN === 1'b1), 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
        $recrem(posedge SN, posedge CK &&& (RN === 1'b1), 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
        $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK &&& (RN === 1'b1), posedge SN, 0.1, NOTIFIER);
      $hold(posedge CK &&& (SN === 1'b1), posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFFRS_X2  (IQ, SN, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN          RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           ?           0           r           ?       : ? :           0;
           ?           1           1           r           ?       : ? :           1;
           1           ?           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           1           ?           ?           ?       : ? :           1; // SN activated
           *           1           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           0           ?           ?           ?       : ? :           0; // RN activated
           1           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFFRS_X2 (D, RN, SE, SI, SN, CK, Q, QN);
  input D;
  input RN;
  input SE;
  input SI;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
      buf (RN_d, RN_di);
    `else
      buf (SN_d, SN);
      buf (RN_d, RN);
    `endif
    \seq_SDFFRS_X2 (IQ, SN_d, RN_d, nextstate, CK_d, NOTIFIER);
    and(IQN, i_32, i_33);
    not(i_32, IQ);
    not(i_33, i_34);
    and(i_34, i_35, i_36);
    not(i_35, SN_d);
    not(i_36, RN_d);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_37, i_38);
    and(i_37, SE_d, SI_d);
    and(i_38, D_d, i_39);
    not(i_39, SE_d);

    // Delayed data/reference logic
    and(id_30, SN_d, RN_d);
    and(id_31, id_30, i_47);
    not(i_47, SE_d);
    and(id_32, id_30, SE_d);
    // SDF Logic
    buf(RNx, RN_d);
    and(RN_AND_NEG_SE_AND_SNx, i_48, SN_d);
    and(i_48, RN_d, i_49);
    not(i_49, SE_d);
    and(RN_AND_SE_AND_SNx, i_50, SN_d);
    and(i_50, RN_d, SE_d);
    and(RN_AND_SNx, RN_d, SN_d);
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE_AND_SN, RN_AND_NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SE_AND_SN, RN_AND_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_30, id_30, 1'b1);
      ng_xbuf(xid_31, id_31, 1'b1);
      ng_xbuf(xid_32, id_32, 1'b1);
    `endif
  `else
    \seq_SDFFRS_X2 (IQ, SN, RN, nextstate, CK, NOTIFIER);
    and(IQN, i_32, i_33);
    not(i_32, IQ);
    not(i_33, i_34);
    and(i_34, i_35, i_36);
    not(i_35, SN);
    not(i_36, RN);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_37, i_38);
    and(i_37, SE, SI);
    and(i_38, D, i_39);
    not(i_39, SE);

    // Delayed data/reference logic
    and(id_22, SN, RN);
    and(id_23, id_22, i_43);
    not(i_43, SE);
    and(id_24, id_22, SE);
    // SDF Logic
    buf(RNx, RN);
    and(RN_AND_NEG_SE_AND_SNx, i_44, SN);
    and(i_44, RN, i_45);
    not(i_45, SE);
    and(RN_AND_SE_AND_SNx, i_46, SN);
    and(i_46, RN, SE);
    and(RN_AND_SNx, RN, SN);
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE_AND_SN, RN_AND_NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SE_AND_SN, RN_AND_SE_AND_SNx, 1'b1);
      ng_xbuf(RN_AND_SN, RN_AND_SNx, 1'b1);
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_22, id_22, 1'b1);
      ng_xbuf(xid_23, id_23, 1'b1);
      ng_xbuf(xid_24, id_24, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b0)) (RN => Q) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1) && (SN == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (SN => QN) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (RN == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK &&& (SN === 1'b1), 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
        $recrem(posedge SN, posedge CK &&& (RN === 1'b1), 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
        $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK &&& (RN === 1'b1), posedge SN, 0.1, NOTIFIER);
      $hold(posedge CK &&& (SN === 1'b1), posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN &&& (SN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $recovery(posedge SN &&& (RN === 1'b1), posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN_AND_SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFFR_X1  (IQ, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           ?           0           r           ?       : ? :           0;
           1           1           r           ?       : ? :           1;
           ?           0           *           ?       : 0 :           0; // reduce pessimism
           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           0; // RN activated
           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFFR_X1 (D, RN, SE, SI, CK, Q, QN);
  input D;
  input RN;
  input SE;
  input SI;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (RN_d, RN_di);
    `else
      buf (RN_d, RN);
    `endif
    \seq_SDFFR_X1 (IQ, RN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE_d, SI_d);
    and(i_19, D_d, i_20);
    not(i_20, SE_d);

    // Delayed data/reference logic
    buf(id_24, RN_d);
    and(id_25, id_24, i_26);
    not(i_26, SE_d);
    and(id_26, id_24, SE_d);
    // SDF Logic
    buf(RNx, RN_d);
    and(RN_AND_NEG_SEx, RN_d, i_27);
    not(i_27, SE_d);
    and(RN_AND_SEx, RN_d, SE_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE, RN_AND_NEG_SEx, 1'b1);
      ng_xbuf(RN_AND_SE, RN_AND_SEx, 1'b1);
      ng_xbuf(xid_24, id_24, 1'b1);
      ng_xbuf(xid_25, id_25, 1'b1);
      ng_xbuf(xid_26, id_26, 1'b1);
    `endif
  `else
    \seq_SDFFR_X1 (IQ, RN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE, SI);
    and(i_19, D, i_20);
    not(i_20, SE);

    // Delayed data/reference logic
    buf(id_18, RN);
    and(id_19, id_18, i_24);
    not(i_24, SE);
    and(id_20, id_18, SE);
    // SDF Logic
    buf(RNx, RN);
    and(RN_AND_NEG_SEx, RN, i_25);
    not(i_25, SE);
    and(RN_AND_SEx, RN, SE);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE, RN_AND_NEG_SEx, 1'b1);
      ng_xbuf(RN_AND_SE, RN_AND_SEx, 1'b1);
      ng_xbuf(xid_18, id_18, 1'b1);
      ng_xbuf(xid_19, id_19, 1'b1);
      ng_xbuf(xid_20, id_20, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK, 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFFR_X2  (IQ, RN, nextstate, CK, NOTIFIER);
  output IQ;
  input RN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // RN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           ?           0           r           ?       : ? :           0;
           1           1           r           ?       : ? :           1;
           ?           0           *           ?       : 0 :           0; // reduce pessimism
           1           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           0; // RN activated
           *           ?           ?           ?       : 0 :           0; // Cover all transitions on RN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFFR_X2 (D, RN, SE, SI, CK, Q, QN);
  input D;
  input RN;
  input SE;
  input SI;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (RN_d, RN_di);
    `else
      buf (RN_d, RN);
    `endif
    \seq_SDFFR_X2 (IQ, RN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE_d, SI_d);
    and(i_19, D_d, i_20);
    not(i_20, SE_d);

    // Delayed data/reference logic
    buf(id_24, RN_d);
    and(id_25, id_24, i_26);
    not(i_26, SE_d);
    and(id_26, id_24, SE_d);
    // SDF Logic
    buf(RNx, RN_d);
    and(RN_AND_NEG_SEx, RN_d, i_27);
    not(i_27, SE_d);
    and(RN_AND_SEx, RN_d, SE_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN_d, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE, RN_AND_NEG_SEx, 1'b1);
      ng_xbuf(RN_AND_SE, RN_AND_SEx, 1'b1);
      ng_xbuf(xid_24, id_24, 1'b1);
      ng_xbuf(xid_25, id_25, 1'b1);
      ng_xbuf(xid_26, id_26, 1'b1);
    `endif
  `else
    \seq_SDFFR_X2 (IQ, RN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE, SI);
    and(i_19, D, i_20);
    not(i_20, SE);

    // Delayed data/reference logic
    buf(id_18, RN);
    and(id_19, id_18, i_24);
    not(i_24, SE);
    and(id_20, id_18, SE);
    // SDF Logic
    buf(RNx, RN);
    and(RN_AND_NEG_SEx, RN, i_25);
    not(i_25, SE);
    and(RN_AND_SEx, RN, SE);

    `ifdef TETRAMAX
    `else
      ng_xbuf(RN, RNx, 1'b1);
      ng_xbuf(RN_AND_NEG_SE, RN_AND_NEG_SEx, 1'b1);
      ng_xbuf(RN_AND_SE, RN_AND_SEx, 1'b1);
      ng_xbuf(xid_18, id_18, 1'b1);
      ng_xbuf(xid_19, id_19, 1'b1);
      ng_xbuf(xid_20, id_20, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (Q +: 1'b0)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge RN => (QN +: 1'b1)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge RN, posedge CK, 0.1, 0.1, NOTIFIER, , ,RN_di, CK_d);
      `else
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
        $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (RN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge RN, 0.1, NOTIFIER);
      $recovery(posedge RN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (RN_AND_SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge RN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (RN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFFS_X1  (IQ, SN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           0           r           ?       : ? :           0;
           ?           1           r           ?       : ? :           1;
           1           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           1; // SN activated
           *           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFFS_X1 (D, SE, SI, SN, CK, Q, QN);
  input D;
  input SE;
  input SI;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
    `else
      buf (SN_d, SN);
    `endif
    \seq_SDFFS_X1 (IQ, SN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE_d, SI_d);
    and(i_19, D_d, i_20);
    not(i_20, SE_d);

    // Delayed data/reference logic
    buf(id_24, SN_d);
    and(id_25, id_24, i_26);
    not(i_26, SE_d);
    and(id_26, id_24, SE_d);
    // SDF Logic
    and(NEG_SE_AND_SNx, i_27, SN_d);
    not(i_27, SE_d);
    and(SE_AND_SNx, SE_d, SN_d);
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE_AND_SN, NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(SE_AND_SN, SE_AND_SNx, 1'b1);
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_24, id_24, 1'b1);
      ng_xbuf(xid_25, id_25, 1'b1);
      ng_xbuf(xid_26, id_26, 1'b1);
    `endif
  `else
    \seq_SDFFS_X1 (IQ, SN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE, SI);
    and(i_19, D, i_20);
    not(i_20, SE);

    // Delayed data/reference logic
    buf(id_18, SN);
    and(id_19, id_18, i_24);
    not(i_24, SE);
    and(id_20, id_18, SE);
    // SDF Logic
    and(NEG_SE_AND_SNx, i_25, SN);
    not(i_25, SE);
    and(SE_AND_SNx, SE, SN);
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE_AND_SN, NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(SE_AND_SN, SE_AND_SNx, 1'b1);
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_18, id_18, 1'b1);
      ng_xbuf(xid_19, id_19, 1'b1);
      ng_xbuf(xid_20, id_20, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge SN, posedge CK, 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
      $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFFS_X2  (IQ, SN, nextstate, CK, NOTIFIER);
  output IQ;
  input SN;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
       // SN   nextstate          CK    NOTIFIER     : @IQ :          IQ
           1           0           r           ?       : ? :           0;
           ?           1           r           ?       : ? :           1;
           1           0           *           ?       : 0 :           0; // reduce pessimism
           ?           1           *           ?       : 1 :           1; // reduce pessimism
           1           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           1           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           0           ?           ?           ?       : ? :           1; // SN activated
           *           ?           ?           ?       : 1 :           1; // Cover all transitions on SN
           ?           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFFS_X2 (D, SE, SI, SN, CK, Q, QN);
  input D;
  input SE;
  input SI;
  input SN;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    `ifdef RECREM
      buf (SN_d, SN_di);
    `else
      buf (SN_d, SN);
    `endif
    \seq_SDFFS_X2 (IQ, SN_d, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE_d, SI_d);
    and(i_19, D_d, i_20);
    not(i_20, SE_d);

    // Delayed data/reference logic
    buf(id_24, SN_d);
    and(id_25, id_24, i_26);
    not(i_26, SE_d);
    and(id_26, id_24, SE_d);
    // SDF Logic
    and(NEG_SE_AND_SNx, i_27, SN_d);
    not(i_27, SE_d);
    and(SE_AND_SNx, SE_d, SN_d);
    buf(SNx, SN_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE_AND_SN, NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(SE_AND_SN, SE_AND_SNx, 1'b1);
      ng_xbuf(SN_d, SNx, 1'b1);
      ng_xbuf(xid_24, id_24, 1'b1);
      ng_xbuf(xid_25, id_25, 1'b1);
      ng_xbuf(xid_26, id_26, 1'b1);
    `endif
  `else
    \seq_SDFFS_X2 (IQ, SN, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_18, i_19);
    and(i_18, SE, SI);
    and(i_19, D, i_20);
    not(i_20, SE);

    // Delayed data/reference logic
    buf(id_18, SN);
    and(id_19, id_18, i_24);
    not(i_24, SE);
    and(id_20, id_18, SE);
    // SDF Logic
    and(NEG_SE_AND_SNx, i_25, SN);
    not(i_25, SE);
    and(SE_AND_SNx, SE, SN);
    buf(SNx, SN);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE_AND_SN, NEG_SE_AND_SNx, 1'b1);
      ng_xbuf(SE_AND_SN, SE_AND_SNx, 1'b1);
      ng_xbuf(SN, SNx, 1'b1);
      ng_xbuf(xid_18, id_18, 1'b1);
      ng_xbuf(xid_19, id_19, 1'b1);
      ng_xbuf(xid_20, id_20, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (Q +: 1'b1)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b0) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b0) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b0) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b0)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    if((CK == 1'b1) && (D == 1'b1) && (SE == 1'b1) && (SI == 1'b1)) (negedge SN => (QN +: 1'b0)) = (0.1, 0.1);
    `ifdef NTC
      `ifdef RECREM
        $recrem(posedge SN, posedge CK, 0.1, 0.1, NOTIFIER, , ,SN_di, CK_d);
      `else
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
        $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      `endif
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `else
      $hold(posedge CK, posedge SN, 0.1, NOTIFIER);
      $recovery(posedge SN, posedge CK, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (NEG_SE_AND_SN === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE_AND_SN === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SN === 1'b1), posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
      $width(negedge SN, 0.1, 0, NOTIFIER);
      $width(posedge CK &&& (SN === 1'b1), 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFF_X1  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           r           ?       : ? :           0;
           1           r           ?       : ? :           1;
           0           *           ?       : 0 :           0; // reduce pessimism
           1           *           ?       : 1 :           1; // reduce pessimism
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFF_X1 (D, SE, SI, CK, Q, QN);
  input D;
  input SE;
  input SI;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    \seq_SDFF_X1 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_12, i_13);
    and(i_12, SE_d, SI_d);
    and(i_13, D_d, i_14);
    not(i_14, SE_d);

    // Delayed data/reference logic
    not(id_16, SE_d);
    buf(id_17, SE_d);
    // SDF Logic
    not(NEG_SEx, SE_d);
    buf(SEx, SE_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE, NEG_SEx, 1'b1);
      ng_xbuf(SE_d, SEx, 1'b1);
      ng_xbuf(xid_16, id_16, 1'b1);
      ng_xbuf(xid_17, id_17, 1'b1);
    `endif
  `else
    \seq_SDFF_X1 (IQ, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_12, i_13);
    and(i_12, SE, SI);
    and(i_13, D, i_14);
    not(i_14, SE);

    // Delayed data/reference logic
    not(id_12, SE);
    buf(id_13, SE);
    // SDF Logic
    not(NEG_SEx, SE);
    buf(SEx, SE);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE, NEG_SEx, 1'b1);
      ng_xbuf(SE, SEx, 1'b1);
      ng_xbuf(xid_12, id_12, 1'b1);
      ng_xbuf(xid_13, id_13, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

primitive \seq_SDFF_X2  (IQ, nextstate, CK, NOTIFIER);
  output IQ;
  input nextstate;
  input CK;
  input NOTIFIER;
  reg IQ;

  table
// nextstate          CK    NOTIFIER     : @IQ :          IQ
           0           r           ?       : ? :           0;
           1           r           ?       : ? :           1;
           0           *           ?       : 0 :           0; // reduce pessimism
           1           *           ?       : 1 :           1; // reduce pessimism
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           n           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module SDFF_X2 (D, SE, SI, CK, Q, QN);
  input D;
  input SE;
  input SI;
  input CK;
  output Q;
  output QN;
  reg NOTIFIER;

  `ifdef NTC
    \seq_SDFF_X2 (IQ, nextstate, CK_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_12, i_13);
    and(i_12, SE_d, SI_d);
    and(i_13, D_d, i_14);
    not(i_14, SE_d);

    // Delayed data/reference logic
    not(id_16, SE_d);
    buf(id_17, SE_d);
    // SDF Logic
    not(NEG_SEx, SE_d);
    buf(SEx, SE_d);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE, NEG_SEx, 1'b1);
      ng_xbuf(SE_d, SEx, 1'b1);
      ng_xbuf(xid_16, id_16, 1'b1);
      ng_xbuf(xid_17, id_17, 1'b1);
    `endif
  `else
    \seq_SDFF_X2 (IQ, nextstate, CK, NOTIFIER);
    not(IQN, IQ);
    buf(Q, IQ);
    buf(QN, IQN);
    or(nextstate, i_12, i_13);
    and(i_12, SE, SI);
    and(i_13, D, i_14);
    not(i_14, SE);

    // Delayed data/reference logic
    not(id_12, SE);
    buf(id_13, SE);
    // SDF Logic
    not(NEG_SEx, SE);
    buf(SEx, SE);

    `ifdef TETRAMAX
    `else
      ng_xbuf(NEG_SE, NEG_SEx, 1'b1);
      ng_xbuf(SE, SEx, 1'b1);
      ng_xbuf(xid_12, id_12, 1'b1);
      ng_xbuf(xid_13, id_13, 1'b1);
    `endif
  `endif

  specify
    (posedge CK => (Q +: D)) = (0.1, 0.1);
    (posedge CK => (QN -: D)) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER, , ,CK_d, D_d);
      $setuphold(posedge CK &&& (SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK &&& (SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER, , ,CK_d, SI_d);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER, , ,CK_d, SE_d);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `else
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (NEG_SE === 1'b1), posedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE === 1'b1), negedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK &&& (SE === 1'b1), posedge SI, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, negedge SE, 0.1, 0.1, NOTIFIER);
      $setuphold(posedge CK, posedge SE, 0.1, 0.1, NOTIFIER);
      $width(negedge CK, 0.1, 0, NOTIFIER);
      $width(posedge CK, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

module TBUF_X1 (A, EN, Z);
  input A;
  input EN;
  output Z;

  bufif0(Z, Z_in, Z_enable);
  buf(Z_enable, EN);
  buf(Z_in, A);

  specify
    (A => Z) = (0.1, 0.1);
    (EN => Z) = (0.1, 0.1);
  endspecify

endmodule

module TBUF_X16 (A, EN, Z);
  input A;
  input EN;
  output Z;

  bufif0(Z, Z_in, Z_enable);
  buf(Z_enable, EN);
  buf(Z_in, A);

  specify
    (A => Z) = (0.1, 0.1);
    (EN => Z) = (0.1, 0.1);
  endspecify

endmodule

module TBUF_X2 (A, EN, Z);
  input A;
  input EN;
  output Z;

  bufif0(Z, Z_in, Z_enable);
  buf(Z_enable, EN);
  buf(Z_in, A);

  specify
    (A => Z) = (0.1, 0.1);
    (EN => Z) = (0.1, 0.1);
  endspecify

endmodule

module TBUF_X4 (A, EN, Z);
  input A;
  input EN;
  output Z;

  bufif0(Z, Z_in, Z_enable);
  buf(Z_enable, EN);
  buf(Z_in, A);

  specify
    (A => Z) = (0.1, 0.1);
    (EN => Z) = (0.1, 0.1);
  endspecify

endmodule

module TBUF_X8 (A, EN, Z);
  input A;
  input EN;
  output Z;

  bufif0(Z, Z_in, Z_enable);
  buf(Z_enable, EN);
  buf(Z_in, A);

  specify
    (A => Z) = (0.1, 0.1);
    (EN => Z) = (0.1, 0.1);
  endspecify

endmodule

module TINV_X1 (EN, I, ZN);
  input EN;
  input I;
  output ZN;

  bufif0(ZN, ZN_in, ZN_enable);
  buf(ZN_enable, EN);
  not(ZN_in, I);

  specify
    (EN => ZN) = (0.1, 0.1);
    (I => ZN) = (0.1, 0.1);
  endspecify

endmodule

primitive \seq_TLAT_X1  (IQ, nextstate, G, NOTIFIER);
  output IQ;
  input nextstate;
  input G;
  input NOTIFIER;
  reg IQ;

  table
// nextstate           G    NOTIFIER     : @IQ :          IQ
           0           1           ?       : ? :           0;
           1           1           ?       : ? :           1;
           *           ?           ?       : ? :           -; // Ignore all edges on nextstate
           ?           0           ?       : ? :           -; // Ignore non-triggering clock edge
           ?           ?           *       : ? :           x; // Any NOTIFIER change
  endtable
endprimitive

module TLAT_X1 (D, G, OE, Q);
  input D;
  input G;
  input OE;
  output Q;
  reg NOTIFIER;

  `ifdef NTC
    bufif0(Q, Q_in, Q_enable);
    not(Q_enable, OE);
    \seq_TLAT_X1 (IQ, nextstate, G_d, NOTIFIER);
    not(IQN, IQ);
    buf(Q_in, IQ);
    buf(nextstate, D_d);

  `else
    bufif0(Q, Q_in, Q_enable);
    not(Q_enable, OE);
    \seq_TLAT_X1 (IQ, nextstate, G, NOTIFIER);
    not(IQN, IQ);
    buf(Q_in, IQ);
    buf(nextstate, D);

  `endif

  specify
    (D => Q) = (0.1, 0.1);
    (posedge G => (Q +: D)) = (0.1, 0.1);
    (OE => Q) = (0.1, 0.1);
    `ifdef NTC
      $setuphold(negedge G, negedge D, 0.1, 0.1, NOTIFIER, , ,G_d, D_d);
      $setuphold(negedge G, posedge D, 0.1, 0.1, NOTIFIER, , ,G_d, D_d);
      $width(posedge G, 0.1, 0, NOTIFIER);
    `else
      $setuphold(negedge G, negedge D, 0.1, 0.1, NOTIFIER);
      $setuphold(negedge G, posedge D, 0.1, 0.1, NOTIFIER);
      $width(posedge G, 0.1, 0, NOTIFIER);
    `endif
  endspecify

endmodule

module XNOR2_X1 (A, B, ZN);
  input A;
  input B;
  output ZN;

  not(ZN, i_4);
  xor(i_4, A, B);

  specify
    if((B == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1)) (B => ZN) = (0.1, 0.1);
  endspecify

endmodule

module XNOR2_X2 (A, B, ZN);
  input A;
  input B;
  output ZN;

  not(ZN, i_4);
  xor(i_4, A, B);

  specify
    if((B == 1'b0)) (A => ZN) = (0.1, 0.1);
    if((B == 1'b1)) (A => ZN) = (0.1, 0.1);
    if((A == 1'b0)) (B => ZN) = (0.1, 0.1);
    if((A == 1'b1)) (B => ZN) = (0.1, 0.1);
  endspecify

endmodule

module XOR2_X1 (A, B, Z);
  input A;
  input B;
  output Z;

  xor(Z, A, B);

  specify
    if((B == 1'b0)) (A => Z) = (0.1, 0.1);
    if((B == 1'b1)) (A => Z) = (0.1, 0.1);
    if((A == 1'b0)) (B => Z) = (0.1, 0.1);
    if((A == 1'b1)) (B => Z) = (0.1, 0.1);
  endspecify

endmodule

module XOR2_X2 (A, B, Z);
  input A;
  input B;
  output Z;

  xor(Z, A, B);

  specify
    if((B == 1'b0)) (A => Z) = (0.1, 0.1);
    if((B == 1'b1)) (A => Z) = (0.1, 0.1);
    if((A == 1'b0)) (B => Z) = (0.1, 0.1);
    if((A == 1'b1)) (B => Z) = (0.1, 0.1);
  endspecify

endmodule

`ifdef TETRAMAX
`else
  primitive ng_xbuf (o, i, d);
	output o;
	input i, d;
	table
	// i   d   : o
	   0   1   : 0 ;
	   1   1   : 1 ;
	   x   1   : 1 ;
	endtable
  endprimitive
`endif
//
// End of file
//
