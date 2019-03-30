module mem_64 (
	input [10:0] data_in,
	input [5:0]	wr_addr,
	input [5:0]	rd_addr,
	input		en_wr,
	input 		clk,
	input 		en_rd,
	output reg[10:0]	data_out
);

reg	[10:0] mem[0:63] ;

always @(posedge clk) begin
	if(en_wr == 1'b1) begin
		mem[wr_addr] <= data_in;
		// data_out <= mem[rd_addr];
	end
end

always @(negedge clk) begin
	if(en_rd == 1'b1) begin
		data_out <= mem[rd_addr] ;
	end
end
endmodule
//====================================================================================================
module FF (clk, data_in, rst_n, data_out) ;

parameter N = 8 ;
input clk ;
input [N-1:0] data_in ;
input rst_n ;
output reg[N-1:0]	data_out ;

// reg [N-1:0]	mem ;

always @(posedge clk) begin
	if(~rst_n) begin
		// mem	<= 0;
		data_out <= 0;
	end
	else begin
		// data_out[N-1:0] = mem[N-1:0] ;
		// mem[N-1:0] = data_in[N-1:0] ;
		data_out[N-1:0] = data_in[N-1:0] ;
	end
end

endmodule

//====================================================================================================
module m_bin_counter	(bin_count, count_on, clk, rst_n, load, count_down, count_up, init_value) ;
parameter N = 6 ;
output [N-1:0]	bin_count ;
output 			count_on ;
input			clk, rst_n ;
input			count_down, count_up, load ;
input	[N-1:0]	init_value ;

wire	[N-1:0]	count_value, count_value_out ;
wire	[N-1:0] add_out, sub_out , FF_in;
wire	[1:0]	select;

assign	count_on = (count_down | count_up) & (~load) ;
assign	bin_count = count_value_out ;
assign	select[1:0]	= {count_up, count_down} ;
mux_2_1	#(N)	m_0	(FF_in, count_value, init_value, load) ;
FF		#(N)	m_1	(clk, FF_in, rst_n, count_value_out) ;


adder_unsign_6_bits	add (add_out, count_value_out, 6'b01, 1'b0) ;
adder_unsign_6_bits sub (sub_out, count_value_out, 6'hff, 1'b0) ;


mux_4_1 #(N)		selecter (count_value, count_value_out, sub_out, add_out, count_value_out, select) ;

endmodule // m_bin_counter

//====================================================================================================
module m_zigzac_table (data_out, data_in, clk, rst_n);
output reg[5:0]	data_out ;
input	[5:0]	data_in ;
input			clk, rst_n ;

reg[7:0] ROM[63:0];

always @(posedge clk or data_in) begin
	if(~rst_n) begin : initialization
		ROM[00] <= 6'd00 ; ROM[02] <= 6'd01 ; ROM[03] <= 6'd02 ; ROM[09] <= 6'd03 ; ROM[10] <= 6'd04 ; ROM[20] <= 6'd05 ; ROM[21] <= 6'd06 ; ROM[35] <= 6'd07 ;
		ROM[01] <= 6'd08 ; ROM[04] <= 6'd09 ; ROM[08] <= 6'd10 ; ROM[11] <= 6'd11 ; ROM[19] <= 6'd12 ; ROM[22] <= 6'd13 ; ROM[34] <= 6'd14 ; ROM[36] <= 6'd15 ;
		ROM[05] <= 6'd16 ; ROM[07] <= 6'd17 ; ROM[12] <= 6'd18 ; ROM[18] <= 6'd19 ; ROM[23] <= 6'd20 ; ROM[33] <= 6'd21 ; ROM[37] <= 6'd22 ; ROM[48] <= 6'd23 ;
		ROM[06] <= 6'd24 ; ROM[13] <= 6'd25 ; ROM[17] <= 6'd26 ; ROM[24] <= 6'd27 ; ROM[32] <= 6'd28 ; ROM[38] <= 6'd29 ; ROM[47] <= 6'd30 ; ROM[49] <= 6'd31 ;
		ROM[14] <= 6'd32 ; ROM[16] <= 6'd33 ; ROM[25] <= 6'd34 ; ROM[31] <= 6'd35 ; ROM[39] <= 6'd36 ; ROM[46] <= 6'd37 ; ROM[50] <= 6'd38 ; ROM[57] <= 6'd39 ;
		ROM[15] <= 6'd40 ; ROM[26] <= 6'd41 ; ROM[30] <= 6'd42 ; ROM[40] <= 6'd43 ; ROM[45] <= 6'd44 ; ROM[51] <= 6'd45 ; ROM[56] <= 6'd46 ; ROM[58] <= 6'd47 ;
		ROM[27] <= 6'd48 ; ROM[29] <= 6'd49 ; ROM[41] <= 6'd50 ; ROM[44] <= 6'd51 ; ROM[52] <= 6'd52 ; ROM[55] <= 6'd53 ; ROM[59] <= 6'd54 ; ROM[62] <= 6'd55 ;
		ROM[28] <= 6'd56 ; ROM[42] <= 6'd57 ; ROM[43] <= 6'd58 ; ROM[53] <= 6'd59 ; ROM[54] <= 6'd60 ; ROM[60] <= 6'd61 ; ROM[61] <= 6'd62 ; ROM[63] <= 6'd63 ;
	end
	else begin
		data_out[5:0] = ROM[data_in]; 
	end
end // always @(posedge clk)

endmodule // m_zigzac_table
//====================================================================================================
module m_ZZk_comparator	(equal, unequal, ZZk, enable);
output	equal, unequal;
input	[10:0]	ZZk;
input			enable;

wire			compare_0;

assign	compare_0 = ~(ZZk[10] | ZZk[9] | ZZk[8] | ZZk[7] | ZZk[6] | ZZk[5] | 
							 ZZk[4] | ZZk[3] | ZZk[2] | ZZk[1] | ZZk[0]) ;

assign	equal = enable & compare_0 ;
assign	unequal = enable &  ~compare_0 ;

endmodule // m_ZZk_comparator

//====================================================================================================//
module m_K_comparator	(equal, unequal, k, enable);
output			equal, unequal;
input	[5:0]	k;
input			enable;

wire			compare_63;

assign	compare_63 = (k[5] & k[4] & k[3] & k[2] & k[1] & k[0]) ;

assign	equal = enable & compare_63;
assign	unequal = enable & ~compare_63;

endmodule // m_K_comparator
//====================================================================================================//
module m_R_comparator	(more, less_or_equal, R, enable);
output			more, less_or_equal;
input	[5:0]	R;
input			enable;

assign	more = enable & R[4] ;
assign	less_or_equal = enable & ~R[4] ;

endmodule // m_R_comparator

//====================================================================================================//
module	m_reg_R	(R, en_sub_16, en_add_1, en_wr, clk_1, rst_n); // checked
output	reg [5:0]	R;
input			en_sub_16, en_add_1 ;
input			en_wr, clk_1, rst_n ;

reg	[5:0]		mem;

always @(posedge clk_1) begin
	if(~rst_n) begin
		mem[5:0]	= 6'b0 ;
		R = 0;
	end
	else begin
		if(en_wr) begin
			if(en_add_1) 	mem++;
			if(en_sub_16) 	mem -= 16;
		end
		R[5:0] = mem[5:0];
	end
end

endmodule // m_reg_R

//====================================================================================================//
// module	m_control	(
// 	Reg, en_sub_16, en_add_1, reg_R_en_wr, reg_R_rst_n,
// 	R_comp_more, R_comp_less_or_equ,
// 	ZZk_equ_0, ZZk_unequ_0, ZZk,
// 	k_I_equ_63, k_I_unequ_63,/* k_I_en,*/
// 	dc_encoder_clk,
// 	output_select,
// 	sync,
// 	is_encoding_ac_coef_process,
// 	RRRR,
// 	encode_in,
// 	delayed_start,
// 	clk_0, clk_1, rst_n
// );

// output	reg		en_sub_16, en_add_1, reg_R_en_wr, reg_R_rst_n;
// output	reg		dc_encoder_clk;
// output	reg[1:0]		output_select;
// output	reg[3:0]	RRRR;
// output	reg[10:0]	encode_in;
// output	reg		sync;

// input			delayed_start;
// input	[5:0]	/*rst_n_counter*/ Reg;
// input	[10:0]	ZZk;
// input			is_encoding_ac_coef_process;
// input			R_comp_more, R_comp_less_or_equ;
// input			ZZk_equ_0, ZZk_unequ_0;
// input			k_I_equ_63, k_I_unequ_63;
// input			clk_1, clk_0, rst_n;


// reg				starting_ac_mode, processing_ac, n_reset_R;


// assign		reg_R_rst_n = (is_encoding_ac_coef_process && n_reset_R)?(1):(0) ;

// always @(negedge clk_0) begin
// 	if(~rst_n) begin
		
// 		starting_ac_mode = 0;
// 		sync = 0;
// 		encode_in = 0;
// 		en_sub_16 = 0;
// 		en_add_1 = 0; 
// 		reg_R_en_wr = 0;
// 		n_reset_R = 0;
// 		output_select = 0;
// 		dc_encoder_clk = 0;
// 		RRRR = 0;
// 		encode_in = 0;
// 	end
// 	else begin
// 	// xu ly ZZk = 0
// 		@(negedge clk_1) begin
// 			if(delayed_start) begin

// 				if(is_encoding_ac_coef_process) begin
// 					if(ZZk_equ_0 & ~ZZk_unequ_0) begin
// 						n_reset_R = 1;
// 						if(k_I_unequ_63 & ~k_I_equ_63) begin
// 							reg_R_en_wr = 1; 
// 							en_add_1 = 1;
// 							@(negedge clk_1) begin
// 								reg_R_en_wr = 0; en_add_1 = 0;
// 							end
// 						end
// 						if(k_I_equ_63 & ~k_I_unequ_63) begin
							
// 							RRRR = 0;
// 							encode_in = 0;
// 							sync = 1;
// 							output_select = 2;

// 							@(negedge clk_1) begin
// 								reg_R_en_wr = 0; en_add_1 = 0;
// 								sync = 0;
// 								output_select = 3;
// 							end
// 						end
// 					end
// 					if(ZZk_unequ_0 & ~ZZk_equ_0) begin
// 						processing_ac = 1;
// 					end
// 				end
// 			end
// 		end
// 	end
// end


// // xu ly  cho DC
// always @(negedge clk_0) begin
// 	if(delayed_start) begin
// 		if(~is_encoding_ac_coef_process) begin
// 			sync = 1;
// 			output_select = 1;
// 			dc_encoder_clk = 1;
// 			@(posedge clk_1) begin
// 				sync = 0;
// 				output_select = 3;
// 			end
// 		end
// 		else begin
// 			dc_encoder_clk = 0;
// 			starting_ac_mode = 1;
// 		end
// 	end
// end


// // xu ly ZZk khac 0
// always @(negedge clk_1/* or ZZk_equ_0 or ZZk_unequ_0 or R_comp_more or R_comp_less_or_equ*/) begin
// 	if(delayed_start) begin
// 		if(ZZk_unequ_0 & ~ZZk_equ_0 & starting_ac_mode & processing_ac) begin
// 			if(R_comp_more) begin

// 				sync = 1 ;
// 				RRRR = 4'hF;
// 				encode_in = 0;
// 				output_select = 2;

// 				reg_R_en_wr = 1;
// 				en_sub_16 = 1;
// 			end
// 			if (R_comp_less_or_equ) begin
				
// 				reg_R_en_wr = 0; 
// 				en_sub_16 = 0;

// 				// code_normal = 1;
// 				sync = 1 ;
// 				output_select = 2;
// 				RRRR = Reg;
// 				encode_in = ZZk;

// 				starting_ac_mode = 0;
// 				//
// 				@(negedge clk_1) begin 
// 					sync = 0;
// 					n_reset_R = 0;   // reset reg o clock ke tiep
// 					output_select = 3;
// 					processing_ac = 0;
// 				end
// 				@(negedge clk_1) n_reset_R = 1;
// 				//
// 			end
// 		end
// 	end
// end


// // always @(*) begin


// // end

// endmodule // control

/////////////////////////////////////////////////////////////////////////////////////////////////////

module m_control_v2 (
	Reg, en_sub_16, en_add_1, reg_R_en_wr, reg_R_rst_n,
	R_comp_more, R_comp_less_or_equ,
	ZZk_equ_0, ZZk_unequ_0, ZZk,
	k_I_equ_63, k_I_unequ_63,/* k_I_en,*/
	dc_encoder_clk,
	output_select,
	sync,
	is_encoding_ac_coef_process,
	RRRR,
	encode_in,
	delayed_start,
	clk_0, clk_1, rst_n
);

output	reg			en_sub_16, en_add_1, reg_R_en_wr, reg_R_rst_n;
output	reg			dc_encoder_clk;
output	reg[1:0]	output_select;
output	reg[3:0]	RRRR;
output	reg[10:0]	encode_in;
output	reg			sync;

input			delayed_start;
input	[5:0]	Reg;
input	[10:0]	ZZk;
input			is_encoding_ac_coef_process;
input			R_comp_more, R_comp_less_or_equ;
input			ZZk_equ_0, ZZk_unequ_0;
input			k_I_equ_63, k_I_unequ_63;
input			clk_1, clk_0, rst_n;


reg				situation, n_reset_R, starting_ac_mode ;




assign		reg_R_rst_n = (is_encoding_ac_coef_process && n_reset_R)?(1):(0) ;


// xu ly  cho DC
always @(negedge clk_0) begin
	if(delayed_start) begin
		if(~is_encoding_ac_coef_process) begin
			sync = 1;
			output_select = 1;
			dc_encoder_clk = 1;
			@(posedge clk_1) begin
				sync = 0;
				output_select = 3;
				dc_encoder_clk = 0;
			end
		end
	end
end



always @(negedge clk_0) begin
	if(~rst_n) begin
		sync = 0;
		en_sub_16 = 0;
		en_add_1 = 0; 
		reg_R_en_wr = 0;
		n_reset_R = 1;
		output_select = 3;
		dc_encoder_clk = 0;
		RRRR = 0;
		encode_in = 0;
		situation = 0;
		starting_ac_mode = 0;
	end
	else begin
		if(delayed_start) begin
			if(is_encoding_ac_coef_process && ~starting_ac_mode) begin
				starting_ac_mode = 1;
				@(negedge clk_1) begin
					if(ZZk_equ_0 && ~ZZk_unequ_0 && k_I_equ_63 && ~k_I_unequ_63) begin
						situation = 0;
						RRRR = 0;
						encode_in = 0;
						sync = 1;
						output_select = 2;
						@(negedge clk_1) begin 
							sync = 0;
							output_select = 3;
							starting_ac_mode = 0;
						end
					end
					if(ZZk_equ_0 && ~ZZk_unequ_0 && ~k_I_equ_63 && k_I_unequ_63) begin
						situation = 0;
						en_add_1 = 1;
						reg_R_en_wr = 1;
						@(negedge clk_1) begin
							en_add_1 = 0;
							reg_R_en_wr = 0;
							starting_ac_mode = 0;
						end
					end
					if(~ZZk_equ_0 && ZZk_unequ_0) begin
						situation = 1;
					end
				end
			end	
		end
	end
end

always @(negedge clk_1) begin
	if(is_encoding_ac_coef_process && situation && starting_ac_mode) begin
		if(R_comp_more && ~R_comp_less_or_equ) begin
			RRRR = 4'hF;
			encode_in = 4'h0;
			sync = 1;
			en_sub_16 = 1;
			reg_R_en_wr = 1;
			output_select = 2;
		end
		if(~R_comp_more && R_comp_less_or_equ) begin
			RRRR = Reg;
			encode_in = ZZk;
			sync = 1;
			en_sub_16 = 0;
			reg_R_en_wr = 0;
			output_select = 2;
			@(negedge clk_1) begin
				sync = 0;
				n_reset_R = 0;
				output_select = 3;
				starting_ac_mode = 0;
			end
			@(negedge clk_1) begin
				n_reset_R = 1;
			end
		end
	end
end



endmodule // control_v2


///////////////////////////////////////////////////////////////////////////////////////////////////////////




//====================================================================================================//
module	m_delay_28_clock (o, in, clk, rst_n);
output	reg	o;
input		in;
input		clk, rst_n;

reg	[29:0]	temp;

always @(posedge clk) begin
	if(~rst_n) begin
		temp = 0;
		o = 0;
	end
	else begin
		temp[0] = in ;
		temp <<= 1;
		o = temp[29];
	end
end

endmodule // m_delay_28_clock

//====================================================================================================//
// module m_delay_half_clock	(o, in, clk);
// output	reg	o;
// input		in;
// input		clk;

// always @(negedge clk) begin
// 	o = in;
// end
// endmodule // m_delay_half_clock

//====================================================================================================//
module m_luminance_component_encoder (
	data_out, bits, sync, 
	quantized_Y, start, clk_0, clk_1, rst_n
);

output	[25:0]	data_out;
output	[4:0]	bits;
output			sync;
input	[10:0]	quantized_Y;
input			start;
input			clk_0, clk_1, rst_n;


wire	[1:0]	output_select;
wire	[5:0]	wr_mem_addr;
wire	[5:0]	rd_addr;
wire	[10:0]	ZZk;
wire	[5:0]	k;
wire			delayed_start;
wire			ZZk_equ_0, ZZk_unequ_0, is_encoding_ac_coef_process;
wire			k_I_equ_63, k_I_unequ_63, k_I_en;
wire	[5:0]	Reg;
wire			en_sub_16, en_add_1, reg_R_en_wr, reg_R_rst_n;
wire			R_comp_more, R_comp_less_or_equ;
wire	[4:0]	number_of_ac_bits;
wire	[25:0]	extd_ac_huff_code;
wire	[10:0]	encode_in;
wire	[3:0]	RRRR;
wire	[4:0]	number_of_dc_bits;
wire	[25:0]	extd_dc_huff_code;
wire			dc_encoder_clk;



//checking
bit[31:0]       element;

initial begin
element = 0;
end


always @(posedge clk_1) begin
	if((sync == 1) && (rst_n == 1)) element++;
end

//end checking


//====================================================================================================//
// store data im mem 64

m_bin_counter	#(6)	calc_mem_addr	(
	.bin_count(wr_mem_addr),
	.count_on(), 
	.clk(clk_0),
	.rst_n(rst_n),
	.load(~start),
	.count_down(1'b0),
	.count_up(1'b1),
	.init_value(6'b0)
);

mem_64				mem	(
	.data_in(quantized_Y),
	.wr_addr(wr_mem_addr),
	.rd_addr(rd_addr),
	.en_wr(1'b1),
	.clk(clk_0),
	.en_rd(1'b1),
	.data_out(ZZk)
);

m_zigzac_table		zigzac_table	(
	.data_out(rd_addr),
	.data_in(k),
	.clk(clk_0), 
	.rst_n(rst_n)
);

//------------------------------------------------------------------------------------------//
m_delay_28_clock delay	(
	.o(delayed_start), .in(start), .clk(clk_0), .rst_n(rst_n)
);

m_bin_counter	#(6)	K_counter	(
	.bin_count(k), 
	.count_on(), 
	.clk(clk_0),
	.rst_n(rst_n),
	.load(~delayed_start),
	.count_down(1'b0), 
	.count_up(1'b1), 
	.init_value(6'b0)
);

m_ZZk_comparator	ZZk_comparator	(
	.equal(ZZk_equ_0),
	.unequal(ZZk_unequ_0),
	.ZZk(ZZk),
	.enable(is_encoding_ac_coef_process)
);

assign	k_I_en = ZZk_equ_0 &  ~ZZk_unequ_0 ;

m_K_comparator		K_I_comparator	(
	.equal(k_I_equ_63), 
	.unequal(k_I_unequ_63), 
	.k(k), 
	.enable(k_I_en)
);

assign	is_encoding_ac_coef_process = (k[5] | k[4] | k[3] | k[2] | k[1] | k[0]) ;

m_reg_R				reg_R	(
	.R(Reg),
	.en_sub_16(en_sub_16), 
	.en_add_1(en_add_1), 
	.en_wr(reg_R_en_wr), 
	.clk_1(clk_1),
	.rst_n(reg_R_rst_n)
);

m_R_comparator		R_comparator	(
	.more(R_comp_more),
	.less_or_equal(R_comp_less_or_equ),
	.R(Reg), 
	.enable(1'b1)
);

m_encode_luminance_ac	encode_luminance_ac	(
	.number_of_bits(number_of_ac_bits),
	.extd_huff_code(extd_ac_huff_code),
	/*.RRRR(Reg[3:0]),*/ .RRRR(RRRR),
	/*.in(ZZk)*/ .in(encode_in)
);

assign extd_dc_huff_code[25:20] = 6'b0;
m_encode_luminance_dc	encode_luminance_dc	(
	.number_of_bits(number_of_dc_bits),
	.ext_code(extd_dc_huff_code[19:0]), 
	.dc_in(ZZk),
	.clk(dc_encoder_clk), .rst_n(rst_n)
);

mux_4_1 #(26)	encoded_data	(
	.O(data_out),
	.in0(26'b0),
	.in1(extd_dc_huff_code),
	.in2(extd_ac_huff_code),
	.in3(26'b0),
	.select(output_select)
);

mux_4_1 #(5)	number_of_bits	(
	.O(bits),
	.in0(5'b0),
	.in1(number_of_dc_bits),
	.in2(number_of_ac_bits),
	.in3(5'b0),
	.select(output_select)
);

m_control_v2	control	(
	.Reg(Reg), .en_sub_16(en_sub_16), .en_add_1(en_add_1), .reg_R_en_wr(reg_R_en_wr), .reg_R_rst_n(reg_R_rst_n),
	.R_comp_more(R_comp_more), .R_comp_less_or_equ(R_comp_less_or_equ),
	.ZZk_equ_0(ZZk_equ_0), .ZZk_unequ_0(ZZk_unequ_0), .ZZk(ZZk),
	.k_I_equ_63(k_I_equ_63), .k_I_unequ_63(k_I_unequ_63), /*.k_I_en(k_I_en),*/
	.dc_encoder_clk(dc_encoder_clk),
	.output_select(output_select),
	.sync(sync),
	.is_encoding_ac_coef_process(is_encoding_ac_coef_process),
	.RRRR(RRRR),
	.encode_in(encode_in),
	.delayed_start(delayed_start),
	.clk_0(clk_0), .clk_1(clk_1), .rst_n(rst_n)
);

endmodule // encode_luminance

//====================================================================================================//
module m_chrominance_component_encoder (
	data_out, bits, sync, 
	quantized_chrominance, start, clk_0, clk_1, rst_n
);

output	[25:0]	data_out;
output	[4:0]	bits;
output			sync;
input	[10:0]	quantized_chrominance;
input			start;
input			clk_0, clk_1, rst_n;

wire	[1:0]	output_select;
wire	[5:0]	wr_mem_addr;
wire	[5:0]	rd_addr;
wire	[10:0]	ZZk;
wire	[5:0]	k;
wire			delayed_start;
wire			ZZk_equ_0, ZZk_unequ_0, is_encoding_ac_coef_process;
wire			k_I_equ_63, k_I_unequ_63, k_I_en;
wire	[5:0]	Reg;
wire			en_sub_16, en_add_1, reg_R_en_wr, reg_R_rst_n;
wire			R_comp_more, R_comp_less_or_equ;
wire	[4:0]	number_of_ac_bits;
wire	[25:0]	extd_ac_huff_code;
wire	[10:0]	encode_in;
wire	[3:0]	RRRR;
wire	[4:0]	number_of_dc_bits;
wire	[25:0]	extd_dc_huff_code;
wire			dc_encoder_clk;



//checking
bit[31:0]       element;

initial begin
element = 0;
end


always @(posedge clk_1) begin
	if((sync == 1) && (rst_n == 1)) element++;
end

//end checking



m_bin_counter	#(6)	calc_mem_addr	(
	.bin_count(wr_mem_addr),
	.count_on(), 
	.clk(clk_0),
	.rst_n(rst_n),
	.load(~start),
	.count_down(1'b0),
	.count_up(1'b1),
	.init_value(6'b0)
);

mem_64				mem	(
	.data_in(quantized_chrominance),
	.wr_addr(wr_mem_addr),
	.rd_addr(rd_addr),
	.en_wr(1'b1),
	.clk(clk_0),
	.en_rd(1'b1),
	.data_out(ZZk)
);

m_zigzac_table		zigzac_table	(
	.data_out(rd_addr),
	.data_in(k),
	.clk(clk_0), 
	.rst_n(rst_n)
);


//====================================================================================================//
m_delay_28_clock delay	(
	.o(delayed_start), .in(start), .clk(clk_0), .rst_n(rst_n)
);

m_bin_counter	#(6)	K_counter	(
	.bin_count(k), 
	.count_on(), 
	.clk(clk_0),
	.rst_n(rst_n),
	.load(~delayed_start),
	.count_down(1'b0), 
	.count_up(1'b1), 
	.init_value(6'b0)
);


m_ZZk_comparator	ZZk_comparator	(
	.equal(ZZk_equ_0),
	.unequal(ZZk_unequ_0),
	.ZZk(ZZk),
	.enable(is_encoding_ac_coef_process)
);

assign	k_I_en = ZZk_equ_0 &  ~ZZk_unequ_0 ;

m_K_comparator		K_I_comparator	(
	.equal(k_I_equ_63), 
	.unequal(k_I_unequ_63), 
	.k(k), 
	.enable(k_I_en)
);

assign	is_encoding_ac_coef_process = (k[5] | k[4] | k[3] | k[2] | k[1] | k[0]) ;

m_reg_R				reg_R	(
	.R(Reg),
	.en_sub_16(en_sub_16), 
	.en_add_1(en_add_1), 
	.en_wr(reg_R_en_wr), 
	.clk_1(clk_1),
	.rst_n(reg_R_rst_n)
);


m_R_comparator		R_comparator	(
	.more(R_comp_more),
	.less_or_equal(R_comp_less_or_equ),
	.R(Reg), 
	.enable(1'b1)
);


m_encode_chrominance_ac	encode_chrominance_ac	(
	.number_of_bits(number_of_ac_bits),
	.extd_huff_code(extd_ac_huff_code),
	/*.RRRR(Reg[3:0]),*/ .RRRR(RRRR),
	/*.in(ZZk)*/ .in(encode_in)
);


assign extd_dc_huff_code[25:20] = 6'b0;
m_encode_chrominance_dc	encode_chrominance_dc	(
	.number_of_bits(number_of_dc_bits),
	.ext_code(extd_dc_huff_code[21:0]), 
	.dc_in(ZZk),
	.clk(dc_encoder_clk), .rst_n(rst_n)
);


mux_4_1 #(26)	encoded_data	(
	.O(data_out),
	.in0(26'b0),
	.in1(extd_dc_huff_code),
	.in2(extd_ac_huff_code),
	.in3(26'b0),
	.select(output_select)
);
mux_4_1 #(5)	number_of_bits	(
	.O(bits),
	.in0(5'b0),
	.in1(number_of_dc_bits),
	.in2(number_of_ac_bits),
	.in3(5'b0),
	.select(output_select)
);

m_control_v2	control	(
	.Reg(Reg), .en_sub_16(en_sub_16), .en_add_1(en_add_1), .reg_R_en_wr(reg_R_en_wr), .reg_R_rst_n(reg_R_rst_n),
	.R_comp_more(R_comp_more), .R_comp_less_or_equ(R_comp_less_or_equ),
	.ZZk_equ_0(ZZk_equ_0), .ZZk_unequ_0(ZZk_unequ_0), .ZZk(ZZk),
	.k_I_equ_63(k_I_equ_63), .k_I_unequ_63(k_I_unequ_63), /*.k_I_en(k_I_en),*/
	.dc_encoder_clk(dc_encoder_clk),
	.output_select(output_select),
	.sync(sync),
	.is_encoding_ac_coef_process(is_encoding_ac_coef_process),
	.RRRR(RRRR),
	.encode_in(encode_in),
	.delayed_start(delayed_start),
	.clk_0(clk_0), .clk_1(clk_1), .rst_n(rst_n)
);


endmodule // m_chrominance_component_encoder