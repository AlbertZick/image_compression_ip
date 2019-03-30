`timescale 1ps/1ps
//tin hieu _in_ dong bo voi _rst_  moi cho ra dung, ko thi tre 1 nhip

//
module mem_8x8	(O, in, clk, en, rst, start_counting_state);
parameter bits = 25;
output reg [bits-1:0] O;
input [bits-1:0]  in;
input clk;
input en, rst, start_counting_state;

parameter S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4=3'd4, S5=3'd5, S6=3'd6, S7=3'd7;
reg [2:0] storing_col_state, storing_row_state;
reg [2:0] releasing_col_state, releasing_row_state;
reg [bits-1:0] mem [7:0][7:0];
reg all_received;
reg [1:0] starting;


always @(posedge clk) begin
	if(rst == 1'b0) begin
		if (en == 1'b1 && starting[1] == 1'b1) begin
			mem[storing_row_state][storing_col_state][bits-1:0] = in[bits-1:0];
			case(storing_row_state)
				S0: storing_row_state = S1;
				S1: storing_row_state = S2;
				S2: storing_row_state = S3;
				S3: storing_row_state = S4;
				S4: storing_row_state = S5;
				S5: storing_row_state = S6;
				S6: storing_row_state = S7;
				S7: begin
						storing_row_state = S0;
						case (storing_col_state)
							S0: storing_col_state = S1;
							S1: storing_col_state = S2;
							S2: storing_col_state = S3;
							S3: storing_col_state = S4;
							S4: storing_col_state = S5;
							S5: storing_col_state = S6;
							S6: storing_col_state = S7;
							S7: begin storing_col_state = S0; all_received = 1'b1; end
						endcase
					end
			endcase
		end else begin if(en == 1'b0 && starting[1] == 1'b1) begin
			O[bits-1:0] = mem[releasing_row_state][releasing_col_state][bits-1:0];
			case(releasing_col_state)
				S0: releasing_col_state = S1;
				S1: releasing_col_state = S2;
				S2: releasing_col_state = S3;
				S3: releasing_col_state = S4;
				S4: releasing_col_state = S5;
				S5: releasing_col_state = S6;
				S6: releasing_col_state = S7;
				S7: begin 
						releasing_col_state = S0;
						case (releasing_row_state)
							S0: releasing_row_state = S1;
							S1: releasing_row_state = S2;
							S2: releasing_row_state = S3;
							S3: releasing_row_state = S4;
							S4: releasing_row_state = S5;
							S5: releasing_row_state = S6;
							S6: releasing_row_state = S7;
							S7: begin releasing_row_state = S0; all_received = 1'b0; end
						endcase
						
					end
			endcase
		end
		end
	end
	if(rst == 1'b1) begin
		storing_col_state = 3'b0; storing_row_state = 3'b0;
		releasing_col_state = 3'b0; releasing_row_state =3'b0;
		O = 0; all_received = 1'b0;
	end

end

always @(posedge start_counting_state) begin
	if(starting[0] == 1'b1) starting[1] = 1'b1;
	starting[0] = 1'b1;
end

endmodule
//====================================================================================================//
module mem_8x8_transpose	(O, in, clk, en, rst, start_counting_state);
parameter bits = 32;
output reg [bits-1:0] O;
input [bits-1:0]  in;
input clk;
input en, rst, start_counting_state;

parameter S0=3'd0, S1=3'd1, S2=3'd2, S3=3'd3, S4=3'd4, S5=3'd5, S6=3'd6, S7=3'd7;
reg [2:0] storing_col_state, storing_row_state;
reg [2:0] releasing_col_state, releasing_row_state;
reg [bits-1:0] mem [7:0][7:0];
reg all_received;

always @(posedge clk) begin
	if(rst == 1'b0) begin
		if (en == 1'b1 && start_counting_state == 1'b1) begin
			mem[storing_row_state][storing_col_state][bits-1:0] = in[bits-1:0];
			case(storing_row_state)
				S0: storing_row_state = S1;
				S1: storing_row_state = S2;
				S2: storing_row_state = S3;
				S3: storing_row_state = S4;
				S4: storing_row_state = S5;
				S5: storing_row_state = S6;
				S6: storing_row_state = S7;
				S7: begin
						storing_row_state = S0;
						case (storing_col_state)
							S0: storing_col_state = S1;
							S1: storing_col_state = S2;
							S2: storing_col_state = S3;
							S3: storing_col_state = S4;
							S4: storing_col_state = S5;
							S5: storing_col_state = S6;
							S6: storing_col_state = S7;
							S7: begin storing_col_state = S0; all_received = 1'b1; end
						endcase
					end
			endcase
		end
		if(en == 1'b1 && all_received == 1'b1) begin
			O[bits-1:0] = mem[releasing_row_state][releasing_col_state][bits-1:0];
			releasing_col_state = releasing_col_state + 3'b1;
			if(releasing_col_state == 3'b0) begin
				releasing_row_state = releasing_row_state + 3'b1;
			end
			/*ase(releasing_col_state)
				S0: releasing_col_state = S1;
				S1: releasing_col_state = S2;
				S2: releasing_col_state = S3;
				S3: releasing_col_state = S4;
				S4: releasing_col_state = S5;
				S5: releasing_col_state = S6;
				S6: releasing_col_state = S7;
				S7: begin
						releasing_col_state = S0;
						case (releasing_row_state)
							S0: releasing_row_state = S1;
							S1: releasing_row_state = S2;
							S2: releasing_row_state = S3;
							S3: releasing_row_state = S4;
							S4: releasing_row_state = S5;
							S5: releasing_row_state = S6;
							S6: releasing_row_state = S7;
							S7: begin releasing_row_state = S0; end
						endcase
						
					end
			endcase*/
		end
	end
	if(rst == 1'b1) begin
		storing_col_state = 3'b0; storing_row_state = 3'b0;
		releasing_col_state = 3'b0; releasing_row_state =3'b0;
		O = 32'bzzz; all_received = 1'b0;
	end

end


endmodule
//====================================================================================================//
module mem_8x8_r_DCT	(O, in, clk, en, rst, start_counting_state);
parameter bits = 32;
output reg [bits-1:0] O;
input [bits-1:0]  in;
input clk;
input en, rst, start_counting_state;

reg [2:0] storing_col_state, storing_row_state;
reg [2:0] releasing_col_state, releasing_row_state;
reg [bits-1:0] mem [7:0][7:0];
reg all_received;

always @(posedge clk) begin
	if(rst == 1'b0) begin
		if (en == 1'b1 && start_counting_state == 1'b1) begin
			mem[storing_row_state][storing_col_state][bits-1:0] = in[bits-1:0];
			storing_row_state = storing_row_state + 3'b1;
			if(storing_row_state == 3'b0) begin
				storing_col_state = storing_col_state + 3'b1;
				if(storing_col_state == 3'b0) begin 
					all_received = 1'b1; 
				end
			end
		end
		if(en == 1'b0 && all_received == 1'b1) begin
			O[bits-1:0] = mem[releasing_row_state][releasing_col_state][bits-1:0];
			releasing_col_state = releasing_col_state + 3'b1;
			if(releasing_col_state == 3'b0) begin
				releasing_row_state = releasing_row_state + 3'b1;
			end
		end
	end
	if(rst == 1'b1) begin
		storing_col_state = 3'b0; storing_row_state = 3'b0;
		releasing_col_state = 3'b0; releasing_row_state =3'b0;
		O = 32'bzzz; all_received = 1'b0;
	end
end


endmodule