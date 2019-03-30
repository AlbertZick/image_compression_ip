// `timescale 1ps/1ps
//====================================================================================================//
/*
u_D = W'*T'

W' = 
1  1  1  1  1  1  1  1
1 -1  1 -1  1 -1  1 -1
1 -1 -1  1  1 -1 -1  1
1  1 -1 -1  1  1 -1 -1
1  1 -1 -1 -1 -1  1  1
1 -1 -1  1 -1  1  1 -1
1 -1  1 -1 -1  1 -1  1
1  1  1  1 -1 -1 -1 -1

T' = 
39   0   0   0   0   0   0   0
 0   0   0   0  39   0   0   0
 0   0  36   0   0   0 -15   0
 0   0  15   0   0   0  36   0
 0  35   0 -14   0   8   0  -6
 0  -2   0  19   0  30   0 -16
 0  16   0  30   0 -19   0  -2
 0   6   0   8   0  14   0  35

X=[x0, x1, x2, x3, x4, x5, x6, x7]
T'*X' = [t0, t1, t2, t3, t4, t5, t6, t7];
t0 = 39x0
t1 = 39x4
t2 = 36x2 - 15x6
t3 = 15x2 + 36x6
t4 = 35x1 - 14x3 + 8x5  -  6x7
t5 = -2x1 + 19x3 + 30x5 - 16x7
t6 = 16x1 + 30x3 - 19x5 -  2x7
t7 =  6x1 +  8x3 + 14x5 + 35x7

a0 = t0 + t1;  b0 = t2 + t3;  c0 = t4 + t5;  d0 = t6 + t7;
a1 = t0 - t1;  b1 = t2 - t3;  c1 = t4 - t5;  d1 = t6 - t7;

f0 = a0 + b0;  g0 = a1 + b1;  h0 = c0 + d0;  i0 = c1 + d1;
f1 = a0 - b0;  g1 = a1 - b1;  h1 = c0 - d0;  i1 = c1 - d1;

w0 = f0 + h0;
w1 = g0 + i0;
w2 = g1 + i1;
w3 = f1 + h1;
w4 = f1 - h1;
w5 = g1 - i1;
w6 = g0 - i0;
w7 = f0 - h0;
*/
//====================================================================================================//
module DCT_1D_reverse (O, finish_computing, in, clk, rst);
output	reg [31:0]	O;
output	reg			finish_computing;
input		[31:0]	in;
input				clk, rst;

reg	[31:0]		mem_in[7:0];
reg	[31:0]		mem_out[7:0];
reg	[2:0]		state;

wire	[31:0]	t_0, t_1, t_2, t_3, t_4, t_5, t_6, t_7;
wire	[31:0]	x2_36, x6_15, x2_15, x6_36, x1_35, x3_14, sub_00, x5_8, x7_6, sub_01, x1_2;
wire	[31:0]	x3_19, sub_02, x5_30, x7_16, sub_03, x1_16, x3_30, add_04, x5_19, x7_2, add_05;
wire	[31:0]	x1_6, x3_8, add_06, x5_14, x7_35, add_07;
// wire	[31:0]	a_0, a_1, b_0, b_1, c_0, c_1, d_0, d_1, f_0, f_1, g_0, g_1, h_0, h_1, i_0, i_1;
wire	[31:0]	w_0, w_1, w_2, w_3, w_4, w_5, w_6, w_7;
wire	[31:0]	a_0, a_1, a_2, a_3, b_0, b_1;
wire	[31:0]	c_0, c_1, c_2, c_3, d_0, d_1;
wire	[31:0]	e_0, e_1, e_2, e_3, f_0, f_1;
wire	[31:0]	g_0, g_1, g_2, g_3, h_0, h_1;
wire	[31:0]	i_0, i_1, i_2, i_3, j_0, j_1;
wire	[31:0]	l_0, l_1, l_2, l_3, m_0, m_1;
wire	[31:0]	n_0, n_1, n_2, n_3, p_0, p_1;
wire	[31:0]	q_0, q_1, q_2, q_3, k_0, k_1;

FP	fp_t_0		(.O(t_0), .in0(mem_in[0]), .in1(32'h421c0000), .operand(2'h2));		// t0
FP	fp_t_1		(.O(t_1), .in0(mem_in[4]), .in1(32'h421C0000), .operand(2'h2));		// t1

