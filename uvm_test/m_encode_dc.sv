module m_encode_luminance_dc (number_of_bits, ext_code, dc_in, clk, rst_n); // checked
output	[4:0]	number_of_bits;
output	[19:0]	ext_code;
input	[10:0]	dc_in;
input			clk, rst_n;

wire	[3:0]	w_category;
wire	[10:0]	w_diff_o;
wire	[8:0]	w_code_word;

m_dc_diff					dc_diff	(
	.category(w_category), 
	.diff_o(w_diff_o), 
	.dc_in(dc_in), 
	.clk(clk),
	.rst_n(rst_n)
);
m_luminance_huff_code_dc 	huff_code	(
	.code_word(w_code_word), 
	.category(w_category), 
	.rst_n(rst_n)
);
m_luminance_ext_hm_code_dc ext_huff_code	(
	.number_of_bits(number_of_bits), 
	.ext_code(ext_code), 
	.category(w_category), 
	.addl_bits(w_diff_o), 
	.code_word(w_code_word)
);
endmodule

//====================================================================================================//
module m_encode_chrominance_dc (number_of_bits, ext_code, dc_in, clk, rst_n); // checked
output	[4:0]	number_of_bits;
output	[21:0]	ext_code;
input	[10:0]	dc_in;
input			clk, rst_n;

wire	[3:0]	w_category;
wire	[10:0]	w_diff_o;
wire	[10:0]	w_code_word;

m_dc_diff					dc_diff	(
	.category(w_category), 
	.diff_o(w_diff_o), 
	.dc_in(dc_in), 
	.clk(clk),
	.rst_n(rst_n)
);

m_chrominance_huff_code_dc 	huff_code	(
	.code_word(w_code_word), 
	.category(w_category), 
	.rst_n(rst_n)
);

m_chrominance_ext_hm_code_dc ext_huff_code	(
	.number_of_bits(number_of_bits), 
	.ext_code(ext_code), 
	.category(w_category), 
	.addl_bits(w_diff_o), 
	.code_word(w_code_word)
);

endmodule // m_encode_chrominance_dc
//====================================================================================================//
module m_dc_diff (category, diff_o, dc_in, clk, rst_n); // checked
output	[3:0]	category;
output	[10:0]	diff_o;
input	[10:0]	dc_in;
input			clk, rst_n;

reg		[10:0]	dc_pre, ram;
wire	[11:0]	w_diff_o, mux_out, diff_abs;
wire	[10:0]	decode_in;
wire	[12:0]	w_0;


