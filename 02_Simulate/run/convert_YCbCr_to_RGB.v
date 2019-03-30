/* 
|  R  |	 	| 1   0.000   1.400 |		(| Y  |   | 0    |)
|  G  | =	| 1  -0.343  -0.711	| * 	(| Cb | + | -128 |)	
|  B  |	 	| 1	  1.765   0.000 |		(| Cr |   | -128 |)

|  R |	 	| 32'h3F800000   32'h00000000  32'h3FB33333 |	  (| Y  |   |32'h43000000	|)
|  G | = 	| 32'h3F800000   32'hBEAF9DB2  32'hBF360419 |  *  (| Cb | + 				|)
|  B |	 	| 32'h3F800000	 32'h3FE1EB85  32'h00000000 |	  (| Cr |   				|)
//tinh luon chuan hoa
 */
 //====================================================================================================//
`timescale 1ps/1ps
module	convert_color_space_R	(R, Y, Cb, Cr);
output	[31:0]	R;
input	[31:0]	Y, Cb, Cr;
wire	[31:0]	fp_00_O, fp_01_O;


FP	fp_00	(.O(fp_00_O) , .in0(Cr) , .in1(32'h3FB33333), .operand(2'h2));
FP	fp_01	(.O(fp_01_O) , .in0(Y) , .in1(fp_00_O), .operand(2'h0));
FP	fp_02	(.O(R), .in0(32'h43000000) , .in1(fp_01_O), .operand(2'h0));

endmodule
 //====================================================================================================//
module	convert_color_space_G	(G, Y, Cb, Cr);
output	[31:0]	G;
input	[31:0]	Y, Cb, Cr;
wire	[31:0]	fp_00_O, fp_01_O, fp_02_O, fp_03_O;

FP	fp_00	(.O(fp_00_O) , .in0(Cb) , .in1(32'hBEAF9DB2), .operand(2'h2));
FP	fp_01	(.O(fp_01_O) , .in0(Cr) , .in1(32'hBF360419), .operand(2'h2));
FP	fp_02	(.O(fp_02_O) , .in0(Y) , .in1(fp_00_O), .operand(2'h0));
FP	fp_03	(.O(fp_03_O) , .in0(fp_01_O) , .in1(fp_02_O), .operand(2'h0));
FP	fp_04	(.O(G), .in0(32'h43000000) , .in1(fp_03_O), .operand(2'h0));

endmodule
//====================================================================================================//
module	convert_color_space_B	(B, Y, Cb, Cr);
output	[31:0]	B;
input	[31:0]	Y, Cb, Cr;
wire	[31:0]	fp_00_O, fp_01_O;

FP	fp_00	(.O(fp_00_O) , .in0(Cb) , .in1(32'h3FE1EB85), .operand(2'h2));
FP	fp_01	(.O(fp_01_O) , .in0(Y) , .in1(fp_00_O), .operand(2'h0));
FP	fp_02	(.O(B), .in0(32'h43000000) , .in1(fp_01_O), .operand(2'h0));

endmodule
//====================================================================================================//
/*module control_convert_YCbCr_to_RGB		(en_mem_RGB, clk);
output	reg	en_mem_RGB;
input	clk;

reg		[31:0]	state;

initial begin
	state = 32'b0;
	en_mem_YCbCr = 1'b0;
end

always @(posedge clk) begin
	if (state == 32'hA9) begin
		en_mem_YCbCr = 1'b1;

	end
	else begin
		state = state + 32'b1;
	end
end

endmodule*/