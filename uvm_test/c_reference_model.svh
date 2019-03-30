`ifndef C_REFERENCE_MODEL
`define C_REFERENCE_MODEL

`include "c_predictor.svh"


`uvm_analysis_imp_decl (_rounding_port)
`uvm_analysis_imp_decl (_transformation_port)
`uvm_analysis_imp_decl (_fdct_port)



class c_reference_model extends uvm_subscriber #(c_basic_item);

c_predictor						predictor;

c_basic_item					item;
c_fdct_transaction				fdct_transaction;
c_y_result_transaction			y_result_transaction;
c_cb_result_transaction			cb_result_transaction;
c_cr_result_transaction			cr_result_transaction;




uvm_analysis_port #(c_transformation_transaction)	prdct_transformation_port;
uvm_analysis_port #(c_fdct_transaction)				prdct_fdct_port;
uvm_analysis_port #(c_quantization_transaction)		prdct_quantization_port;

uvm_analysis_port #(c_y_result_transaction) 		y_reference_port;
uvm_analysis_port #(c_cb_result_transaction) 		cb_reference_port;
uvm_analysis_port #(c_cr_result_transaction) 		cr_reference_port;




uvm_analysis_imp_rounding_port 		#(c_rounding_transaction, c_reference_model) 	result_rounding_port;
uvm_analysis_imp_transformation_port #(c_transformation_transaction, c_reference_model) transformation_port;
uvm_analysis_imp_fdct_port 			#(c_fdct_transaction, c_reference_model)		fdct_port;



int y_rounding[64], cb_rounding[64], cr_rounding[64];
int in_rounding_counter;

