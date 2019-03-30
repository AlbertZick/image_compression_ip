`timescale 1ps/1ps
//--------------------------------------------------//
module multiplier_39(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, s6_out, as7_out;
//39*in = 32*in + 8*in - in;

	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	dich_trai_1 s6(s6_out, s5_out); //in*32

	cong_25bits as7(as7_out, s6_out, s4_out);
	tru_25bits as8(out, as7_out, in);

endmodule
//--------------------------------------------------//
module multiplier_36(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, s6_out;
// 36*in = 32*in + 4*in
	
	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	dich_trai_1 s6(s6_out, s5_out); //in*32
	
	cong_25bits as7(out, s6_out, s3_out);
	
endmodule
//--------------------------------------------------//
module multiplier_35(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, s6_out, as7_out;
// 35*in = 32*in + 2*in + in
	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	dich_trai_1 s6(s6_out, s5_out); //in*32
	
	cong_25bits as7(as7_out, s6_out, s2_out);
	cong_25bits as8(out, as7_out, in);
endmodule
//--------------------------------------------------//
module multiplier_30(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, s6_out;
// 30*in = 32*in - 2*in
	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	dich_trai_1 s6(s6_out, s5_out); //in*32
	
	tru_25bits as7(out, s6_out, s2_out);
endmodule
//--------------------------------------------------//
module multiplier_19(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, as6_out;
// 19*in = 16*in + 2*in + in
	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	
	cong_25bits as6(as6_out, s5_out, s2_out);
	cong_25bits as7(out, as6_out, in);
endmodule
//--------------------------------------------------//
module multiplier_16(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out;

	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(out, s4_out); //in*16

endmodule
//--------------------------------------------------//
module multiplier_15(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, as6_out;
// 15*in = 16*in - in
	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	
	tru_25bits as6(out, s5_out, in);
endmodule
//--------------------------------------------------//
module multiplier_14(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out, s5_out, as6_out;
// 14*in = 16*in - 2*in
	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(s4_out, s3_out); //in*8
	dich_trai_1 s5(s5_out, s4_out); //in*16
	
	tru_25bits as6(out, s5_out, s2_out);
endmodule
//--------------------------------------------------//
module multiplier_8(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out;

	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	dich_trai_1 s4(out, s3_out); //in*8

endmodule
//--------------------------------------------------//
module multiplier_6(out, in);
	output [24:0] out;
	input  [24:0] in;
	wire [24:0] s2_out, s3_out, s4_out;

	dich_trai_1 s2(s2_out, in); //in*2
	dich_trai_1 s3(s3_out, s2_out); //in*4
	
	cong_25bits as4(out, s3_out, s2_out);

endmodule
//--------------------------------------------------//
module multiplier_2(out, in);
	output [24:0] out;
	input  [24:0] in;

	dich_trai_1 s2(out, in); //in*2

endmodule
