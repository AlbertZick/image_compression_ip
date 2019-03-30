// `timescale 1ps/1ps
//====================================================================================================//
module	not_gate	(O, in);
parameter N = 8;
output	[N-1:0]	O;
input		[N-1:0]	in;
	assign	O[N-1:0] = ~(in[N-1:0]);
endmodule
//====================================================================================================//
module full_adder(O, cout, a, b, cin);
output O, cout;
input cin, a, b;
	assign O = (b^a)^cin;
	assign cout = ((b^a)&cin)|(b&a);
endmodule
//====================================================================================================//
module dich_phai(O,a);
input [24:0] a;
output [24:0] O;
	assign O[24] = a[24];
	assign O[23:0] = a[24:1];
endmodule
//====================================================================================================//
module extend_8to25_bits(
	output [24:0] O,
	input [7:0] a
);
	assign O[24:8] = 17'b0;
	assign O[7:0] = a;
endmodule
//====================================================================================================//
module half_adder(s, c, a, b);
output s,c;
input a,b;
	assign s = a^b;
	assign c = a&b;
endmodule
//====================================================================================================//
module dich_trai_1(O,a);
output [24:0] O;
input [24:0] a;
	assign O[24:1] = a[23:0];
	assign O[0] = 1'b0;
endmodule
//====================================================================================================//
module mux_2_1(O, in0, in1, select);
parameter N = 25;
output [N-1:0] O;
input  [N-1:0] in0, in1;
input select;
	assign O[N-1:0] = select ? (in1[N-1:0]) : (in0[N-1:0]);
endmodule
//====================================================================================================//
module mux_4_1(O, in0, in1, in2, in3, select);
parameter N = 25;
output	[N-1:0]	O;
input		[N-1:0]	in0, in1, in2, in3;
input		[1:0]		select;
wire		[N-1:0]	m00_O, m01_O;
	mux_2_1	#(N) m00	(m00_O, in0, in1, select[0]);
	mux_2_1	#(N) m01	(m01_O, in2, in3, select[0]);
	mux_2_1	#(N) m02	(O, m00_O[N-1:0], m01_O[N-1:0], select[1]);
endmodule
//====================================================================================================//
module demux_1_2	(O0, O1, in, select);
parameter N = 24;
output	[N-1:0]	O0,O1;
input		[N-1:0]	in;
input					select;

	assign 	O0[N-1:0] = (select == 1'b0)?(in[N-1:0]):({(N-1){1'bz}});
	assign	O1[N-1:0] = (select == 1'b1)?(in[N-1:0]):({(N-1){1'bz}});
	
endmodule
//====================================================================================================//
module demux_1_4 (O0, O1, O2, O3, in, select);
parameter	N = 24;
output 		[N-1:0]	O0, O1, O2, O3;
input 		[N-1:0]	in;
input			[1:0]		select;

wire		[N-1:0] de00_0, de00_1;

	demux_1_2	#(N)	de00	(de00_0, de00_1, in, select[1]);
	demux_1_2	#(N)	de01	(O0, O1, de00_0, select[0]);
	demux_1_2	#(N)	de02	(O2, O3, de00_1, select[0]);
endmodule

//====================================================================================================//
module adder_unsign_5_bits 	(O, in0, in1, cin);
output	[4:0]	O;
input	[4:0]	in0, in1;
input			cin;
wire	[4:0]	w;
	full_adder	f00	(O[0],	w[0],	in0[0],	in1[0],	cin);
	full_adder	f01	(O[1],	w[1],	in0[1],	in1[1],	w[0]);
	full_adder	f02	(O[2],	w[2],	in0[2],	in1[2],	w[1]);
	full_adder	f03	(O[3],	w[3],	in0[3],	in1[3],	w[2]);
	full_adder	f04	(O[4],	w[4],	in0[4],	in1[4],	w[3]);
endmodule

//====================================================================================================//
module adder_unsign_6_bits	(O, in0, in1, cin);
output	[5:0]	O;
input	[5:0]	in0, in1;
input			cin;
wire	[5:0]	w;
	full_adder	f00	(O[0],	w[0],	in0[0],	in1[0],	cin);
	full_adder	f01	(O[1],	w[1],	in0[1],	in1[1],	w[0]);
	full_adder	f02	(O[2],	w[2],	in0[2],	in1[2],	w[1]);
	full_adder	f03	(O[3],	w[3],	in0[3],	in1[3],	w[2]);
	full_adder	f04	(O[4],	w[4],	in0[4],	in1[4],	w[3]);
	full_adder	f05	(O[5],	w[5],	in0[5],	in1[5],	w[4]);
endmodule
//====================================================================================================//
module sub_unsign_6_bits 	(O, in0, in1);
output	[5:0]	O;
input	[5:0]	in0,in1;

