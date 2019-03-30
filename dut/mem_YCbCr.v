// `timescale 1ps/1ps
//====================================================================================================//
module	mem_YCbCr	(Y_O, Cb_O, Cr_O, Y_in, Cb_in, Cr_in, en_write, en_read, enable, clk);
output	reg[31:0]	Y_O, Cb_O, Cr_O;
input	[31:0]		Y_in, Cb_in, Cr_in;
input				enable, clk, en_write, en_read;

reg[31:0] 	mem_Y  [0:1048575];
reg[31:0] 	mem_Cb [0:1048575];
reg[31:0] 	mem_Cr [0:1048575];

reg[31:0]	write_counter;
reg[31:0]	read_counter;

always @(clk) begin
	if(enable == 1'b0) begin
		write_counter = 32'b0;
		read_counter  = 32'b0;
	end 
	else begin
		// pos-edge write
		if(en_write == 1'b1 && clk == 1'b1) begin
			mem_Y[write_counter]  = Y_in;
			mem_Cb[write_counter] = Cb_in;
			mem_Cr[write_counter] = Cr_in;
			write_counter = write_counter + 32'b1;
		end
		// neg-edge read
		if(en_read == 1'b1 && clk == 1'b0) begin
			Y_O		=	mem_Y[read_counter];
			Cb_O	=	mem_Cb[read_counter];
			Cr_O	=	mem_Cr[read_counter];
			read_counter = read_counter + 32'b1;
		end
	end


end
endmodule
//====================================================================================================//