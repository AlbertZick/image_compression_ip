`ifndef C_RESULT_TRANSACTION
`define C_RESULT_TRANSACTION

class c_y_result_transaction extends uvm_transaction;

bit[25:0]	encoded_y;
bit[4:0]	encoded_y_bits;

`uvm_object_utils(c_y_result_transaction)

extern function void do_copy(uvm_object rhs);
extern function bit  compare_func(c_y_result_transaction rhs);

endclass : c_y_result_transaction

//
function void c_y_result_transaction::do_copy(uvm_object rhs);
	c_y_result_transaction rhs_;
	if(!$cast(rhs_,rhs)) begin
		uvm_report_error("do_copy:", "Cast failed");
		return;
	end
	super.do_copy(rhs);

	this.encoded_y[25:0] 		= rhs_.encoded_y[25:0];
	this.encoded_y_bits[4:0] 	= rhs_.encoded_y_bits[4:0];

endfunction : do_copy

//
function bit  c_y_result_transaction::compare_func(c_y_result_transaction rhs);
	compare_func = 1;
	if(this.encoded_y[25:0] == rhs.encoded_y[25:0]/* && this.encoded_y_bits[4:0] == rhs.encoded_y_bits[4:0]*/);
	else begin
		compare_func = 0;
		$display("this: %h\nrhs: %h", this.encoded_y[25:0], rhs.encoded_y[25:0]);
	end
endfunction : compare_func

////////////////////////////////////////////////////////////
class c_cb_result_transaction extends uvm_transaction;

bit[25:0]	encoded_cb;
bit[4:0]	encoded_cb_bits;

`uvm_object_utils(c_cb_result_transaction)

extern function void do_copy(uvm_object rhs);
extern function bit	 compare_func(c_cb_result_transaction rhs);

endclass : c_cb_result_transaction

//
function void c_cb_result_transaction::do_copy(uvm_object rhs);
	c_cb_result_transaction rhs_;
	if(!$cast(rhs_,rhs)) begin
		uvm_report_error("do_copy:", "Cast failed");
		return;
	end
	super.do_copy(rhs);

	this.encoded_cb[25:0] 		= rhs_.encoded_cb[25:0];
	this.encoded_cb_bits[4:0] 	= rhs_.encoded_cb_bits[4:0];

endfunction : do_copy

//
function bit  c_cb_result_transaction::compare_func(c_cb_result_transaction rhs);
	compare_func = 1;
	if(this.encoded_cb[25:0] == rhs.encoded_cb[25:0]/* && this.encoded_y_bits[4:0] == rhs.encoded_y_bits[4:0]*/);
	else begin
		compare_func = 0;
		$display("this: %h\nrhs: %h", this.encoded_cb[25:0], rhs.encoded_cb[25:0]);
	end
endfunction : compare_func

////////////////////////////////////////////////////////////
class c_cr_result_transaction extends uvm_transaction;

bit[25:0]	encoded_cr;
bit[4:0]	encoded_cr_bits;

`uvm_object_utils(c_cr_result_transaction)

extern function void do_copy(uvm_object rhs);
extern function bit  compare_func(c_cr_result_transaction rhs);

endclass : c_cr_result_transaction

//
function void c_cr_result_transaction::do_copy(uvm_object rhs);
	c_cr_result_transaction rhs_;
	if(!$cast(rhs_,rhs)) begin
		uvm_report_error("do_copy:", "Cast failed");
		return;
	end
	super.do_copy(rhs);

	this.encoded_cr[25:0] 		= rhs_.encoded_cr[25:0];
	this.encoded_cr_bits[4:0] 	= rhs_.encoded_cr_bits[4:0];

endfunction : do_copy

//
function bit  c_cr_result_transaction::compare_func(c_cr_result_transaction rhs);
	compare_func = 1;
	if(this.encoded_cr[25:0] == rhs.encoded_cr[25:0]/* && this.encoded_y_bits[4:0] == rhs.encoded_y_bits[4:0]*/);
	else begin
		compare_func = 0;
		$display("this: %h\nrhs: %h", this.encoded_cr[25:0], rhs.encoded_cr[25:0]);
	end
endfunction : compare_func

`endif