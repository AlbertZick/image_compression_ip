module m_calc_ac_category (o, in);	// checked
output	[3:0]	o;
input	[10:0]	in;

wire	[11:0]	in_abs;
wire	[10:0]	w;
wire			temp;

// assign	xor_in[9:0]	= in[9:0] ^ in[10] ;
sub_nadd_11_sign_bits sub_nadd (in_abs, 11'b0, in, in[10]);

assign	w[10:0]	= in_abs[10:0] ;

assign	o[3]	= w[10] | w[9] | w[8] | w[7] ;
assign	o[2]	= ~o[3] & (w[6] | w[5] | w[4] | w[3]);
assign	temp	= w[10] | w[9] | w[8] | w[7] | w[6] | w[5] | w[4] | w[3] ;
assign	o[1]	= (w[10] | w[9]) | (~o[3] & (w[6] | w[5])) | (~temp & (w[2] | w[1])) ;
assign	o[0]	= w[10] | 
					( ~(w[10] | w[9]) & w[8]) | 
					( ~o[3] & w[6]) | 
					( ~(o[3] | w[6] | w[5]) & w[4] ) |
	      			( ~temp & w[2] ) |
	      			( ~(temp | w[2] | w[1]) & w[0] );
endmodule // m_calc_ac_category

//====================================================================================================//
module m_calc_ac_addl_bits (o, category, in); // checked
output	[9:0] 	o;
output	[3:0]	category;
input	[10:0]	in;

wire	[10:0]	mux_out;
wire	[11:0]	w_addl_bits;


m_calc_ac_category	m_calc	(
	.o(category),
	.in(in)
);

mux_2_1	#(11)	m0	(
	.O(mux_out),
	.in0(11'b0), 
	.in1(11'b1), 
	.select(in[10])
);
sub_nadd_11_sign_bits	m1	(
	.out(w_addl_bits), 
	.in0(in), 
	.in1(mux_out), 
	.sub_nadd(1'b1)
);

assign	o[9:0]	= w_addl_bits[9:0];

endmodule // m_calc_ac_addl_bits

//====================================================================================================//
module	m_luminance_huff_code_ac	(huff_code, length, RRRR, SSSS); // checked
output	reg[15:0]	huff_code;
output	reg[4:0]	length;
input	[3:0]	RRRR, SSSS;

wire	[7:0]	rs ;

assign	rs[7:0]	= {RRRR[3:0], SSSS[3:0]} ;

always @(*) begin
	case (rs)
		8'h00: begin huff_code[15:0] <= 16'b1010 ;				length <= 5'd4	;	end
		8'h01: begin huff_code[15:0] <= 16'b00 ;				length <= 5'd2	;	end
		8'h02: begin huff_code[15:0] <= 16'b01 ;				length <= 5'd2	;	end
		8'h03: begin huff_code[15:0] <= 16'b100 ;				length <= 5'd3	;	end
		8'h04: begin huff_code[15:0] <= 16'b1011 ;				length <= 5'd4	;	end
		8'h05: begin huff_code[15:0] <= 16'b11010 ;				length <= 5'd5	;	end
		8'h06: begin huff_code[15:0] <= 16'b1111000 ;			length <= 5'd7	;	end
		8'h07: begin huff_code[15:0] <= 16'b11111000 ;			length <= 5'd8	;	end
		8'h08: begin huff_code[15:0] <= 16'b1111110110 ;		length <= 5'd10	;	end
		8'h09: begin huff_code[15:0] <= 16'b1111111110000010 ;	length <= 5'd16	;	end
		8'h0A: begin huff_code[15:0] <= 16'b1111111110000011 ;	length <= 5'd16	;	end
		8'h11: begin huff_code[15:0] <= 16'b1100 ;				length <= 5'd4 	;	end
		8'h12: begin huff_code[15:0] <= 16'b11011 ;				length <= 5'd5 	;	end
		8'h13: begin huff_code[15:0] <= 16'b1111001 ;			length <= 5'd7 	;	end
		8'h14: begin huff_code[15:0] <= 16'b111110110 ;			length <= 5'd9 	;	end
		8'h15: begin huff_code[15:0] <= 16'b11111110110 ;		length <= 5'd11 ;	end
		8'h16: begin huff_code[15:0] <= 16'b1111111110000100 ;	length <= 5'd16 ;	end
		8'h17: begin huff_code[15:0] <= 16'b1111111110000101 ;	length <= 5'd16 ;	end
		8'h18: begin huff_code[15:0] <= 16'b1111111110000110 ;	length <= 5'd16 ;	end
		8'h19: begin huff_code[15:0] <= 16'b1111111110000111 ;	length <= 5'd16 ;	end
		8'h1A: begin huff_code[15:0] <= 16'b1111111110001000 ;	length <= 5'd16 ;	end
		8'h21: begin huff_code[15:0] <= 16'b11100 ;				length <= 5'd5	;	end
		8'h22: begin huff_code[15:0] <= 16'b11111001 ;			length <= 5'd8 	;	end
		8'h23: begin huff_code[15:0] <= 16'b1111110111 ;		length <= 5'd10 ;	end
		8'h24: begin huff_code[15:0] <= 16'b111111110100 ;		length <= 5'd12 ;	end
		8'h25: begin huff_code[15:0] <= 16'b1111111110001001 ;	length <= 5'd16 ;	end
		8'h26: begin huff_code[15:0] <= 16'b1111111110001010 ;	length <= 5'd16 ;	end
		8'h27: begin huff_code[15:0] <= 16'b1111111110001011 ;	length <= 5'd16 ;	end
		8'h28: begin huff_code[15:0] <= 16'b1111111110001100 ;	length <= 5'd16 ;	end
		8'h29: begin huff_code[15:0] <= 16'b1111111110001101 ;	length <= 5'd16 ;	end
		8'h2A: begin huff_code[15:0] <= 16'b1111111110001110 ;	length <= 5'd16 ;	end
		8'h31: begin huff_code[15:0] <= 16'b111010 ;			length <= 5'd6 	;	end
		8'h32: begin huff_code[15:0] <= 16'b111110111 ;			length <= 5'd9 	;	end
		8'h33: begin huff_code[15:0] <= 16'b111111110101 ;		length <= 5'd12 ;	end
		8'h34: begin huff_code[15:0] <= 16'b1111111110001111 ;	length <= 5'd16 ;	end
		8'h35: begin huff_code[15:0] <= 16'b1111111110010000 ;	length <= 5'd16 ;	end
		8'h36: begin huff_code[15:0] <= 16'b1111111110010001 ;	length <= 5'd16 ;	end
		8'h37: begin huff_code[15:0] <= 16'b1111111110010010 ;	length <= 5'd16 ;	end
		8'h38: begin huff_code[15:0] <= 16'b1111111110010011 ;	length <= 5'd16 ;	end
		8'h39: begin huff_code[15:0] <= 16'b1111111110010100 ;	length <= 5'd16 ;	end
		8'h3A: begin huff_code[15:0] <= 16'b1111111110010101 ;	length <= 5'd16 ;	end

		8'h41: begin huff_code[15:0] <= 16'b111011 ;			length <= 5'd6	;	end
		8'h42: begin huff_code[15:0] <= 16'b1111111000 ;		length <= 5'd10	;	end
		8'h43: begin huff_code[15:0] <= 16'b1111111110010110 ;	length <= 5'd16	;	end
		8'h44: begin huff_code[15:0] <= 16'b1111111110010111 ;	length <= 5'd16	;	end
		8'h45: begin huff_code[15:0] <= 16'b1111111110011000 ;	length <= 5'd16	;	end
		8'h46: begin huff_code[15:0] <= 16'b1111111110011001 ;	length <= 5'd16	;	end
		8'h47: begin huff_code[15:0] <= 16'b1111111110011010 ;	length <= 5'd16	;	end
		8'h48: begin huff_code[15:0] <= 16'b1111111110011011 ;	length <= 5'd16	;	end
		8'h49: begin huff_code[15:0] <= 16'b1111111110011100 ;	length <= 5'd16	;	end
		8'h4A: begin huff_code[15:0] <= 16'b1111111110011101 ;	length <= 5'd16	;	end
		8'h51: begin huff_code[15:0] <= 16'b1111010 ;			length <= 5'd7	;	end
		8'h52: begin huff_code[15:0] <= 16'b11111110111 ;		length <= 5'd11	;	end
		8'h53: begin huff_code[15:0] <= 16'b1111111110011110 ;	length <= 5'd16	;	end
		8'h54: begin huff_code[15:0] <= 16'b1111111110011111 ;	length <= 5'd16	;	end
		8'h55: begin huff_code[15:0] <= 16'b1111111110100000 ;	length <= 5'd16	;	end
		8'h56: begin huff_code[15:0] <= 16'b1111111110100001 ;	length <= 5'd16	;	end
		8'h57: begin huff_code[15:0] <= 16'b1111111110100010 ;	length <= 5'd16	;	end
		8'h58: begin huff_code[15:0] <= 16'b1111111110100011 ;	length <= 5'd16	;	end
		8'h59: begin huff_code[15:0] <= 16'b1111111110100100 ;	length <= 5'd16	;	end
		8'h5A: begin huff_code[15:0] <= 16'b1111111110100101 ;	length <= 5'd16	;	end
		8'h61: begin huff_code[15:0] <= 16'b1111011 ;			length <= 5'd7	;	end
		8'h62: begin huff_code[15:0] <= 16'b111111110110 ;		length <= 5'd12	;	end
		8'h63: begin huff_code[15:0] <= 16'b1111111110100110 ;	length <= 5'd16	;	end
		8'h64: begin huff_code[15:0] <= 16'b1111111110100111 ;	length <= 5'd16	;	end
		8'h65: begin huff_code[15:0] <= 16'b1111111110101000 ;	length <= 5'd16	;	end
		8'h66: begin huff_code[15:0] <= 16'b1111111110101001 ;	length <= 5'd16	;	end
		8'h67: begin huff_code[15:0] <= 16'b1111111110101010 ;	length <= 5'd16	;	end
		8'h68: begin huff_code[15:0] <= 16'b1111111110101011 ;	length <= 5'd16	;	end
		8'h69: begin huff_code[15:0] <= 16'b1111111110101100 ;	length <= 5'd16	;	end
		8'h6A: begin huff_code[15:0] <= 16'b1111111110101101 ;	length <= 5'd16	;	end
		8'h71: begin huff_code[15:0] <= 16'b11111010 ;			length <= 5'd8	;	end
		8'h72: begin huff_code[15:0] <= 16'b111111110111 ;		length <= 5'd12	;	end
		8'h73: begin huff_code[15:0] <= 16'b1111111110101110 ;	length <= 5'd16	;	end
		8'h74: begin huff_code[15:0] <= 16'b1111111110101111 ;	length <= 5'd16	;	end
		8'h75: begin huff_code[15:0] <= 16'b1111111110110000 ;	length <= 5'd16	;	end
		8'h76: begin huff_code[15:0] <= 16'b1111111110110001 ;	length <= 5'd16	;	end
		8'h77: begin huff_code[15:0] <= 16'b1111111110110010 ;	length <= 5'd16	;	end
		8'h78: begin huff_code[15:0] <= 16'b1111111110110011 ;	length <= 5'd16	;	end
		8'h79: begin huff_code[15:0] <= 16'b1111111110110100 ;	length <= 5'd16	;	end
		8'h7A: begin huff_code[15:0] <= 16'b1111111110110101 ;	length <= 5'd16	;	end
		8'h81: begin huff_code[15:0] <= 16'b111111000 ;			length <= 5'd9	;	end
		8'h82: begin huff_code[15:0] <= 16'b111111111000000 ;	length <= 5'd15	;	end

		8'h83: begin huff_code[15:0] <= 16'b1111111110110110 ;	length <= 5'd16	;	end
		8'h84: begin huff_code[15:0] <= 16'b1111111110110111 ;	length <= 5'd16	;	end
		8'h85: begin huff_code[15:0] <= 16'b1111111110111000 ;	length <= 5'd16	;	end
		8'h86: begin huff_code[15:0] <= 16'b1111111110111001 ;	length <= 5'd16	;	end
		8'h87: begin huff_code[15:0] <= 16'b1111111110111010 ;	length <= 5'd16	;	end
		8'h88: begin huff_code[15:0] <= 16'b1111111110111011 ;	length <= 5'd16	;	end
		8'h89: begin huff_code[15:0] <= 16'b1111111110111100 ;	length <= 5'd16	;	end
		8'h8A: begin huff_code[15:0] <= 16'b1111111110111101 ;	length <= 5'd16	;	end
		8'h91: begin huff_code[15:0] <= 16'b111111001 ;			length <= 5'd9	;	end
		8'h92: begin huff_code[15:0] <= 16'b1111111110111110 ;	length <= 5'd16	;	end
		8'h93: begin huff_code[15:0] <= 16'b1111111110111111 ;	length <= 5'd16	;	end
		8'h94: begin huff_code[15:0] <= 16'b1111111111000000 ;	length <= 5'd16	;	end
		8'h95: begin huff_code[15:0] <= 16'b1111111111000001 ;	length <= 5'd16	;	end
		8'h96: begin huff_code[15:0] <= 16'b1111111111000010 ;	length <= 5'd16	;	end
		8'h97: begin huff_code[15:0] <= 16'b1111111111000011 ;	length <= 5'd16	;	end
		8'h98: begin huff_code[15:0] <= 16'b1111111111000100 ;	length <= 5'd16	;	end
		8'h99: begin huff_code[15:0] <= 16'b1111111111000101 ;	length <= 5'd16	;	end
		8'h9A: begin huff_code[15:0] <= 16'b1111111111000110 ;	length <= 5'd16	;	end
		8'hA1: begin huff_code[15:0] <= 16'b111111010 ;			length <= 5'd9	;	end
		8'hA2: begin huff_code[15:0] <= 16'b1111111111000111 ;	length <= 5'd16	;	end
		8'hA3: begin huff_code[15:0] <= 16'b1111111111001000 ;	length <= 5'd16	;	end
		8'hA4: begin huff_code[15:0] <= 16'b1111111111001001 ;	length <= 5'd16	;	end
		8'hA5: begin huff_code[15:0] <= 16'b1111111111001010 ;	length <= 5'd16	;	end
		8'hA6: begin huff_code[15:0] <= 16'b1111111111001011 ;	length <= 5'd16	;	end
		8'hA7: begin huff_code[15:0] <= 16'b1111111111001100 ;	length <= 5'd16	;	end
		8'hA8: begin huff_code[15:0] <= 16'b1111111111001101 ;	length <= 5'd16	;	end
		8'hA9: begin huff_code[15:0] <= 16'b1111111111001110 ;	length <= 5'd16	;	end
		8'hAA: begin huff_code[15:0] <= 16'b1111111111001111 ;	length <= 5'd16	;	end
		8'hB1: begin huff_code[15:0] <= 16'b1111111001 ;		length <= 5'd10	;	end
		8'hB2: begin huff_code[15:0] <= 16'b1111111111010000 ;	length <= 5'd16	;	end
		8'hB3: begin huff_code[15:0] <= 16'b1111111111010001 ;	length <= 5'd16	;	end
		8'hB4: begin huff_code[15:0] <= 16'b1111111111010010 ;	length <= 5'd16	;	end
		8'hB5: begin huff_code[15:0] <= 16'b1111111111010011 ;	length <= 5'd16	;	end
		8'hB6: begin huff_code[15:0] <= 16'b1111111111010100 ;	length <= 5'd16	;	end
		8'hB7: begin huff_code[15:0] <= 16'b1111111111010101 ;	length <= 5'd16	;	end
		8'hB8: begin huff_code[15:0] <= 16'b1111111111010110 ;	length <= 5'd16	;	end
		8'hB9: begin huff_code[15:0] <= 16'b1111111111010111 ;	length <= 5'd16	;	end
		8'hBA: begin huff_code[15:0] <= 16'b1111111111011000 ;	length <= 5'd16	;	end
		8'hC1: begin huff_code[15:0] <= 16'b1111111010 ;		length <= 5'd10	;	end
		8'hC2: begin huff_code[15:0] <= 16'b1111111111011001 ;	length <= 5'd16	;	end
		8'hC3: begin huff_code[15:0] <= 16'b1111111111011010 ;	length <= 5'd16	;	end
		8'hC4: begin huff_code[15:0] <= 16'b1111111111011011 ;	length <= 5'd16	;	end
 	
		8'hC5: begin huff_code[15:0] <= 16'b1111111111011100 ;	length <= 5'd16	;	end
		8'hC6: begin huff_code[15:0] <= 16'b1111111111011101 ;	length <= 5'd16	;	end
		8'hC7: begin huff_code[15:0] <= 16'b1111111111011110 ;	length <= 5'd16	;	end
		8'hC8: begin huff_code[15:0] <= 16'b1111111111011111 ;	length <= 5'd16	;	end
		8'hC9: begin huff_code[15:0] <= 16'b1111111111100000 ;	length <= 5'd16	;	end
		8'hCA: begin huff_code[15:0] <= 16'b1111111111100001 ;	length <= 5'd16	;	end
		8'hD1: begin huff_code[15:0] <= 16'b11111111000 ;		length <= 5'd11	;	end
		8'hD2: begin huff_code[15:0] <= 16'b1111111111100010 ;	length <= 5'd16	;	end
		8'hD3: begin huff_code[15:0] <= 16'b1111111111100011 ;	length <= 5'd16	;	end
		8'hD4: begin huff_code[15:0] <= 16'b1111111111100100 ;	length <= 5'd16	;	end
		8'hD5: begin huff_code[15:0] <= 16'b1111111111100101 ;	length <= 5'd16	;	end
		8'hD6: begin huff_code[15:0] <= 16'b1111111111100110 ;	length <= 5'd16	;	end
		8'hD7: begin huff_code[15:0] <= 16'b1111111111100111 ;	length <= 5'd16	;	end
		8'hD8: begin huff_code[15:0] <= 16'b1111111111101000 ;	length <= 5'd16	;	end
		8'hD9: begin huff_code[15:0] <= 16'b1111111111101001 ;	length <= 5'd16	;	end
		8'hDA: begin huff_code[15:0] <= 16'b1111111111101010 ;	length <= 5'd16	;	end
		8'hE1: begin huff_code[15:0] <= 16'b1111111111101011 ;	length <= 5'd16	;	end
		8'hE2: begin huff_code[15:0] <= 16'b1111111111101100 ;	length <= 5'd16	;	end
		8'hE3: begin huff_code[15:0] <= 16'b1111111111101101 ;	length <= 5'd16	;	end
		8'hE4: begin huff_code[15:0] <= 16'b1111111111101110 ;	length <= 5'd16	;	end
		8'hE5: begin huff_code[15:0] <= 16'b1111111111101111 ;	length <= 5'd16	;	end
		8'hE6: begin huff_code[15:0] <= 16'b1111111111110000 ;	length <= 5'd16	;	end
		8'hE7: begin huff_code[15:0] <= 16'b1111111111110001 ;	length <= 5'd16	;	end
		8'hE8: begin huff_code[15:0] <= 16'b1111111111110010 ;	length <= 5'd16	;	end
		8'hE9: begin huff_code[15:0] <= 16'b1111111111110011 ;	length <= 5'd16	;	end
		8'hEA: begin huff_code[15:0] <= 16'b1111111111110100 ;	length <= 5'd16	;	end
		8'hF0: begin huff_code[15:0] <= 16'b11111111001 ;		length <= 5'd11	;	end
		8'hF1: begin huff_code[15:0] <= 16'b1111111111110101 ;	length <= 5'd16	;	end
		8'hF2: begin huff_code[15:0] <= 16'b1111111111110110 ;	length <= 5'd16	;	end
		8'hF3: begin huff_code[15:0] <= 16'b1111111111110111 ;	length <= 5'd16	;	end
		8'hF4: begin huff_code[15:0] <= 16'b1111111111111000 ;	length <= 5'd16	;	end
		8'hF5: begin huff_code[15:0] <= 16'b1111111111111001 ;	length <= 5'd16	;	end
		8'hF6: begin huff_code[15:0] <= 16'b1111111111111010 ;	length <= 5'd16	;	end
		8'hF7: begin huff_code[15:0] <= 16'b1111111111111011 ;	length <= 5'd16	;	end
		8'hF8: begin huff_code[15:0] <= 16'b1111111111111100 ;	length <= 5'd16	;	end
		8'hF9: begin huff_code[15:0] <= 16'b1111111111111101 ;	length <= 5'd16	;	end
		8'hFA: begin huff_code[15:0] <= 16'b1111111111111110 ;	length <= 5'd16	;	end
		default: begin huff_code[15:0] <= 16'b1010 ;			length <= 5'd4	;	end
	endcase
end

endmodule // m_luminance_huff_code_ac

//====================================================================================================//
module	m_luminance_ext_hm_code_ac (number_of_bits, ext_code, category, addl_bits, length, code_word);
output	[4:0]	number_of_bits;
output	reg[25:0]	ext_code;
input	[3:0]	category;
input	[9:0]	addl_bits;
input	[4:0]	length;
input	[15:0]	code_word;

wire	[4:0]	w_category;


assign	w_category[4:0] = {1'b0, category[3:0]} ;
adder_unsign_5_bits	calc_number_of_bits	(
	.O(number_of_bits), 
	.in0(w_category), 
	.in1(length), 
	.cin(1'b0)
);

always @(*) begin
	ext_code[25:0] = 26'b0;
	ext_code[15:0] = code_word[15:0];
	case(category)
		10'd1:	begin 
			ext_code <<= 1; 
			ext_code[0] = addl_bits[0];
		end
		10'd2:	begin
			ext_code <<= 2; 
			ext_code[1:0] = addl_bits[1:0];
		end
		10'd3:	begin
			ext_code <<= 3; 
			ext_code[2:0] = addl_bits[2:0];
		end
		10'd4:	begin
			ext_code <<= 4; 
			ext_code[3:0] = addl_bits[3:0];
		end
		10'd5:	begin
			ext_code <<= 5; 
			ext_code[4:0] = addl_bits[4:0];
		end
		10'd6:	begin
			ext_code <<= 6; 
			ext_code[5:0] = addl_bits[5:0];
		end
		10'd7:	begin
			ext_code <<= 7; 
			ext_code[6:0] = addl_bits[6:0];
		end
		10'd8:	begin
			ext_code <<= 8; 
			ext_code[7:0] = addl_bits[7:0];
		end
		10'd9:	begin
			ext_code <<= 9; 
			ext_code[8:0] = addl_bits[8:0];
		end
		10'd10:	begin
			ext_code <<= 10; 
			ext_code[9:0] = addl_bits[9:0];
		end
	endcase // category
end

endmodule // m_luminance_ext_hm_code_ac

//====================================================================================================//
module m_encode_luminance_ac (number_of_bits, extd_huff_code, RRRR, in);
output	[4:0]	number_of_bits;
output	[25:0]	extd_huff_code;
input	[3:0]	RRRR;
input	[10:0]	in;

wire	[3:0]	category;
wire	[4:0]	huff_code_length;
wire	[9:0]	addl_bits;
wire	[15:0]	huff_code;



// m_calc_ac_category			m_0	(
// 	.o(category), 
// 	.in(in)
// );
m_calc_ac_addl_bits 		calc_ac_addl_bits	(
	.o(addl_bits), 
	.category(category), 
	.in(in)
);
m_luminance_huff_code_ac	luminance_huff_code_ac	(
	.huff_code(huff_code), 
	.length(huff_code_length), 
	.RRRR(RRRR), 
	.SSSS(category)
);

m_luminance_ext_hm_code_ac	luminance_ext_hm_code_ac	(
	.number_of_bits(number_of_bits), 
	.ext_code(extd_huff_code), 
	.category(category), 
	.addl_bits(addl_bits), 
	.length(huff_code_length), 
	.code_word(huff_code)
);

endmodule




//====================================================================================================//
module m_encode_chrominance_ac (number_of_bits, extd_huff_code, RRRR, in);
output	[4:0]	number_of_bits;
output	[25:0]	extd_huff_code;
input	[3:0]	RRRR;
input	[10:0]	in;

wire	[3:0]	category;
wire	[4:0]	huff_code_length;
wire	[9:0]	addl_bits;
wire	[15:0]	huff_code;



m_calc_ac_addl_bits 		calc_ac_addl_bits	(
	.o(addl_bits), 
	.category(category), 
	.in(in)
);
m_chrominance_huff_code_ac	chrominance_huff_code_ac	(
	.huff_code(huff_code), 
	.length(huff_code_length), 
	.RRRR(RRRR), 
	.SSSS(category)
);

m_chrominance_ext_hm_code_ac	chrominance_ext_hm_code_ac	(
	.number_of_bits(number_of_bits), 
	.ext_code(extd_huff_code), 
	.category(category), 
	.addl_bits(addl_bits), 
	.length(huff_code_length), 
	.code_word(huff_code)
);

endmodule

//====================================================================================================//
module	m_chrominance_huff_code_ac	(huff_code, length, RRRR, SSSS); // checked
output	reg[15:0]	huff_code;
output	reg[4:0]	length;
input	[3:0]	RRRR, SSSS;

wire	[7:0]	rs ;

assign	rs[7:0]	= {RRRR[3:0], SSSS[3:0]} ;

always @(*) begin
	case(rs)
		8'h00: begin huff_code[15:0] = 16'b00 ;					length = 2; 		end
		8'h01: begin huff_code[15:0] = 16'b01 ;					length = 2; 		end
		8'h02: begin huff_code[15:0] = 16'b100 ;					length = 3; 		end
		8'h03: begin huff_code[15:0] = 16'b1010 ;				length = 4; 		end
		8'h04: begin huff_code[15:0] = 16'b11000 ;				length = 5; 		end
		8'h05: begin huff_code[15:0] = 16'b11001 ;				length = 5; 		end
		8'h06: begin huff_code[15:0] = 16'b111000 ;				length = 6; 		end
		8'h07: begin huff_code[15:0] = 16'b1111000 ;				length = 7; 		end
		8'h08: begin huff_code[15:0] = 16'b111110100 ;			length = 9; 		end
		8'h09: begin huff_code[15:0] = 16'b1111110110 ;			length = 10; 		end
		8'h0A: begin huff_code[15:0] = 16'b111111110100 ;		length = 12; 		end
		8'h11: begin huff_code[15:0] = 16'b1011 ;				length = 4; 		end
		8'h12: begin huff_code[15:0] = 16'b111001 ;				length = 6; 		end
		8'h13: begin huff_code[15:0] = 16'b11110110 ;			length = 8; 		end
		8'h14: begin huff_code[15:0] = 16'b111110101 ;			length = 9; 		end
		8'h15: begin huff_code[15:0] = 16'b11111110110 ;			length = 11; 		end
		8'h16: begin huff_code[15:0] = 16'b111111110101 ;		length = 12; 		end
		8'h17: begin huff_code[15:0] = 16'b1111111110001000 ;	length = 16; 		end
		8'h18: begin huff_code[15:0] = 16'b1111111110001001 ;	length = 16; 		end
		8'h19: begin huff_code[15:0] = 16'b1111111110001010 ;	length = 16; 		end
		8'h1A: begin huff_code[15:0] = 16'b1111111110001011 ;	length = 16; 		end
		8'h21: begin huff_code[15:0] = 16'b11010 ;				length = 5; 		end
		8'h22: begin huff_code[15:0] = 16'b11110111 ;			length = 8; 		end
		8'h23: begin huff_code[15:0] = 16'b1111110111 ;			length = 10; 		end
		8'h24: begin huff_code[15:0] = 16'b111111110110 ;		length = 12; 		end
		8'h25: begin huff_code[15:0] = 16'b111111111000010 ;		length = 15; 		end
		8'h26: begin huff_code[15:0] = 16'b1111111110001100 ;	length = 16; 		end
		8'h27: begin huff_code[15:0] = 16'b1111111110001101 ;	length = 16; 		end
		8'h28: begin huff_code[15:0] = 16'b1111111110001110 ;	length = 16; 		end
		8'h29: begin huff_code[15:0] = 16'b1111111110001111 ;	length = 16; 		end
		8'h2A: begin huff_code[15:0] = 16'b1111111110010000 ;	length = 16; 		end
		8'h31: begin huff_code[15:0] = 16'b11011 ;				length = 5; 		end
		8'h32: begin huff_code[15:0] = 16'b11111000 ;			length = 8; 		end
		8'h33: begin huff_code[15:0] = 16'b1111111000 ;			length = 10; 		end
		8'h34: begin huff_code[15:0] = 16'b111111110111 ;		length = 12; 		end
		8'h35: begin huff_code[15:0] = 16'b1111111110010001 ;	length = 16; 		end
		8'h36: begin huff_code[15:0] = 16'b1111111110010010 ;	length = 16; 		end
		8'h37: begin huff_code[15:0] = 16'b1111111110010011 ;	length = 16; 		end
		8'h38: begin huff_code[15:0] = 16'b1111111110010100 ;	length = 16; 		end
		8'h39: begin huff_code[15:0] = 16'b1111111110010101 ;	length = 16; 		end
		8'h3A: begin huff_code[15:0] = 16'b1111111110010110 ;	length = 16; 		end
		8'h41: begin huff_code[15:0] = 16'b111010 ;				length = 6; 		end
		8'h42: begin huff_code[15:0] = 16'b111110110 ;			length = 9; 		end
		8'h43: begin huff_code[15:0] = 16'b1111111110010111 ;	length = 16; 		end
		8'h44: begin huff_code[15:0] = 16'b1111111110011000 ;	length = 16; 		end
		8'h45: begin huff_code[15:0] = 16'b1111111110011001 ;	length = 16; 		end
		8'h46: begin huff_code[15:0] = 16'b1111111110011010 ;	length = 16; 		end
		8'h47: begin huff_code[15:0] = 16'b1111111110011011 ;	length = 16; 		end
		8'h48: begin huff_code[15:0] = 16'b1111111110011100 ;	length = 16; 		end
		8'h49: begin huff_code[15:0] = 16'b1111111110011101 ;	length = 16; 		end
		8'h4A: begin huff_code[15:0] = 16'b1111111110011110 ;	length = 16; 		end
		8'h51: begin huff_code[15:0] = 16'b111011 ;				length =  6; 		end
		8'h52: begin huff_code[15:0] = 16'b1111111001 ;			length = 10; 		end
		8'h53: begin huff_code[15:0] = 16'b1111111110011111 ;	length = 16; 		end
		8'h54: begin huff_code[15:0] = 16'b1111111110100000 ;	length = 16; 		end
		8'h55: begin huff_code[15:0] = 16'b1111111110100001 ;	length = 16; 		end
		8'h56: begin huff_code[15:0] = 16'b1111111110100010 ;	length = 16; 		end
		8'h57: begin huff_code[15:0] = 16'b1111111110100011 ;	length = 16; 		end
		8'h58: begin huff_code[15:0] = 16'b1111111110100100 ;	length = 16; 		end
		8'h59: begin huff_code[15:0] = 16'b1111111110100101 ;	length = 16; 		end
		8'h5A: begin huff_code[15:0] = 16'b1111111110100110 ;	length = 16; 		end
		8'h61: begin huff_code[15:0] = 16'b1111001 ;				length =  7; 		end
		8'h62: begin huff_code[15:0] = 16'b11111110111 ;			length = 11; 		end
		8'h63: begin huff_code[15:0] = 16'b1111111110100111 ;	length = 16; 		end
		8'h64: begin huff_code[15:0] = 16'b1111111110101000 ;	length = 16; 		end
		8'h65: begin huff_code[15:0] = 16'b1111111110101001 ;	length = 16; 		end
		8'h66: begin huff_code[15:0] = 16'b1111111110101010 ;	length = 16; 		end
		8'h67: begin huff_code[15:0] = 16'b1111111110101011 ;	length = 16; 		end
		8'h68: begin huff_code[15:0] = 16'b1111111110101100 ;	length = 16; 		end
		8'h69: begin huff_code[15:0] = 16'b1111111110101101 ;	length = 16; 		end
		8'h6A: begin huff_code[15:0] = 16'b1111111110101110 ;	length = 16; 		end
		8'h71: begin huff_code[15:0] = 16'b1111010 ;				length =  7; 		end
		8'h72: begin huff_code[15:0] = 16'b11111111000 ;			length = 11; 		end
		8'h73: begin huff_code[15:0] = 16'b1111111110101111 ;	length = 16; 		end
		8'h74: begin huff_code[15:0] = 16'b1111111110110000 ;	length = 16; 		end
		8'h75: begin huff_code[15:0] = 16'b1111111110110001 ;	length = 16; 		end
		8'h76: begin huff_code[15:0] = 16'b1111111110110010 ;	length = 16; 		end
		8'h77: begin huff_code[15:0] = 16'b1111111110110011 ;	length = 16; 		end
		8'h78: begin huff_code[15:0] = 16'b1111111110110100 ;	length = 16; 		end
		8'h79: begin huff_code[15:0] = 16'b1111111110110101 ;	length = 16; 		end
		8'h7A: begin huff_code[15:0] = 16'b1111111110110110 ;	length = 16; 		end
		8'h81: begin huff_code[15:0] = 16'b11111001 ;			length =  8; 		end
		8'h82: begin huff_code[15:0] = 16'b1111111110110111 ;	length = 16; 		end
		8'h83: begin huff_code[15:0] = 16'b1111111110111000 ;	length = 16; 		end
		8'h84: begin huff_code[15:0] = 16'b1111111110111001 ;	length = 16; 		end
		8'h85: begin huff_code[15:0] = 16'b1111111110111010 ;	length = 16; 		end
		8'h86: begin huff_code[15:0] = 16'b1111111110111011 ;	length = 16; 		end
		8'h87: begin huff_code[15:0] = 16'b1111111110111100 ;	length = 16; 		end
		8'h88: begin huff_code[15:0] = 16'b1111111110111101 ;	length = 16; 		end
		8'h89: begin huff_code[15:0] = 16'b1111111110111110 ;	length = 16; 		end
		8'h8A: begin huff_code[15:0] = 16'b1111111110111111 ;	length = 16; 		end
		8'h91: begin huff_code[15:0] = 16'b111110111 ;			length = 9; 		end
		8'h92: begin huff_code[15:0] = 16'b1111111111000000 ;	length = 16; 		end
		8'h93: begin huff_code[15:0] = 16'b1111111111000001 ;	length = 16; 		end
		8'h94: begin huff_code[15:0] = 16'b1111111111000010 ;	length = 16; 		end
		8'h95: begin huff_code[15:0] = 16'b1111111111000011 ;	length = 16; 		end
		8'h96: begin huff_code[15:0] = 16'b1111111111000100 ;	length = 16; 		end
		8'h97: begin huff_code[15:0] = 16'b1111111111000101 ;	length = 16; 		end
		8'h98: begin huff_code[15:0] = 16'b1111111111000110 ;	length = 16; 		end
		8'h99: begin huff_code[15:0] = 16'b1111111111000111 ;	length = 16; 		end
		8'h9A: begin huff_code[15:0] = 16'b1111111111001000 ;	length = 16; 		end
		8'hA1: begin huff_code[15:0] = 16'b111111000 ;			length =  9; 		end
		8'hA2: begin huff_code[15:0] = 16'b1111111111001001 ;	length = 16; 		end
		8'hA3: begin huff_code[15:0] = 16'b1111111111001010 ;	length = 16; 		end
		8'hA4: begin huff_code[15:0] = 16'b1111111111001011 ;	length = 16; 		end
		8'hA5: begin huff_code[15:0] = 16'b1111111111001100 ;	length = 16; 		end
		8'hA6: begin huff_code[15:0] = 16'b1111111111001101 ;	length = 16; 		end
		8'hA7: begin huff_code[15:0] = 16'b1111111111001110 ;	length = 16; 		end
		8'hA8: begin huff_code[15:0] = 16'b1111111111001111 ;	length = 16; 		end
		8'hA9: begin huff_code[15:0] = 16'b1111111111010000 ;	length = 16; 		end
		8'hAA: begin huff_code[15:0] = 16'b1111111111010001 ;	length = 16; 		end
		8'hB1: begin huff_code[15:0] = 16'b111111001 ;			length =  9; 		end
		8'hB2: begin huff_code[15:0] = 16'b1111111111010010 ;	length = 16; 		end
		8'hB3: begin huff_code[15:0] = 16'b1111111111010011 ;	length = 16; 		end
		8'hB4: begin huff_code[15:0] = 16'b1111111111010100 ;	length = 16; 		end
		8'hB5: begin huff_code[15:0] = 16'b1111111111010101 ;	length = 16; 		end
		8'hB6: begin huff_code[15:0] = 16'b1111111111010110 ;	length = 16; 		end
		8'hB7: begin huff_code[15:0] = 16'b1111111111010111 ;	length = 16; 		end
		8'hB8: begin huff_code[15:0] = 16'b1111111111011000 ;	length = 16; 		end
		8'hB9: begin huff_code[15:0] = 16'b1111111111011001 ;	length = 16; 		end
		8'hBA: begin huff_code[15:0] = 16'b1111111111011010 ;	length = 16; 		end
		8'hC1: begin huff_code[15:0] = 16'b111111010 ;			length =  9; 		end
		8'hC2: begin huff_code[15:0] = 16'b1111111111011011 ;	length = 16; 		end
		8'hC3: begin huff_code[15:0] = 16'b1111111111011100 ;	length = 16; 		end
		8'hC4: begin huff_code[15:0] = 16'b1111111111011101 ;	length = 16; 		end
		8'hC5: begin huff_code[15:0] = 16'b1111111111011110 ;	length = 16; 		end
		8'hC6: begin huff_code[15:0] = 16'b1111111111011111 ;	length = 16;		end
		8'hC7: begin huff_code[15:0] = 16'b1111111111100000 ;	length = 16;		end
		8'hC8: begin huff_code[15:0] = 16'b1111111111100001 ;	length = 16;		end
		8'hC9: begin huff_code[15:0] = 16'b1111111111100010 ;	length = 16;		end
		8'hCA: begin huff_code[15:0] = 16'b1111111111100011 ;	length = 16;		end
		8'hD1: begin huff_code[15:0] = 16'b11111111001 ;			length = 11;		end
		8'hD2: begin huff_code[15:0] = 16'b1111111111100100 ;	length = 16;		end
		8'hD3: begin huff_code[15:0] = 16'b1111111111100101 ;	length = 16;		end
		8'hD4: begin huff_code[15:0] = 16'b1111111111100110 ;	length = 16;		end
		8'hD5: begin huff_code[15:0] = 16'b1111111111100111 ;	length = 16;		end
		8'hD6: begin huff_code[15:0] = 16'b1111111111101000 ;	length = 16;		end
		8'hD7: begin huff_code[15:0] = 16'b1111111111101001 ;	length = 16;		end
		8'hD8: begin huff_code[15:0] = 16'b1111111111101010 ;	length = 16;		end
		8'hD9: begin huff_code[15:0] = 16'b1111111111101011 ;	length = 16;		end
		8'hDA: begin huff_code[15:0] = 16'b1111111111101100 ;	length = 16;		end
		8'hE1: begin huff_code[15:0] = 16'b11111111100000 ;		length = 14;		end
		8'hE2: begin huff_code[15:0] = 16'b1111111111101101 ;	length = 16;		end
		8'hE3: begin huff_code[15:0] = 16'b1111111111101110 ;	length = 16;		end
		8'hE4: begin huff_code[15:0] = 16'b1111111111101111 ;	length = 16;		end
		8'hE5: begin huff_code[15:0] = 16'b1111111111110000 ;	length = 16;		end
		8'hE6: begin huff_code[15:0] = 16'b1111111111110001 ;	length = 16;		end
		8'hE7: begin huff_code[15:0] = 16'b1111111111110010 ;	length = 16;		end
		8'hE8: begin huff_code[15:0] = 16'b1111111111110011 ;	length = 16;		end
		8'hE9: begin huff_code[15:0] = 16'b1111111111110100 ;	length = 16;		end
		8'hEA: begin huff_code[15:0] = 16'b1111111111110101 ;	length = 16;		end
		8'hF0: begin huff_code[15:0] = 16'b1111111010 ;			length = 10;		end
		8'hF1: begin huff_code[15:0] = 16'b111111111000011 ;		length = 15;		end
		8'hF2: begin huff_code[15:0] = 16'b1111111111110110 ;	length = 16;		end
		8'hF3: begin huff_code[15:0] = 16'b1111111111110111 ;	length = 16;		end
		8'hF4: begin huff_code[15:0] = 16'b1111111111111000 ;	length = 16;		end
		8'hF5: begin huff_code[15:0] = 16'b1111111111111001 ;	length = 16;		end
		8'hF6: begin huff_code[15:0] = 16'b1111111111111010 ;	length = 16;		end
		8'hF7: begin huff_code[15:0] = 16'b1111111111111011 ;	length = 16;		end
		8'hF8: begin huff_code[15:0] = 16'b1111111111111100 ;	length = 16;		end
		8'hF9: begin huff_code[15:0] = 16'b1111111111111101 ;	length = 16;		end
		8'hFA: begin huff_code[15:0] = 16'b1111111111111110 ;	length = 16;		end
		default: begin huff_code[15:0] = 16'b00 ;					end
	endcase
end

endmodule

//====================================================================================================//
module	m_chrominance_ext_hm_code_ac (number_of_bits, ext_code, category, addl_bits, length, code_word);
output	[4:0]	number_of_bits;
output	reg[25:0]	ext_code;
input	[3:0]	category;
input	[9:0]	addl_bits;
input	[4:0]	length;
input	[15:0]	code_word;

wire	[4:0]	w_category;

assign	w_category[4:0] = {1'b0, category[3:0]} ;
adder_unsign_5_bits	calc_number_of_bits	(
	.O(number_of_bits), 
	.in0(w_category), 
	.in1(length), 
	.cin(1'b0)
);

always @(*) begin
	ext_code[25:0] = 26'b0;
	ext_code[15:0] = code_word[15:0];
	case(category)
		10'd1:	begin 
			ext_code <<= 1; 
			ext_code[0] = addl_bits[0];
		end
		10'd2:	begin
			ext_code <<= 2; 
			ext_code[1:0] = addl_bits[1:0];
		end
		10'd3:	begin
			ext_code <<= 3; 
			ext_code[2:0] = addl_bits[2:0];
		end
		10'd4:	begin
			ext_code <<= 4; 
			ext_code[3:0] = addl_bits[3:0];
		end
		10'd5:	begin
			ext_code <<= 5; 
			ext_code[4:0] = addl_bits[4:0];
		end
		10'd6:	begin
			ext_code <<= 6; 
			ext_code[5:0] = addl_bits[5:0];
		end
		10'd7:	begin
			ext_code <<= 7; 
			ext_code[6:0] = addl_bits[6:0];
		end
		10'd8:	begin
			ext_code <<= 8; 
			ext_code[7:0] = addl_bits[7:0];
		end
		10'd9:	begin
			ext_code <<= 9; 
			ext_code[8:0] = addl_bits[8:0];
		end
		10'd10:	begin
			ext_code <<= 10; 
			ext_code[9:0] = addl_bits[9:0];
		end
	endcase // category
end

endmodule // m_luminance_ext_hm_code_ac
