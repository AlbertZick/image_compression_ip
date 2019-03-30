// Author: Truong Tran
// Date: 2019/05/10
//====================================================================================================//
// input is unsigned binary
`timescale 1ps/1ps
module	convert_int_into_float	(O, in);
output	[31:0]	O;
input	[24:0]	in;


wire	[7:0]	w_00, w_01, w_02, w_03, w_04, w_05, w_06, w_07, w_08, w_09, w_10, w_11, w_12;
wire	[7:0]	add_26_O, add_27_O, add_28_O, add_29_O, add_30_O, add_31_O, add_32_O, add_33_O;
wire	[7:0]	add_34_O, add_35_O, add_36_O, add_37_O, add_38_O;
wire	[8:0]	add_38_O_ex;
wire	[9:0]	add_39_O;
wire	[24:0]	abs_O, s_00_O, s_01_O, s_02_O, s_03_O, s_04_O, s_05_O, s_06_O, s_07_O, s_08_O, s_09_O;
wire	[24:0]	s_10_O, s_11_O, s_12_O, s_13_O, s_14_O, s_15_O, s_16_O, s_17_O, s_18_O, s_19_O, s_20_O;
wire	[24:0]	s_21_O, s_22_O, s_23_O, s_24_O, s_25_O;

abs_25_bits	abs	(.O(abs_O), .in(in));
shift_left_1_25bits	s_00	(s_00_O, abs_O, ~abs_O[24]);
shift_left_1_25bits	s_01	(s_01_O, s_00_O, ~s_00_O[24]);
shift_left_1_25bits	s_02	(s_02_O, s_01_O, ~s_01_O[24]);
shift_left_1_25bits	s_03	(s_03_O, s_02_O, ~s_02_O[24]);
shift_left_1_25bits	s_04	(s_04_O, s_03_O, ~s_03_O[24]);
shift_left_1_25bits	s_05	(s_05_O, s_04_O, ~s_04_O[24]);
shift_left_1_25bits	s_06	(s_06_O, s_05_O, ~s_05_O[24]);
shift_left_1_25bits	s_07	(s_07_O, s_06_O, ~s_06_O[24]);
shift_left_1_25bits	s_08	(s_08_O, s_07_O, ~s_07_O[24]);
shift_left_1_25bits	s_09	(s_09_O, s_08_O, ~s_08_O[24]);
shift_left_1_25bits	s_10	(s_10_O, s_09_O, ~s_09_O[24]);
shift_left_1_25bits	s_11	(s_11_O, s_10_O, ~s_10_O[24]);
shift_left_1_25bits	s_12	(s_12_O, s_11_O, ~s_11_O[24]);
shift_left_1_25bits	s_13	(s_13_O, s_12_O, ~s_12_O[24]);
shift_left_1_25bits	s_14	(s_14_O, s_13_O, ~s_13_O[24]);
shift_left_1_25bits	s_15	(s_15_O, s_14_O, ~s_14_O[24]);
shift_left_1_25bits	s_16	(s_16_O, s_15_O, ~s_15_O[24]);
shift_left_1_25bits	s_17	(s_17_O, s_16_O, ~s_16_O[24]);
shift_left_1_25bits	s_18	(s_18_O, s_17_O, ~s_17_O[24]);
shift_left_1_25bits	s_19	(s_19_O, s_18_O, ~s_18_O[24]);
shift_left_1_25bits	s_20	(s_20_O, s_19_O, ~s_19_O[24]);
shift_left_1_25bits	s_21	(s_21_O, s_20_O, ~s_20_O[24]);
shift_left_1_25bits	s_22	(s_22_O, s_21_O, ~s_21_O[24]);
shift_left_1_25bits	s_23	(s_23_O, s_22_O, ~s_22_O[24]);
shift_left_1_25bits	s_24	(s_24_O, s_23_O, ~s_23_O[24]);
shift_left_1_25bits	s_25	(s_25_O, s_24_O, 1'b1);

mux_2_1	#(23)	significand	(O[22:0], 23'b0, s_25_O[24:2], s_24_O[24]);

assign w_00[7:0] = {7'b0, ~abs_O[24]};
assign w_01[7:0] = {7'b0, ~s_01_O[24]};
assign w_02[7:0] = {7'b0, ~s_03_O[24]};
assign w_03[7:0] = {7'b0, ~s_05_O[24]};
assign w_04[7:0] = {7'b0, ~s_07_O[24]};
assign w_05[7:0] = {7'b0, ~s_09_O[24]};
assign w_06[7:0] = {7'b0, ~s_11_O[24]};
assign w_07[7:0] = {7'b0, ~s_13_O[24]};
assign w_08[7:0] = {7'b0, ~s_15_O[24]};
assign w_09[7:0] = {7'b0, ~s_17_O[24]};
assign w_10[7:0] = {7'b0, ~s_19_O[24]};
assign w_11[7:0] = {7'b0, ~s_21_O[24]};
assign w_12[7:0] = {7'b0, ~s_23_O[24]};

adder_unsign_8_bits		add_26	(add_26_O, 8'b00000, w_00, ~s_00_O[24]);
adder_unsign_8_bits		add_27	(add_27_O, add_26_O, w_01, ~s_02_O[24]);
adder_unsign_8_bits		add_28	(add_28_O, add_27_O, w_02, ~s_04_O[24]);
adder_unsign_8_bits		add_29	(add_29_O, add_28_O, w_03, ~s_06_O[24]);
adder_unsign_8_bits		add_30	(add_30_O, add_29_O, w_04, ~s_08_O[24]);
adder_unsign_8_bits		add_31	(add_31_O, add_30_O, w_05, ~s_10_O[24]);
adder_unsign_8_bits		add_32	(add_32_O, add_31_O, w_06, ~s_12_O[24]);
adder_unsign_8_bits		add_33	(add_33_O, add_32_O, w_07, ~s_14_O[24]);
adder_unsign_8_bits		add_34	(add_34_O, add_33_O, w_08, ~s_16_O[24]);
adder_unsign_8_bits		add_35	(add_35_O, add_34_O, w_09, ~s_18_O[24]);
adder_unsign_8_bits		add_36	(add_36_O, add_35_O, w_10, ~s_20_O[24]);
adder_unsign_8_bits		add_37	(add_37_O, add_36_O, w_11, ~s_22_O[24]);
adder_unsign_8_bits		add_38	(add_38_O, add_37_O, w_12, 1'b0);
assign add_38_O_ex[8:0] = {1'b0, add_38_O[7:0]};
sub_nadd_9_sign_bits	add_39	(add_39_O, 9'h97, add_38_O_ex, 1'b1);
mux_2_1	#(8)	exponent	(O[30:23], 8'b0, add_39_O[7:0], s_24_O[24]);
assign O[31] = in[24];

endmodule
//====================================================================================================//
module	shift_left_1_25bits	(O, in, en);
output	[24:0]	O;
input			en;
input	[24:0]	in;

assign O[24:0] = (en == 1'b1)?({in[23:0], 1'b0}):(in[24:0]);

endmodule
//====================================================================================================//
module	convert_float_into_int	(O, in);
output	[24:0]	O;
input	[31:0]	in;
wire			decision;
wire	[8:0]	extended_exponent;
wire	[9:0]	sub_exponent_00_O;
wire	[24:0]	adjusted_significand, extended_decision, n_sub_nadd_O, mux_0_O, mux_1_O;
wire	[25:0]	sub_nadd_O;
assign extended_exponent[8:0] = {1'b0, in[30:23]};
sub_nadd_9_sign_bits	sub_exponent_00	(sub_exponent_00_O, extended_exponent, 9'h7f, 1'b1);
adjust_significand		adjust_01		(.O(adjusted_significand), .in(in[22:0]), .number(sub_exponent_00_O[7:0]));
decide_on_rounding	rounding_decision	(.decision(decision), .in(in[22:0]), .number(sub_exponent_00_O[7:0]));
assign extended_decision[24:0] = {24'b0, decision};
sub_nadd_25_sign_bits	sub_nadd		(.O(sub_nadd_O), .in0(adjusted_significand), .in1(extended_decision), .sub_nadd(1'b0));

assign n_sub_nadd_O[24:0] = ~sub_nadd_O[24:0];
mux_2_1	#(25)	mux_0	(mux_0_O, sub_nadd_O[24:0], n_sub_nadd_O, in[31]);
mux_2_1	#(25)	mux_1	(mux_1_O, 25'b0, 25'b1, in[31]);
cong_25bits	add			(O, mux_0_O, mux_1_O);

endmodule
//====================================================================================================//
module	adjust_significand	(O, in, number);
output	reg[24:0]	O;
input	[22:0]		in;
input	[7:0]		number;

always @(*) begin
	case(number)
		8'h00:	O[24:0] = {24'b0, 1'b1};
		8'h01:	O[24:0] = {23'b0, 1'b1, in[22]};
		8'h02:	O[24:0] = {22'b0, 1'b1, in[22:21]};
		8'h03:	O[24:0] = {21'b0, 1'b1, in[22:20]};
		8'h04:	O[24:0] = {20'b0, 1'b1, in[22:19]};
		8'h05:	O[24:0] = {19'b0, 1'b1, in[22:18]};
		8'h06:	O[24:0] = {18'b0, 1'b1, in[22:17]};
		8'h07:	O[24:0] = {17'b0, 1'b1, in[22:16]};
		8'h08:	O[24:0] = {16'b0, 1'b1, in[22:15]};
		8'h09:	O[24:0] = {15'b0, 1'b1, in[22:14]};
		8'h0a:	O[24:0] = {14'b0, 1'b1, in[22:13]};
		8'h0b:	O[24:0] = {13'b0, 1'b1, in[22:12]};
		8'h0c:	O[24:0] = {12'b0, 1'b1, in[22:11]};
		8'h0d:	O[24:0] = {11'b0, 1'b1, in[22:10]};
		8'h0e:	O[24:0] = {10'b0, 1'b1, in[22:09]};
		8'h0f:	O[24:0] = { 9'b0, 1'b1, in[22:08]};
		8'h10:	O[24:0] = { 8'b0, 1'b1, in[22:07]};
		8'h11:	O[24:0] = { 7'b0, 1'b1, in[22:06]};
		8'h12:	O[24:0] = { 6'b0, 1'b1, in[22:05]};
		8'h13:	O[24:0] = { 5'b0, 1'b1, in[22:04]};
		8'h14:	O[24:0] = { 4'b0, 1'b1, in[22:03]};
		8'h15:	O[24:0] = { 3'b0, 1'b1, in[22:02]};
		8'h16:	O[24:0] = { 2'b0, 1'b1, in[22:01]};
		8'h17:	O[24:0] = { 1'b0, 1'b1, in[22:00]};
		8'h18:	O[24:0] = { 1'b1, in[22:00], 1'b0};
		default: O[24:0] = 25'b0;
	endcase
end
endmodule
//====================================================================================================//
module	decide_on_rounding	(decision, in, number);
output	reg		decision;
input	[22:0]		in;
input	[7:0]		number;

always @(*) begin
	case(number)
	8'h00:	begin if(in[22] == 1'b1 || in[21:11] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h01:	begin if(in[21] == 1'b1 || in[20:10] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h02:	begin if(in[20] == 1'b1 || in[19:09] == 11'h7ff) begin
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h03:	begin if(in[19] == 1'b1 || in[18:08] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end
			end
	8'h04:	begin if(in[18] == 1'b1 || in[17:07] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h05:	begin if(in[17] == 1'b1 || in[16:06] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h06:	begin if(in[16] == 1'b1 || in[15:05] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end
			end
	8'h07:	begin if(in[15] == 1'b1 || in[14:04] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h08:	begin if(in[14] == 1'b1 || in[13:03] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h09:	begin if(in[13] == 1'b1 || in[12:02] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h0a:	begin if(in[12] == 1'b1 || in[11:01] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h0b:	begin if(in[11] == 1'b1 || in[10:0] == 11'h7ff) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h0c:	begin if(in[10] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h0d:	begin if(in[09] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h0e:	begin if(in[08] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h0f:	begin if(in[07] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h10:	begin if(in[06] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h11:	begin if(in[05] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h12:	begin if(in[04] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h13:	begin if(in[03] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h14:	begin if(in[02] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h15:	begin if(in[01] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'h16:	begin if(in[00] == 1'b1) begin 
					decision = 1'b1; 
				end 
				else begin 
					decision = 1'b0; 
				end 
			end
	8'hff:	decision = 1'b1;
	default: decision = 1'b0;
	endcase
end
endmodule
//====================================================================================================//