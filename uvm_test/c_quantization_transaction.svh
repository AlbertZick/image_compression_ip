`ifndef C_QUANTIZATION_TRANSACTION
`define C_QUANTIZATION_TRANSACTION

class c_quantization_transaction extends uvm_transaction;

int quantized_y[64];
int quantized_cb[64];
int quantized_cr[64];

`uvm_object_utils(c_quantization_transaction)

extern function void do_copy (uvm_object rhs);
extern function bit compare_y_func (c_quantization_transaction rhs);
extern function bit compare_cb_func (c_quantization_transaction rhs);
extern function bit compare_cr_func (c_quantization_transaction rhs);

endclass : c_quantization_transaction

///////////////////////////////////////////////////////////////////////
function void c_quantization_transaction::do_copy (uvm_object rhs);
c_quantization_transaction	rhs_;

if(!$cast(rhs_,rhs)) begin
	uvm_report_error("do_copy:", "Cast failed");
	return;
end

super.do_copy(rhs);

foreach(this.quantized_y[i]) begin
	this.quantized_y[i]  = rhs_.quantized_y[i];
	this.quantized_cb[i] = rhs_.quantized_cb[i];
	this.quantized_cr[i] = rhs_.quantized_cr[i];
end

endfunction : do_copy

//
function bit c_quantization_transaction::compare_y_func (c_quantization_transaction rhs);

compare_y_func = 1;
foreach(this.quantized_y[i]) begin
	if((this.quantized_y[i] - rhs.quantized_y[i] < -1) || (this.quantized_y[i] - rhs.quantized_y[i] > 1)) begin
		compare_y_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.quantized_y[i], rhs.quantized_y[i]);
	end
end

endfunction : compare_y_func

//
function bit c_quantization_transaction::compare_cb_func (c_quantization_transaction rhs);

compare_cb_func = 1;
foreach(this.quantized_cb[i]) begin
	if((this.quantized_cb[i] - rhs.quantized_cb[i] < -1 ) || (this.quantized_cb[i] - rhs.quantized_cb[i] > 1)) begin
		compare_cb_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.quantized_cb[i], rhs.quantized_cb[i]);
	end
end

endfunction : compare_cb_func

//
function bit c_quantization_transaction::compare_cr_func (c_quantization_transaction rhs);

compare_cr_func = 1;
foreach(this.quantized_cr[i]) begin
	if((this.quantized_cr[i] - rhs.quantized_cr[i] < -1) || (this.quantized_cr[i] - rhs.quantized_cr[i] > 1)) begin
		compare_cr_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.quantized_cr[i], rhs.quantized_cr[i]);
	end
end

endfunction : compare_cr_func


`endif