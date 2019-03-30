`timescale 1ps/1ps
module	coding	(O, sync_clk, in, clk, rst);
output	reg	[7:0]	O;
output  reg			sync_clk;
input	[24:0]		in;
input				clk, rst;
reg		[2:0]		state;
reg		[7:0]		mem [1048575:0];
reg		[19:0]		store_counter;
reg		[19:0]		release_counter;
reg					flag;
reg		[9:0]		number_of_byte_0;

always @(clk) begin
	if (rst) begin
		store_counter 		<= 20'b0;
		release_counter 	<= 20'b0;
		state 				<= 3'b0;
		flag				<= 1'b0;
		number_of_byte_0	<= 10'b0;
		sync_clk			<= 1'b0;
	end
	else begin
		if(clk == 1'b1) begin
			mem[store_counter][7:0] = in[7:0];
			store_counter 			= store_counter + 20'b01;
			case(state)
			3'b000: begin
						if(mem[release_counter] == 8'b0) begin
							number_of_byte_0 	= number_of_byte_0 + 10'b1;
							flag 				= 1'b1;
							release_counter 	= release_counter + 10'b1;
							state = 3'b00;
						end
						else begin
							if(flag == 1'b1) begin
								state = 3'b01;
							end
							else begin
								O[7:0] = mem[release_counter][7:0];
								release_counter = release_counter + 20'b1;
								state = 3'b00;
							end
						end
					end
			3'b001: begin
						sync_clk 	<= 1'b1;
						O[7:0]		<= 8'b0;
						flag		<= 1'b0;
						state		<= 3'b10;
					end
			3'b010: begin
						sync_clk	<= 1'b1;
						O[7:0]		<= number_of_byte_0[7:0];
						number_of_byte_0[7:0]	<=	8'b0;
						state		<= 3'b00;
					end
			endcase
		end
		else begin
			sync_clk = 1'b0;
		end
	end
end
endmodule
//===================================================================================================
module	decoding	(O, in, clk, rst);
output	reg	[7:0]	O;
input		[7:0]	in;
input				clk, rst;

reg		[2:0]		state;
reg		[7:0]		mem [1048575:0];
reg		[19:0]		store_counter;
reg		[19:0]		release_counter;
reg		[7:0]		down_counter;
reg					flag;

always @(posedge clk) begin
	if (rst) begin
		store_counter 		<= 20'b0;
		release_counter 	<= 20'b0;
		state 				<= 3'b0;
		down_counter		<= 8'b0;
	end
	else begin
		mem[store_counter][7:0] = in[7:0];
		store_counter = store_counter + 20'b1;

		case (state)
		3'b00:	begin
					O[7:0] = mem[release_counter][7:0];
					release_counter	= 	release_counter + 20'b1;
					if(mem[release_counter][7:0] == 8'b0) begin
						state = 3'b01;
						flag   = 1'b1;
					end
					else begin
						state  = 3'b00;
					end
				end
		3'b01:	begin
					if(flag   == 1'b1) begin
						down_counter[7:0] 	= mem[release_counter][7:0];
						release_counter 	= release_counter + 20'b1;
						flag  				= 1'b0;
					end
					down_counter[7:0] = down_counter[7:0] - 8'b01;
					if(down_counter[7:0] == 8'b0) begin
						state = 3'b00;
					end
					else begin
						O[7:0] 	<= 8'b0;
						state 	<= 3'b01;
					end
				end
		endcase
	end
end

endmodule