FP	fp_mul_00	(.O(x2_36), .in0(mem_in[2]), .in1(32'h42100000), .operand(2'h2)); 
FP	fp_mul_01	(.O(x6_15), .in0(mem_in[6]), .in1(32'h41700000), .operand(2'h2));
FP	fp_t_2		(.O(t_2), .in0(x2_36), .in1(x6_15), .operand(2'h1));				// t2

FP	fp_mul_02	(.O(x2_15), .in0(mem_in[2]), .in1(32'h41700000), .operand(2'h2));
FP	fp_mul_03	(.O(x6_36), .in0(mem_in[6]), .in1(32'h42100000), .operand(2'h2));
FP	fp_t_3		(.O(t_3), .in0(x2_15), .in1(x6_36), .operand(2'h0));				// t3

FP	fp_mul_04	(.O(x1_35), .in0(mem_in[1]), .in1(32'h420C0000), .operand(2'h2));
FP	fp_mul_05	(.O(x3_14), .in0(mem_in[3]), .in1(32'h41600000), .operand(2'h2));
FP	fp_sub_00	(.O(sub_00), .in0(x1_35), .in1(x3_14), .operand(2'h1));
FP	fp_mul_06	(.O(x5_8), .in0(mem_in[5]), .in1(32'h41000000), .operand(2'h2));
FP	fp_mul_07	(.O(x7_6), .in0(mem_in[7]), .in1(32'h40C00000), .operand(2'h2));
FP	fp_sub_01	(.O(sub_01), .in0(x5_8), .in1(x7_6), .operand(2'h1));
FP	fp_t_4		(.O(t_4), .in0(sub_00), .in1(sub_01), .operand(2'h0));				// t4

FP	fp_mul_08	(.O(x1_2), .in0(mem_in[1]), .in1(32'h40000000), .operand(2'h2));
FP	fp_mul_09	(.O(x3_19), .in0(mem_in[3]), .in1(32'h41980000), .operand(2'h2));
FP	fp_sub_02	(.O(sub_02), .in0(x3_19), .in1(x1_2), .operand(2'h1));
FP	fp_mul_10	(.O(x5_30), .in0(mem_in[5]), .in1(32'h41F00000), .operand(2'h2));
FP	fp_mul_11	(.O(x7_16), .in0(mem_in[7]), .in1(32'h41800000), .operand(2'h2));
FP	fp_sub_03	(.O(sub_03), .in0(x5_30), .in1(x7_16), .operand(2'h1));
FP	fp_t_5		(.O(t_5), .in0(sub_02), .in1(sub_03), .operand(2'h0));				// t5

FP	fp_mul_12	(.O(x1_16), .in0(mem_in[1]), .in1(32'h41800000), .operand(2'h2));
FP	fp_mul_13	(.O(x3_30), .in0(mem_in[3]), .in1(32'h41F00000), .operand(2'h2));
FP	fp_add_04	(.O(add_04), .in0(x1_16), .in1(x3_30), .operand(2'h0));
FP	fp_mul_14	(.O(x5_19), .in0(mem_in[5]), .in1(32'h41980000), .operand(2'h2));
FP	fp_mul_15	(.O(x7_2), .in0(mem_in[7]), .in1(32'h40000000), .operand(2'h2));
FP	fp_add_05	(.O(add_05), .in0(x5_19), .in1(x7_2), .operand(2'h0));
FP	fp_t_6		(.O(t_6), .in0(add_04), .in1(add_05), .operand(2'h1));				// t6

FP	fp_mul_16	(.O(x1_6), .in0(mem_in[1]), .in1(32'h40C00000), .operand(2'h2));
FP	fp_mul_17	(.O(x3_8), .in0(mem_in[3]), .in1(32'h41000000), .operand(2'h2));
FP	fp_add_06	(.O(add_06), .in0(x1_6), .in1(x3_8), .operand(2'h0));
FP	fp_mul_18	(.O(x5_14), .in0(mem_in[5]), .in1(32'h41600000), .operand(2'h2));
FP	fp_mul_19	(.O(x7_35), .in0(mem_in[7]), .in1(32'h420C0000), .operand(2'h2));
FP	fp_add_07	(.O(add_07), .in0(x5_14), .in1(x7_35), .operand(2'h0));
FP	fp_t_7		(.O(t_7), .in0(add_06), .in1(add_07), .operand(2'h0));				// t7

// FP	fp_a_0		(.O(a_0), .in0(t_0), .in1(t_1), .operand(2'h0));	
// FP	fp_a_1		(.O(a_1), .in0(t_0), .in1(t_1), .operand(2'h1));	
// FP	fp_b_0		(.O(b_0), .in0(t_2), .in1(t_3), .operand(2'h0));	
// FP	fp_b_1		(.O(b_1), .in0(t_2), .in1(t_3), .operand(2'h1));	
// FP	fp_c_0		(.O(c_0), .in0(t_4), .in1(t_5), .operand(2'h0));	
// FP	fp_c_1		(.O(c_1), .in0(t_4), .in1(t_5), .operand(2'h1));	
// FP	fp_d_0		(.O(d_0), .in0(t_6), .in1(t_7), .operand(2'h0));	
// FP	fp_d_1		(.O(d_1), .in0(t_6), .in1(t_7), .operand(2'h1));	

// FP	fp_f_0		(.O(f_0), .in0(a_0), .in1(b_0), .operand(2'h0));	
// FP	fp_f_1		(.O(f_1), .in0(a_0), .in1(b_0), .operand(2'h1));	
// FP	fp_g_0		(.O(g_0), .in0(a_1), .in1(b_1), .operand(2'h0));	
// FP	fp_g_1		(.O(g_1), .in0(a_1), .in1(b_1), .operand(2'h1));	
// FP	fp_h_0		(.O(h_0), .in0(c_0), .in1(d_0), .operand(2'h0));	
// FP	fp_h_1		(.O(h_1), .in0(c_0), .in1(d_0), .operand(2'h1));	
// FP	fp_i_0		(.O(i_0), .in0(c_1), .in1(d_1), .operand(2'h0));	
// FP	fp_i_1		(.O(i_1), .in0(c_1), .in1(d_1), .operand(2'h1));	

// FP	fp_w_0		(.O(w_0), .in0(f_0), .in1(h_0), .operand(2'h0));	
// FP	fp_w_1		(.O(w_1), .in0(g_0), .in1(i_0), .operand(2'h0));	
// FP	fp_w_2		(.O(w_2), .in0(g_1), .in1(i_1), .operand(2'h0));	
// FP	fp_w_3		(.O(w_3), .in0(f_1), .in1(h_1), .operand(2'h0));	
// FP	fp_w_4		(.O(w_4), .in0(f_1), .in1(h_1), .operand(2'h1));	
// FP	fp_w_5		(.O(w_5), .in0(g_1), .in1(i_1), .operand(2'h1));	
// FP	fp_w_6		(.O(w_6), .in0(g_0), .in1(i_0), .operand(2'h1));	
//FP	fp_w_7		(.O(w_7), .in0(f_0), .in1(h_0), .operand(2'h1));	

/*
0     1     1     1     1     1     1     1     1
1     1    -1     1    -1     1    -1     1    -1
2     1    -1    -1     1     1    -1    -1     1
3     1     1    -1    -1     1     1    -1    -1
4     1     1    -1    -1    -1    -1     1     1
5     1    -1    -1     1    -1     1     1    -1
6     1    -1     1    -1    -1     1    -1     1
7     1     1     1     1    -1    -1    -1    -1
     */
//w_0
// 1     1     1     1     1     1     1     1
FP	fp_w_0_0	(.O(a_0), .in0(t_0), .in1(t_4), .operand(2'h0));
FP	fp_w_0_1	(.O(a_1), .in0(t_1), .in1(t_5), .operand(2'h0));
FP	fp_w_0_2	(.O(a_2), .in0(t_2), .in1(t_6), .operand(2'h0));
FP	fp_w_0_3	(.O(a_3), .in0(t_3), .in1(t_7), .operand(2'h0));
FP	fp_w_0_4	(.O(b_0), .in0(a_0), .in1(a_1), .operand(2'h0));
FP	fp_w_0_5	(.O(b_1), .in0(a_2), .in1(a_3), .operand(2'h0));
FP	fp_w_0_6	(.O(w_0), .in0(b_0), .in1(b_1), .operand(2'h0));
//w_1
// 1     1    -1     1    -1     1    -1     1    -1
FP	fp_w_1_0	(.O(c_0), .in0(t_0), .in1(t_1), .operand(2'h1));
FP	fp_w_1_1	(.O(c_1), .in0(t_2), .in1(t_3), .operand(2'h1));
FP	fp_w_1_2	(.O(c_2), .in0(t_4), .in1(t_5), .operand(2'h1));
FP	fp_w_1_3	(.O(c_3), .in0(t_6), .in1(t_7), .operand(2'h1));
FP	fp_w_1_4	(.O(d_0), .in0(c_0), .in1(c_1), .operand(2'h0));
FP	fp_w_1_5	(.O(d_1), .in0(c_2), .in1(c_3), .operand(2'h0));
FP	fp_w_1_6	(.O(w_1), .in0(d_0), .in1(d_1), .operand(2'h0));
//w_2
// 2     1    -1    -1     1     1    -1    -1     1
FP	fp_w_2_0	(.O(e_0), .in0(t_0), .in1(t_1), .operand(2'h1));
FP	fp_w_2_1	(.O(e_1), .in0(t_3), .in1(t_2), .operand(2'h1));
FP	fp_w_2_2	(.O(e_2), .in0(t_4), .in1(t_5), .operand(2'h1));
FP	fp_w_2_3	(.O(e_3), .in0(t_7), .in1(t_6), .operand(2'h1));
FP	fp_w_2_4	(.O(f_0), .in0(e_0), .in1(e_1), .operand(2'h0));
FP	fp_w_2_5	(.O(f_1), .in0(e_2), .in1(e_3), .operand(2'h0));
FP	fp_w_2_6	(.O(w_2), .in0(f_0), .in1(f_1), .operand(2'h0));
//w_3
//1     1    -1    -1     1     1    -1    -1
FP	fp_w_3_0	(.O(g_0), .in0(t_0), .in1(t_2), .operand(2'h1));
FP	fp_w_3_1	(.O(g_1), .in0(t_1), .in1(t_3), .operand(2'h1));
FP	fp_w_3_2	(.O(g_2), .in0(t_4), .in1(t_6), .operand(2'h1));
FP	fp_w_3_3	(.O(g_3), .in0(t_5), .in1(t_7), .operand(2'h1));
FP	fp_w_3_4	(.O(h_0), .in0(g_0), .in1(g_1), .operand(2'h0));
FP	fp_w_3_5	(.O(h_1), .in0(g_2), .in1(g_3), .operand(2'h0));
FP	fp_w_3_6	(.O(w_3), .in0(h_0), .in1(h_1), .operand(2'h0));
//w_4
//4     1     1    -1    -1    -1    -1     1     1
FP	fp_w_4_0	(.O(i_0), .in0(t_0), .in1(t_2), .operand(2'h1));
FP	fp_w_4_1	(.O(i_1), .in0(t_1), .in1(t_3), .operand(2'h1));
FP	fp_w_4_2	(.O(i_2), .in0(t_6), .in1(t_4), .operand(2'h1));
FP	fp_w_4_3	(.O(i_3), .in0(t_7), .in1(t_5), .operand(2'h1));
FP	fp_w_4_4	(.O(j_0), .in0(i_0), .in1(i_1), .operand(2'h0));
FP	fp_w_4_5	(.O(j_1), .in0(i_2), .in1(i_3), .operand(2'h0));
FP	fp_w_4_6	(.O(w_4), .in0(j_0), .in1(j_1), .operand(2'h0));
//w_5
// 5     1    -1    -1     1    -1     1     1    -1
FP	fp_w_5_0	(.O(l_0), .in0(t_0), .in1(t_1), .operand(2'h1));
FP	fp_w_5_1	(.O(l_1), .in0(t_3), .in1(t_2), .operand(2'h1));
FP	fp_w_5_2	(.O(l_2), .in0(t_5), .in1(t_4), .operand(2'h1));
FP	fp_w_5_3	(.O(l_3), .in0(t_6), .in1(t_7), .operand(2'h1));
FP	fp_w_5_4	(.O(m_0), .in0(l_0), .in1(l_1), .operand(2'h0));
FP	fp_w_5_5	(.O(m_1), .in0(l_2), .in1(l_3), .operand(2'h0));
FP	fp_w_5_6	(.O(w_5), .in0(m_0), .in1(m_1), .operand(2'h0));
//w_6
// 6     1    -1     1    -1    -1     1    -1     1
FP	fp_w_6_0	(.O(n_0), .in0(t_0), .in1(t_1), .operand(2'h1));
FP	fp_w_6_1	(.O(n_1), .in0(t_2), .in1(t_3), .operand(2'h1));
FP	fp_w_6_2	(.O(n_2), .in0(t_5), .in1(t_4), .operand(2'h1));
FP	fp_w_6_3	(.O(n_3), .in0(t_7), .in1(t_6), .operand(2'h1));
FP	fp_w_6_4	(.O(p_0), .in0(n_0), .in1(n_1), .operand(2'h0));
FP	fp_w_6_5	(.O(p_1), .in0(n_2), .in1(n_3), .operand(2'h0));
FP	fp_w_6_6	(.O(w_6), .in0(p_0), .in1(p_1), .operand(2'h0));
//w_7
// 7     1     1     1     1    -1    -1    -1    -1
FP	fp_w_7_0	(.O(q_0), .in0(t_0), .in1(t_4), .operand(2'h1));
FP	fp_w_7_1	(.O(q_1), .in0(t_1), .in1(t_5), .operand(2'h1));
FP	fp_w_7_2	(.O(q_2), .in0(t_2), .in1(t_6), .operand(2'h1));
FP	fp_w_7_3	(.O(q_3), .in0(t_3), .in1(t_7), .operand(2'h1));
FP	fp_w_7_4	(.O(k_0), .in0(q_0), .in1(q_1), .operand(2'h0));
FP	fp_w_7_5	(.O(k_1), .in0(q_2), .in1(q_3), .operand(2'h0));
FP	fp_w_7_6	(.O(w_7), .in0(k_0), .in1(k_1), .operand(2'h0));


always @(posedge clk or posedge rst) begin
	if (rst) begin
		state = 3'b00;			
		mem_out[0] = 32'b0;
		mem_out[1] = 32'b0;
		mem_out[2] = 32'b0;
		mem_out[3] = 32'b0;
		mem_out[4] = 32'b0;
		mem_out[5] = 32'b0;
		mem_out[6] = 32'b0;
		mem_out[7] = 32'b0;
	end
	else begin
		mem_in[state] = in;
		if(state == 3'b000) begin
			mem_out[0] = w_0;
			mem_out[1] = w_1;
			mem_out[2] = w_2;
			mem_out[3] = w_3;
			mem_out[4] = w_4;
			mem_out[5] <= w_5;
			mem_out[6] <= w_6;
			mem_out[7] = w_7;
			finish_computing = 1'b1;
		end
		O = mem_out[state];
		
		if(state == 3'b01) begin
			finish_computing = 1'b0;
		end
		state = state + 3'b1;
	end
end

endmodule
//====================================================================================================//
module	DCT_2D_reverse	(O, in, clk, rst);
output	[31:0]	O;
input	[31:0]	in;
input			clk, rst;

wire			delay_01_O;

wire			mem_a_start, mem_b_start, reset_mux, delayed_reset_mux;
wire			r_dct_a_finish, r_dct_b_finish, mux_a_select, mux_b_select, mux_c_select;
wire			mem_a_en, mem_b_en, reset_r_dct_b;
wire	[31:0]	r_dct_a_O, r_dct_b_O, mux_a_O, mux_b_O, mux_c_O, mem_a_O, mem_b_O;

wire			flag, count_adj, control, mem_en, mux_control;
wire	temp;

DCT_1D_reverse		r_dct_a	(.O(r_dct_a_O), .finish_computing(r_dct_a_finish), .in(in), .clk(clk), .rst(rst));
//mux_2_1		#(32)	mux_a 	(.O(mux_a_O), .in0(32'b0), .in1(r_dct_a_O), .select(mux_a_select));
//mux_2_1		#(32)	mux_b 	(.O(mux_b_O), .in0(32'b0), .in1(r_dct_a_O), .select(mux_b_select));

mem_8x8_r	mem_a	(.O(mem_a_O), .in(r_dct_a_O), .en_write(mem_a_en), .clk(clk), .rst(mem_restart));

mem_8x8_r	mem_b	(.O(mem_b_O), .in(r_dct_a_O), .en_write(mem_b_en), .clk(clk), .rst(mem_restart)); 
					
mux_2_1		#(32)	mux_c 		(.O(mux_c_O), .in0(mem_a_O), .in1(mem_b_O), .select(mux_c_select));
DCT_1D_reverse		r_dct_b		(.O(r_dct_b_O), .finish_computing(r_dct_b_finish), .in(mux_c_O), .clk(clk), 
								.rst(reset_r_dct_b));

restart_mem		to_retart_mem		(.reset_mem(mem_restart), .clk(clk), .rst(rst));
adjustment_dct_reverse_b	adjust_r_dct_b	(.O(reset_r_dct_b), .in(r_dct_a_finish), .clk(clk), .rst(rst));

count_8_clock				count	(.flag(flag), .clk(r_dct_a_finish), .rst(count_adj));
count_8_clock_adjustment	m_0		(.O(count_adj), .clk(clk), .rst(rst));
D_flip_flop			D_FF			(.O(control), .clk(flag), .rst(rst));

delay_1_clock_a		delay_a			(.O(mux_control), .in(control), .clk(clk), .rst(rst));

//assign	temp = mem_en;
//delay_1_clock_b		delay_b			(.O(mux_control), .in(temp), .clk(clk), .rst(rst));

assign O[31:0] = r_dct_b_O[31:0];

assign mem_a_en = ~control; // write mem_a first
assign mem_b_en =  control;
assign mux_c_select = ~mux_control;

// assign mem_a_start  = 1'b1;
// assign mem_b_start	= 1'b1;

//assign mux_a_select =  control_mux_O;
//assign mux_b_select = ~control_mux_O;
//assign mux_c_select = ~delayed_select_c;

//assign mem_a_en		= control_mux_O;
//assign mem_a_reset 	= ~delay_01_O;
// assign mem_a_start  = control_mux_O;
//assign mem_a_start	= delayed_control_mux_O;

//assign mem_b_en		= ~control_mux_O;
//assign mem_b_reset 	= ~delay_01_O;
//assign mem_b_start  = ~control_mux_O;
// assign mem_b_start = ~delayed_control_mux_O;

endmodule
//====================================================================================================//
/*module	mux_controler	(O, in, start_counting, clk, rst);
output	reg	O;
input		in, start_counting, clk, rst;
reg			flag;
reg	[2:0]	counter;

always @(posedge in or posedge rst) begin
	if (rst) begin
		flag = 1'b1;
		O 	= 1'b0;
		counter = 3'b0;
	end
	else begin 
		O = flag;
		if(start_counting == 1'b1) begin
			if(in == 1'b1) begin
				counter = counter + 3'b1;
			end
			if(counter == 3'b0) begin
				flag = ~flag;
			end
		end
	end
end

endmodule*/
//====================================================================================================//
module	count_8_clock	(flag, clk, rst);
output	reg	flag;
input		clk, rst;
reg		[2:0]	counter;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		counter = 3'b0;
		flag = 1'b0;
	end
	else begin
		counter = counter + 4'b1;
		if(counter == 3'b0) begin
			flag = 3'b1;
		end
		else begin
			flag = 3'b0;
		end
	end
end

endmodule
//====================================================================================================//
module count_8_clock_adjustment		(O, clk, rst);
output reg	O;
input		clk, rst;

reg		[7:0]	counter;	

always @(posedge clk or posedge rst) begin
	if (rst) begin
		O = 1'b1;
		counter = 8'b0;
	end
	else begin 
		if (counter == 8'd9) begin
			O = 1'b0;
		end
		counter = counter + 8'b1;
	end
end

endmodule
//====================================================================================================//
module	adjustment_dct_reverse_b	(O, in, clk, rst);
output	reg	O;
input		in, clk, rst;
reg		[3:0]	counter;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		counter = 4'b0;
	end
	else begin
		if (counter == 4'b0111) begin
			O = 1'b1;
		end
		else begin
			O = 1'b0;
		end
		if (in == 1'b1) begin
			counter = counter + 4'b1;
		end
		if (counter > 4'b1001) begin
			counter = 4'b1000;
		end
	end
end

endmodule
//====================================================================================================//
module delay_1_clock_a	(O, in, clk, rst);
output	reg	O;
input		in, clk, rst;
reg		mem;

always @(posedge clk or posedge rst or in) begin
	if (rst) begin
		O = 1'b0;
		mem = 1'b0;
	end
	else begin
		O = mem;
		mem = in;
	end
end

endmodule

module delay_1_clock_b	(O, in, clk, rst);
output	reg	O;
input		in, clk, rst;
reg		mem;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		O = 1'b0;
	end
	else begin
		O = in;
	end
end

endmodule
//====================================================================================================//
module	D_flip_flop	(O, clk, rst);
output	reg O;
input		clk, rst;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		O = 1'b0;
	end
	else begin
		O = ~O;
	end
end

endmodule
//====================================================================================================//
module	restart_mem	(reset_mem, clk, rst);
output	reg	reset_mem;
input		clk, rst;
reg		[7:0]	counter;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		counter = 8'b0;
		reset_mem = 1'b1;
	end
	else begin
		if(counter == 8'd8) begin
			reset_mem = 1'b0;
		end
		counter = counter + 8'b1;
	end
end

endmodule