sub_nadd_11_sign_bits	m_0	(
	.out(w_diff_o), 
	.in0(dc_in), 
	.in1(dc_pre), 
	.sub_nadd(1'b1)
);


sub_nadd_11_sign_bits	m_1	(
	.out(diff_abs), 
	.in0(11'b0), 
	.in1(w_diff_o[10:0]), 
	.sub_nadd(w_diff_o[11])
);

assign decode_in[10:0] = diff_abs[10:0];

m_calc_dc_category		calc_dc_category	(
	.o(category),
	.in(decode_in)
);

mux_2_1		#(12)		mux	(
	.O(mux_out),
	.in0(12'b00), 
	.in1(12'b01), 
	.select(w_diff_o[11])
);
sub_nadd_12_sign_bits	m_2	(
	.out(w_0), 
	.in0(w_diff_o),
	.in1(mux_out), 
	.sub_nadd(1'b1)
);
assign	diff_o[10:0] = w_0[10:0] ;


always @(posedge clk) begin	
	if(rst_n) begin
		dc_pre = ram; #1;
		ram = dc_in;
	end
end

always @(negedge rst_n) begin
	ram = 0; #1;
	dc_pre = 0;
end // else

endmodule // m_dc_diff

//====================================================================================================//
module m_luminance_huff_code_dc (code_word, category, rst_n);	// checked
output	[8:0]	code_word ;
input	[3:0]	category ;
input			rst_n;

wire			a0, a1, a2, a3;

assign	a0 = category[0];
assign	a1 = category[1];
assign	a2 = category[2];
assign	a3 = category[3];

assign	code_word[0] = (~a0 & a1 & ~a2 & ~a3) | (~a0 & ~a1 & a2 & ~a3) ;
assign	code_word[1] = (~a2 & a3) | (a0 & ~a1 & ~a3) | (~a0 & a1 & ~a3) | (a1 & a2 & ~a3) ;
assign	code_word[2] = (a2 & ~a3) | (~ a2 & a3) | (a0 & a1 & ~a2) ;
assign	code_word[3] = (~a2 & a3) | (a1 & a2 & ~a3) ;
assign	code_word[4] = (~a2 & a3) | (a0 & a1 & a2 & ~a3) ;
assign	code_word[5] = (~a2 & a3) ;
assign	code_word[6] = (a0 & ~a2 & a3) | (a1 & ~a2 & a3) ;
assign	code_word[7] = (a1 & ~a2 & a3) ;
assign	code_word[8] = (a0 & a1 & ~a2 & a3) ;

endmodule

//====================================================================================================//
module m_luminance_ext_hm_code_dc (number_of_bits, ext_code, category, addl_bits, code_word); //checked
output	[4:0]	number_of_bits;
output	reg[19:0]	ext_code;
input	[3:0]	category;
input	[10:0]	addl_bits;
input	[8:0]	code_word;

// calculate number_of_bits
assign number_of_bits[4] = (  category[0] |  category[1]) & (~category[2] &  category[3] ) ;
assign number_of_bits[3] =  ((category[0] |  category[1]) & ( category[2] & ~category[3] )) | 
							(~category[0] & ~category[1] &   ~category[2] &  category[3] ) ;

assign number_of_bits[2] = 	(category[0] |  category[1]) & (~(category[2] |  category[3]) ) |
							(category[0] &  category[1]) & (~(category[2] & category[3]) )	|
							~(category[0] |  category[1]) & (category[2] ^ category[3]) ;

assign number_of_bits[1] = 	~category[0] & (category[2] ^ category[3]) |
							~(category[0] | category[1] | category[2]) |
							(category[0] & category[1] & ~category[2] & ~category[3]);

assign number_of_bits[0] = ~(category[0] | category[3]) & (category[1] ^ category[2]) ;

always @(*) begin
	case (category)
		4'd00:	ext_code[19:0]	=	{18'b0, code_word[1:0]} ;
		4'd01:	ext_code[19:0]	=	{16'b0, code_word[2:0], addl_bits[0]} ;
		4'd02:	ext_code[19:0]	=	{15'b0, code_word[2:0], addl_bits[1:0]} ;
		4'd03:	ext_code[19:0]	=	{14'b0, code_word[2:0], addl_bits[2:0]} ;
		4'd04:	ext_code[19:0]	=	{13'b0, code_word[2:0], addl_bits[3:0]} ;
		4'd05:	ext_code[19:0]	=	{12'b0, code_word[2:0], addl_bits[4:0]} ;
		4'd06:	ext_code[19:0]	=	{10'b0, code_word[3:0], addl_bits[5:0]} ;
		4'd07:	ext_code[19:0]	=	{08'b0, code_word[4:0], addl_bits[6:0]} ;
		4'd08:	ext_code[19:0]	=	{06'b0, code_word[5:0], addl_bits[7:0]} ;
		4'd09:	ext_code[19:0]	=	{04'b0, code_word[6:0], addl_bits[8:0]} ;
		4'd10:	ext_code[19:0]	=	{02'b0, code_word[7:0], addl_bits[9:0]} ;
		4'd11:	ext_code[19:0]	=	{		code_word[8:0], addl_bits[10:0]};
		default : ext_code[19:0]	=	20'b0;
	endcase
end

endmodule

//====================================================================================================//
module m_calc_dc_category (o, in);	// checked
output	[3:0]	o;
input	[10:0]	in;

wire			w_0;

assign	o[3]	= in[10] | in[9] | in[8] | in[7] ;
assign	o[2]	= ~o[3] & (in[6] | in[5] | in[4] | in[3]);
assign	w_0		= in[10] | in[9] | in[8] | in[7] | in[6] | in[5] | in[4] | in[3] ;
assign	o[1]	= (in[10] | in[9]) | (~o[3] & (in[6] | in[5])) | (~w_0 & (in[2] | in[1])) ;
assign	o[0]	= in[10] | ( ~(in[10] | in[9]) & in[8]) | ( ~o[3] & in[6]) | ( ~(o[3] | in[6] | in[5]) & in[4] ) |
	      			( ~w_0 & in[2] ) |
	      			( ~(w_0 | in[2] | in[1]) & in[0] );
