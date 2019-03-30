`ifndef C_PREDICTOR
`define C_PREDICTOR

interface class ifc_basic_matrix_functions;

pure virtual function int index (int x, int y);
pure virtual function void add_mtx(ref shortreal rs_array[64], const ref shortreal mtx_0[64], const ref shortreal mtx_1[64]);
pure virtual function void add_num_to_mtx(ref shortreal rs_array[64], const ref shortreal mtx[64], input shortreal num);
pure virtual function void mul_matrix(ref shortreal rs_array[64], const ref shortreal mtx_0[64], const ref shortreal mtx_1[64]);
pure virtual function void mul_mtx_by_num(ref shortreal rs_array[64], const ref shortreal array[64], input shortreal num);
pure virtual function void div_mtx_by_num(ref shortreal rs_array[64], input shortreal num);
pure virtual function void transpose_mtx(ref shortreal mtx[64]);

endclass


virtual class basic_matrix_functions implements ifc_basic_matrix_functions;

extern virtual function int index (int x, int y);
extern virtual function void add_mtx(ref shortreal rs_array[64], const ref shortreal mtx_0[64], const ref shortreal mtx_1[64]);
extern virtual function void add_num_to_mtx(ref shortreal rs_array[64], const ref shortreal mtx[64], input shortreal num);
extern virtual function void mul_matrix(ref shortreal rs_array[64], const ref shortreal mtx_0[64], const ref shortreal mtx_1[64]);
extern virtual function void mul_mtx_by_num(ref shortreal rs_array[64], const ref shortreal array[64], input shortreal num);
extern virtual function void div_mtx_by_num(ref shortreal rs_array[64], input shortreal num);
extern virtual function void transpose_mtx(ref shortreal mtx[64]);

endclass : basic_matrix_functions

//////////////////////////////////////////////////////////////////////////////////////

function void basic_matrix_functions::transpose_mtx(ref shortreal mtx[64]);
automatic shortreal temp[64];

for(int row = 0; row<8; row++) begin
	for(int col = 0; col<8; col++) begin
		temp[this.index(row, col)] = mtx[this.index(col, row)];
	end
end

foreach(temp[i]) begin
	mtx[i] = temp[i];
end

endfunction : transpose_mtx

function int  basic_matrix_functions::index (int x, int y);
	int indx;
	indx = x*8 + y;
	return indx;
endfunction : index

//
function void basic_matrix_functions::add_mtx(ref shortreal rs_array[64], const ref shortreal mtx_0[64], const ref shortreal mtx_1[64]);
	foreach(rs_array[i]) begin
			rs_array[i] = mtx_1[i] + mtx_0[i];
	end
endfunction : add_mtx

//
function void basic_matrix_functions::add_num_to_mtx(ref shortreal rs_array[64], const ref shortreal mtx[64], input shortreal num);
foreach(rs_array[i]) begin
		rs_array[i] = mtx[i] + num ;
	end
endfunction : add_num_to_mtx

//
function void basic_matrix_functions::mul_matrix(ref shortreal rs_array[64], const ref shortreal mtx_0[64], const ref shortreal mtx_1[64]);
for(int row = 0; row < 8; row++) begin
		for(int col = 0; col < 8; col++) begin
			rs_array[index(row,col)] = 	mtx_0[index(row,0)] * mtx_1[index(0,col)] + 
										mtx_0[index(row,1)] * mtx_1[index(1,col)] +
										mtx_0[index(row,2)] * mtx_1[index(2,col)] +
										mtx_0[index(row,3)] * mtx_1[index(3,col)] +
										mtx_0[index(row,4)] * mtx_1[index(4,col)] +
										mtx_0[index(row,5)] * mtx_1[index(5,col)] +
										mtx_0[index(row,6)] * mtx_1[index(6,col)] +
										mtx_0[index(row,7)] * mtx_1[index(7,col)] ;
		end
	end
endfunction : mul_matrix

//
function void basic_matrix_functions::mul_mtx_by_num(ref shortreal rs_array[64], const ref shortreal array[64], input shortreal num);
for(int row = 0; row < 8; row++) begin
	for(int col = 0; col < 8; col++) begin
		rs_array[index(row,col)] = array[index(row,col)] * num ;
	end
end

endfunction : mul_mtx_by_num

//
function void basic_matrix_functions::div_mtx_by_num(ref shortreal rs_array[64], input shortreal num);
for(int row = 0; row < 8; row++) begin
	for(int col = 0; col < 8; col++) begin
		rs_array[index(row,col)] /= num ;
	end
end

endfunction : div_mtx_by_num





class c_predictor extends basic_matrix_functions;

longint 	y_nth_block, cb_nth_block, cr_nth_block;
int 	y_dc_queue[$], cb_dc_queue[$], cr_dc_queue[$];

// //*******************************************************
// static int my_checker;
// //*******************************************************

bit[25:0]	y_encoded[$];
bit[25:0]	cb_encoded[$];
bit[25:0]	cr_encoded[$];

bit[4:0]	y_encoded_bits[$];
bit[4:0]	cb_encoded_bits[$];
bit[4:0]	cr_encoded_bits[$];

function new();
	y_nth_block = 0;
	cb_nth_block = 0;
	cr_nth_block = 0;
endfunction : new


const shortreal		D[64] = {
	39,    39,    39,    39,    39,    39,    39,    39,
    55,    47,    27,    11,   -11,   -27,   -47,   -55,
    51,    21,   -21,   -51,   -51,   -21,    21,    51,
    43,   -11,   -55,   -33,    33,    55,    11,   -43,
    39,   -39,   -39,    39,    39,   -39,   -39,    39,
    33,   -55,    11,    43,   -43,   -11,    55,   -33,
    21,   -51,    51,   -21,   -21,    51,   -51,    21,
    11,   -27,    47,   -55,    55,   -47,    27,   -11};

const shortreal 		D_T[64] = {
	39,    55,    51,    43,    39,    33,    21,    11,
	39,    47,    21,   -11,   -39,   -55,   -51,   -27,
	39,    27,   -21,   -55,   -39,    11,    51,    47,
	39,    11,   -51,   -33,    39,    43,   -21,   -55,
	39,   -11,   -51,    33,    39,   -43,   -21,    55,
	39,   -27,   -21,    55,   -39,   -11,    51,   -47,
	39,   -47,    21,    11,   -39,    55,   -51,    27,
	39,   -55,    51,   -43,    39,   -33,    21,   -11 };

