/*

// Author:	Truong Tran
// Date:	2018/05/10
//====================================================================================================//
//====================================================================================================//
`timescale 1ps/1ps
module	image_compression_ip	(R_out, G_out, B_out, rst, clk);
output	[7:0]	R_out, G_out, B_out;
input			clk, rst;

wire	mem_start;
wire	finish_64, finish, enable, dct_2_D_rst, reset_quatization, reset_unquatization, r_dct_2_D_rst;
wire	[24:0]	dct_2D_Y_int, dct_2D_Cb_int, dct_2D_Cr_int, Y_int, Cb_int, Cr_int;
wire	[31:0]	R_O, G_O, B_O, Y_in, Cb_in, Cr_in, Y_O, Cb_O, Cr_O;
wire	[31:0]	float_Y, float_Cb, float_Cr, dct_2D_Y_float, dct_2D_Cb_float, dct_2D_Cr_float;
wire	[31:0]	quantized_Y, quantized_Cb, quantized_Cr;
wire	[24:0]	rounded_Y_int, rounded_Cb_int, rounded_Cr_int;
wire	[31:0]	rounded_Y_float, rounded_Cb_float, rounded_Cr_float;
wire	[31:0]	unquantized_Y, unquantized_Cb, unquantized_Cr, r_Y, r_Cb, r_Cr;
wire	[31:0]	mem_Y_O, mem_Cb_O, mem_Cr_O;
wire	[31:0]	r_dct_2D_Y_float, r_dct_2D_Cb_float, r_dct_2D_Cr_float;
wire	[31:0]	R_result_float, G_result_float, B_result_float;
wire	[24:0]	R_result_int, G_result_int, B_result_int;
wire	[7:0]	scaled_R, scaled_G, scaled_B;

wire	[7:0]	Y_coding, Cb_coding, Cr_coding, decode_Y, decode_Cb, decode_Cr;
wire			reset_coding, sync_clk_Y, sync_clk_Cb, sync_clk_Cr;


//----------------------------------------------------------------------------------------------------//
//----- change colour spaces
mem_RGB					RGB_mem					(.R_O(R_O), .G_O(G_O), .B_O(B_O), .finish_64(finish_64), .finish(finish), .size_x(32'd512), .size_y(32'd512), .en_read(1'b1), .clk(clk));
convert_color_space_Y	convert_into_Y_space	(.Y(Y_in)  , .R(R_O), .G(G_O), .B(B_O));
convert_color_space_Cb	convert_into_Cb_space	(.Cb(Cb_in), .R(R_O), .G(G_O), .B(B_O));
convert_color_space_Cr	convert_into_Cr_space	(.Cr(Cr_in), .R(R_O), .G(G_O), .B(B_O));
control_convertion		control_mem_YCbCr		(.en_mem_YCbCr(enable), .clk(clk));
mem_YCbCr				YCbCr_mem				(.Y_O(Y_O), .Cb_O(Cb_O), .Cr_O(Cr_O), .Y_in(Y_in), .Cb_in(Cb_in), .Cr_in(Cr_in), .en_write(1'b1), .en_read(1'b1), .enable(enable), .clk(clk));

//----------------------------------------------------------------------------------------------------//
//----- calculate DCT_2D
convert_float_into_int	float_2_int_Y_00	(Y_int, Y_O);
convert_float_into_int	float_2_int_Cb_00	(Cb_int, Cb_O);
convert_float_into_int	float_2_int_Cr_00	(Cr_int, Cr_O);
control_DCT				control_dct 	(.dct_2_D_reset(dct_2_D_rst), .clk(clk));
dct_2_D					dct_2_D_Y		(.O(dct_2D_Y_int) , .in(Y_int) , .clk(clk), .rst(dct_2_D_rst));
dct_2_D					dct_2_D_Cb		(.O(dct_2D_Cb_int), .in(Cb_int), .clk(clk), .rst(dct_2_D_rst));
dct_2_D					dct_2_D_Cr		(.O(dct_2D_Cr_int), .in(Cr_int), .clk(clk), .rst(dct_2_D_rst));

convert_int_into_float	int_2_float_Y_00	(.O(float_Y)	 , .in(dct_2D_Y_int));
convert_int_into_float	int_2_float_Cb_00	(.O(float_Cb)	, .in(dct_2D_Cb_int));
convert_int_into_float	int_2_float_Cr_00	(.O(float_Cr)	, .in(dct_2D_Cr_int));

//----- divide by 8*39*39 --> finish calculating DCT_2D
FP	fp_Y	(.O(dct_2D_Y_float) , .in0(float_Y) , .in1(32'h38AC598B), .operand(2'h2));
FP	fp_Cb	(.O(dct_2D_Cb_float), .in0(float_Cb), .in1(32'h38AC598B), .operand(2'h2));
FP	fp_Cr	(.O(dct_2D_Cr_float), .in0(float_Cr), .in1(32'h38AC598B), .operand(2'h2));

//----------------------------------------------------------------------------------------------------//
//----- Quantization
control_quatization	ctrl_quatization	(.reset_quatization(reset_quatization), .clk(clk), .rst(rst));
Y_quantization				Y_table		(.quantized_Y(quantized_Y), .Y_in(dct_2D_Y_float), .clk(clk), .rst(reset_quatization));
Chrominance_quantization	Cb_table	(.quantized_Cb_Cr(quantized_Cb), .Cb_Cr_in(dct_2D_Cb_float), .clk(clk), .rst(reset_quatization));
Chrominance_quantization	Cr_table	(.quantized_Cb_Cr(quantized_Cr), .Cb_Cr_in(dct_2D_Cr_float), .clk(clk), .rst(reset_quatization));

//----------------------------------------------------------------------------------------------------//
//----- Rounding
convert_float_into_int	float_2_int_Y_01	(rounded_Y_int, quantized_Y);
convert_float_into_int	float_2_int_Cb_01	(rounded_Cb_int, quantized_Cb);
convert_float_into_int	float_2_int_Cr_01	(rounded_Cr_int, quantized_Cr);

convert_int_into_float	int_2_float_Y_01	(.O(rounded_Y_float)	, .in(rounded_Y_int));
convert_int_into_float	int_2_float_Cb_01	(.O(rounded_Cb_float)	, .in(rounded_Cb_int));
convert_int_into_float	int_2_float_Cr_01	(.O(rounded_Cr_float)	, .in(rounded_Cr_int));

//----------------------------------------------------------------------------------------------------//
//----- Huffman Coding
m_luminance_component_encoder luminance_component_encoder(
	.data_out(encoded_y), .bits(encoded_y_bits), .sync(sync_y), 
	.quantized_Y(rounded_Y_int[10:0]), .start(start_encoder), .clk_0(clk_0), .clk_1(clk_1), .rst_n(~rst)
);
m_luminance_component_encoder luminance_component_encoder(
	.data_out(encoded_cb), .bits(encoded_cb_bits), .sync(sync_cb), 
	.quantized_Y(rounded_Cb_int[10:0]), .start(start_encoder), .clk_0(clk_0), .clk_1(clk_1), .rst_n(~rst)
);
m_luminance_component_encoder luminance_component_encoder(
	.data_out(encoded_cr), .bits(encoded_cr_bits), .sync(sync_cr), 
	.quantized_Y(rounded_Cr_int[10:0]), .start(start_encoder), .clk_0(clk_0), .clk_1(clk_1), .rst_n(~rst)
);

// //----------------------------------------------------------------------------------------------------//
// //----- Inverse Huffman coding
// decoding	decoding_Y	(.O(decode_Y), 	.in(Y_coding), 	.clk(sync_clk_Y), .rst(reset_coding));
// decoding	decoding_Cb	(.O(decode_Cb), .in(Cb_coding), .clk(sync_clk_Cb), .rst(reset_coding));
// decoding	decoding_Cr	(.O(decode_Cr), .in(Cr_coding), .clk(sync_clk_Cr), .rst(reset_coding));

//----------------------------------------------------------------------------------------------------//
//----- Unquantization
assign reset_unquatization = reset_quatization;
Y_unquantization		recover_Y	(unquantized_Y, rounded_Y_float, clk, reset_unquatization);
Cb_Cr_unquantization	recover_Cb	(unquantized_Cb, rounded_Cb_float, clk, reset_unquatization);
Cb_Cr_unquantization	recover_Cr	(unquantized_Cr, rounded_Cr_float, clk, reset_unquatization);

//----------------------------------------------------------------------------------------------------//
//----- Reverse DCT 2D
control_r_DCT	control_r_dct	(.r_dct_2_D_reset(r_dct_2_D_rst), .clk(clk));
DCT_2D_reverse	r_DCT_2D_Y		(r_Y,  unquantized_Y, clk, r_dct_2_D_rst);
DCT_2D_reverse	r_DCT_2D_Cb		(r_Cb, unquantized_Cb, clk, r_dct_2_D_rst);
DCT_2D_reverse	r_DCT_2D_Cr		(r_Cr, unquantized_Cr, clk, r_dct_2_D_rst);
//----- divide by 8*39*39 --> finish calculating r_DCT_2D
FP	fp_divide_Y		(.O(r_dct_2D_Y_float) , .in0(r_Y) , .in1(32'h38AC598B), .operand(2'h2));
FP	fp_divide_Cb	(.O(r_dct_2D_Cb_float), .in0(r_Cb), .in1(32'h38AC598B), .operand(2'h2));
FP	fp_divide_Cr	(.O(r_dct_2D_Cr_float), .in0(r_Cr), .in1(32'h38AC598B), .operand(2'h2));
//----------------------------------------------------------------------------------------------------//
//----- un-normalize
//----- change colour space from YCbCr to RGB

convert_color_space_R	convert_into_R	(R_result_float, r_dct_2D_Y_float, r_dct_2D_Cb_float, r_dct_2D_Cr_float);
convert_color_space_G	convert_into_G	(G_result_float, r_dct_2D_Y_float, r_dct_2D_Cb_float, r_dct_2D_Cr_float);
convert_color_space_B	convert_into_B	(B_result_float, r_dct_2D_Y_float, r_dct_2D_Cb_float, r_dct_2D_Cr_float);
//----------------------------------------------------------------------------------------------------//
//----- take output
convert_float_into_int	R_result	(R_result_int, R_result_float);
convert_float_into_int	G_result	(G_result_int, G_result_float);
convert_float_into_int	B_result	(B_result_int, B_result_float);

mux_2_1		#(8)	scaled_R_space	(scaled_R, R_result_int[7:0], 8'hff, (R_result_int[8] | R_result_int[9]));
mux_2_1		#(8)	scaled_G_space	(scaled_G, G_result_int[7:0], 8'hff, (G_result_int[8] | G_result_int[9]));
mux_2_1		#(8)	scaled_B_space	(scaled_B, B_result_int[7:0], 8'hff, (B_result_int[8] | B_result_int[9]));

mux_2_1		#(8)	R_output	(R_out, scaled_R, 8'b0, R_result_int[24]);
mux_2_1		#(8)	G_output	(G_out, scaled_G, 8'b0, G_result_int[24]);
mux_2_1		#(8)	B_output	(B_out, scaled_B, 8'b0, B_result_int[24]);

endmodule
//====================================================================================================//
module	control_DCT	(dct_2_D_reset, clk);
output	reg		dct_2_D_reset;
input			clk;

reg		[31:0]	counter;

always @(posedge clk) begin
	counter = counter + 32'b1;
	if (counter == 32'h03 || dct_2_D_reset == 1'b0) begin
		dct_2_D_reset = 1'b0;
	end
	else begin
		dct_2_D_reset = 1'b1;
	end
end

initial begin
	counter = 32'b0;
	dct_2_D_reset = 1'b1;
end

endmodule
//====================================================================================================//
module	control_quatization	(reset_quatization, clk, rst);
output	reg	reset_quatization;
input		clk, rst;
reg	[6:0]	counter;

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		counter = 7'b0;
		reset_quatization = 1'b1;
	end
	else begin
		if(counter == 7'h53) begin
			reset_quatization = 1'b0;
		end
		counter = counter + 7'b1;
	end
end
endmodule
//====================================================================================================//
module	control_r_DCT	(r_dct_2_D_reset, clk);
output	reg		r_dct_2_D_reset;
input			clk;

reg		[31:0]	counter;

always @(posedge clk) begin
	counter = counter + 32'b1;
	//if (counter == 32'h46 || r_dct_2_D_reset == 1'b0) begin
	if (counter == 32'h56 || r_dct_2_D_reset == 1'b0) begin
		r_dct_2_D_reset = 1'b0;
	end
end

initial begin
	counter = 32'b0;
	r_dct_2_D_reset = 1'b1;
end

endmodule
//====================================================================================================//
module	transpose 	(O, clk, rst);
output	reg	O;
input		clk, rst;

reg		[31:0]	counter;

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		counter = 32'b0;
		O = 1'b0;
	end
	else begin
		if(counter == 32'h54) begin
			O = 1'b1;
		end
		counter = counter + 32'b1;
	end
end
endmodule
//====================================================================================================//
// module	reset_code	(O, clk, rst);
// output	reg O;
// input	clk, rst;
// reg		[7:0]	counter;

// always @(posedge clk) begin
// 	if (rst) begin
// 		counter = 8'b0;
// 		O = 1'b1;
// 	end
// 	else begin
// 		if(counter == 8'd85) begin
// 			O = 1'b0;
// 		end
// 		counter = counter + 8'b1;
// 	end
// end

// endmodule

*/