`uvm_component_utils(c_reference_model)



extern function new(string name = "c_reference_model", uvm_component parent);

extern function void build_phase(uvm_phase phase);

// finish
extern function void write_rounding_port (input c_rounding_transaction t);

// compute fdct
extern function void write_transformation_port (input c_transformation_transaction t);

//
extern function void write_fdct_port (input c_fdct_transaction t);

//
extern function void write(c_basic_item t);


endclass : c_reference_model






///////////////////////////////////////////////////////////////////////////


function c_reference_model::new(string name = "c_reference_model", uvm_component parent);
	super.new(name, parent);
	predictor = new();
	item					= new();
	y_result_transaction 	= new();
	cb_result_transaction 	= new();
	cr_result_transaction 	= new();

	in_rounding_counter = 0;
endfunction : new

function void c_reference_model::build_phase(uvm_phase phase);
	super.build_phase(phase);
	y_reference_port 		= new ("y_reference_port", this);
	cb_reference_port 		= new ("cb_reference_port", this);
	cr_reference_port 		= new ("cr_reference_port", this);

	prdct_transformation_port	= new ("prdct_transformation_port", this);
	prdct_fdct_port				= new ("prdct_fdct_port", this);
	prdct_quantization_port		= new ("prdct_quantization_port", this);

	result_rounding_port 	= new ("result_rounding_port", this);
	transformation_port  	= new("transformation_port", this);
	fdct_port 				= new("fdct_port", this);


endfunction : build_phase

//
function void c_reference_model::write_transformation_port (input c_transformation_transaction t);
automatic c_fdct_transaction	fdct_transaction;
automatic shortreal y[64], cb[64], cr[64];

fdct_transaction = new();

foreach(y[i]) begin
	y[i] 	= shortreal' (t.transformed_y[i]);
	cb[i] 	= shortreal' (t.transformed_cb[i]);
	cr[i] 	= shortreal' (t.transformed_cr[i]);
end



predictor.fdct(fdct_transaction.fdct_y, y);
predictor.fdct(fdct_transaction.fdct_cb, cb);
predictor.fdct(fdct_transaction.fdct_cr, cr);



//transpose matrix
predictor.transpose_mtx(fdct_transaction.fdct_y);
predictor.transpose_mtx(fdct_transaction.fdct_cb);
predictor.transpose_mtx(fdct_transaction.fdct_cr);

// $display("\ntransformed_y:\n%p", fdct_transaction.fdct_y);

prdct_fdct_port.write(fdct_transaction);

endfunction : write_transformation_port




function void c_reference_model::write_fdct_port (input c_fdct_transaction t);
automatic c_quantization_transaction	quantization_transaction;
automatic c_fdct_transaction item;
automatic int temp[64];

item = new ();
item.do_copy(t);

quantization_transaction = new();

//transpose matrix
predictor.transpose_mtx(item.fdct_y);
predictor.transpose_mtx(item.fdct_cb);
predictor.transpose_mtx(item.fdct_cr);

predictor.quantization(item.fdct_y, 1);
predictor.quantization(item.fdct_cb, 2);
predictor.quantization(item.fdct_cr, 3);

predictor.rounding(quantization_transaction.quantized_y, item.fdct_y);
predictor.rounding(quantization_transaction.quantized_cb, item.fdct_cb);
predictor.rounding(quantization_transaction.quantized_cr, item.fdct_cr);

for(int row = 0; row < 8; row++) begin
	for (int col = 0; col < 8; col++) begin
		temp[predictor.index(row,col)] = quantization_transaction.quantized_y[predictor.index(col,row)];
	end
end

foreach(temp[i]) begin
	quantization_transaction.quantized_y[i] = temp[i];
end

for(int row = 0; row < 8; row++) begin
	for (int col = 0; col < 8; col++) begin
		temp[predictor.index(row,col)] = quantization_transaction.quantized_cb[predictor.index(col,row)];
	end
end

foreach(temp[i]) begin
	quantization_transaction.quantized_cb[i] = temp[i];
end

for(int row = 0; row < 8; row++) begin
	for (int col = 0; col < 8; col++) begin
		temp[predictor.index(row,col)] = quantization_transaction.quantized_cr[predictor.index(col,row)];
	end
end

foreach(temp[i]) begin
	quantization_transaction.quantized_cr[i] = temp[i];
end

prdct_quantization_port.write(quantization_transaction);

endfunction : write_fdct_port

//
function automatic void c_reference_model::write_rounding_port (input c_rounding_transaction t);

automatic int	zz_scan[64];

y_rounding[in_rounding_counter]  = t.y_rounding;
cb_rounding[in_rounding_counter] = t.cb_rounding;
cr_rounding[in_rounding_counter] = t.cr_rounding;
in_rounding_counter++;

if(in_rounding_counter == 64) begin
	in_rounding_counter = 0;

	predictor.erase_data();

	// predict y encoding
	predictor.zigzag_scan(zz_scan, y_rounding);

	// $display("==y==zz_scan\n%p",zz_scan);

	predictor.encoding(zz_scan, 1);
	foreach(predictor.y_encoded[i]) begin
		y_result_transaction.encoded_y = predictor.y_encoded[i];
		y_reference_port.write(y_result_transaction);
	end

	// predict cb encoding
	predictor.zigzag_scan(zz_scan, cb_rounding);

	// $display("==cb==zz_scan\n%p",zz_scan);

	predictor.encoding(zz_scan, 2);
	foreach(predictor.cb_encoded[i]) begin
		cb_result_transaction.encoded_cb = predictor.cb_encoded[i];
		cb_reference_port.write(cb_result_transaction);
	end

	// predict cr encoding
	predictor.zigzag_scan(zz_scan, cr_rounding);
	predictor.encoding(zz_scan, 3);
	foreach(predictor.cr_encoded[i]) begin
		cr_result_transaction.encoded_cr = predictor.cr_encoded[i];
		cr_reference_port.write(cr_result_transaction);
	end

end

endfunction : write_rounding_port


//
//this func calculates the transformation data and sends to SB
function automatic void c_reference_model::write(c_basic_item t);
automatic shortreal		r_data[64], g_data[64], b_data[64], y[64], cb[64], cr[64];
c_transformation_transaction	transformation_transaction;
transformation_transaction = new();

//------------------------------------------------------------
foreach(r_data[i]) begin
	r_data[i] = shortreal' (t.red_value[i]) ;
	g_data[i] = shortreal' (t.green_value[i]) ;
	b_data[i] = shortreal' (t.blue_value[i]) ;
end

predictor.converting_RGB_into_YCbCr_and_sub_128(y, cb, cr,
												r_data, g_data, b_data) ;

predictor.rounding(transformation_transaction.transformed_y, y);
predictor.rounding(transformation_transaction.transformed_cb, cb);
predictor.rounding(transformation_transaction.transformed_cr, cr);

// $displayh("== rf\n%p", transformation_transaction.transformed_y);

prdct_transformation_port.write(transformation_transaction);

endfunction : write

`endif