const shortreal Y_quantization_table[64] = {
    16, 11, 10, 16,  24,  40,  51,  61,
    12, 12, 14, 19,  26,  58,  60,  55,
    14, 13, 16, 24,  40,  57,  69,  56,
    14, 17, 22, 29,  51,  87,  80,  62,
    18, 22, 37, 56,  68, 109, 103,  77,
    24, 35, 55, 64,  81, 104, 113,  92,
    49, 64, 78, 87, 103, 121, 120, 101,
    72, 92, 95, 98, 112, 100, 103,  99 };

const shortreal Chrominance_quantization_table[64] = {
    17, 18, 24, 47, 99, 99, 99, 99,
    18, 21, 26, 66, 99, 99, 99, 99,
    24, 26, 56, 99, 99, 99, 99, 99,
    47, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99,
    99, 99, 99, 99, 99, 99, 99, 99  };

virtual function void erase_data ();
	y_encoded = {};
	cb_encoded = {};
	cr_encoded = {};
	y_encoded_bits = {};
	cb_encoded_bits = {};
	cr_encoded_bits = {};
endfunction : erase_data


extern virtual function void converting_RGB_into_YCbCr_and_sub_128(ref shortreal y_data[64], ref shortreal cb_data[64], ref shortreal cr_data[64], 
																	shortreal r_data[64], 	 shortreal g_data[64],		shortreal b_data[64]);


extern virtual function void fdct(ref shortreal rs_array[64], const ref shortreal data_mtx[64]);

extern virtual function void quantization(ref shortreal rs_array[64], input int data_type);

extern virtual function void rounding(ref int rs_array[64], ref shortreal data[64]);

extern virtual function void encode_ac (input int r, int zz_data_k, int component_type);

extern virtual function void encoding(input int zz_data[64], int component_type);

extern virtual function void zigzag_scan(ref int zz_rs[64], input int array[64]);

virtual function void round(ref int rs, ref shortreal data);
	rs = int'(data) ;
endfunction : round

extern virtual function void encode_dc(ref int zz_data_0, int component_type);

endclass : c_predictor




//////////////////////////////////////////////////////////////////////////////////////////

function void c_predictor::fdct(ref shortreal rs_array[64], const ref shortreal data_mtx[64]);
	automatic shortreal	temp[64] ;
	automatic shortreal a ;

	mul_matrix(temp, D, data_mtx) ;

	mul_matrix(rs_array, temp, D_T) ;

	a = (8*39*39) ;
	div_mtx_by_num(rs_array, a);


endfunction : fdct

//-------------------------------------------------------------------------------------
function void c_predictor::quantization(ref shortreal rs_array[64], input int data_type);

	if(data_type == 1) begin
		foreach(rs_array[i]) begin
			rs_array[i] /= Y_quantization_table[i];
		end
	end
	else begin
		foreach(rs_array[i]) begin
			rs_array[i] /= Chrominance_quantization_table[i];
		end
	end
endfunction : quantization

//
function void c_predictor::rounding(ref int rs_array[64], ref shortreal data[64]);
	foreach(data[i]) begin
		round(rs_array[i], data[i]);
	end
endfunction : rounding


