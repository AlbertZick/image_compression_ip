`timescale 1ps/1ps
module	mem_8x8_r	(O, in, en_write, clk, rst);
output	reg [31:0]	O;
input	[31:0]	in;
input			en_write, clk, rst;

reg		[31:0]	ram[7:0][7:0];
reg		[2:0]	write_counter_row, write_counter_col;
reg		[2:0]	read_counter_row, read_counter_col;


always @(posedge clk or posedge rst) begin
	if (rst == 1'b1) begin
		read_counter_col = 3'b0; read_counter_row = 3'b0;
		write_counter_col = 3'b0; write_counter_row = 3'b0;
	end
	else begin
		if(en_write == 1'b0) begin
			O[31:0] = ram[read_counter_row][read_counter_col];
			read_counter_col = read_counter_col + 3'b1;
			if(read_counter_col == 3'b0) begin
				read_counter_row = read_counter_row + 3'b1;
			end
		end
		else begin
			ram[write_counter_row][write_counter_col][31:0] = in[31:0];
			write_counter_row = write_counter_row + 3'b1;
			if(write_counter_row == 3'b0) begin
				write_counter_col = write_counter_col + 3'b1;
			end
		end
	end
end

endmodule