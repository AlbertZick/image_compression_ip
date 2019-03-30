// Author:	Truong Tran
// Date:	2018/08/14
//====================================================================================================//
//====================================================================================================//
module m_dut (if_dut	bfm);

m_small_ip small_ip	(
	.encoded_y(bfm.encoded_y), .encoded_cb(bfm.encoded_cb), .encoded_cr(bfm.encoded_cr),
	.encoded_y_bits(bfm.encoded_y_bits), .encoded_cb_bits(bfm.encoded_cb_bits), .encoded_cr_bits(bfm.encoded_cr_bits),
	.sync_y(bfm.sync_y), .sync_cb(bfm.sync_cb), .sync_cr(bfm.sync_cr),
	.R_in(bfm.R_in), .G_in(bfm.G_in), .B_in(bfm.B_in), 
	.clk_0(bfm.clk_0), .clk_1(bfm.clk_1), .rst(bfm.rst)
);

assign	bfm.start_encoder 	=	small_ip.start_encoder;
assign	bfm.rounded_Y_int 	=	small_ip.rounded_Y_int;
assign	bfm.rounded_Cb_int 	=	small_ip.rounded_Cb_int;
assign	bfm.rounded_Cr_int 	=	small_ip.rounded_Cr_int;

//for transformation monitor
assign	bfm.Y_int = small_ip.Y_int; 
assign	bfm.Cb_int = small_ip.Cb_int; 
assign	bfm.Cr_int = small_ip.Cr_int;

//for fdct monitor
assign	bfm.dct_2D_Y_float  = (small_ip.dct_2D_Y_float[31:0]);
assign	bfm.dct_2D_Cb_float = (small_ip.dct_2D_Cb_float[31:0]);
assign	bfm.dct_2D_Cr_float = (small_ip.dct_2D_Cr_float[31:0]);

assign	bfm.dct_2_D_rst 	= small_ip.dct_2_D_rst;

endmodule

//====================================================================================================//
module	m_small_ip	(
	encoded_y, encoded_cb, encoded_cr,
	encoded_y_bits, encoded_cb_bits, encoded_cr_bits,
	sync_y, sync_cb, sync_cr,
	R_in, G_in, B_in, 
	clk_0, clk_1, rst
);

output [25:0]	encoded_y, encoded_cb, encoded_cr;
output[4:0]	encoded_y_bits, encoded_cb_bits, encoded_cr_bits;
output 			sync_y, sync_cb, sync_cr;
wire			start_encoder;

input	[7:0]	R_in, G_in, B_in;
input			clk_0, clk_1, rst;

wire			/*finish_64, finish, */enable, dct_2_D_rst, reset_quatization;
wire	[24:0]	dct_2D_Y_int, dct_2D_Cb_int, dct_2D_Cr_int, Y_int, Cb_int, Cr_int;
wire	[31:0]	R_O, G_O, B_O, Y_in, Cb_in, Cr_in, Y_O, Cb_O, Cr_O;
wire	[31:0]	float_Y, float_Cb, float_Cr, dct_2D_Y_float, dct_2D_Cb_float, dct_2D_Cr_float;
wire	[31:0]	quantized_Y, quantized_Cb, quantized_Cr;
wire	[24:0]	rounded_Y_int, rounded_Cb_int, rounded_Cr_int;
// wire	[31:0]	rounded_Y_float, rounded_Cb_float, rounded_Cr_float;
wire	[24:0]	R_in_ext, G_in_ext, B_in_ext;

// wire	[7:0]	Y_coding, Cb_coding, Cr_coding, decode_Y, decode_Cb, decode_Cr;
// wire			reset_coding, sync_clk_Y, sync_clk_Cb, sync_clk_Cr;
wire			clk;



assign clk = clk_0;
//----------------------------------------------------------------------------------------------------//
//----- take input value

assign R_in_ext [24:0] = {17'b0, R_in[7:0]};
assign G_in_ext [24:0] = {17'b0, G_in[7:0]};
assign B_in_ext [24:0] = {17'b0, B_in[7:0]};

convert_int_into_float R_component	(R_O, R_in_ext);
convert_int_into_float G_component	(G_O, G_in_ext);
convert_int_into_float B_component	(B_O, B_in_ext);


//----------------------------------------------------------------------------------------------------//
//----- change colour spaces
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

// convert_int_into_float	int_2_float_Y_01	(.O(rounded_Y_float)	, .in(rounded_Y_int));
// convert_int_into_float	int_2_float_Cb_01	(.O(rounded_Cb_float)	, .in(rounded_Cb_int));
// convert_int_into_float	int_2_float_Cr_01	(.O(rounded_Cr_float)	, .in(rounded_Cr_int));

//----------------------------------------------------------------------------------------------------//
//----- Huffman Coding

m_control_encoder ctl_encoder	(.o(start_encoder), .in(dct_2_D_Y.dct_b_finish), 
									.clk(clk_0), .rst_n(~rst));

m_luminance_component_encoder y_component_encoder(
	.data_out(encoded_y), .bits(encoded_y_bits), .sync(sync_y), 
	.quantized_Y(rounded_Y_int[10:0]), .start(start_encoder), .clk_0(clk_0), .clk_1(clk_1), .rst_n(~rst)
);
m_chrominance_component_encoder cb_component_encoder(
	.data_out(encoded_cb), .bits(encoded_cb_bits), .sync(sync_cb), 
	.quantized_chrominance(rounded_Cb_int[10:0]), .start(start_encoder), .clk_0(clk_0), .clk_1(clk_1), .rst_n(~rst)
);
m_chrominance_component_encoder cr_component_encoder(
	.data_out(encoded_cr), .bits(encoded_cr_bits), .sync(sync_cr), 
	.quantized_chrominance(rounded_Cr_int[10:0]), .start(start_encoder), .clk_0(clk_0), .clk_1(clk_1), .rst_n(~rst)
);


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

//===============
module m_control_encoder (o, in, clk, rst_n);
reg	[3:0]	counter;
input		in, clk, rst_n;
output	reg	o;

always @(negedge clk) begin
	if(~rst_n) begin
		counter = 0;
		o = 0;
	end
	else begin
		if(in == 1) counter++;
		if(counter == 4'd11) o = 1;
	end
end

endmodule // m_control_encoder