//-------------------------------------------------------------------------------------
function void c_predictor::encoding(input int zz_data[64], int component_type);
	automatic int r = 0;

	case(component_type)
		1: begin
			encode_dc(zz_data[0], component_type);
			for(int k = 1; k< 64; k++) begin
				if(zz_data[k] == 0) begin
					if(k == 63) begin
						y_encoded = {y_encoded, 25'h0a};
						r = 0;
					end
					r++;
				end
				else begin
					while(r > 15) begin
						y_encoded = {y_encoded, 26'b011111111001};
						r -= 16;
					end
					encode_ac(r, zz_data[k], component_type);
					r = 0;
				end
			end
		end
		2: begin
			encode_dc(zz_data[0], component_type);
			for(int k = 1; k< 64; k++) begin
				if(zz_data[k] == 0) begin
					if(k == 63) begin
						cb_encoded = {cb_encoded, 25'h00};
						r = 0;
					end
					r++;
				end
				else begin
					while(r > 15) begin
						cb_encoded = {cb_encoded, 26'b01111111010};
						r -= 16;
					end
					encode_ac(r, zz_data[k], component_type);
					r = 0;
				end
			end
		end
		3: begin
			encode_dc(zz_data[0], component_type);
			for(int k = 1; k< 64; k++) begin
				if(zz_data[k] == 0) begin
					if(k == 63) begin
						cr_encoded = {cr_encoded, 25'h00};
						r = 0;
					end
					r++;
				end
				else begin
					while(r > 15) begin
						cr_encoded = {cr_encoded, 26'b01111111010};
						r -= 16;
					end
					encode_ac(r, zz_data[k], component_type);
					r = 0;
				end
			end
		end
	endcase

	

endfunction : encoding
//------------------------------------------------------------------------------------
function void c_predictor::zigzag_scan(ref int zz_rs[64], input int array[64]);
	zz_rs[00] = array[00] ; zz_rs[02] = array[01] ; zz_rs[03] = array[02] ; zz_rs[09] = array[03] ; zz_rs[10] = array[04] ; zz_rs[20] = array[05] ; zz_rs[21] = array[06] ; zz_rs[35] = array[07] ;
	zz_rs[01] = array[08] ; zz_rs[04] = array[09] ; zz_rs[08] = array[10] ; zz_rs[11] = array[11] ; zz_rs[19] = array[12] ; zz_rs[22] = array[13] ; zz_rs[34] = array[14] ; zz_rs[36] = array[15] ;
	zz_rs[05] = array[16] ; zz_rs[07] = array[17] ; zz_rs[12] = array[18] ; zz_rs[18] = array[19] ; zz_rs[23] = array[20] ; zz_rs[33] = array[21] ; zz_rs[37] = array[22] ; zz_rs[48] = array[23] ;
	zz_rs[06] = array[24] ; zz_rs[13] = array[25] ; zz_rs[17] = array[26] ; zz_rs[24] = array[27] ; zz_rs[32] = array[28] ; zz_rs[38] = array[29] ; zz_rs[47] = array[30] ; zz_rs[49] = array[31] ;
	zz_rs[14] = array[32] ; zz_rs[16] = array[33] ; zz_rs[25] = array[34] ; zz_rs[31] = array[35] ; zz_rs[39] = array[36] ; zz_rs[46] = array[37] ; zz_rs[50] = array[38] ; zz_rs[57] = array[39] ;
	zz_rs[15] = array[40] ; zz_rs[26] = array[41] ; zz_rs[30] = array[42] ; zz_rs[40] = array[43] ; zz_rs[45] = array[44] ; zz_rs[51] = array[45] ; zz_rs[56] = array[46] ; zz_rs[58] = array[47] ;
	zz_rs[27] = array[48] ; zz_rs[29] = array[49] ; zz_rs[41] = array[50] ; zz_rs[44] = array[51] ; zz_rs[52] = array[52] ; zz_rs[55] = array[53] ; zz_rs[59] = array[54] ; zz_rs[62] = array[55] ;
	zz_rs[28] = array[56] ; zz_rs[42] = array[57] ; zz_rs[43] = array[58] ; zz_rs[53] = array[59] ; zz_rs[54] = array[60] ; zz_rs[60] = array[61] ; zz_rs[61] = array[62] ; zz_rs[63] = array[63] ;
endfunction

//------------------------------------------------------------------------------------
function void c_predictor::converting_RGB_into_YCbCr_and_sub_128(ref shortreal y_data[64], ref shortreal cb_data[64], ref shortreal cr_data[64], 
											shortreal r_data[64], 	 shortreal g_data[64],		shortreal b_data[64]);
	
	automatic shortreal temp_0[64], temp_1[64], temp_2[64], temp_3[64];
	// convert into y
	mul_mtx_by_num(temp_0, r_data, 0.299);
	mul_mtx_by_num(temp_1, g_data, 0.587);
	mul_mtx_by_num(temp_2, b_data, 0.114);
	add_mtx(temp_3, temp_0, temp_1);
	add_mtx(y_data, temp_2, temp_3);
	add_num_to_mtx(y_data, y_data, -128);

	// convert into cb
	mul_mtx_by_num(temp_0, r_data, -0.169);
	mul_mtx_by_num(temp_1, g_data, -0.331);
	mul_mtx_by_num(temp_2, b_data,  0.5000);
	add_mtx(temp_3, temp_0, temp_1);
	add_mtx(cb_data, temp_2, temp_3);
	
	// convert into cr
	mul_mtx_by_num(temp_0, r_data,  0.5000);
	mul_mtx_by_num(temp_1, g_data, -0.4187);
	mul_mtx_by_num(temp_2, b_data, -0.0813);
	add_mtx(temp_3, temp_0, temp_1);
	add_mtx(cr_data, temp_2, temp_3);
endfunction : converting_RGB_into_YCbCr_and_sub_128

//--------------------------------------------------------------------------------------------------//
//done with 3 component type
function void c_predictor::encode_dc(ref int zz_data_0, int component_type);
	automatic bit [25:0]	encoded_data;
	automatic int diff;
	automatic int diff_abs;

	case(component_type)
		1: begin
			y_dc_queue.push_back(zz_data_0);
			if(y_nth_block == 0) diff = y_dc_queue[0];
			else diff = y_dc_queue[y_nth_block] - y_dc_queue[y_nth_block-1];
			y_nth_block++;
		end
		2: begin
			cb_dc_queue.push_back(zz_data_0);
			if(cb_nth_block == 0) diff = cb_dc_queue[0];
			else diff = cb_dc_queue[cb_nth_block] - cb_dc_queue[cb_nth_block-1];
			cb_nth_block++;
		end
		3: begin
			cr_dc_queue.push_back(zz_data_0);
			if(cr_nth_block == 0) diff = cr_dc_queue[0];
			else diff = cr_dc_queue[cr_nth_block] - cr_dc_queue[cr_nth_block-1];
			cr_nth_block++;
		end
	endcase

	if(diff < 0) diff_abs = -diff;
	else	diff_abs = diff;

	case (component_type)
	1: begin
		if(component_type == 1) begin
			if(	diff_abs >= 	1024) begin
				encoded_data[10:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[19:11] = 9'b1_1111_1110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 512) begin
				encoded_data[9:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[17:10] = 8'b1111_1110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 256) begin
				encoded_data[8:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[15:9] = 7'b111_1110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 128) begin
				encoded_data[7:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[13:8] = 6'b11_1110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 64) begin
				encoded_data[6:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[11:7] = 5'b1_1110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 32) begin
				encoded_data[5:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[9:6] = 4'b1110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 16) begin
				encoded_data[4:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[7:5] = 3'b110 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 8) begin
				encoded_data[3:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[6:4] = 3'b101 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 4) begin
				encoded_data[2:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[5:3] = 3'b100 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs >= 2) begin
				encoded_data[1:0] = (diff<0)?(diff-1):(diff) ;
				encoded_data[4:2] = 3'b011 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs == 1) begin
				encoded_data[0] = (diff<0)?(0):(1) ;
				encoded_data[3:1] = 3'b010 ;
				y_encoded.push_back(encoded_data);
				return;
			end
			else if(diff_abs == 0) begin
				encoded_data[1:0] = 2'b00 ;
				y_encoded.push_back(encoded_data);
				return;
			end
		end
	end
	2: begin
		if(	diff_abs >= 	1024) begin
			encoded_data[10:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[21:11] = 11'b111_1111_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 512) begin
			encoded_data[9:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[19:10] = 10'b11_1111_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 256) begin
			encoded_data[8:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[17:9] = 9'b1_1111_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 128) begin
			encoded_data[7:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[15:8] = 8'b1111_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 64) begin
			encoded_data[6:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[13:7] = 7'b111_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 32) begin
			encoded_data[5:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[11:6] = 6'b11_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 16) begin
			encoded_data[4:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[9:5] = 5'b1_1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 8) begin
			encoded_data[3:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[7:4] = 4'b1110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 4) begin
			encoded_data[2:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[5:3] = 3'b110 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 2) begin
			encoded_data[1:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[3:2] = 2'b10 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs == 1) begin
			encoded_data[0] = (diff<0)?(0):(1) ;
			encoded_data[2:1] = 2'b01 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs == 0) begin
			encoded_data[1:0] = 2'b00 ;
			cb_encoded.push_back(encoded_data);
			return;
		end
	end
	3: begin
		if(	diff_abs >= 	1024) begin
			encoded_data[10:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[21:11] = 11'b111_1111_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 512) begin
			encoded_data[9:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[19:10] = 10'b11_1111_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 256) begin
			encoded_data[8:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[17:9] = 9'b1_1111_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 128) begin
			encoded_data[7:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[15:8] = 8'b1111_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 64) begin
			encoded_data[6:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[13:7] = 7'b111_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 32) begin
			encoded_data[5:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[11:6] = 6'b11_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 16) begin
			encoded_data[4:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[9:5] = 5'b1_1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 8) begin
			encoded_data[3:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[7:4] = 4'b1110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 4) begin
			encoded_data[2:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[5:3] = 3'b110 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs >= 2) begin
			encoded_data[1:0] = (diff<0)?(diff-1):(diff) ;
			encoded_data[3:2] = 2'b10 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs == 1) begin
			encoded_data[0] = (diff<0)?(0):(1) ;
			encoded_data[2:1] = 2'b01 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
		else if(diff_abs == 0) begin
			encoded_data[1:0] = 2'b00 ;
			cr_encoded.push_back(encoded_data);
			return;
		end
	end
	endcase // component_type

endfunction : encode_dc
//-----------------------------------------
function void c_predictor::encode_ac(int r, int zz_data_k, int component_type);
	int zz_data_k_abs;
	bit[3:0]	RRRR, SSSS;
	bit[25:0]	encoded_data;
	bit[7:0]	rs;


	RRRR[3:0] = r[3:0];


	if(zz_data_k < 0) zz_data_k_abs = -zz_data_k;
	else				zz_data_k_abs = zz_data_k;



	if(zz_data_k_abs >= 512 ) SSSS = 4'd10;
	else	if(zz_data_k_abs >= 256) SSSS = 4'd9;
			else	if(zz_data_k_abs >= 128) SSSS = 4'd8;
					else	if(zz_data_k_abs >= 64) SSSS = 4'd7;
							else	if(zz_data_k_abs >= 32) SSSS = 4'd6;
									else	if(zz_data_k_abs >= 16) SSSS = 4'd5;
											else	if(zz_data_k_abs >= 8) SSSS = 4'd4;
													else	if(zz_data_k_abs >= 4) SSSS = 4'd3;
															else	if(zz_data_k_abs >= 2) SSSS = 4'd2;
																	else	if(zz_data_k_abs >= 1) 	SSSS = 4'd1;
																			else 					SSSS = 4'd0;

	rs[7:0]	= {RRRR[3:0], SSSS[3:0]} ;


	if(component_type == 1) begin // for luminance component
		case (rs)
			8'h00: begin encoded_data[15:0] = 16'b1010 ;				end
			8'h01: begin encoded_data[15:0] = 16'b00 ;					end
			8'h02: begin encoded_data[15:0] = 16'b01 ;					end
			8'h03: begin encoded_data[15:0] = 16'b100 ;				end
			8'h04: begin encoded_data[15:0] = 16'b1011 ;				end
			8'h05: begin encoded_data[15:0] = 16'b11010 ;				end
			8'h06: begin encoded_data[15:0] = 16'b1111000 ;			end
			8'h07: begin encoded_data[15:0] = 16'b11111000 ;			end
			8'h08: begin encoded_data[15:0] = 16'b1111110110 ;			end
			8'h09: begin encoded_data[15:0] = 16'b1111111110000010 ;	end
			8'h0A: begin encoded_data[15:0] = 16'b1111111110000011 ;	end
			8'h11: begin encoded_data[15:0] = 16'b1100 ;				end
			8'h12: begin encoded_data[15:0] = 16'b11011 ;				end
			8'h13: begin encoded_data[15:0] = 16'b1111001 ;			end
			8'h14: begin encoded_data[15:0] = 16'b111110110 ;			end
			8'h15: begin encoded_data[15:0] = 16'b11111110110 ;		end
			8'h16: begin encoded_data[15:0] = 16'b1111111110000100 ;	end
			8'h17: begin encoded_data[15:0] = 16'b1111111110000101 ;	end
			8'h18: begin encoded_data[15:0] = 16'b1111111110000110 ;	end
			8'h19: begin encoded_data[15:0] = 16'b1111111110000111 ;	end
			8'h1A: begin encoded_data[15:0] = 16'b1111111110001000 ;	end
			8'h21: begin encoded_data[15:0] = 16'b11100 ;				end
			8'h22: begin encoded_data[15:0] = 16'b11111001 ;			end
			8'h23: begin encoded_data[15:0] = 16'b1111110111 ;			end
			8'h24: begin encoded_data[15:0] = 16'b111111110100 ;		end
			8'h25: begin encoded_data[15:0] = 16'b1111111110001001 ;	end
			8'h26: begin encoded_data[15:0] = 16'b1111111110001010 ;	end
			8'h27: begin encoded_data[15:0] = 16'b1111111110001011 ;	end
			8'h28: begin encoded_data[15:0] = 16'b1111111110001100 ;	end
			8'h29: begin encoded_data[15:0] = 16'b1111111110001101 ;	end
			8'h2A: begin encoded_data[15:0] = 16'b1111111110001110 ;	end
			8'h31: begin encoded_data[15:0] = 16'b111010 ;				end
			8'h32: begin encoded_data[15:0] = 16'b111110111 ;			end
			8'h33: begin encoded_data[15:0] = 16'b111111110101 ;		end
			8'h34: begin encoded_data[15:0] = 16'b1111111110001111 ;	end
			8'h35: begin encoded_data[15:0] = 16'b1111111110010000 ;	end
			8'h36: begin encoded_data[15:0] = 16'b1111111110010001 ;	end
			8'h37: begin encoded_data[15:0] = 16'b1111111110010010 ;	end
			8'h38: begin encoded_data[15:0] = 16'b1111111110010011 ;	end
			8'h39: begin encoded_data[15:0] = 16'b1111111110010100 ;	end
			8'h3A: begin encoded_data[15:0] = 16'b1111111110010101 ;	end

			8'h41: begin encoded_data[15:0] = 16'b111011 ;				end
			8'h42: begin encoded_data[15:0] = 16'b1111111000 ;			end
			8'h43: begin encoded_data[15:0] = 16'b1111111110010110 ;	end
			8'h44: begin encoded_data[15:0] = 16'b1111111110010111 ;	end
			8'h45: begin encoded_data[15:0] = 16'b1111111110011000 ;	end
			8'h46: begin encoded_data[15:0] = 16'b1111111110011001 ;	end
			8'h47: begin encoded_data[15:0] = 16'b1111111110011010 ;	end
			8'h48: begin encoded_data[15:0] = 16'b1111111110011011 ;	end
			8'h49: begin encoded_data[15:0] = 16'b1111111110011100 ;	end
			8'h4A: begin encoded_data[15:0] = 16'b1111111110011101 ;	end
			8'h51: begin encoded_data[15:0] = 16'b1111010 ;			end
			8'h52: begin encoded_data[15:0] = 16'b11111110111 ;		end
			8'h53: begin encoded_data[15:0] = 16'b1111111110011110 ;	end
			8'h54: begin encoded_data[15:0] = 16'b1111111110011111 ;	end
			8'h55: begin encoded_data[15:0] = 16'b1111111110100000 ;	end
			8'h56: begin encoded_data[15:0] = 16'b1111111110100001 ;	end
			8'h57: begin encoded_data[15:0] = 16'b1111111110100010 ;	end
			8'h58: begin encoded_data[15:0] = 16'b1111111110100011 ;	end
			8'h59: begin encoded_data[15:0] = 16'b1111111110100100 ;	end
			8'h5A: begin encoded_data[15:0] = 16'b1111111110100101 ;	end
			8'h61: begin encoded_data[15:0] = 16'b1111011 ;			end
			8'h62: begin encoded_data[15:0] = 16'b111111110110 ;		end
			8'h63: begin encoded_data[15:0] = 16'b1111111110100110 ;	end
			8'h64: begin encoded_data[15:0] = 16'b1111111110100111 ;	end
			8'h65: begin encoded_data[15:0] = 16'b1111111110101000 ;	end
			8'h66: begin encoded_data[15:0] = 16'b1111111110101001 ;	end
			8'h67: begin encoded_data[15:0] = 16'b1111111110101010 ;	end
			8'h68: begin encoded_data[15:0] = 16'b1111111110101011 ;	end
			8'h69: begin encoded_data[15:0] = 16'b1111111110101100 ;	end
			8'h6A: begin encoded_data[15:0] = 16'b1111111110101101 ;	end
			8'h71: begin encoded_data[15:0] = 16'b11111010 ;			end
			8'h72: begin encoded_data[15:0] = 16'b111111110111 ;		end
			8'h73: begin encoded_data[15:0] = 16'b1111111110101110 ;	end
			8'h74: begin encoded_data[15:0] = 16'b1111111110101111 ;	end
			8'h75: begin encoded_data[15:0] = 16'b1111111110110000 ;	end
			8'h76: begin encoded_data[15:0] = 16'b1111111110110001 ;	end
			8'h77: begin encoded_data[15:0] = 16'b1111111110110010 ;	end
			8'h78: begin encoded_data[15:0] = 16'b1111111110110011 ;	end
			8'h79: begin encoded_data[15:0] = 16'b1111111110110100 ;	end
			8'h7A: begin encoded_data[15:0] = 16'b1111111110110101 ;	end
			8'h81: begin encoded_data[15:0] = 16'b111111000 ;			end
			8'h82: begin encoded_data[15:0] = 16'b111111111000000 ;	end

			8'h83: begin encoded_data[15:0] = 16'b1111111110110110 ;	end
			8'h84: begin encoded_data[15:0] = 16'b1111111110110111 ;	end
			8'h85: begin encoded_data[15:0] = 16'b1111111110111000 ;	end
			8'h86: begin encoded_data[15:0] = 16'b1111111110111001 ;	end
			8'h87: begin encoded_data[15:0] = 16'b1111111110111010 ;	end
			8'h88: begin encoded_data[15:0] = 16'b1111111110111011 ;	end
			8'h89: begin encoded_data[15:0] = 16'b1111111110111100 ;	end
			8'h8A: begin encoded_data[15:0] = 16'b1111111110111101 ;	end
			8'h91: begin encoded_data[15:0] = 16'b111111001 ;			end
			8'h92: begin encoded_data[15:0] = 16'b1111111110111110 ;	end
			8'h93: begin encoded_data[15:0] = 16'b1111111110111111 ;	end
			8'h94: begin encoded_data[15:0] = 16'b1111111111000000 ;	end
			8'h95: begin encoded_data[15:0] = 16'b1111111111000001 ;	end
			8'h96: begin encoded_data[15:0] = 16'b1111111111000010 ;	end
			8'h97: begin encoded_data[15:0] = 16'b1111111111000011 ;	end
			8'h98: begin encoded_data[15:0] = 16'b1111111111000100 ;	end
			8'h99: begin encoded_data[15:0] = 16'b1111111111000101 ;	end
			8'h9A: begin encoded_data[15:0] = 16'b1111111111000110 ;	end
			8'hA1: begin encoded_data[15:0] = 16'b111111010 ;			end
			8'hA2: begin encoded_data[15:0] = 16'b1111111111000111 ;	end
			8'hA3: begin encoded_data[15:0] = 16'b1111111111001000 ;	end
			8'hA4: begin encoded_data[15:0] = 16'b1111111111001001 ;	end
			8'hA5: begin encoded_data[15:0] = 16'b1111111111001010 ;	end
			8'hA6: begin encoded_data[15:0] = 16'b1111111111001011 ;	end
			8'hA7: begin encoded_data[15:0] = 16'b1111111111001100 ;	end
			8'hA8: begin encoded_data[15:0] = 16'b1111111111001101 ;	end
			8'hA9: begin encoded_data[15:0] = 16'b1111111111001110 ;	end
			8'hAA: begin encoded_data[15:0] = 16'b1111111111001111 ;	end
			8'hB1: begin encoded_data[15:0] = 16'b1111111001 ;			end
			8'hB2: begin encoded_data[15:0] = 16'b1111111111010000 ;	end
			8'hB3: begin encoded_data[15:0] = 16'b1111111111010001 ;	end
			8'hB4: begin encoded_data[15:0] = 16'b1111111111010010 ;	end
			8'hB5: begin encoded_data[15:0] = 16'b1111111111010011 ;	end
			8'hB6: begin encoded_data[15:0] = 16'b1111111111010100 ;	end
			8'hB7: begin encoded_data[15:0] = 16'b1111111111010101 ;	end
			8'hB8: begin encoded_data[15:0] = 16'b1111111111010110 ;	end
			8'hB9: begin encoded_data[15:0] = 16'b1111111111010111 ;	end
			8'hBA: begin encoded_data[15:0] = 16'b1111111111011000 ;	end
			8'hC1: begin encoded_data[15:0] = 16'b1111111010 ;			end
			8'hC2: begin encoded_data[15:0] = 16'b1111111111011001 ;	end
			8'hC3: begin encoded_data[15:0] = 16'b1111111111011010 ;	end
			8'hC4: begin encoded_data[15:0] = 16'b1111111111011011 ;	end
	 	
			8'hC5: begin encoded_data[15:0] = 16'b1111111111011100 ;	end
			8'hC6: begin encoded_data[15:0] = 16'b1111111111011101 ;	end
			8'hC7: begin encoded_data[15:0] = 16'b1111111111011110 ;	end
			8'hC8: begin encoded_data[15:0] = 16'b1111111111011111 ;	end
			8'hC9: begin encoded_data[15:0] = 16'b1111111111100000 ;	end
			8'hCA: begin encoded_data[15:0] = 16'b1111111111100001 ;	end
			8'hD1: begin encoded_data[15:0] = 16'b11111111000 ;		end
			8'hD2: begin encoded_data[15:0] = 16'b1111111111100010 ;	end
			8'hD3: begin encoded_data[15:0] = 16'b1111111111100011 ;	end
			8'hD4: begin encoded_data[15:0] = 16'b1111111111100100 ;	end
			8'hD5: begin encoded_data[15:0] = 16'b1111111111100101 ;	end
			8'hD6: begin encoded_data[15:0] = 16'b1111111111100110 ;	end
			8'hD7: begin encoded_data[15:0] = 16'b1111111111100111 ;	end
			8'hD8: begin encoded_data[15:0] = 16'b1111111111101000 ;	end
			8'hD9: begin encoded_data[15:0] = 16'b1111111111101001 ;	end
			8'hDA: begin encoded_data[15:0] = 16'b1111111111101010 ;	end
			8'hE1: begin encoded_data[15:0] = 16'b1111111111101011 ;	end
			8'hE2: begin encoded_data[15:0] = 16'b1111111111101100 ;	end
			8'hE3: begin encoded_data[15:0] = 16'b1111111111101101 ;	end
			8'hE4: begin encoded_data[15:0] = 16'b1111111111101110 ;	end
			8'hE5: begin encoded_data[15:0] = 16'b1111111111101111 ;	end
			8'hE6: begin encoded_data[15:0] = 16'b1111111111110000 ;	end
			8'hE7: begin encoded_data[15:0] = 16'b1111111111110001 ;	end
			8'hE8: begin encoded_data[15:0] = 16'b1111111111110010 ;	end
			8'hE9: begin encoded_data[15:0] = 16'b1111111111110011 ;	end
			8'hEA: begin encoded_data[15:0] = 16'b1111111111110100 ;	end
			8'hF0: begin encoded_data[15:0] = 16'b11111111001 ;		end
			8'hF1: begin encoded_data[15:0] = 16'b1111111111110101 ;	end
			8'hF2: begin encoded_data[15:0] = 16'b1111111111110110 ;	end
			8'hF3: begin encoded_data[15:0] = 16'b1111111111110111 ;	end
			8'hF4: begin encoded_data[15:0] = 16'b1111111111111000 ;	end
			8'hF5: begin encoded_data[15:0] = 16'b1111111111111001 ;	end
			8'hF6: begin encoded_data[15:0] = 16'b1111111111111010 ;	end
			8'hF7: begin encoded_data[15:0] = 16'b1111111111111011 ;	end
			8'hF8: begin encoded_data[15:0] = 16'b1111111111111100 ;	end
			8'hF9: begin encoded_data[15:0] = 16'b1111111111111101 ;	end
			8'hFA: begin encoded_data[15:0] = 16'b1111111111111110 ;	end
			default: begin encoded_data[15:0] = 16'b1010 ;				end
		endcase
	end // if(component_type == 1)
	else begin // for chrominance component
		case(rs)
			8'h00: begin encoded_data[15:0] = 16'b00 ;				end
			8'h01: begin encoded_data[15:0] = 16'b01 ;				end
			8'h02: begin encoded_data[15:0] = 16'b100 ;				end
			8'h03: begin encoded_data[15:0] = 16'b1010 ;			end
			8'h04: begin encoded_data[15:0] = 16'b11000 ;			end
			8'h05: begin encoded_data[15:0] = 16'b11001 ;			end
			8'h06: begin encoded_data[15:0] = 16'b111000 ;			end
			8'h07: begin encoded_data[15:0] = 16'b1111000 ;			end
			8'h08: begin encoded_data[15:0] = 16'b111110100 ;		end
			8'h09: begin encoded_data[15:0] = 16'b1111110110 ;		end
			8'h0A: begin encoded_data[15:0] = 16'b111111110100 ;	end
			8'h11: begin encoded_data[15:0] = 16'b1011 ;			end
			8'h12: begin encoded_data[15:0] = 16'b111001 ;			end
			8'h13: begin encoded_data[15:0] = 16'b11110110 ;		end
			8'h14: begin encoded_data[15:0] = 16'b111110101 ;		end
			8'h15: begin encoded_data[15:0] = 16'b11111110110 ;		end
			8'h16: begin encoded_data[15:0] = 16'b111111110101 ;	end
			8'h17: begin encoded_data[15:0] = 16'b1111111110001000 ;end
			8'h18: begin encoded_data[15:0] = 16'b1111111110001001 ;end
			8'h19: begin encoded_data[15:0] = 16'b1111111110001010 ;end
			8'h1A: begin encoded_data[15:0] = 16'b1111111110001011 ;end
			8'h21: begin encoded_data[15:0] = 16'b11010 ;			end
			8'h22: begin encoded_data[15:0] = 16'b11110111 ;		end
			8'h23: begin encoded_data[15:0] = 16'b1111110111 ;		end
			8'h24: begin encoded_data[15:0] = 16'b111111110110 ;	end
			8'h25: begin encoded_data[15:0] = 16'b111111111000010 ;	end
			8'h26: begin encoded_data[15:0] = 16'b1111111110001100 ;end
			8'h27: begin encoded_data[15:0] = 16'b1111111110001101 ;end
			8'h28: begin encoded_data[15:0] = 16'b1111111110001110 ;end
			8'h29: begin encoded_data[15:0] = 16'b1111111110001111 ;end
			8'h2A: begin encoded_data[15:0] = 16'b1111111110010000 ;end
			8'h31: begin encoded_data[15:0] = 16'b11011 ;			end
			8'h32: begin encoded_data[15:0] = 16'b11111000 ;		end
			8'h33: begin encoded_data[15:0] = 16'b1111111000 ;		end
			8'h34: begin encoded_data[15:0] = 16'b111111110111 ;	end
			8'h35: begin encoded_data[15:0] = 16'b1111111110010001 ;end
			8'h36: begin encoded_data[15:0] = 16'b1111111110010010 ;end
			8'h37: begin encoded_data[15:0] = 16'b1111111110010011 ;end
			8'h38: begin encoded_data[15:0] = 16'b1111111110010100 ;end
			8'h39: begin encoded_data[15:0] = 16'b1111111110010101 ;end
			8'h3A: begin encoded_data[15:0] = 16'b1111111110010110 ;end
			8'h41: begin encoded_data[15:0] = 16'b111010 ;			end
			8'h42: begin encoded_data[15:0] = 16'b111110110 ;		end
			8'h43: begin encoded_data[15:0] = 16'b1111111110010111 ;end
			8'h44: begin encoded_data[15:0] = 16'b1111111110011000 ;end
			8'h45: begin encoded_data[15:0] = 16'b1111111110011001 ;end
			8'h46: begin encoded_data[15:0] = 16'b1111111110011010 ;end
			8'h47: begin encoded_data[15:0] = 16'b1111111110011011 ;end
			8'h48: begin encoded_data[15:0] = 16'b1111111110011100 ;end
			8'h49: begin encoded_data[15:0] = 16'b1111111110011101 ;end
			8'h4A: begin encoded_data[15:0] = 16'b1111111110011110 ;end
			8'h51: begin encoded_data[15:0] = 16'b111011 ;			end
			8'h52: begin encoded_data[15:0] = 16'b1111111001 ;		end
			8'h53: begin encoded_data[15:0] = 16'b1111111110011111 ;end
			8'h54: begin encoded_data[15:0] = 16'b1111111110100000 ;end
			8'h55: begin encoded_data[15:0] = 16'b1111111110100001 ;end
			8'h56: begin encoded_data[15:0] = 16'b1111111110100010 ;end
			8'h57: begin encoded_data[15:0] = 16'b1111111110100011 ;end
			8'h58: begin encoded_data[15:0] = 16'b1111111110100100 ;end
			8'h59: begin encoded_data[15:0] = 16'b1111111110100101 ;end
			8'h5A: begin encoded_data[15:0] = 16'b1111111110100110 ;end
			8'h61: begin encoded_data[15:0] = 16'b1111001 ;			end
			8'h62: begin encoded_data[15:0] = 16'b11111110111 ;		end
			8'h63: begin encoded_data[15:0] = 16'b1111111110100111 ;end
			8'h64: begin encoded_data[15:0] = 16'b1111111110101000 ;end
			8'h65: begin encoded_data[15:0] = 16'b1111111110101001 ;end
			8'h66: begin encoded_data[15:0] = 16'b1111111110101010 ;end
			8'h67: begin encoded_data[15:0] = 16'b1111111110101011 ;end
			8'h68: begin encoded_data[15:0] = 16'b1111111110101100 ;end
			8'h69: begin encoded_data[15:0] = 16'b1111111110101101 ;end
			8'h6A: begin encoded_data[15:0] = 16'b1111111110101110 ;end
			8'h71: begin encoded_data[15:0] = 16'b1111010 ;			end
			8'h72: begin encoded_data[15:0] = 16'b11111111000 ;		end
			8'h73: begin encoded_data[15:0] = 16'b1111111110101111 ;end
			8'h74: begin encoded_data[15:0] = 16'b1111111110110000 ;end
			8'h75: begin encoded_data[15:0] = 16'b1111111110110001 ;end
			8'h76: begin encoded_data[15:0] = 16'b1111111110110010 ;end
			8'h77: begin encoded_data[15:0] = 16'b1111111110110011 ;end
			8'h78: begin encoded_data[15:0] = 16'b1111111110110100 ;end
			8'h79: begin encoded_data[15:0] = 16'b1111111110110101 ;end
			8'h7A: begin encoded_data[15:0] = 16'b1111111110110110 ;end
			8'h81: begin encoded_data[15:0] = 16'b11111001 ;		end
			8'h82: begin encoded_data[15:0] = 16'b1111111110110111 ;end
			8'h83: begin encoded_data[15:0] = 16'b1111111110111000 ;end
			8'h84: begin encoded_data[15:0] = 16'b1111111110111001 ;end
			8'h85: begin encoded_data[15:0] = 16'b1111111110111010 ;end
			8'h86: begin encoded_data[15:0] = 16'b1111111110111011 ;end
			8'h87: begin encoded_data[15:0] = 16'b1111111110111100 ;end
			8'h88: begin encoded_data[15:0] = 16'b1111111110111101 ;end
			8'h89: begin encoded_data[15:0] = 16'b1111111110111110 ;end
			8'h8A: begin encoded_data[15:0] = 16'b1111111110111111 ;		end
			8'h91: begin encoded_data[15:0] = 16'b111110111 ;		end
			8'h92: begin encoded_data[15:0] = 16'b1111111111000000 ;end
			8'h93: begin encoded_data[15:0] = 16'b1111111111000001 ;end
			8'h94: begin encoded_data[15:0] = 16'b1111111111000010 ;end
			8'h95: begin encoded_data[15:0] = 16'b1111111111000011 ;end
			8'h96: begin encoded_data[15:0] = 16'b1111111111000100 ;end
			8'h97: begin encoded_data[15:0] = 16'b1111111111000101 ;end
			8'h98: begin encoded_data[15:0] = 16'b1111111111000110 ;end
			8'h99: begin encoded_data[15:0] = 16'b1111111111000111 ;end
			8'h9A: begin encoded_data[15:0] = 16'b1111111111001000 ;		end
			8'hA1: begin encoded_data[15:0] = 16'b111111000 ;		end
			8'hA2: begin encoded_data[15:0] = 16'b1111111111001001 ;		end
			8'hA3: begin encoded_data[15:0] = 16'b1111111111001010 ;		end
			8'hA4: begin encoded_data[15:0] = 16'b1111111111001011 ;		end
			8'hA5: begin encoded_data[15:0] = 16'b1111111111001100 ;		end
			8'hA6: begin encoded_data[15:0] = 16'b1111111111001101 ;		end
			8'hA7: begin encoded_data[15:0] = 16'b1111111111001110 ;		end
			8'hA8: begin encoded_data[15:0] = 16'b1111111111001111 ;		end
			8'hA9: begin encoded_data[15:0] = 16'b1111111111010000 ;		end
			8'hAA: begin encoded_data[15:0] = 16'b1111111111010001 ;		end
			8'hB1: begin encoded_data[15:0] = 16'b111111001 ;		end
			8'hB2: begin encoded_data[15:0] = 16'b1111111111010010 ;		end
			8'hB3: begin encoded_data[15:0] = 16'b1111111111010011 ;		end
			8'hB4: begin encoded_data[15:0] = 16'b1111111111010100 ;		end
			8'hB5: begin encoded_data[15:0] = 16'b1111111111010101 ;		end
			8'hB6: begin encoded_data[15:0] = 16'b1111111111010110 ;		end
			8'hB7: begin encoded_data[15:0] = 16'b1111111111010111 ;		end
			8'hB8: begin encoded_data[15:0] = 16'b1111111111011000 ;		end
			8'hB9: begin encoded_data[15:0] = 16'b1111111111011001 ;		end
			8'hBA: begin encoded_data[15:0] = 16'b1111111111011010 ;		end
			8'hC1: begin encoded_data[15:0] = 16'b111111010 ;				end
			8'hC2: begin encoded_data[15:0] = 16'b1111111111011011 ;		end
			8'hC3: begin encoded_data[15:0] = 16'b1111111111011100 ;		end
			8'hC4: begin encoded_data[15:0] = 16'b1111111111011101 ;		end
			8'hC5: begin encoded_data[15:0] = 16'b1111111111011110 ;		end
			8'hC6: begin encoded_data[15:0] = 16'b1111111111011111 ;		end
			8'hC7: begin encoded_data[15:0] = 16'b1111111111100000 ;		end
			8'hC8: begin encoded_data[15:0] = 16'b1111111111100001 ;		end
			8'hC9: begin encoded_data[15:0] = 16'b1111111111100010 ;		end
			8'hCA: begin encoded_data[15:0] = 16'b1111111111100011 ;		end
			8'hD1: begin encoded_data[15:0] = 16'b11111111001 ;				end
			8'hD2: begin encoded_data[15:0] = 16'b1111111111100100 ;		end
			8'hD3: begin encoded_data[15:0] = 16'b1111111111100101 ;		end
			8'hD4: begin encoded_data[15:0] = 16'b1111111111100110 ;		end
			8'hD5: begin encoded_data[15:0] = 16'b1111111111100111 ;		end
			8'hD6: begin encoded_data[15:0] = 16'b1111111111101000 ;		end
			8'hD7: begin encoded_data[15:0] = 16'b1111111111101001 ;		end
			8'hD8: begin encoded_data[15:0] = 16'b1111111111101010 ;		end
			8'hD9: begin encoded_data[15:0] = 16'b1111111111101011 ;		end
			8'hDA: begin encoded_data[15:0] = 16'b1111111111101100 ;		end
			8'hE1: begin encoded_data[15:0] = 16'b11111111100000 ;			end
			8'hE2: begin encoded_data[15:0] = 16'b1111111111101101 ;		end
			8'hE3: begin encoded_data[15:0] = 16'b1111111111101110 ;		end
			8'hE4: begin encoded_data[15:0] = 16'b1111111111101111 ;		end
			8'hE5: begin encoded_data[15:0] = 16'b1111111111110000 ;		end
			8'hE6: begin encoded_data[15:0] = 16'b1111111111110001 ;		end
			8'hE7: begin encoded_data[15:0] = 16'b1111111111110010 ;		end
			8'hE8: begin encoded_data[15:0] = 16'b1111111111110011 ;		end
			8'hE9: begin encoded_data[15:0] = 16'b1111111111110100 ;		end
			8'hEA: begin encoded_data[15:0] = 16'b1111111111110101 ;		end
			8'hF0: begin encoded_data[15:0] = 16'b1111111010 ;				end
			8'hF1: begin encoded_data[15:0] = 16'b111111111000011 ;			end
			8'hF2: begin encoded_data[15:0] = 16'b1111111111110110 ;		end
			8'hF3: begin encoded_data[15:0] = 16'b1111111111110111 ;		end
			8'hF4: begin encoded_data[15:0] = 16'b1111111111111000 ;		end
			8'hF5: begin encoded_data[15:0] = 16'b1111111111111001 ;		end
			8'hF6: begin encoded_data[15:0] = 16'b1111111111111010 ;		end
			8'hF7: begin encoded_data[15:0] = 16'b1111111111111011 ;		end
			8'hF8: begin encoded_data[15:0] = 16'b1111111111111100 ;		end
			8'hF9: begin encoded_data[15:0] = 16'b1111111111111101 ;		end
			8'hFA: begin encoded_data[15:0] = 16'b1111111111111110 ;		end
			default: begin encoded_data[15:0] = 16'b00 ;					end
		endcase
	end

	encoded_data <<= SSSS;

	case(SSSS)
		01: begin encoded_data[0]   = (zz_data_k < 0)?(0):(1) ; end
		02: begin encoded_data[1:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		03: begin encoded_data[2:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		04: begin encoded_data[3:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		05: begin encoded_data[4:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		06: begin encoded_data[5:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		07: begin encoded_data[6:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		08: begin encoded_data[7:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		09: begin encoded_data[8:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
		10: begin encoded_data[9:0] = (zz_data_k < 0)?(zz_data_k-1):(zz_data_k) ; end
	endcase

	case(component_type)
		1:	y_encoded.push_back(encoded_data);
		2:	cb_encoded.push_back(encoded_data);
		3:	cr_encoded.push_back(encoded_data);
	endcase

	//
	// if(my_checker >= 20 && my_checker <= 35 && component_type== 3) $display("****%h",encoded_data);
	//

endfunction : encode_ac



`endif