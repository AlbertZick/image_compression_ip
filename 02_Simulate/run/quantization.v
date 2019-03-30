`timescale 1ps/1ps
//
//====================================================================================================//
module	Y_quantization	(quantized_Y, Y_in, clk, rst);
output		[31:0]	quantized_Y;
input		[31:0]	Y_in;
input				clk, rst;
reg			[31:0]	rom[7:0][7:0];
reg			[31:0]	fp_in;
reg			[2:0]	row, col;

FP	fp	(.O(quantized_Y), .in0(Y_in), .in1(fp_in), .operand(2'h2));
always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		row	=	3'b0;	col = 3'b0;
		rom[0][0] <= 32'h3d800000; rom[0][1] <= 32'h3dba2e8c; rom[0][2] <= 32'h3dcccccd; rom[0][3] <= 32'h3d800000;
		rom[0][4] <= 32'h3d2aaaab; rom[0][5] <= 32'h3ccccccd; rom[0][6] <= 32'h3ca0a0a1; rom[0][7] <= 32'h3c864b8a;
		rom[1][0] <= 32'h3daaaaab; rom[1][1] <= 32'h3daaaaab; rom[1][2] <= 32'h3d924925; rom[1][3] <= 32'h3d579436;
		rom[1][4] <= 32'h3d1d89d9; rom[1][5] <= 32'h3c8d3dcb; rom[1][6] <= 32'h3c888889; rom[1][7] <= 32'h3c94f209;
		rom[2][0] <= 32'h3d924925; rom[2][1] <= 32'h3d9d89d9; rom[2][2] <= 32'h3d800000; rom[2][3] <= 32'h3d2aaaab;
		rom[2][4] <= 32'h3ccccccd; rom[2][5] <= 32'h3c8fb824; rom[2][6] <= 32'h3c6d7304; rom[2][7] <= 32'h3c924925;
		rom[3][0] <= 32'h3d924925; rom[3][1] <= 32'h3d70f0f1; rom[3][2] <= 32'h3d3a2e8c; rom[3][3] <= 32'h3d0d3dcb;
		rom[3][4] <= 32'h3ca0a0a1; rom[3][5] <= 32'h3c3c5264; rom[3][6] <= 32'h3c4ccccd; rom[3][7] <= 32'h3c842108;
		rom[4][0] <= 32'h3d638e39; rom[4][1] <= 32'h3d3a2e8c; rom[4][2] <= 32'h3cdd67c9; rom[4][3] <= 32'h3c924925;
		rom[4][4] <= 32'h3c70f0f1; rom[4][5] <= 32'h3c164fda; rom[4][6] <= 32'h3c1f1166; rom[4][7] <= 32'h3c54c77b;
		rom[5][0] <= 32'h3d2aaaab; rom[5][1] <= 32'h3cea0ea1; rom[5][2] <= 32'h3c94f209; rom[5][3] <= 32'h3c800000;
		rom[5][4] <= 32'h3c4a4588; rom[5][5] <= 32'h3c1d89d9; rom[5][6] <= 32'h3c10fdbc; rom[5][7] <= 32'h3c321643;
		rom[6][0] <= 32'h3ca72f05; rom[6][1] <= 32'h3c800000; rom[6][2] <= 32'h3c520d21; rom[6][3] <= 32'h3c3c5264;
		rom[6][4] <= 32'h3c1f1166; rom[6][5] <= 32'h3c0767ab; rom[6][6] <= 32'h3c088889; rom[6][7] <= 32'h3c2237c3;
		rom[7][0] <= 32'h3c638e39; rom[7][1] <= 32'h3c321643; rom[7][2] <= 32'h3c2c7692; rom[7][3] <= 32'h3c272f05;
		rom[7][4] <= 32'h3c124925; rom[7][5] <= 32'h3c23d70a; rom[7][6] <= 32'h3c1f1166; rom[7][7] <= 32'h3c257eb5;
	end
	else begin
		fp_in = rom[row][col];
		row = row + 3'b1;
		if (row == 3'b0) begin
			col = col + 3'b1;
		end
	end
end

endmodule
//====================================================================================================//
module	Chrominance_quantization	(quantized_Cb_Cr, Cb_Cr_in, clk, rst);
output		[31:0]	quantized_Cb_Cr;
input		[31:0]	Cb_Cr_in;
input				clk, rst;
reg			[31:0]	rom[7:0][7:0];
reg			[31:0]	fp_in;
reg			[2:0]	row, col;

FP	fp	(.O(quantized_Cb_Cr), .in0(Cb_Cr_in), .in1(fp_in), .operand(2'h2));
always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		row	=	3'b0;	col = 3'b0;
		rom[0][0] <= 32'h3d70f0f1; rom[1][0] <= 32'h3d638e39; rom[2][0] <= 32'h3d2aaaab; rom[3][0] <= 32'h3cae4c41;	
		rom[4][0] <= 32'h3c257eb5; rom[5][0] <= 32'h3c257eb5; rom[6][0] <= 32'h3c257eb5; rom[7][0] <= 32'h3c257eb5; 
		rom[0][1] <= 32'h3d638e39; rom[1][1] <= 32'h3d430c31; rom[2][1] <= 32'h3d1d89d9; rom[3][1] <= 32'h3c257eb5; 
		rom[4][1] <= 32'h3c257eb5; rom[5][1] <= 32'h3c257eb5; rom[6][1] <= 32'h3c257eb5; rom[7][1] <= 32'h3c257eb5; 
		rom[0][2] <= 32'h3d2aaaab; rom[1][2] <= 32'h3d1d89d9; rom[2][2] <= 32'h3c924925; rom[3][2] <= 32'h3c257eb5; 
		rom[4][2] <= 32'h3c257eb5; rom[5][2] <= 32'h3c257eb5; rom[6][2] <= 32'h3c257eb5; rom[7][2] <= 32'h3c257eb5; 
		rom[0][3] <= 32'h3cae4c41; rom[1][3] <= 32'h3c783e10; rom[2][3] <= 32'h3c257eb5; rom[3][3] <= 32'h3c257eb5; 
		rom[4][3] <= 32'h3c257eb5; rom[5][3] <= 32'h3c257eb5; rom[6][3] <= 32'h3c257eb5; rom[7][3] <= 32'h3c257eb5; 
		rom[0][4] <= 32'h3c257eb5; rom[1][4] <= 32'h3c257eb5; rom[2][4] <= 32'h3c257eb5; rom[3][4] <= 32'h3c257eb5; 
		rom[4][4] <= 32'h3c257eb5; rom[5][4] <= 32'h3c257eb5; rom[6][4] <= 32'h3c257eb5; rom[7][4] <= 32'h3c257eb5; 
		rom[0][5] <= 32'h3c257eb5; rom[1][5] <= 32'h3c257eb5; rom[2][5] <= 32'h3c257eb5; rom[3][5] <= 32'h3c257eb5; 
		rom[4][5] <= 32'h3c257eb5; rom[5][5] <= 32'h3c257eb5; rom[6][5] <= 32'h3c257eb5; rom[7][5] <= 32'h3c257eb5; 
		rom[0][6] <= 32'h3c257eb5; rom[1][6] <= 32'h3c257eb5; rom[2][6] <= 32'h3c257eb5; rom[3][6] <= 32'h3c257eb5; 
		rom[4][6] <= 32'h3c257eb5; rom[5][6] <= 32'h3c257eb5; rom[6][6] <= 32'h3c257eb5; rom[7][6] <= 32'h3c257eb5; 
		rom[0][7] <= 32'h3c257eb5; rom[1][7] <= 32'h3c257eb5; rom[2][7] <= 32'h3c257eb5; rom[3][7] <= 32'h3c257eb5; 
		rom[4][7] <= 32'h3c257eb5; rom[5][7] <= 32'h3c257eb5; rom[6][7] <= 32'h3c257eb5; rom[7][7] <= 32'h3c257eb5; 
	end
	else begin
		fp_in = rom[row][col];
		row = row + 3'b1;
		if (row == 3'b0) begin
			col = col + 3'b1;
		end
	end
end
endmodule
//====================================================================================================//
module	Y_unquantization	(unquantized_Y, Y_in, clk, rst);
output		[31:0]	unquantized_Y;
input		[31:0]	Y_in;
input				clk, rst;
reg			[31:0]	rom[7:0][7:0];
reg			[31:0]	fp_in;
reg			[2:0]	row, col;

FP	fp	(.O(unquantized_Y), .in0(Y_in), .in1(fp_in), .operand(2'h2));
always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		row	=	3'h0;	col = 3'h0;
		rom[0][0] <= 32'h41800000;	rom[0][1] <= 32'h41300000;	rom[0][2] <= 32'h41200000;	rom[0][3] <= 32'h41800000;	rom[0][4] <= 32'h41c00000;	rom[0][5] <= 32'h42200000;	rom[0][6] <= 32'h424c0000;	rom[0][7] <= 32'h42740000;	
		rom[1][0] <= 32'h41400000;	rom[1][1] <= 32'h41400000;	rom[1][2] <= 32'h41600000;	rom[1][3] <= 32'h41980000;	rom[1][4] <= 32'h41d00000;	rom[1][5] <= 32'h42680000;	rom[1][6] <= 32'h42700000;	rom[1][7] <= 32'h425c0000;	
		rom[2][0] <= 32'h41600000;	rom[2][1] <= 32'h41500000;	rom[2][2] <= 32'h41800000;	rom[2][3] <= 32'h41c00000;	rom[2][4] <= 32'h42200000;	rom[2][5] <= 32'h42640000;	rom[2][6] <= 32'h428a0000;	rom[2][7] <= 32'h42600000;	
		rom[3][0] <= 32'h41600000;	rom[3][1] <= 32'h41880000;	rom[3][2] <= 32'h41b00000;	rom[3][3] <= 32'h41e80000;	rom[3][4] <= 32'h424c0000;	rom[3][5] <= 32'h42ae0000;	rom[3][6] <= 32'h42a00000;	rom[3][7] <= 32'h42780000;	
		rom[4][0] <= 32'h41900000;	rom[4][1] <= 32'h41b00000;	rom[4][2] <= 32'h42140000;	rom[4][3] <= 32'h42600000;	rom[4][4] <= 32'h42880000;	rom[4][5] <= 32'h42da0000;	rom[4][6] <= 32'h42ce0000;	rom[4][7] <= 32'h429a0000;	
		rom[5][0] <= 32'h41c00000;	rom[5][1] <= 32'h420c0000;	rom[5][2] <= 32'h425c0000;	rom[5][3] <= 32'h42800000;	rom[5][4] <= 32'h42a20000;	rom[5][5] <= 32'h42d00000;	rom[5][6] <= 32'h42e20000;	rom[5][7] <= 32'h42b80000;	
		rom[6][0] <= 32'h42440000;	rom[6][1] <= 32'h42800000;	rom[6][2] <= 32'h429c0000;	rom[6][3] <= 32'h42ae0000;	rom[6][4] <= 32'h42ce0000;	rom[6][5] <= 32'h42f20000;	rom[6][6] <= 32'h42f00000;	rom[6][7] <= 32'h42ca0000;	
		rom[7][0] <= 32'h42900000;	rom[7][1] <= 32'h42b80000;	rom[7][2] <= 32'h42be0000;	rom[7][3] <= 32'h42c40000;	rom[7][4] <= 32'h42e00000;	rom[7][5] <= 32'h42c80000;	rom[7][6] <= 32'h42ce0000;	rom[7][7] <= 32'h42c60000;	
	end
	else begin
		fp_in = rom[row][col];
		row = row + 3'b1;
		if(row == 3'b0) begin
			col = col + 3'b1;
		end
	end
end

endmodule
//====================================================================================================//
module	Cb_Cr_unquantization	(unquantized_Cb_Cr, Cb_Cr_in, clk, rst);
output		[31:0]	unquantized_Cb_Cr;
input		[31:0]	Cb_Cr_in;
input				clk, rst;
reg			[31:0]	rom[7:0][7:0];
reg			[31:0]	fp_in;
reg			[2:0]	row, col;

FP	fp	(.O(unquantized_Cb_Cr), .in0(Cb_Cr_in), .in1(fp_in), .operand(2'h2));

always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		row	=	3'h0;	col = 3'h0;
		rom[0][0] <= 32'h41880000;	rom[0][1] <= 32'h41900000;	rom[0][2] <= 32'h41c00000;	rom[0][3] <= 32'h423c0000;	rom[0][4] <= 32'h42c60000;	rom[0][5] <= 32'h42c60000;	rom[0][6] <= 32'h42c60000;	rom[0][7] <= 32'h42c60000;	
		rom[1][0] <= 32'h41900000;	rom[1][1] <= 32'h41a80000;	rom[1][2] <= 32'h41d00000;	rom[1][3] <= 32'h42840000;	rom[1][4] <= 32'h42c60000;	rom[1][5] <= 32'h42c60000;	rom[1][6] <= 32'h42c60000;	rom[1][7] <= 32'h42c60000;	
		rom[2][0] <= 32'h41c00000;	rom[2][1] <= 32'h41d00000;	rom[2][2] <= 32'h42600000;	rom[2][3] <= 32'h42c60000;	rom[2][4] <= 32'h42c60000;	rom[2][5] <= 32'h42c60000;	rom[2][6] <= 32'h42c60000;	rom[2][7] <= 32'h42c60000;	
		rom[3][0] <= 32'h423c0000;	rom[3][1] <= 32'h42c60000;	rom[3][2] <= 32'h42c60000;	rom[3][3] <= 32'h42c60000;	rom[3][4] <= 32'h42c60000;	rom[3][5] <= 32'h42c60000;	rom[3][6] <= 32'h42c60000;	rom[3][7] <= 32'h42c60000;	
		rom[4][0] <= 32'h42c60000;	rom[4][1] <= 32'h42c60000;	rom[4][2] <= 32'h42c60000;	rom[4][3] <= 32'h42c60000;	rom[4][4] <= 32'h42c60000;	rom[4][5] <= 32'h42c60000;	rom[4][6] <= 32'h42c60000;	rom[4][7] <= 32'h42c60000;	
		rom[5][0] <= 32'h42c60000;	rom[5][1] <= 32'h42c60000;	rom[5][2] <= 32'h42c60000;	rom[5][3] <= 32'h42c60000;	rom[5][4] <= 32'h42c60000;	rom[5][5] <= 32'h42c60000;	rom[5][6] <= 32'h42c60000;	rom[5][7] <= 32'h42c60000;	
		rom[6][0] <= 32'h42c60000;	rom[6][1] <= 32'h42c60000;	rom[6][2] <= 32'h42c60000;	rom[6][3] <= 32'h42c60000;	rom[6][4] <= 32'h42c60000;	rom[6][5] <= 32'h42c60000;	rom[6][6] <= 32'h42c60000;	rom[6][7] <= 32'h42c60000;	
		rom[7][0] <= 32'h42c60000;	rom[7][1] <= 32'h42c60000;	rom[7][2] <= 32'h42c60000;	rom[7][3] <= 32'h42c60000;	rom[7][4] <= 32'h42c60000;	rom[7][5] <= 32'h42c60000;	rom[7][6] <= 32'h42c60000;	rom[7][7] <= 32'h42c60000;	
	end
	else begin
		fp_in = rom[row][col];
		col = col + 3'b1;
		if(col == 3'b0) begin
			row = row + 3'b1;
		end
	end
end
endmodule
//====================================================================================================//
/*
Y_quantization = [
    16 11 10 16  24  40  51  61;
    12 12 14 19  26  58  60  55;
    14 13 16 24  40  57  69  56;
    14 17 22 29  51  87  80  62;
    18 22 37 56  68 109 103  77;
    24 35 55 64  81 104 113  92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103  99  ];

Chrominance_quantization = [
    17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99  ];
*/