wire	[5:0]	in2,w;
	assign in2[5:0] = ~in1[5:0];
	full_adder	f00	(O[0],	w[0],	in0[0],	in2[0],	1'b1);
	full_adder	f01	(O[1],	w[1],	in0[1],	in2[1],	w[0]);
	full_adder	f02	(O[2],	w[2],	in0[2],	in2[2],	w[1]);
	full_adder	f03	(O[3],	w[3],	in0[3],	in2[3],	w[2]);
	full_adder	f04	(O[4],	w[4],	in0[4],	in2[4],	w[3]);
	full_adder	f05	(O[5],	w[5],	in0[5],	in2[5],	w[4]);
endmodule
//====================================================================================================//
module adder_unsign_8_bits 	(O, in0, in1, cin);
output	[7:0]	O;
input	[7:0]	in0, in1;
input			cin;
wire	[7:0]	w;
	full_adder	f00	(O[0],	w[0],	in0[0],	in1[0],	cin);
	full_adder	f01	(O[1],	w[1],	in0[1],	in1[1],	w[0]);
	full_adder	f02	(O[2],	w[2],	in0[2],	in1[2],	w[1]);
	full_adder	f03	(O[3],	w[3],	in0[3],	in1[3],	w[2]);
	full_adder	f04	(O[4],	w[4],	in0[4],	in1[4],	w[3]);
	full_adder	f05	(O[5],	w[5],	in0[5],	in1[5],	w[4]);
	full_adder	f06	(O[6],	w[6],	in0[6],	in1[6],	w[5]);
	full_adder	f07	(O[7],	w[7],	in0[7],	in1[7],	w[6]);
endmodule

//====================================================================================================//
module sub_nadd_9_sign_bits (O, in0, in1, sub_nadd);
output		[9:0]	O;
input		[8:0]	in0, in1;
input				sub_nadd;
wire		[8:0]	w, in;
	assign in[8:0] = in1[8:0] ^ {9{sub_nadd}};
	full_adder	f00	(O[0],	w[0],	in0[0],	in[0],	sub_nadd);
	full_adder	f01	(O[1],	w[1],	in0[1],	in[1],	w[0]);
	full_adder	f02	(O[2],	w[2],	in0[2],	in[2],	w[1]);
	full_adder	f03	(O[3],	w[3],	in0[3],	in[3],	w[2]);
	full_adder	f04	(O[4],	w[4],	in0[4],	in[4],	w[3]);
	full_adder	f05	(O[5],	w[5],	in0[5],	in[5],	w[4]);
	full_adder	f06	(O[6],	w[6],	in0[6],	in[6],	w[5]);
	full_adder	f07	(O[7],	w[7],	in0[7],	in[7],	w[6]);
	full_adder	f08	(O[8],	w[8],	in0[8],	in[8],	w[7]);
	assign	O[9] = (sub_nadd & (~(in0[8] ^ in1[8]) ^ w[8])) | ((~sub_nadd) & (w[8] ^ (in0[8] ^ in1[8])));
endmodule
//====================================================================================================//
module sub_nadd_10_sign_bits (O, in0, in1, sub_nadd);
output		[11:0]	O;
input		[10:0]	in0, in1;
input				sub_nadd;
wire		[10:0]	w, in;
	assign in[10:0] = in1[10:0] ^ {11{sub_nadd}};
	full_adder	f00	(O[0],	w[0],	in0[0],	in[0],	sub_nadd);
	full_adder	f01	(O[1],	w[1],	in0[1],	in[1],	w[0]);
	full_adder	f02	(O[2],	w[2],	in0[2],	in[2],	w[1]);
	full_adder	f03	(O[3],	w[3],	in0[3],	in[3],	w[2]);
	full_adder	f04	(O[4],	w[4],	in0[4],	in[4],	w[3]);
	full_adder	f05	(O[5],	w[5],	in0[5],	in[5],	w[4]);
	full_adder	f06	(O[6],	w[6],	in0[6],	in[6],	w[5]);
	full_adder	f07	(O[7],	w[7],	in0[7],	in[7],	w[6]);
	full_adder	f08	(O[8],	w[8],	in0[8],	in[8],	w[7]);
	full_adder	f09	(O[9],	w[9],	in0[9],	in[9],	w[8]);
	full_adder	f10	(O[10],	w[10],	in0[10],	in[10],	w[10]);
	assign	O[11] = (sub_nadd & (~(in0[10] ^ in1[10]) ^ w[10])) | ((~sub_nadd) & (w[10] ^ (in0[10] ^ in1[10])));
endmodule

//====================================================================================================//
module sub_nadd_11_sign_bits (out, in0, in1, sub_nadd);
output		[11:0]	out;
input		[10:0]	in0, in1;
input				sub_nadd;
wire		[10:0]	w, in;
	assign in[10:0] = in1[10:0] ^ {11{sub_nadd}};
	full_adder	f00	(out[00],	w[00],	in0[00],	in[00],	sub_nadd);
	full_adder	f01	(out[01],	w[01],	in0[01],	in[01],	w[00]);
	full_adder	f02	(out[02],	w[02],	in0[02],	in[02],	w[01]);
	full_adder	f03	(out[03],	w[03],	in0[03],	in[03],	w[02]);
	full_adder	f04	(out[04],	w[04],	in0[04],	in[04],	w[03]);
	full_adder	f05	(out[05],	w[05],	in0[05],	in[05],	w[04]);
	full_adder	f06	(out[06],	w[06],	in0[06],	in[06],	w[05]);
	full_adder	f07	(out[07],	w[07],	in0[07],	in[07],	w[06]);
	full_adder	f08	(out[08],	w[08],	in0[08],	in[08],	w[07]);
	full_adder	f09	(out[09],	w[09],	in0[09],	in[09],	w[08]);
	full_adder	f10	(out[10],	w[10],	in0[10],	in[10],	w[09]);
	assign	out[11] = (sub_nadd & (~(in0[10] ^ in1[10]) ^ w[10])) | ((~sub_nadd) & (w[10] ^ (in0[10] ^ in1[10])));
endmodule


//====================================================================================================//
module sub_nadd_12_sign_bits (out, in0, in1, sub_nadd);
output		[12:0]	out;
input		[11:0]	in0, in1;
input				sub_nadd;
wire		[11:0]	w, in;
	assign in[11:0] = in1[11:0] ^ {12{sub_nadd}};
	full_adder	f00	(out[00],	w[00],	in0[00],	in[00],	sub_nadd);
	full_adder	f01	(out[01],	w[01],	in0[01],	in[01],	w[00]);
	full_adder	f02	(out[02],	w[02],	in0[02],	in[02],	w[01]);
	full_adder	f03	(out[03],	w[03],	in0[03],	in[03],	w[02]);
	full_adder	f04	(out[04],	w[04],	in0[04],	in[04],	w[03]);
	full_adder	f05	(out[05],	w[05],	in0[05],	in[05],	w[04]);
	full_adder	f06	(out[06],	w[06],	in0[06],	in[06],	w[05]);
	full_adder	f07	(out[07],	w[07],	in0[07],	in[07],	w[06]);
	full_adder	f08	(out[08],	w[08],	in0[08],	in[08],	w[07]);
	full_adder	f09	(out[09],	w[09],	in0[09],	in[09],	w[08]);
	full_adder	f10	(out[10],	w[10],	in0[10],	in[10],	w[09]);
	full_adder	f11	(out[11],	w[11],	in0[11],	in[11],	w[10]);
	assign	out[12] = (sub_nadd & (~(in0[11] ^ in1[11]) ^ w[11])) | ((~sub_nadd) & (w[11] ^ (in0[11] ^ in1[11])));
endmodule

//====================================================================================================//
module sub_nadd_25_sign_bits (O, in0, in1, sub_nadd);
output	[25:0]	O;
input	[24:0]	in0, in1;
input			sub_nadd;
wire	[24:0]	w, in2;
	assign in2[24:0] = in1[24:0]^{25{sub_nadd}};
	full_adder	f00	(O[00],	w[00],	in0[00],	in2[00],	sub_nadd);
	full_adder	f01	(O[01],	w[01],	in0[01],	in2[01],	w[00]);
	full_adder	f02	(O[02],	w[02],	in0[02],	in2[02],	w[01]);
	full_adder	f03	(O[03],	w[03],	in0[03],	in2[03],	w[02]);
	full_adder	f04	(O[04],	w[04],	in0[04],	in2[04],	w[03]);
	full_adder	f05	(O[05],	w[05],	in0[05],	in2[05],	w[04]);
	full_adder	f06	(O[06],	w[06],	in0[06],	in2[06],	w[05]);
	full_adder	f07	(O[07],	w[07],	in0[07],	in2[07],	w[06]);
	full_adder	f08	(O[08],	w[08],	in0[08],	in2[08],	w[07]);
	full_adder	f09	(O[09],	w[09],	in0[09],	in2[09],	w[08]);
	full_adder	f10	(O[10],	w[10],	in0[10],	in2[10],	w[09]);
	full_adder	f11	(O[11],	w[11],	in0[11],	in2[11],	w[10]);
	full_adder	f12	(O[12],	w[12],	in0[12],	in2[12],	w[11]);
	full_adder	f13	(O[13],	w[13],	in0[13],	in2[13],	w[12]);
	full_adder	f14	(O[14],	w[14],	in0[14],	in2[14],	w[13]);
	full_adder	f15	(O[15],	w[15],	in0[15],	in2[15],	w[14]);
	full_adder	f16	(O[16],	w[16],	in0[16],	in2[16],	w[15]);
	full_adder	f17	(O[17],	w[17],	in0[17],	in2[17],	w[16]);
	full_adder	f18	(O[18], w[18],	in0[18],	in2[18],	w[17]);
	full_adder	f19	(O[19], w[19],	in0[19],	in2[19],	w[18]);
	full_adder	f20	(O[20], w[20],	in0[20],	in2[20],	w[19]);
	full_adder	f21	(O[21],	w[21],	in0[21],	in2[21],	w[20]);
	full_adder	f22	(O[22],	w[22],	in0[22],	in2[22],	w[21]);
	full_adder	f23	(O[23],	w[23],	in0[23],	in2[23],	w[22]);
	full_adder	f24	(O[24],	w[24],	in0[24],	in2[24],	w[23]);
	assign	O[25] = (sub_nadd & (~(in0[24] ^ in1[24]) ^ w[24])) | ((~sub_nadd) & (w[24] ^ (in0[24] ^ in1[24])));
endmodule
//====================================================================================================//
module sub_nadd_49_sign_bits (O, in0, in1, sub_nadd);
output	[49:0]	O;
input	[48:0]	in0, in1;
input			sub_nadd;
wire	[48:0]	w, in2;
	assign in2[48:0] = in1[48:0]^{49{sub_nadd}};
	full_adder	f00	(O[00],	w[00],	in0[00],	in2[00],	sub_nadd);
	full_adder	f01	(O[01],	w[01],	in0[01],	in2[01],	w[00]);
	full_adder	f02	(O[02],	w[02],	in0[02],	in2[02],	w[01]);
	full_adder	f03	(O[03],	w[03],	in0[03],	in2[03],	w[02]);
	full_adder	f04	(O[04],	w[04],	in0[04],	in2[04],	w[03]);
	full_adder	f05	(O[05],	w[05],	in0[05],	in2[05],	w[04]);
	full_adder	f06	(O[06],	w[06],	in0[06],	in2[06],	w[05]);
	full_adder	f07	(O[07],	w[07],	in0[07],	in2[07],	w[06]);
	full_adder	f08	(O[08],	w[08],	in0[08],	in2[08],	w[07]);
	full_adder	f09	(O[09],	w[09],	in0[09],	in2[09],	w[08]);
	full_adder	f10	(O[10],	w[10],	in0[10],	in2[10],	w[09]);
	full_adder	f11	(O[11],	w[11],	in0[11],	in2[11],	w[10]);
	full_adder	f12	(O[12],	w[12],	in0[12],	in2[12],	w[11]);
	full_adder	f13	(O[13],	w[13],	in0[13],	in2[13],	w[12]);
	full_adder	f14	(O[14],	w[14],	in0[14],	in2[14],	w[13]);
	full_adder	f15	(O[15],	w[15],	in0[15],	in2[15],	w[14]);
	full_adder	f16	(O[16],	w[16],	in0[16],	in2[16],	w[15]);
	full_adder	f17	(O[17],	w[17],	in0[17],	in2[17],	w[16]);
	full_adder	f18	(O[18], w[18],	in0[18],	in2[18],	w[17]);
	full_adder	f19	(O[19], w[19],	in0[19],	in2[19],	w[18]);
	full_adder	f20	(O[20], w[20],	in0[20],	in2[20],	w[19]);
	full_adder	f21	(O[21],	w[21],	in0[21],	in2[21],	w[20]);
	full_adder	f22	(O[22],	w[22],	in0[22],	in2[22],	w[21]);
	full_adder	f23	(O[23],	w[23],	in0[23],	in2[23],	w[22]);
	full_adder	f24	(O[24],	w[24],	in0[24],	in2[24],	w[23]);
	full_adder	f25	(O[25],	w[25],	in0[25],	in2[25],	w[24]);
	full_adder	f26	(O[26],	w[26],	in0[26],	in2[26],	w[25]);
	full_adder	f27	(O[27],	w[27],	in0[27],	in2[27],	w[26]);
	full_adder	f28	(O[28], w[28],	in0[28],	in2[28],	w[27]);
	full_adder	f29	(O[29], w[29],	in0[29],	in2[29],	w[28]);
	full_adder	f30	(O[30], w[30],	in0[30],	in2[30],	w[29]);
	full_adder	f31	(O[31],	w[31],	in0[31],	in2[31],	w[30]);
	full_adder	f32	(O[32],	w[32],	in0[32],	in2[32],	w[31]);
	full_adder	f33	(O[33],	w[33],	in0[33],	in2[33],	w[32]);
	full_adder	f34	(O[34],	w[34],	in0[34],	in2[34],	w[33]);
	full_adder	f35	(O[35],	w[35],	in0[35],	in2[35],	w[34]);
	full_adder	f36	(O[36],	w[36],	in0[36],	in2[36],	w[35]);
	full_adder	f37	(O[37],	w[37],	in0[37],	in2[37],	w[36]);
	full_adder	f38	(O[38], w[38],	in0[38],	in2[38],	w[37]);
	full_adder	f39	(O[39], w[39],	in0[39],	in2[39],	w[38]);
	full_adder	f40	(O[40], w[40],	in0[40],	in2[40],	w[39]);
	full_adder	f41	(O[41],	w[41],	in0[41],	in2[41],	w[40]);
	full_adder	f42	(O[42],	w[42],	in0[42],	in2[42],	w[41]);
	full_adder	f43	(O[43],	w[43],	in0[43],	in2[43],	w[42]);
	full_adder	f44	(O[44],	w[44],	in0[44],	in2[44],	w[43]);
	full_adder	f45	(O[45],	w[45],	in0[45],	in2[45],	w[44]);
	full_adder	f46	(O[46],	w[46],	in0[46],	in2[46],	w[45]);
	full_adder	f47	(O[47],	w[47],	in0[47],	in2[47],	w[46]);
	full_adder	f48	(O[48], w[48],	in0[48],	in2[48],	w[47]);
	assign	O[49] = (sub_nadd & (~(in0[48] ^ in1[48]) ^ w[48])) | ((~sub_nadd) & (w[48] ^ (in0[48] ^ in1[48])));
endmodule
//====================================================================================================//
module cong_25bits(O, a, b);
output 		[24:0]	O ;
input 		[24:0]	a ;
input 		[24:0]	b ;
wire 		[24:0]	w ;
	full_adder	m0		(O[00], w[00], a[00], b[00], 1'b0);
	full_adder	m1		(O[01], w[01], a[01], b[01], w[0]);
	full_adder	m2		(O[02], w[02], a[02], b[02], w[1]);
	full_adder	m3		(O[03], w[03], a[03], b[03], w[2]);
	full_adder	m4		(O[04], w[04], a[04], b[04], w[3]);
	full_adder	m5		(O[05], w[05], a[05], b[05], w[4]);
	full_adder	m6		(O[06], w[06], a[06], b[06], w[5]);
	full_adder	m7		(O[07], w[07], a[07], b[07], w[6]);
	full_adder	m8		(O[08], w[08], a[08], b[08], w[7]);
	full_adder	m9		(O[09], w[09], a[09], b[09], w[8]);
	full_adder	m10		(O[10], w[10], a[10], b[10], w[9]);
	full_adder	m11		(O[11], w[11], a[11], b[11], w[10]);
	full_adder	m12		(O[12], w[12], a[12], b[12], w[11]);
	full_adder	m13		(O[13], w[13], a[13], b[13], w[12]);
	full_adder	m14		(O[14], w[14], a[14], b[14], w[13]);
	full_adder	m15		(O[15], w[15], a[15], b[15], w[14]);
	full_adder	m16		(O[16], w[16], a[16], b[16], w[15]);
	full_adder	m17		(O[17], w[17], a[17], b[17], w[16]);
	full_adder	m18		(O[18], w[18], a[18], b[18], w[17]);
	full_adder	m19		(O[19], w[19], a[19], b[19], w[18]);
	full_adder	m20		(O[20], w[20], a[20], b[20], w[19]);
	full_adder	m21		(O[21], w[21], a[21], b[21], w[20]);
	full_adder	m22		(O[22], w[22], a[22], b[22], w[21]);
	full_adder	m23		(O[23], w[23], a[23], b[23], w[22]);
	full_adder	m24		(O[24], w[24], a[24], b[24], w[23]);
endmodule
//====================================================================================================//
module tru_25bits(O, a, b);
output 	[24:0] O;
input 	[24:0] a;
input 	[24:0] b;
wire 	[24:0] w;

	full_adder	m0		(O[0], w[0], a[0], ~b[0], 1'b1);
	full_adder	m1		(O[1], w[1], a[1], ~b[1], w[0]);
	full_adder	m2		(O[2], w[2], a[2], ~b[2], w[1]);
	full_adder	m3		(O[3], w[3], a[3], ~b[3], w[2]);
	full_adder	m4		(O[4], w[4], a[4], ~b[4], w[3]);
	full_adder	m5		(O[5], w[5], a[5], ~b[5], w[4]);
	full_adder	m6		(O[6], w[6], a[6], ~b[6], w[5]);
	full_adder	m7		(O[7], w[7], a[7], ~b[7], w[6]);
	full_adder	m8		(O[8], w[8], a[8], ~b[8], w[7]);
	full_adder	m9		(O[9], w[9], a[9], ~b[9], w[8]);
	full_adder	m10	(O[10], w[10], a[10], ~b[10], w[9]);
	full_adder	m11	(O[11], w[11], a[11], ~b[11], w[10]);
	full_adder	m12	(O[12], w[12], a[12], ~b[12], w[11]);
	full_adder	m13	(O[13], w[13], a[13], ~b[13], w[12]);
	full_adder	m14	(O[14], w[14], a[14], ~b[14], w[13]);
	full_adder	m15	(O[15], w[15], a[15], ~b[15], w[14]);
	full_adder	m16	(O[16], w[16], a[16], ~b[16], w[15]);
	full_adder	m17	(O[17], w[17], a[17], ~b[17], w[16]);
	full_adder	m18	(O[18], w[18], a[18], ~b[18], w[17]);
	full_adder	m19	(O[19], w[19], a[19], ~b[19], w[18]);
	full_adder	m20	(O[20], w[20], a[20], ~b[20], w[19]);
	full_adder	m21	(O[21], w[21], a[21], ~b[21], w[20]);
	full_adder	m22	(O[22], w[22], a[22], ~b[22], w[21]);
	full_adder	m23	(O[23], w[23], a[23], ~b[23], w[22]);
	full_adder	m24	(O[24], w[24], a[24], ~b[24], w[23]);
endmodule
//====================================================================================================//
module add_24_bits(O, cout, in0, in1, cin);
output 	[23:0]	O;
output				cout;
input		[23:0]	in0, in1;
input					cin;
wire					f00_cout,f01_cout,f02_cout,f03_cout,f04_cout,f05_cout,f06_cout;
wire					f07_cout,f08_cout,f09_cout,f10_cout,f11_cout,f12_cout,f13_cout;
wire					f14_cout,f15_cout,f16_cout,f17_cout,f18_cout,f19_cout,f20_cout;
wire					f21_cout,f22_cout;
	full_adder	f00	(O[00], f00_cout, in0[00], in1[00], cin);
	full_adder	f01	(O[01], f01_cout, in0[01], in1[01], f00_cout);
	full_adder	f02	(O[02], f02_cout, in0[02], in1[02], f01_cout);
	full_adder	f03	(O[03], f03_cout, in0[03], in1[03], f02_cout);
	full_adder	f04	(O[04], f04_cout, in0[04], in1[04], f03_cout);
	full_adder	f05	(O[05], f05_cout, in0[05], in1[05], f04_cout);
	full_adder	f06	(O[06], f06_cout, in0[06], in1[06], f05_cout);
	full_adder	f07	(O[07], f07_cout, in0[07], in1[07], f06_cout);
	full_adder	f08	(O[08], f08_cout, in0[08], in1[08], f07_cout);
	full_adder	f09	(O[09], f09_cout, in0[09], in1[09], f08_cout);
	full_adder	f10	(O[10], f10_cout, in0[10], in1[10], f09_cout);
	full_adder	f11	(O[11], f11_cout, in0[11], in1[11], f10_cout);
	full_adder	f12	(O[12], f12_cout, in0[12], in1[12], f11_cout);
	full_adder	f13	(O[13], f13_cout, in0[13], in1[13], f12_cout);
	full_adder	f14	(O[14], f14_cout, in0[14], in1[14], f13_cout);
	full_adder	f15	(O[15], f15_cout, in0[15], in1[15], f14_cout);
	full_adder	f16	(O[16], f16_cout, in0[16], in1[16], f15_cout);
	full_adder	f17	(O[17], f17_cout, in0[17], in1[17], f16_cout);
	full_adder	f18	(O[18], f18_cout, in0[18], in1[18], f17_cout);
	full_adder	f19	(O[19], f19_cout, in0[19], in1[19], f18_cout);
	full_adder	f20	(O[20], f20_cout, in0[20], in1[20], f19_cout);
	full_adder	f21	(O[21], f21_cout, in0[21], in1[21], f20_cout);
	full_adder	f22	(O[22], f22_cout, in0[22], in1[22], f21_cout);
	full_adder	f23	(O[23], cout	 , in0[23], in1[23], f22_cout);
endmodule
//====================================================================================================//
module add_48_bits (O, cout, in0, in1, cin);
output	[47:0]	O;
output				cout;
input		[47:0]	in0, in1;
input					cin;
wire					add00_cout, add01_cout;
//{
	add_24_bits		add00		(O[23:00], add00_cout, in0[23:00], in1[23:00], 1'b0);
	add_24_bits		add01		(O[47:24], add01_cout, in0[47:24], in1[47:24], add00_cout);
//}
endmodule
//====================================================================================================//

//====================================================================================================//
module multiplier_6x6_bits( O, x, y);
output	[11:0]	O;
input		[5:0]		x, y;
wire a00_O,f01_O,a02_O,f03_O,a04_O,f05_O,a06_O,f07_O,a08_O,f09_O,a10_O,f11_O,a12_O,f13_O,a14_O,f15_O;
wire a16_O,f17_O,a18_O,f19_O,a20_O,f21_O,a22_O,f23_O,a24_O,f25_O,a26_O,f27_O,a28_O,f29_O,a30_O,f31_O;
wire a32_O,f33_O,a34_O,f35_O,a36_O,f37_O,a38_O,f39_O,a40_O,f41_O,a42_O,f43_O,a44_O,f45_O,a46_O,f47_O;
wire a48_O,f49_O,a50_O,f51_O,a52_O,f53_O,a54_O,f55_O,a56_O,f57_O,a58_O,f59_O,a60_O,f61_O,a62_O,f63_O;
wire a64_O,f65_O,a66_O,f67_O,a68_O,f69_O,a70_O,f71_O;
wire f01_cout,f03_cout,f05_cout,f07_cout,f09_cout,f11_cout,f13_cout,f15_cout,f17_cout,f19_cout;
wire f21_cout,f23_cout,f25_cout,f27_cout,f29_cout,f31_cout,f33_cout,f35_cout,f37_cout,f39_cout;
wire f41_cout,f43_cout,f45_cout,f47_cout,f49_cout,f51_cout,f53_cout,f55_cout,f57_cout,f59_cout;
wire f61_cout,f63_cout,f65_cout,f67_cout,f69_cout,f71_cout;
//{
	and			a00	(a00_O, y[0], x[0]);
	full_adder	f01	(f01_O, f01_cout, 1'b0, a00_O, 1'b0);
	and			a02	(a02_O, y[0], x[1]);
	full_adder	f03	(f03_O, f03_cout, 1'b0, a02_O, f01_cout);
	and			a04	(a04_O, y[0], x[2]);
	full_adder	f05	(f05_O, f05_cout, 1'b0, a04_O, f03_cout);
	and			a06	(a06_O, y[0], x[3]);
	full_adder	f07	(f07_O, f07_cout, 1'b0, a06_O, f05_cout);
	and			a08	(a08_O, y[0], x[4]);
	full_adder	f09	(f09_O, f09_cout, 1'b0, a08_O, f07_cout);
	and			a10	(a10_O, y[0], x[5]);
	full_adder	f11	(f11_O, f11_cout, 1'b0, a10_O, f09_cout);

	and			a12	(a12_O, y[1], x[0]);
	full_adder	f13	(f13_O, f13_cout, f03_O, a12_O, 1'b0);
	and			a14	(a14_O, y[1], x[1]);
	full_adder	f15	(f15_O, f15_cout, f05_O, a14_O, f13_cout);
	and			a16	(a16_O, y[1], x[2]);
	full_adder	f17	(f17_O, f17_cout, f07_O, a16_O, f15_cout);
	and			a18	(a18_O, y[1], x[3]);            
	full_adder	f19	(f19_O, f19_cout, f09_O, a18_O, f17_cout);
	and			a20	(a20_O, y[1], x[4]);            
	full_adder	f21	(f21_O, f21_cout, f11_O, a20_O, f19_cout);
	and			a22	(a22_O, y[1], x[5]);
	full_adder	f23	(f23_O, f23_cout, f11_cout, a22_O, f21_cout);

	and			a24	(a24_O, y[2], x[0]);
	full_adder	f25	(f25_O, f25_cout, f15_O, a24_O, 1'b0);
	and			a26	(a26_O, y[2], x[1]);            
	full_adder	f27	(f27_O, f27_cout, f17_O, a26_O, f25_cout);
	and			a28	(a28_O, y[2], x[2]);            
	full_adder	f29	(f29_O, f29_cout, f19_O, a28_O, f27_cout);
	and			a30	(a30_O, y[2], x[3]);            
	full_adder	f31	(f31_O, f31_cout, f21_O, a30_O, f29_cout);
	and			a32	(a32_O, y[2], x[4]);            
	full_adder	f33	(f33_O, f33_cout, f23_O, a32_O, f31_cout);
	and			a34	(a34_O, y[2], x[5]);
	full_adder	f35	(f35_O, f35_cout, f23_cout, a34_O, f33_cout);

	and			a36	(a36_O, y[3], x[0]);
	full_adder	f37	(f37_O, f37_cout, f27_O, a36_O, 1'b0);
	and			a38	(a38_O, y[3], x[1]);
	full_adder	f39	(f39_O, f39_cout, f29_O, a38_O, f37_cout);
	and			a40	(a40_O, y[3], x[2]);
	full_adder	f41	(f41_O, f41_cout, f31_O, a40_O, f39_cout);
	and			a42	(a42_O, y[3], x[3]);
	full_adder	f43	(f43_O, f43_cout, f33_O, a42_O, f41_cout);
	and			a44	(a44_O, y[3], x[4]);
	full_adder	f45	(f45_O, f45_cout, f35_O, a44_O, f43_cout);
	and			a46	(a46_O, y[3], x[5]);
	full_adder	f47	(f47_O, f47_cout, f35_cout, a46_O, f45_cout);

	and			a48	(a48_O, y[4], x[0]);
	full_adder	f49	(f49_O, f49_cout, f39_O, a48_O, 1'b0);
	and			a50	(a50_O, y[4], x[1]);
	full_adder	f51	(f51_O, f51_cout, f41_O, a50_O, f49_cout);
	and			a52	(a52_O, y[4], x[2]);
	full_adder	f53	(f53_O, f53_cout, f43_O, a52_O, f51_cout);
	and			a54	(a54_O, y[4], x[3]);
	full_adder	f55	(f55_O, f55_cout, f45_O, a54_O, f53_cout);
	and			a56	(a56_O, y[4], x[4]);
	full_adder	f57	(f57_O, f57_cout, f47_O, a56_O, f55_cout);
	and			a58	(a58_O, y[4], x[5]);
	full_adder	f59	(f59_O, f59_cout, f47_cout, a58_O,  f57_cout);

	and			a60	(a60_O, y[5], x[0]);
	full_adder	f61	(f61_O, f61_cout, f51_O, a60_O, 1'b0);
	and			a62	(a62_O, y[5], x[1]);
	full_adder	f63	(f63_O, f63_cout, f53_O, a62_O, f61_cout);
	and			a64	(a64_O, y[5], x[2]);
	full_adder	f65	(f65_O, f65_cout, f55_O, a64_O, f63_cout);
	and			a66	(a66_O, y[5], x[3]);
	full_adder	f67	(f67_O, f67_cout, f57_O, a66_O, f65_cout);
	and			a68	(a68_O, y[5], x[4]);
	full_adder	f69	(f69_O, f69_cout, f59_O, a68_O, f67_cout);
	and			a70	(a70_O, y[5], x[5]);
	full_adder	f71	(f71_O, f71_cout, f59_cout, a70_O, f69_cout);
//}
	assign O[11:0] = {f71_cout, f71_O,f69_O,f67_O,f65_O,f63_O,f61_O,f49_O,f37_O,f25_O,f13_O,f01_O};
endmodule
//====================================================================================================//
module multiplier_12x12_bits (O, in0, in1);
output	[23:0]	O;
input		[11:0]	in0, in1;
wire 		[23:0]	w0,w1,w2,w3;
wire					cout;
	assign	w0[5:0] = 6'b0;
	assign	w0[23:18] = 6'b0;
	assign	w2[5:0] = 6'b0;
	assign	w2[23:18] = 6'b0;
//{
	multiplier_6x6_bits	m00	(w0[17:06],  in0[11:6], in1[05:0]);
	multiplier_6x6_bits	m01	(w1[11:00],  in0[05:0], in1[05:0]);
	multiplier_6x6_bits	m02	(w1[23:12],  in0[11:6], in1[11:6]);
	multiplier_6x6_bits	m03	(w2[17:06],  in0[05:0], in1[11:6]);
	add_24_bits 			a04	(w3, a04_cout, w0, w1, 1'b0);
	add_24_bits				a05	(O, cout, w2, w3, a04_cout);
//}
endmodule
//====================================================================================================//
module multiplier_24x24_bits (O, in0, in1);
output	[47:0]	O;
input		[23:0]	in0, in1;
wire 		[47:0]	w0,w1,w2,w3;
wire 					cout;
	assign	w0[11:00] 	= 12'b0;
	assign	w0[47:36] 	= 12'b0;
	assign	w2[11:00] 	= 12'b0;
	assign	w2[47:36] 	= 12'b0;
	multiplier_12x12_bits	m00	(w0[35:12],  in0[23:12], in1[11:00]);
	multiplier_12x12_bits	m01	(w1[23:00],  in0[11:00], in1[11:00]);
	multiplier_12x12_bits	m02	(w1[47:24],  in0[23:12], in1[23:12]);
	multiplier_12x12_bits	m03	(w2[35:12],  in0[11:00], in1[23:12]);
	add_48_bits 				a04	(w3, a04_cout, w0, w1, 1'b0);
	add_48_bits					a05	(O, cout, w2, w3, a04_cout);
endmodule
//--------------------------------1--------------------------------------------------------------------//
module divider_24x24_bits (quotient, dividend, divisor);
output		[23:0]	quotient;
input		[23:0]	dividend, divisor;
wire 		[23:0]	remainder;
	assign quotient[23:0] = 24'b0;
endmodule
//====================================================================================================//
module	right_shifter	(O, in, shift_count);
output	reg [22:0]	O;
input		[22:0]		in;
input		[4:0]			shift_count;
always @(*) begin
	case(shift_count)
		5'b0		:	O = in;
		5'b1		:	O = {01'b0, in[22:01]};
		5'b10   	:	O = {02'b0, in[22:02]};
		5'b11   	:	O = {03'b0, in[22:03]};
		5'b100  	:	O = {04'b0, in[22:04]};
		5'b101  	:	O = {05'b0, in[22:05]};
		5'b110  	:	O = {06'b0, in[22:06]};
		5'b111  	:	O = {07'b0, in[22:07]};
		5'b1000 	:	O = {08'b0, in[22:08]};
		5'b1001 	:	O = {09'b0, in[22:09]};
		5'b1010 	:	O = {10'b0, in[22:10]};
		5'b1011 	:	O = {11'b0, in[22:11]};
		5'b1100 	:	O = {12'b0, in[22:12]};
		5'b1101 	:	O = {13'b0, in[22:13]};
		5'b1110 	:	O = {14'b0, in[22:14]};
		5'b1111 	:	O = {15'b0, in[22:15]};
		5'b10000	:	O = {16'b0, in[22:16]};
		5'b10001	:	O = {17'b0, in[22:17]};
		5'b10010	:	O = {18'b0, in[22:18]};
		5'b10011	:	O = {19'b0, in[22:19]};
		5'b10100	:	O = {20'b0, in[22:20]};
		5'b10101	:	O = {21'b0, in[22:21]};
		5'b10110	:	O = {22'b0, in[22]	};
	endcase
