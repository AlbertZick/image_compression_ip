/* 
|  Y  |	 	| 0   |	  | 0.299  0.587  0.114 |	| R |
|  Cb | =	| 128 | + |-0.169 -0.331  0.5	| * | G |
|  Cr |	 	| 128 |	  | 0.5	  -0.419 -0.081 |   | B |

|  Y  |	 	| 0x00000000 |	    | 32'h3E991687   32'h3F1645A2  32'h3DE978D5 |	  | R |
|  Cb | = 	| 0x43000000 |  + 	| 32'hBE2D0E56   32'hBEA978D5  32'h3F000000 |  *  | G |
|  Cr |	 	| 0x43000000 |	  	| 32'h3F000000	 32'hBED6872B  32'hBDA5E354 |	  | B |

tru Y, Cb, Cr cho 128 vi chuan hoa

 */
 //====================================================================================================//
// `timescale 1ps/1ps
module	convert_color_space_Y	(Y, R, G, B);
output	[31:0]	Y;
input		[31:0]	R, G, B;
wire		[31:0]	fp_00_O, fp_01_O, fp_02_O, fp_03_O, fp_04_O;

FP	fp_00	(.O(fp_00_O), .in0(R), .in1(32'h3E991687), .operand(2'h2));
FP	fp_01	(.O(fp_01_O), .in0(G), .in1(32'h3F1645A2), .operand(2'h2));
FP	fp_02	(.O(fp_02_O), .in0(B), .in1(32'h3DE978D5), .operand(2'h2));
FP	fp_03	(.O(fp_03_O), .in0(fp_00_O), .in1(fp_01_O), .operand(2'h0));
FP	fp_04	(.O(fp_04_O), .in0(fp_03_O), .in1(fp_02_O), .operand(2'h0));
FP	fp_05	(.O(Y), .in0(fp_04_O), .in1(32'h43000000), .operand(2'h1));

endmodule
//====================================================================================================//
module	convert_color_space_Cb	(Cb, R, G, B);
output	[31:0]	Cb;
input		[31:0]	R, G, B;
wire		[31:0]	fp_00_O, fp_01_O, fp_02_O, fp_03_O;

FP	fp_00	(.O(fp_00_O), .in0(R), .in1(32'hBE2D0E56), .operand(2'h2));
FP	fp_01	(.O(fp_01_O), .in0(G), .in1(32'hBEA978D5), .operand(2'h2));
FP	fp_02	(.O(fp_02_O), .in0(B), .in1(32'h3F000000), .operand(2'h2));
FP	fp_03	(.O(fp_03_O), .in0(fp_00_O), .in1(fp_01_O), .operand(2'h0));
FP	fp_04	(.O(Cb), .in0(fp_03_O), .in1(fp_02_O), .operand(2'h0));

endmodule
//====================================================================================================//
module	convert_color_space_Cr	(Cr, R, G, B);
output	[31:0]	Cr;
input		[31:0]	R, G, B;
wire		[31:0]	fp_00_O, fp_01_O, fp_02_O, fp_03_O;

FP	fp_00	(.O(fp_00_O), .in0(R), .in1(32'h3F000000), .operand(2'h2));
FP	fp_01	(.O(fp_01_O), .in0(G), .in1(32'hBED6872B), .operand(2'h2));
FP	fp_02	(.O(fp_02_O), .in0(B), .in1(32'hBDA5E354), .operand(2'h2));
FP	fp_03	(.O(fp_03_O), .in0(fp_00_O), .in1(fp_01_O), .operand(2'h0));
FP	fp_04	(.O(Cr), .in0(fp_03_O), .in1(fp_02_O), .operand(2'h0));


endmodule
//====================================================================================================//
module control_convertion	(en_mem_YCbCr,clk);
output	reg	en_mem_YCbCr;
input	clk;

reg		[31:0]	state;

initial begin
	state = 32'b0;
	en_mem_YCbCr = 1'b0;
end

always @(posedge clk) begin
	if (state != 32'b0) begin
		en_mem_YCbCr = 1'b1;

	end
	else begin
		state = 1'b1;
		en_mem_YCbCr = 1'b0;
	end
end
endmodule
//====================================================================================================//
