// `timescale 1ps/1ps
//====================================================================================================//
`define NULL 0
module	mem_RGB	(R_O, G_O, B_O, finish_64, finish, size_x, size_y, en_read, clk);
output	reg[31:0]	R_O, G_O, B_O;
output	reg			finish, finish_64;
input		[31:0]	size_x, size_y;
input				en_read, clk;

reg[31:0]	mem_R [0:1048575]; //0 - 2^20
reg[31:0]	mem_G [0:1048575];
reg[31:0]	mem_B [0:1048575];
reg[31:0]	write_counter, read_counter;
reg[31:0]	R_in, G_in, B_in;
integer		file_R, file_B, file_G; // file handler
integer		scan_R, scan_B, scan_G; // file handler

initial begin
	// $monitor("mem_R[%d] = %b\nmem_G[%d] = %b\nmem_B[%d] = %b\nR_O[%d] = %b\nG_O[%d] = %b\nB_O[%d] = %b\n", write_counter, mem_R[write_counter], write_counter, mem_G[write_counter], write_counter, mem_B[write_counter], read_counter, mem_R[read_counter], read_counter, mem_G[read_counter], read_counter, mem_B[read_counter]);
	write_counter	= 32'b0;
	read_counter	= 32'b0;
	file_R = $fopen("/mnt/hgfs/A/Truong/project_term_172/02_Simulate/test_data/read_R.v", "r");
	file_G = $fopen("/mnt/hgfs/A/Truong/project_term_172/02_Simulate/test_data/read_G.v", "r");
	file_B = $fopen("/mnt/hgfs/A/Truong/project_term_172/02_Simulate/test_data/read_B.v", "r");
	if (file_R == `NULL) begin
		$display("file_R file was not found or contain NULL");
		$finish;
	end
	if (file_G == `NULL) begin
		$display("file_G file was not found or contain NULL");
		$finish;
	end
	if (file_B == `NULL) begin
		$display("file_B file was not found or contain NULL");
		$finish;
	end
end

always @(posedge clk) begin
	//----- store data from file to mem
	scan_R = $fscanf(file_R, "%h\n", R_in);
	scan_G = $fscanf(file_G, "%h\n", G_in);
	scan_B = $fscanf(file_B, "%h\n", B_in);
	// store each R value in mem_R
	if (!$feof(file_R)) begin
		mem_R[write_counter] = R_in;
	end
	// store each G value in mem_G
	if (!$feof(file_G)) begin
		mem_G[write_counter] = G_in;
	end
	// store each B value in mem_B
	if (!$feof(file_B)) begin
		mem_B[write_counter] = B_in;
	end
	write_counter = write_counter + 32'b1;
	//-----
	//	read data from memory to port
	if (en_read == 1'b1) begin
		R_O	=	mem_R[read_counter];
		G_O	=	mem_G[read_counter];
		B_O	=	mem_B[read_counter];
		read_counter = read_counter + 32'b1;
	end
end
endmodule
//====================================================================================================//
//====================================================================================================//