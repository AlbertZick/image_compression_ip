// `timescale 1ps/1ps
//====================================================================================================//
module	small_ALU	(O, multiply_by_zero, add_2_zero_no, left_FP, right_FP, sub_nadd);
output	[8:0]	O;
output			multiply_by_zero, add_2_zero_no;
input	[7:0]	left_FP, right_FP;
input			sub_nadd;
wire	[8:0]	left_FP_ex, right_FP_ex, left_FP_reduce, right_FP_reduce;
wire	[9:0]	O_left_FP, O_right_FP, Out;


	assign multiply_by_zero = (~(left_FP[7] | left_FP[6] | left_FP[5] | left_FP[4] | left_FP[3] | left_FP[2] | left_FP[1] | left_FP[0]) | 
							  ~(right_FP[7] | right_FP[6] | right_FP[5] | right_FP[4] | right_FP[3] | right_FP[2] | right_FP[1] | right_FP[0])) & (~sub_nadd);
	assign add_2_zero_no = (~(left_FP[7] | left_FP[6] | left_FP[5] | left_FP[4] | left_FP[3] | left_FP[2] | left_FP[1] | left_FP[0]) & 
							  ~(right_FP[7] | right_FP[6] | right_FP[5] | right_FP[4] | right_FP[3] | right_FP[2] | right_FP[1] | right_FP[0])) & (sub_nadd);


	assign  left_FP_ex[8:0] = {1'b0,left_FP[7:0]};
	assign  right_FP_ex[8:0] = {1'b0, right_FP[7:0]};
	sub_nadd_9_sign_bits	m00	(O_left_FP, left_FP_ex, 9'b0111_1111, 1'b1); // tru di 127
	sub_nadd_9_sign_bits	m01	(O_right_FP, right_FP_ex, 9'b0111_1111, 1'b1); // tru di 127
	assign  left_FP_reduce[8:0] = {O_left_FP[9],		O_left_FP[7:0]};
	assign  right_FP_reduce[8:0] = {O_right_FP[9],	O_right_FP[7:0]};
	sub_nadd_9_sign_bits	m03	(Out, left_FP_reduce, right_FP_reduce, sub_nadd);
	assign  O[8:0] = {Out[9], Out[7:0]};
endmodule
//====================================================================================================//
module exponent_difference	(O, in);
output	[7:0]	O;
input	[8:0]	in;
wire	[8:0]	n_in, m00_O, m01_O;
wire	[9:0]	m02_O;
	assign  n_in[8:0]	= ~(in[8:0]);
	mux_2_1	#(9)	m00	(m00_O, in, n_in, in[8]);
	mux_2_1	#(9)	m01	(m01_O, 9'b0, 9'b01, in[8]);
	sub_nadd_9_sign_bits m02	(m02_O, m01_O, m00_O, 1'b0);
	assign  O[7:0] = m02_O[7:0];
endmodule
//====================================================================================================//
module	shift_right	(O, in, number);
output	reg [23:0]	O;
input		[22:0]	in;
input		[7:0]	number;

	always @(*) begin
		case (number)
			8'b0_0000:	O[23:0] = {01'b1, in[22:0]};
			8'b0_0001:	O[23:0] = {01'b0, 1'b1, in[22:01]};
			8'b0_0010:	O[23:0] = {02'b0, 1'b1, in[22:02]};
			8'b0_0011:	O[23:0] = {03'b0, 1'b1, in[22:03]};
			8'b0_0100:	O[23:0] = {04'b0, 1'b1, in[22:04]};
			8'b0_0101:	O[23:0] = {05'b0, 1'b1, in[22:05]};
			8'b0_0110:	O[23:0] = {06'b0, 1'b1, in[22:06]};
			8'b0_0111:	O[23:0] = {07'b0, 1'b1, in[22:07]};
			8'b0_1000:	O[23:0] = {08'b0, 1'b1, in[22:08]};
			8'b0_1001:	O[23:0] = {09'b0, 1'b1, in[22:09]};
			8'b0_1010:	O[23:0] = {10'b0, 1'b1, in[22:10]};
			8'b0_1011:	O[23:0] = {11'b0, 1'b1, in[22:11]};
			8'b0_1100:	O[23:0] = {12'b0, 1'b1, in[22:12]};
			8'b0_1101:	O[23:0] = {13'b0, 1'b1, in[22:13]};
			8'b0_1110:	O[23:0] = {14'b0, 1'b1, in[22:14]};
			8'b0_1111:	O[23:0] = {15'b0, 1'b1, in[22:15]};
			8'b1_0000:	O[23:0] = {16'b0, 1'b1, in[22:16]};
			8'b1_0001:	O[23:0] = {17'b0, 1'b1, in[22:17]};
			8'b1_0010:	O[23:0] = {18'b0, 1'b1, in[22:18]};
			8'b1_0011:	O[23:0] = {19'b0, 1'b1, in[22:19]};
			8'b1_0100:	O[23:0] = {20'b0, 1'b1, in[22:20]};
			8'b1_0101:	O[23:0] = {21'b0, 1'b1, in[22:21]};
			8'b1_0110:	O[23:0] = {22'b0, 1'b1, in[22]};
			8'b1_0111:	O[23:0] = {23'b0, 1'b1};
			8'b1_1000:	O[23:0] = {24'b0};
			default: 	O[23:0] = {24'b0};
		endcase
	end
endmodule
//====================================================================================================//
//-----tested
module	big_ALU	(O, in0, in1, option);
output	[48:0]	O;
input	[23:0]	in0;
input	[22:0]	in1;
input	[3:0]	option;

wire			sub_nadd, mux_05_select;
wire	[1:0]	select, mux_06_select;
wire	[23:0]	in_left, in_left_00, in_left_01, in_left_02, in_left_03;
wire	[23:0]	in_right, in_right_00, in_right_01, in_right_02, in_right_03;
wire 	[23:0]	divider_04_O, mux_05_O;
wire	[24:0]	in_right_00_ex, in_left_00_ex;
wire 	[25:0]	sub_nadd_25_sign_02_O;
wire	[47:0]	multiplier_03_O;
wire	[48:0]	mux_06_O, sub_nadd_25_sign_02_O_ex, multiplier_03_O_ex, divider_04_O_ex, mux_05_O_ex;

//-----to declare modules and connect them together
assign in_left[23:0] = in0[23:0];
assign in_right[23:0] = {1'b1, in1[22:0]};
demux_1_4	#(24)		dem_00	(in_left_00, in_left_01, in_left_02, in_left_03, in_left, select);
demux_1_4	#(24)		dem_01	(in_right_00, in_right_01, in_right_02, in_right_03, in_right, select);
assign  in_left_00_ex[24:0] = {1'b0,in_left_00[23:0]};
assign  in_right_00_ex[24:0] = {1'b0, in_right_00[23:0]};
sub_nadd_25_sign_bits 	sub_nadd_25_sign_02 	(sub_nadd_25_sign_02_O, in_right_00_ex, in_left_00_ex, sub_nadd);
multiplier_24x24_bits 	multiplier_03			(multiplier_03_O, in_left_01, in_right_01);
divider_24x24_bits		divider_04				(divider_04_O, in_left_02, in_right_02);
mux_2_1		#(24)		mux_05					(mux_05_O, in_left_03, in_right_03, mux_05_select);
assign  sub_nadd_25_sign_02_O_ex[48:0] 	= {sub_nadd_25_sign_02_O[25:0], 23'b0};
assign  multiplier_03_O_ex[48:0] 		= {1'b0, multiplier_03_O[47:0]};
assign  divider_04_O_ex[48:0] 			= {divider_04_O[23:0], 25'b0};
assign  mux_05_O_ex[48:0]				= {mux_05_O[23:0], 25'b0};
mux_4_1		#(49)		mux_06					(mux_06_O, 
								sub_nadd_25_sign_02_O_ex, multiplier_03_O_ex, divider_04_O_ex, mux_05_O_ex, 
												mux_06_select);
assign O[48:0] = mux_06_O[48:0];
//-----to receive control signal
assign select[0] =  ~(option[3]   | option[2]    | option[1] 	| option[0]) |
					(option[3]    & option[2]    & option[1] 	& option[0]) |
					((~option[3]) & (~option[2]) & option[1] 	& option[0]);
assign select[1] = ~(option[3]    | option[2]    | option[1] 	| option[0]) |
					(option[3]    & option[2]    & option[1] 	& option[0]) |
					((~option[3]) & option[2]    & (~option[1]) & (~option[0]));
assign sub_nadd = ((~option[3])   & (~option[2]) & option[1] 	& (~option[0]));
assign mux_05_select = (option[3] & option[2]    & option[1] 	& option[0]);
assign mux_06_select[1:0] = select[1:0];
endmodule
//====================================================================================================//
module abs	(O, in);
output	[47:0]	O;
input	[48:0]	in;
wire	[48:0]	n_in, m00_O, m01_O;
wire	[49:0]	m02_O;
	assign  n_in[48:0]	= ~(in[48:0]);
	mux_2_1	#(49)	m00	(m00_O, in, n_in, in[48]);
	mux_2_1	#(49)	m01	(m01_O, 49'b0, 49'b01, in[48]);
	sub_nadd_49_sign_bits m02	(m02_O, m01_O, m00_O, 1'b0);
	assign  O[47:0] = m02_O[47:0];
endmodule
//====================================================================================================//
//----- tested
module shift_left_or_right	(O, shift_count, equal_to_zero, in);
output	[47:0]	O;
output	[5:0]	shift_count;
output			equal_to_zero;
input	[47:0]	in;

wire			or_01_O, or_03_O, or_05_O, n_or_01_O, n_or_03_O, n_or_05_O;
wire			s_09_en, s_10_en, s_11_en, s_12_en, s_13_en, mux_14_select, mux_15_select, mux_17_select;
wire	[1:0]	mux_04_select;
wire	[5:0]	mux_04_O, mux_14_O, mux_15_O, mux_17_O, add_16_O, add_18_O, add_19_in0, add_19_O, add_20_in0, add_20_O, sub_24_O;
wire	[11:0]	mux_02_O;
wire	[47:0]	dem_00_0, dem_00_1, s_06_O, s_07_O, s_08_O, s_09_O, s_10_O, s_11_O, s_12_O, s_13_O, s_21_O, shift_O;

demux_1_2	#(48)	dem_00 	(dem_00_0, dem_00_1, in, in[47]);
assign or_01_O = 	dem_00_0[47]| dem_00_0[46]| dem_00_0[45]| dem_00_0[44]| dem_00_0[43]| dem_00_0[42]| dem_00_0[41]| dem_00_0[40]| dem_00_0[39]| dem_00_0[38]|
					dem_00_0[37]| dem_00_0[36]| dem_00_0[35]| dem_00_0[34]| dem_00_0[33]| dem_00_0[32]| dem_00_0[31]| dem_00_0[30]| dem_00_0[29]| dem_00_0[28]|
					dem_00_0[27]| dem_00_0[26]| dem_00_0[25]| dem_00_0[24];
mux_2_1		#(12)	mux_02	(mux_02_O,dem_00_0[23:12],dem_00_0[47:36],or_01_O);
assign or_03_O = 	mux_02_O[11]| mux_02_O[10]| mux_02_O[09]| mux_02_O[08]| mux_02_O[07]| mux_02_O[06]|
					mux_02_O[05]| mux_02_O[04]| mux_02_O[03]| mux_02_O[02]| mux_02_O[01]| mux_02_O[00];
assign mux_04_select[1:0] = {or_01_O, or_03_O};
mux_4_1		#(6)	mux_04	(mux_04_O, dem_00_0[11:6], dem_00_0[23:18], dem_00_0[35:30], dem_00_0[47:42], mux_04_select);
assign  or_05_O 	= mux_04_O[05]| mux_04_O[04]| mux_04_O[03]| mux_04_O[02]| mux_04_O[01]| mux_04_O[00];
assign n_or_01_O 	= ~or_01_O;
shift_left_24_bits	s_06	(s_06_O, dem_00_0, n_or_01_O);
assign n_or_03_O 	= ~or_03_O;
shift_left_12_bits	s_07 	(s_07_O, s_06_O, n_or_03_O);
assign n_or_05_O 	= ~or_05_O;
shift_left_6_bits	s_08 	(s_08_O, s_07_O, n_or_05_O);
assign s_09_en 		= ~s_08_O[47];
shift_left_1_bit 	s_09 	(s_09_O, s_08_O, s_09_en);
assign s_10_en 		= ~s_09_O[47];
shift_left_1_bit 	s_10 	(s_10_O, s_09_O, s_10_en);
assign s_11_en 		= ~s_10_O[47];
shift_left_1_bit 	s_11 	(s_11_O, s_10_O, s_11_en);
assign s_12_en 		= ~s_11_O[47];
shift_left_1_bit 	s_12 	(s_12_O, s_11_O, s_12_en);
assign s_13_en 		= ~s_12_O[47];
shift_left_1_bit 	s_13 	(s_13_O, s_12_O, s_13_en);
assign equal_to_zero = (~s_13_O[47]) & (~in[47]);	//----- to check if input bit string equal to zero or not
shift_left_1_bit 	shift 	(shift_O, s_13_O, 1'b1);
//

assign mux_14_select = or_01_O;
mux_2_1		#(6)	mux_14 	(mux_14_O, 6'b01_1000, 6'b0, mux_14_select);
assign mux_15_select = or_03_O;
mux_2_1		#(6)	mux_15 	(mux_15_O, 6'b00_1100, 6'b0, mux_15_select);
adder_unsign_6_bits	add_16	(add_16_O, mux_14_O, mux_15_O, s_09_en);
assign mux_17_select = or_05_O;
mux_2_1		#(6)	mux_17 	(mux_17_O, 6'b00_0110, 6'b0, mux_17_select);
adder_unsign_6_bits add_18	(add_18_O, add_16_O, mux_17_O, s_10_en);
assign add_19_in0 = {5'b0, s_11_en};
adder_unsign_6_bits add_19	(add_19_O, add_19_in0, add_18_O, s_12_en);
assign add_20_in0 = {5'b0, s_13_en};
adder_unsign_6_bits	add_20 	(add_20_O, add_20_in0, add_19_O, 1'b1);
//----- hieu chinh shift_count
sub_unsign_6_bits 	sub_24	(sub_24_O, add_20_O, 6'b00_0010);
//
shift_left_1_bit	s_21 	(s_21_O, dem_00_1, 1'b1);
mux_2_1		#(48)	mux_22  (O, shift_O, s_21_O, in[47]);
mux_2_1 	#(6)	mux_23  (shift_count, sub_24_O, 6'b11_1111, in[47]);
endmodule
//====================================================================================================//
module	inc_or_dec	(O, overflow, exponent, shift_count, equal_to_zero, en, adjust_in);
output	[7:0]	O;
output	[1:0]	overflow;
input	[8:0]	exponent;	// sign number in 8 bit string.
input	[5:0]	shift_count;
input			equal_to_zero, en, adjust_in;

wire			select, n_select, nor_gate_O;
wire	[8:0]	exponent_ex, mux_02_O, shift_count_ex, adjust_O;
wire	[9:0]	sub_nadd_sign_01_O, sub_nadd_sign_04_O;

assign exponent_ex[8:0] = exponent[8:0];

mux_2_1	#(9)	adjust	(adjust_O, 9'b0, 9'b0111_1111, adjust_in);

sub_nadd_9_sign_bits 	sub_nadd_sign_01	(sub_nadd_sign_01_O, exponent_ex, adjust_O, 1'b0);

assign shift_count_ex[8:0] = {3'b0, shift_count[5:0]};
mux_2_1		#(9)		mux_02 	(mux_02_O, shift_count_ex, 9'b01, select);

assign select 		= 	shift_count[5] & shift_count[4] & shift_count[3];
assign n_select 	= ~select;
sub_nadd_9_sign_bits 	sub_nadd_sign_04	(sub_nadd_sign_04_O, sub_nadd_sign_01_O[8:0], mux_02_O, n_select);

assign nor_gate_O 	= ~(sub_nadd_sign_04_O[0] | sub_nadd_sign_04_O[1] | sub_nadd_sign_04_O[2] | sub_nadd_sign_04_O[3] |
						sub_nadd_sign_04_O[4] | sub_nadd_sign_04_O[5] | sub_nadd_sign_04_O[6] | sub_nadd_sign_04_O[7] | 
						sub_nadd_sign_04_O[8]);
assign overflow[1] 	= (~sub_nadd_sign_04_O[9]) & 
						sub_nadd_sign_04_O[0] & sub_nadd_sign_04_O[1] & sub_nadd_sign_04_O[2] & sub_nadd_sign_04_O[3] &
						sub_nadd_sign_04_O[4] & sub_nadd_sign_04_O[5] & sub_nadd_sign_04_O[6] & sub_nadd_sign_04_O[7];
assign overflow[0] 	= 	(sub_nadd_sign_04_O[9] | nor_gate_O | equal_to_zero) & (~overflow[1]);
mux_2_1		#(8)		mux_05 	(O, sub_nadd_sign_01_O[7:0], sub_nadd_sign_04_O[7:0], en);
endmodule
//====================================================================================================//
module 	FP_control		(small_ALU, inc_or_dec_en, mux_ex_select, mux_00_select, mux_01_select, mux_02_select, mux_03_select, mux_04_select,
sign, adjust,
mux_05_select, mux_06_select, mux_07_select, 
big_ALU, shift_right,
MSB_small_ALU, MSB_big_ALU, MSB_left, MSB_right,
operand, overflow,
exponent_difference,
small_ALU_O, multiply_by_zero, add_2_zero_no);
output	reg			small_ALU, inc_or_dec_en, mux_ex_select, mux_00_select, mux_01_select, mux_02_select, mux_03_select, mux_04_select;
output	reg			sign, adjust;
output	reg[1:0]		mux_05_select, mux_06_select, mux_07_select;
output	reg[3:0]		big_ALU;
output	reg[7:0]		shift_right;

input					multiply_by_zero, add_2_zero_no;
input					MSB_small_ALU, MSB_big_ALU, MSB_left, MSB_right;
input 		[1:0]		operand, overflow;
input		[7:0]		exponent_difference;
input		[8:0]		small_ALU_O;

wire		[9:0]		m_00_O, m_01_O, m_02_O;


sub_nadd_9_sign_bits		m_01	(m_01_O, small_ALU_O, 9'b0111_1110, 1'b0);
assign	less_than_n126	=	m_01_O[9];
sub_nadd_9_sign_bits		m_02	(m_02_O, small_ALU_O, 9'b0111_1111, 1'b1);
assign	more_than_127	=	(~m_02_O[9]) & (m_02_O[8] | m_02_O[7] | m_02_O[6] | m_02_O[5] | m_02_O[4] | 
														m_02_O[3] | m_02_O[2] | m_02_O[1] | m_02_O[0]);
always  @(*)  begin
	case (operand)
		2'b00:	begin
						small_ALU = 1'b1;
						if(MSB_small_ALU == 1'b0) begin
							mux_00_select = 1'b0;
							mux_01_select = 1'b1;
							mux_02_select = 1'b0;
						end
						else begin
							mux_00_select = 1'b1;
							mux_01_select = 1'b0;
							mux_02_select = 1'b1;
						end
						mux_ex_select = 1'b0;
						adjust = 1'b0;
						mux_03_select = 1'b0;
						mux_04_select = 1'b0;
						shift_right[7:0] = exponent_difference[7:0];
						inc_or_dec_en = 1'b1;
						case ({MSB_left, MSB_right})
							2'b00: begin sign = 1'b0; big_ALU = 4'b0001; end
							2'b11: begin sign = 1'b1; big_ALU = 4'b0001; end
							default: begin big_ALU = 4'b0010; end
						endcase
						if(exponent_difference[7:0] != 8'b0) begin
							if(MSB_small_ALU == 1'b0) begin 
								sign = MSB_left; 
							end
							else begin 
								sign = MSB_right; 
							end
						end
						else begin
							if(MSB_big_ALU == 1'b0) begin sign = MSB_left; end
							else begin sign = MSB_right; end
						end
						case (overflow)
							2'b00: begin 
										if(add_2_zero_no == 1'b0) begin
											mux_05_select = 2'b10; 
											mux_06_select = 2'b11; 
											mux_07_select = 2'b11; 
										end
										else begin
											mux_05_select = 2'b00; 
											mux_06_select = 2'b00; 
											mux_07_select = 2'b00; 
										end
									end
							2'b01: begin 
										mux_05_select = 2'b00; 
										mux_06_select = 2'b00; 
										mux_07_select = 2'b00; 
									end
							2'b10: begin 
										if(add_2_zero_no == 1'b0) begin
											mux_05_select[1] = 1'b0; 
											mux_05_select[0] = MSB_right ^ MSB_left; 
											mux_06_select = 2'b01; 
											mux_07_select = 2'b01;
										end
										else begin
											mux_05_select = 2'b00; 
											mux_06_select = 2'b00; 
											mux_07_select = 2'b00;
										end
									end
						endcase
					end
		2'b01:	begin
						small_ALU = 1'b1;
						if(MSB_small_ALU == 1'b0) begin
							mux_00_select = 1'b0;
							mux_01_select = 1'b1;
							mux_02_select = 1'b0;
						end
						else begin
							mux_00_select = 1'b1;
							mux_01_select = 1'b0;
							mux_02_select = 1'b1;
						end
						mux_ex_select = 1'b0;
						adjust = 1'b0;
						mux_03_select = 1'b0;
						mux_04_select = 1'b0;
						shift_right[7:0] = exponent_difference[7:0];
						inc_or_dec_en = 1'b1;
						case ({MSB_left, MSB_right})
							2'b01: begin sign = 1'b0; big_ALU = 4'b0001; end
							2'b10: begin sign = 1'b1; big_ALU = 4'b0001; end
							default: begin big_ALU = 4'b0010; end
						endcase
						if(exponent_difference[7:0] != 8'b0) begin
							if(MSB_small_ALU == 1'b0) begin 
								sign = MSB_left; 
							end
							else begin 
								sign = ~MSB_right; 
							end
						end
						else begin
							if(MSB_big_ALU == 1'b0) begin 
								sign = MSB_left; 
							end
							else begin 
								sign = ~MSB_right; 
							end
							//sign = ~MSB_big_ALU;

						end
						case (overflow)
							2'b00:	begin 
										mux_05_select = 2'b10; 
										mux_06_select = 2'b11; 
										mux_07_select = 2'b11; 
									end
							2'b01:	begin 
										mux_05_select = 2'b00; 
										mux_06_select = 2'b00; 
										mux_07_select = 2'b00; 
									end
							2'b10:	begin 
										mux_05_select[1] = 1'b0; 
										mux_05_select[0] = (MSB_right ^ MSB_left); 
										mux_06_select = 2'b01; 
										mux_07_select = 2'b01; 
									end
						endcase
					end
		2'b10:	if(more_than_127 == 1'b1) begin
					small_ALU = 1'b0;
					adjust = 1'b1;
					case ({MSB_left, MSB_right})
						2'b00:	begin mux_05_select = 2'b00; end
						2'b01:	begin mux_05_select = 2'b01; end
						2'b10:	begin mux_05_select = 2'b01; end
						2'b11:	begin mux_05_select = 2'b00; end
					endcase
					mux_06_select = 2'b01;
					mux_07_select = 2'b01;
					shift_right = 8'b0;
					inc_or_dec_en = 1'b0;
				end
				else if (less_than_n126 == 1'b1) begin
					small_ALU = 1'b0;
					adjust = 1'b1;
					mux_05_select = 2'b00;
					mux_06_select = 2'b00;
					mux_07_select = 2'b00;
					shift_right = 8'b0;
					inc_or_dec_en = 1'b0;
				end
				else begin
					small_ALU = 1'b0;
					big_ALU	= 4'b0011;
					shift_right = 8'b0;
					mux_ex_select = 1'b1;
					adjust = 1'b1;
					mux_00_select = 1'b0;
					mux_01_select = 1'b0;
					mux_02_select = 1'b1;
					mux_03_select = 1'b0;
					mux_04_select = 1'b0;
					inc_or_dec_en = 1'b1;
					case (overflow)
					2'b00:	begin 
								case ({MSB_left, MSB_right})
									2'b00:	begin mux_05_select = 2'b00; end
									2'b01:	begin 
												if(multiply_by_zero == 1'b0) begin
													mux_05_select = 2'b01; 
												end
												else begin
													mux_05_select = 2'b00;
												end
											end
									2'b10:	begin 
												if(multiply_by_zero == 1'b0) begin
													mux_05_select = 2'b01;
												end
												else begin
													mux_05_select = 2'b00;
												end 
											end
									2'b11:	begin mux_05_select = 2'b00; end
								endcase
								if(multiply_by_zero == 1'b0) begin
									mux_06_select = 2'b11;
									mux_07_select = 2'b11;
								end
								else begin
									mux_06_select = 2'b00;
									mux_07_select = 2'b00;
								end										
							end
					2'b01:	begin 
								mux_05_select = 2'b00; 
								mux_06_select = 2'b00; 
								mux_07_select = 2'b00; 
							end
					2'b10:	begin 
								if(multiply_by_zero == 1'b0) begin
									mux_05_select[1] = 1'b0; 
									mux_05_select[0] = MSB_right ^ MSB_left; 
									mux_06_select	= 2'b01; 
									mux_07_select	= 2'b01; 
								end
								else begin
									mux_05_select = 2'b00; 
									mux_06_select = 2'b00; 
									mux_07_select = 2'b00;
								end
							end
					endcase
				end
	endcase
end
endmodule
//====================================================================================================//
module rounding	(O_exponent, O_significand, exponent, significand);
output	[22:0]	O_significand;
output	[7:0]	O_exponent;
input	[47:0]	significand;
input	[7:0]	exponent;
wire			exponent_eq_zero;

assign exponent_eq_zero = ~(exponent[0] | exponent[1] | exponent[2] | exponent[3] | 
							exponent[4] | exponent[5] | exponent[6] | exponent[7]);

assign O_significand[22:0] = (exponent_eq_zero == 1'b1)?(23'b0):(significand[47:25]);
assign O_exponent[7:0]		= exponent[7:0];

endmodule
//====================================================================================================//
module	FP	(O, in0, in1, operand);
output	[31:0]	O;
input		[31:0]	in0, in1;
input		[1:0]		operand;

wire			multiply_by_zero, add_2_zero_no;
wire			s_ALU_sub_nadd, left_MSB, right_MSB, mux_00_select, mux_01_select, mux_02_select, mux_03_select, mux_04_select;
wire			equal_to_zero, inc_dec_en, sign_bit, adjust, mux_05_11, mux_ex_select, MSB_small_ALU;
wire	[1:0]	inc_dec_overflow, mux_05_select, mux_06_select, mux_07_select;
wire	[3:0]	b_ALU_option;
wire	[7:0]	shift_number;
wire	[5:0]	shift_count;
wire	[7:0]	left_exponent, right_exponent, expo_diff_O, mux_00_O, inc_dec_O, mux_06_O, mux_06_10, mux_06_11;
wire	[7:0]	O_exponent;
wire	[8:0]	s_ALU_O, mux_ex_in0, mux_03_O, mux_03_0, mux_03_1, inc_dec_exponent;
wire	[22:0]	left_significand, right_significand, shift_in, b_ALU_in1, mux_07_O, mux_07_10, mux_07_11;
wire	[22:0]	O_significand;
wire	[23:0]	shift_O, b_ALU_in0;
wire	[47:0]	abs_00_O, shift_left_right_O, mux_04_1, mux_04_O;
wire	[48:0]	b_ALU_O, abs_00_in;

assign	left_MSB = in0[31];
assign	right_MSB = in1[31];
assign	left_exponent[7:0] = in0[30:23];
assign	right_exponent[7:0] = in1[30:23];
small_ALU	s_ALU	(s_ALU_O, multiply_by_zero, add_2_zero_no, left_exponent, right_exponent, s_ALU_sub_nadd);
exponent_difference	expo_diff	(expo_diff_O, s_ALU_O);
assign	left_significand[22:0] = in0[22:0];
assign	right_significand[22:0] = in1[22:0];
mux_2_1	#(8)	mux_00	(mux_00_O, left_exponent, right_exponent, mux_00_select);
mux_2_1	#(23)	mux_01	(shift_in, left_significand, right_significand, mux_01_select);
mux_2_1	#(23)	mux_02	(b_ALU_in1, left_significand, right_significand, mux_02_select);
assign	mux_ex_in0[8:0] = {1'b0, mux_00_O[7:0]};
mux_2_1	#(9)	mux_ex	(mux_03_0, mux_ex_in0, s_ALU_O, mux_ex_select);
shift_right		shift	(shift_O, shift_in, shift_number);
assign	b_ALU_in0[23:0] = shift_O[23:0];
big_ALU		b_ALU		(b_ALU_O, b_ALU_in0, b_ALU_in1, b_ALU_option);
assign	abs_00_in[48:0] = b_ALU_O[48:0];
abs			abs_00	(abs_00_O, abs_00_in);
assign		mux_03_1 = 9'b0;
mux_2_1	#(9)	mux_03	(mux_03_O, mux_03_0, mux_03_1, mux_03_select);
assign	mux_04_1 = 48'b0;
mux_2_1	#(48)	mux_04	(mux_04_O, abs_00_O, mux_04_1, mux_04_select);
assign inc_dec_exponent[8:0] = mux_03_O[8:0];
inc_or_dec	inc_dec	(inc_dec_O, inc_dec_overflow, inc_dec_exponent, shift_count, 
								equal_to_zero, inc_dec_en, adjust);
shift_left_or_right	shift_left_right	(shift_left_right_O, shift_count, equal_to_zero, mux_04_O);

assign MSB_small_ALU = s_ALU_O[8];
assign MSB_big_ALU = b_ALU_O[48];
FP_control	fp	(s_ALU_sub_nadd, inc_dec_en, mux_ex_select, mux_00_select, mux_01_select, mux_02_select, mux_03_select, mux_04_select,
sign_bit, adjust,
mux_05_select, mux_06_select, mux_07_select, 
b_ALU_option, shift_number,
MSB_small_ALU, MSB_big_ALU, left_MSB, right_MSB,
operand, inc_dec_overflow,
expo_diff_O,
s_ALU_O, multiply_by_zero, add_2_zero_no);

rounding		round		(O_exponent, O_significand, inc_dec_O, shift_left_right_O);

mux_4_1	#(1)	mux_05	(mux_05_O, 1'b0, 1'b1, sign_bit, mux_05_11, mux_05_select);
mux_4_1	#(8)	mux_06	(mux_06_O, 8'b0, 8'b1111_1111, mux_06_10, O_exponent, mux_06_select);
mux_4_1	#(23)	mux_07	(mux_07_O, 23'b0, 23'h7fffff, mux_07_10, O_significand, mux_07_select);

assign	O[31] = mux_05_O;
assign	O[30:23] = mux_06_O[7:0];
assign	O[22:0] = mux_07_O[22:0];

endmodule
//====================================================================================================//