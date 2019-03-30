// `timescale 1ps/1ps
module dct(O, finish_computing, in, clk, rst);
	parameter bits = 25;
	parameter S0=4'd0, S1=4'd1, S2=4'd2, S3=4'd3, S4=4'd4, S5=4'd5, S6=4'd6, S7=4'd7;
	parameter S8=4'd8, S9=4'd9, S10=4'd10, S11=4'd11, S12=4'd12, S13=4'd13, S14=4'd14, S15=4'd15;
	output reg [bits-1:0] O;
	output reg finish_computing;
	input [bits-1:0] in;
	input clk, rst;
	reg [bits-1:0] Mem_in [7:0];
	reg [bits-1:0] Mem_out [7:0];
	reg [3:0] state;
	
	wire [bits:0] na_s_a0_0, na_s_a1_0, na_s_a2_0, na_s_a3_0, na_s_a4_0, na_s_a5_0, na_s_a6_0, na_s_a7_0;
	wire [bits:0] na_s_b0_0, na_s_b1_0, na_s_b2_0, na_s_b3_0, na_s_b4_0, na_s_b5_0, na_s_b6_0, na_s_b7_0;
	wire [bits:0] na_s_w0_0, na_s_w1_0, na_s_w2_0, na_s_w3_0, na_s_w4_0, na_s_w5_0, na_s_w6_0, na_s_w7_0;
	wire [bits:0] dct0, dct1, dct2, dct3, dct4, dct5, dct6, dct7;
	wire [bits-1:0] m2w5, m2w6, m6w7, m6w4, m8w4, m8w7, m14w7, m14w4, m15w3, m15w2, m16w5, m16w6, m19w5, m19w6, m30w5, m30w6, m35w4, m35w7, m36w2, m36w3, m39w0, m39w1;
	wire [bits:0] sub11_0, add12_0, add13_0, sub8_0, add9_0, add10_0, add3_0, sub7_0, add6_0, add4_0, sub5_0, add0_0, add1_0, sub2_0;
	wire [bits-1:0] in_25bits;