end
endmodule
//====================================================================================================//
module shift_left_24_bits	(O, in, en);
output	[47:0]	O;
input	[47:0]	in;
input			en;
assign O[47:0] = (en == 1'b1)?({in[23:0], 24'b0}):(in[47:0]);
endmodule
//====================================================================================================//
module shift_left_12_bits	(O, in, en);
output	[47:0]	O;
input	[47:0]	in;
input			en;
assign O[47:0] = (en == 1'b1)?({in[35:0], 12'b0}):(in[47:0]);
endmodule
//====================================================================================================//
module shift_left_6_bits	(O, in, en);
output	[47:0]	O;
input	[47:0]	in;
input			en;
assign O[47:0] = (en == 1'b1)?({in[41:0], 6'b0}):(in[47:0]);
endmodule
//====================================================================================================//
module shift_left_1_bit	(O, in, en);
output	[47:0]	O;
input	[47:0]	in;
input			en;
assign O[47:0] = (en == 1'b1)?({in[46:0], 1'b0}):(in[47:0]);
endmodule
//====================================================================================================//
module shift_right_1_bit	(O, in, en);
output	[47:0]	O;
input	[47:0]	in;
input			en;
assign O[47:0] = (en == 1'b1)?({1'b0, in[47:1]}):(in[47:0]);
endmodule
//====================================================================================================//
module abs_25_bits	(O, in);
output	[24:0]	O;
input	[24:0]	in;
wire	[24:0]	n_in, mux_0_O, mux_1_O;
assign	n_in[24:0] = ~in[24:0];
mux_2_1	#(25)	mux_0	(mux_0_O, in, n_in, in[24]);
mux_2_1	#(25)	mux_1	(mux_1_O, 25'b00, 25'b01, in[24]);
cong_25bits add	(.O(O), .a(mux_0_O), .b(mux_1_O));
endmodule
//====================================================================================================//
