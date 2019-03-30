// inputs are in x-axis order by default, outputs are in y-axis order

// `timescale 1ps/1ps
//====================================================================================================//
module dct_2_D (O, in, clk, rst);

parameter bits = 25;

output	[bits-1:0]	O;
input	[bits-1:0]	in;
input		clk, rst;

reg [6:0] state;

wire [bits-1:0] dct_a_O, dct_b_O, mem_a_O, mem_b_O, mux_a_O, mux_b_O, mux_c_O;
wire [bits-1:0] dct_a_in, dct_b_in, mem_a_in, mem_b_in, mux_a_0, mux_a_1, mux_b_0, mux_b_1, mux_c_0, mux_c_1;
wire 			mem_a_en, mem_b_en, mux_a_select, mux_b_select, mux_c_select;
wire			Q, a, sensitivity, dct_a_finish, dct_b_finish, mem_a_start_count_state, mem_b_start_count_state;
wire			reset, dieu_chinh_in;

//----- list all modules --------------------
dct 					dct_a		(dct_a_O, dct_a_finish, dct_a_in, clk, rst);
dieu_chinh				dc			(reset, dieu_chinh_in, clk, rst);
dct 					dct_b		(dct_b_O, dct_b_finish, dct_b_in, clk, reset);

mem_8x8 	#(25)		mem_a		(mem_a_O, mem_a_in, clk, mem_a_en, rst, mem_a_start_count_state);
mem_8x8 	#(25)		mem_b		(mem_b_O, mem_b_in, clk, mem_b_en, rst, mem_b_start_count_state);

mux_2_1  	#(bits)		mux_a 	(mux_a_O, mux_a_0, mux_a_1, mux_a_select);
mux_2_1  	#(bits)		mux_b 	(mux_b_O, mux_b_0, mux_b_1, mux_b_select);
mux_2_1  	#(bits)		mux_c 	(mux_c_O, mux_c_0, mux_c_1, mux_c_select);

counter_8_state 	C			(sensitivity, dct_a_finish,rst);
D_flipflop 			D			(Q, a, a, sensitivity);
delay_1_clk stall	(.O(mux_c_select), .in(~Q), .clk(clk), .rst(rst));

//----- connect wires --------------------
assign dct_a_in[bits-1:0]		=	in[bits-1:0];

assign mux_a_1[bits-1:0]		=	dct_a_O[bits-1:0];
assign mux_b_1[bits-1:0]		=	dct_a_O[bits-1:0];
assign mux_a_0[bits-1:0]		=	25'b0;
assign mux_b_0[bits-1:0]		=	25'b0;
assign mem_a_in[bits-1:0]		=	mux_a_O[bits-1:0];
assign mem_b_in[bits-1:0]		=	mux_b_O[bits-1:0];
assign mux_c_0[bits-1:0]		=	mem_b_O[bits-1:0];
assign mux_c_1[bits-1:0]		=	mem_a_O[bits-1:0];
assign dct_b_in[bits-1:0]		=	mux_c_O[bits-1:0];

assign mem_a_en			=	 Q;
assign mem_b_en			=	~Q;
assign mux_a_select		=	 Q;
assign mux_b_select		=	~Q;
// assign mux_c_select		=	~Q;

assign mem_a_start_count_state		= dct_a_finish;
assign mem_b_start_count_state		= dct_a_finish;
assign dieu_chinh_in				= dct_a_finish;

assign O[bits-1:0]					=	dct_b_O[bits-1:0];

endmodule

//====================================================================================================//
// D flip-flop
module D_flipflop(Q, Q_n, D, clk);
output reg Q, Q_n;
input D, clk;

initial begin
	Q_n 	= 1'b1;
	Q		= 1'b0;
end

always @(posedge clk) begin
	Q		=  D;
	Q_n	= ~Q;
end

endmodule
//====================================================================================================//
// count 8 state
module counter_8_state(Q, clk, rst);
output reg Q;
input clk, rst;
reg [2:0] state;

reg [1:0] starting;

always @(posedge clk or posedge rst) begin
	if(rst == 1'b1) state = 3'b000;
	else begin
		if(starting[1] == 1'b1) begin
			case(state) 
				3'b000: begin state = 3'b001; Q = 1'b0; end
				3'b001: state = 3'b010;
				3'b010: state = 3'b011;
				3'b011: state = 3'b100;
				3'b100: state = 3'b101;
				3'b101: state = 3'b110;
				3'b110: state = 3'b111;
				3'b111: begin state = 3'b000; Q = 1'b1; end
			endcase
		end
	end
end

always @(posedge clk) begin
	if(starting[0] == 1'b1) starting[1] = 1'b1;
	starting[0] = 1'b1;
end

endmodule
//====================================================================================================//
//----- module dieu chinh clock -----
module dieu_chinh(reset, in, clk, rst);
output reset;
input in, clk, rst;

reg [1:0] state;

always @(posedge clk or posedge in) begin
	if(rst == 1'b1) state = 2'b00;
	else begin
		case(state)
			2'b00: if(in == 1'b1) state = 2'b01;
			2'b01: state = 2'b10;
			2'b10: state = 2'b11;
		endcase
	end
end

assign reset = (state == 2'b01);

endmodule
//====================================================================================================//
module delay_1_clk (O, in, clk, rst);
output reg	O;
input		in, clk, rst;
reg			mem;

always @(posedge clk) begin
	if(rst == 1'b1) begin
		mem = 1'b0;
		O = 1'b0;
	end
	else begin
		mem = in;
		O = mem;
	end
end
endmodule