//----------

	assign in_25bits[bits-1:0] = in[bits-1:0];

	sub_nadd_25_sign_bits	na_s_a0	(na_s_a0_0, Mem_in[0], Mem_in[7], 1'b0); // x0 + x7
	sub_nadd_25_sign_bits 	na_s_a1	(na_s_a1_0, Mem_in[1], Mem_in[6], 1'b0); // x1 + x6
	sub_nadd_25_sign_bits 	na_s_a2	(na_s_a2_0, Mem_in[2], Mem_in[5], 1'b0); // x2 + x5
	sub_nadd_25_sign_bits 	na_s_a3	(na_s_a3_0, Mem_in[3], Mem_in[4], 1'b0); // x3 + x4
	sub_nadd_25_sign_bits	 	na_s_a4	(na_s_a4_0, Mem_in[0], Mem_in[7], 1'b1); // x0 - x7
	sub_nadd_25_sign_bits 		na_s_a5	(na_s_a5_0, Mem_in[1], Mem_in[6], 1'b1); // x1 - x6
	sub_nadd_25_sign_bits 		na_s_a6	(na_s_a6_0, Mem_in[2], Mem_in[5], 1'b1); // x2 - x5
	sub_nadd_25_sign_bits 		na_s_a7	(na_s_a7_0, Mem_in[3], Mem_in[4], 1'b1); // x3 - x4
	
	sub_nadd_25_sign_bits 	na_s_b0	(na_s_b0_0, {na_s_a0_0[bits], na_s_a0_0[bits-2:0]}, {na_s_a1_0[bits], na_s_a1_0[bits-2:0]}, 1'b0); // a0+a1
	sub_nadd_25_sign_bits 	na_s_b1	(na_s_b1_0, {na_s_a4_0[bits], na_s_a4_0[bits-2:0]}, {na_s_a5_0[bits], na_s_a5_0[bits-2:0]}, 1'b0); // a4+a5
	sub_nadd_25_sign_bits 	na_s_b2	(na_s_b2_0, {na_s_a2_0[bits], na_s_a2_0[bits-2:0]}, {na_s_a3_0[bits], na_s_a3_0[bits-2:0]}, 1'b0); // a2+a3
	sub_nadd_25_sign_bits 	na_s_b3	(na_s_b3_0, {na_s_a6_0[bits], na_s_a6_0[bits-2:0]}, {na_s_a7_0[bits], na_s_a7_0[bits-2:0]}, 1'b0); // a6+a7
	sub_nadd_25_sign_bits 		na_s_b4	(na_s_b4_0, {na_s_a0_0[bits], na_s_a0_0[bits-2:0]}, {na_s_a1_0[bits], na_s_a1_0[bits-2:0]}, 1'b1); // a0-a1
	sub_nadd_25_sign_bits 		na_s_b5	(na_s_b5_0, {na_s_a4_0[bits], na_s_a4_0[bits-2:0]}, {na_s_a5_0[bits], na_s_a5_0[bits-2:0]}, 1'b1); // a4-a5
	sub_nadd_25_sign_bits 		na_s_b6	(na_s_b6_0, {na_s_a2_0[bits], na_s_a2_0[bits-2:0]}, {na_s_a3_0[bits], na_s_a3_0[bits-2:0]}, 1'b1); // a2-a3
	sub_nadd_25_sign_bits 		na_s_b7	(na_s_b7_0, {na_s_a6_0[bits], na_s_a6_0[bits-2:0]}, {na_s_a7_0[bits], na_s_a7_0[bits-2:0]}, 1'b1); // a6-a7
	
	sub_nadd_25_sign_bits 	na_s_w0	(na_s_w0_0, {na_s_b0_0[bits], na_s_b0_0[bits-2:0]}, {na_s_b2_0[bits], na_s_b2_0[bits-2:0]}, 1'b0); // b0+b2
	sub_nadd_25_sign_bits 		na_s_w1	(na_s_w1_0, {na_s_b4_0[bits], na_s_b4_0[bits-2:0]}, {na_s_b6_0[bits], na_s_b6_0[bits-2:0]}, 1'b1); // b4-b6
	sub_nadd_25_sign_bits 		na_s_w2	(na_s_w2_0, {na_s_b0_0[bits], na_s_b0_0[bits-2:0]}, {na_s_b2_0[bits], na_s_b2_0[bits-2:0]}, 1'b1); // b0-b2
	sub_nadd_25_sign_bits 	na_s_w3	(na_s_w3_0, {na_s_b4_0[bits], na_s_b4_0[bits-2:0]}, {na_s_b6_0[bits], na_s_b6_0[bits-2:0]}, 1'b0); // b4+b6
	sub_nadd_25_sign_bits 	na_s_w4	(na_s_w4_0, {na_s_b1_0[bits], na_s_b1_0[bits-2:0]}, {na_s_b3_0[bits], na_s_b3_0[bits-2:0]}, 1'b0); // b1+b3
	sub_nadd_25_sign_bits 		na_s_w5	(na_s_w5_0, {na_s_b5_0[bits], na_s_b5_0[bits-2:0]}, {na_s_b7_0[bits], na_s_b7_0[bits-2:0]}, 1'b1); // b5-b7
	sub_nadd_25_sign_bits 		na_s_w6	(na_s_w6_0, {na_s_b1_0[bits], na_s_b1_0[bits-2:0]}, {na_s_b3_0[bits], na_s_b3_0[bits-2:0]}, 1'b1); // b1-b3
	sub_nadd_25_sign_bits 	na_s_w7	(na_s_w7_0, {na_s_b5_0[bits], na_s_b5_0[bits-2:0]}, {na_s_b7_0[bits], na_s_b7_0[bits-2:0]}, 1'b0); // b5+b7
	
/*	T*Wx = 
*	 a*w0
*	 a*w1
*	 b*w2 + c*w3
*	-c*w2 + b*w3
*	 d*w4 - e*w5 + h*w6 +  y*w7	
*	 f*w4 + g*w5 - j*w6 +  k*w7
*	-k*w4 + j*w5 + g*w6 +  f*w7
*	-y*w4 - h*w5 - e*w6 +  d*w7
*	
*	a=39; b=36; c=15; d=35; e=2; f=8; g=30; h=16; y=6; j=19; k=14;
*/

	multiplier_2  		m0		(m2w5	, {na_s_w5_0[bits], na_s_w5_0[bits-2:0]});
	multiplier_2    	m1		(m2w6	, {na_s_w6_0[bits], na_s_w6_0[bits-2:0]});
	multiplier_6  		m2		(m6w7	, {na_s_w7_0[bits], na_s_w7_0[bits-2:0]});
	multiplier_6    	m3		(m6w4	, {na_s_w4_0[bits], na_s_w4_0[bits-2:0]});
	multiplier_8 		m4		(m8w4	, {na_s_w4_0[bits], na_s_w4_0[bits-2:0]});
	multiplier_8 		m5		(m8w7	, {na_s_w7_0[bits], na_s_w7_0[bits-2:0]});
	multiplier_14 		m6		(m14w7	, {na_s_w7_0[bits], na_s_w7_0[bits-2:0]});
	multiplier_14 		m7		(m14w4	, {na_s_w4_0[bits], na_s_w4_0[bits-2:0]});
	multiplier_15 		m8		(m15w3	, {na_s_w3_0[bits], na_s_w3_0[bits-2:0]});
	multiplier_15 		m9		(m15w2	, {na_s_w2_0[bits], na_s_w2_0[bits-2:0]});
	multiplier_16   	m10		(m16w5	, {na_s_w5_0[bits], na_s_w5_0[bits-2:0]});
	multiplier_16 		m11		(m16w6	, {na_s_w6_0[bits], na_s_w6_0[bits-2:0]});
	multiplier_19  		m12		(m19w5	, {na_s_w5_0[bits], na_s_w5_0[bits-2:0]});
	multiplier_19 		m13		(m19w6	, {na_s_w6_0[bits], na_s_w6_0[bits-2:0]});
	multiplier_30  		m14		(m30w5	, {na_s_w5_0[bits], na_s_w5_0[bits-2:0]});
	multiplier_30 		m21		(m30w6	, {na_s_w6_0[bits], na_s_w6_0[bits-2:0]});
	multiplier_35 		m15		(m35w4	, {na_s_w4_0[bits], na_s_w4_0[bits-2:0]});
	multiplier_35   	m16		(m35w7	, {na_s_w7_0[bits], na_s_w7_0[bits-2:0]});
	multiplier_36 		m17		(m36w2	, {na_s_w2_0[bits], na_s_w2_0[bits-2:0]});
	multiplier_36 		m18		(m36w3	, {na_s_w3_0[bits], na_s_w3_0[bits-2:0]});
	multiplier_39 		m19		(m39w0	, {na_s_w0_0[bits], na_s_w0_0[bits-2:0]});
	multiplier_39 		m20		(m39w1	, {na_s_w1_0[bits], na_s_w1_0[bits-2:0]});
	//dct0
	assign dct0[bits-1:0] 	= m39w0[bits-1:0];
	//dct1
	sub_nadd_25_sign_bits		sub11	(sub11_0	, m35w4	, m2w5, 1'b1);
	sub_nadd_25_sign_bits 		add12	(add12_0	, {sub11_0[bits], sub11_0[bits-2:0]}, m16w6, 1'b0);
	sub_nadd_25_sign_bits 		add13	(add13_0	, {add12_0[bits], add12_0[bits-2:0]}, m6w7, 1'b0);
	assign dct1[bits-1:0] 	= {add13_0[bits], add13_0[bits-2:0]};
	//dct2
	sub_nadd_25_sign_bits 		add6	(add6_0	, m36w2	, m15w3, 1'b0);
	assign dct2[bits-1:0] 	= {add6_0[bits], add6_0[bits-2:0]};
	//dct3
	sub_nadd_25_sign_bits 		sub8	(sub8_0		, m19w5	, m14w4, 1'b1);
	sub_nadd_25_sign_bits 		add9	(add9_0		, {sub8_0[bits], sub8_0[bits-2:0]}, m30w6, 1'b0);
	sub_nadd_25_sign_bits 		add10	(add10_0	, {add9_0[bits], add9_0[bits-2:0]}, m8w7, 1'b0);
	assign dct3[bits-1:0]  	= {add10_0[bits], add10_0[bits-2:0]};
	//dct4
	assign dct4[bits-1:0] 	= m39w1[bits-1:0];
	//dct5
	sub_nadd_25_sign_bits 		add3	(add3_0	, m8w4	 , m30w5, 1'b0);
	sub_nadd_25_sign_bits 		add4	(add4_0	, {add3_0[bits], add3_0[bits-2:0]} , m14w7, 1'b0);
	sub_nadd_25_sign_bits  		sub5	(sub5_0	, {add4_0[bits], add4_0[bits-2:0]} , m19w6, 1'b1);
	assign dct5[bits-1:0] 	= {sub5_0[bits], sub5_0[bits-2:0]};
	//dct6
	sub_nadd_25_sign_bits 			sub7	(sub7_0	, m36w3, m15w2, 1'b1);
	assign dct6[bits-1:0] 	= {sub7_0[bits], sub7_0[bits-2:0]};
	//dct7
	sub_nadd_25_sign_bits 		add0	(add0_0	, m6w4, m16w5, 1'b0);
	sub_nadd_25_sign_bits 		add1	(add1_0	, {add0_0[bits], add0_0[bits-2:0]}, m2w6 , 1'b0);
	sub_nadd_25_sign_bits  		sub2	(sub2_0	, m35w7, {add1_0[bits], add1_0[bits-2:0]}, 1'b1);
	assign dct7[bits-1:0] 	= {sub2_0[bits], sub2_0[bits-2:0]};
	
	always @(posedge clk) begin
		if(rst) begin
			Mem_in[0] = 8'b0;
			Mem_in[1] = 8'b0;
			Mem_in[2] = 8'b0;
			Mem_in[3] = 8'b0;
			Mem_in[4] = 8'b0;
			Mem_in[5] = 8'b0;
			Mem_in[6] = 8'b0;
			Mem_in[7] = 8'b0;
			O = 8'b0;
			finish_computing = 1'b0;
			state = 4'b0;
			
		end
		else begin
			case (state) 
				S0: begin 
						Mem_in[0] = in_25bits; state = S1;
						finish_computing = 1'b1;
						Mem_out[0] = dct0;
						Mem_out[1] = dct1;
						Mem_out[2] = dct2;
						Mem_out[3] = dct3;
						Mem_out[4] = dct4;
						Mem_out[5] = dct5;
						Mem_out[6] = dct6;
						Mem_out[7] = dct7;
						O = Mem_out[0];
					end
				S1: begin 
						Mem_in[1] = in_25bits; state = S2;
						finish_computing = 1'b0;
						O = Mem_out[1];
					end
				S2: begin 
						Mem_in[2] = in_25bits; state = S3; 
						O = Mem_out[2];
					end
				S3: begin 
						Mem_in[3] = in_25bits; state = S4; 
						O = Mem_out[3];
					end
				S4: begin 
						Mem_in[4] = in_25bits; state = S5; 
						O = Mem_out[4];
					end
				S5: begin 
						Mem_in[5] = in_25bits; state = S6; 
						O = Mem_out[5];
					end
				S6: begin 
						Mem_in[6] = in_25bits; state = S7; 
						O = Mem_out[6];
					end
				S7: begin 
						Mem_in[7] = in_25bits; state = S0; 
						O = Mem_out[7];
					end
				/* 
				S9:  begin  state = S10; end
				S10: begin  state = S11; end
				S11: begin  state = S12; end
				S12: begin  state = S13; end
				S13: begin  state = S14; end
				S14: begin  state = S15; end
				S15: begin  state = S0; end */
			endcase
		end
			
	end
endmodule