endmodule



//====================================================================================================//
module m_chrominance_ext_hm_code_dc (number_of_bits, ext_code, category, addl_bits, code_word); //checked
output	[4:0]	number_of_bits;
output	reg[21:0]	ext_code;
input	[3:0]	category;
input	[10:0]	addl_bits;
input	[10:0]	code_word;

wire			a0, a1, a2, a3;

assign	a0 = category[0];
assign	a1 = category[1];
assign	a2 = category[2];
assign	a3 = category[3];

assign number_of_bits[0] = ~a3 &	~a2 &	~a1 & a0 ;
assign number_of_bits[1] = (a0 & ~a2 ) | ( a0 & ~a3 ) | ( ~a1 & ~a2 & ~a3);
assign number_of_bits[2] = (a1 & ~a2 ) | ( a1 & ~a3 );
assign number_of_bits[3] =  a2 & ~a3 ;
assign number_of_bits[4] =  ~a2 & a3 ;

always @(*) begin
	case (category)
		4'd00:	ext_code[21:0]	=	{20'b0,	code_word[01:0]				};
		4'd01:	ext_code[21:0]	=	{19'b0,	code_word[01:0], addl_bits[0]};
		4'd02:	ext_code[21:0]	=	{18'b0,	code_word[01:0], addl_bits[01:0]};
		4'd03:	ext_code[21:0]	=	{16'b0,	code_word[02:0], addl_bits[02:0]};
		4'd04:	ext_code[21:0]	=	{14'b0,	code_word[03:0], addl_bits[03:0]};
		4'd05:	ext_code[21:0]	=	{12'b0,	code_word[04:0], addl_bits[04:0]};
		4'd06:	ext_code[21:0]	=	{10'b0,	code_word[05:0], addl_bits[05:0]};
		4'd07:	ext_code[21:0]	=	{8'b0,	code_word[06:0], addl_bits[06:0]};
		4'd08:	ext_code[21:0]	=	{6'b0,	code_word[07:0], addl_bits[07:0]};
		4'd09:	ext_code[21:0]	=	{4'b0,	code_word[08:0], addl_bits[08:0]};
		4'd10:	ext_code[21:0]	=	{2'b0,	code_word[09:0], addl_bits[09:0]};
		4'd11:	ext_code[21:0]	=	{		code_word[10:0], addl_bits[10:0]};
	endcase
end

endmodule // m_chrominance_ext_hm_code_dc


//====================================================================================================//
module m_chrominance_huff_code_dc (code_word, category, rst_n);	// checked
output	[10:0]	code_word ;
input	[3:0]	category ;
input			rst_n;

wire			a0, a1, a2, a3;

assign	a0 = category[0];
assign	a1 = category[1];
assign	a2 = category[2];
assign	a3 = category[3];

assign	code_word[00] = a0 & ~a1 & ~a2 & ~a3 ;
assign	code_word[01] = (a1 & ~a2 )|( a2 & ~a3 )|( ~a2 & a3 );
assign	code_word[02] = (a2 & ~a3 )|( ~a2 & a3 )|( a0 & a1 & ~a2 );
assign	code_word[03] = (a2 & ~a3 )|( ~a2 & a3 );
assign	code_word[04] = (~a2 & a3 )|( a0 & a2 & ~a3 )|( a1 & a2 & ~a3 );
assign	code_word[05] = (~a2 & a3 )|( a1 & a2 & ~a3 );
assign	code_word[06] = (~a2 & a3 )|( a0 & a1 & a2 & ~a3) ;
assign	code_word[07] = ~a2 & a3 ;
assign	code_word[08] = (a0 & ~a2 & a3 )|( a1 & ~a2 & a3) ;
assign	code_word[09] = a1 & ~a2 & a3 ;
assign	code_word[10] = a0 & a1 & ~a2 & a3 ;

endmodule // m_chrominance_huff_code_dc