`ifndef C_FDCT_TRANSACTION
`define C_FDCT_TRANSACTION

class c_fdct_transaction extends uvm_transaction;

shortreal	fdct_y[64];
shortreal	fdct_cb[64];
shortreal	fdct_cr[64];

`uvm_object_utils(c_fdct_transaction)

extern function void do_copy (uvm_object rhs);
extern function bit compare_y_func (c_fdct_transaction rhs);
extern function bit compare_cb_func (c_fdct_transaction rhs);
extern function bit compare_cr_func (c_fdct_transaction rhs);

endclass : c_fdct_transaction

///////////////////////////////////////////////////////////////////////
function void c_fdct_transaction::do_copy (uvm_object rhs);
c_fdct_transaction	rhs_;

if(!$cast(rhs_,rhs)) begin
	uvm_report_error("do_copy:", "Cast failed");
	return;
end

super.do_copy(rhs);

foreach(this.fdct_y[i]) begin
	this.fdct_y[i] 	= rhs_.fdct_y[i];
	this.fdct_cb[i] = rhs_.fdct_cb[i];
	this.fdct_cr[i] = rhs_.fdct_cr[i];
end

endfunction : do_copy

//
function bit c_fdct_transaction::compare_y_func (c_fdct_transaction rhs);

compare_y_func = 1;
foreach(this.fdct_y[i]) begin
	if((this.fdct_y[i] - rhs.fdct_y[i] > 0.1) || (this.fdct_y[i] - rhs.fdct_y[i] < -0.1)) begin
		compare_y_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.fdct_y[i], rhs.fdct_y[i]);
	end
end

endfunction : compare_y_func
//
function bit c_fdct_transaction::compare_cb_func (c_fdct_transaction rhs);

compare_cb_func = 1;
foreach(this.fdct_cb[i]) begin
	if((this.fdct_cb[i] - rhs.fdct_cb[i] > 0.1) || (this.fdct_cb[i] - rhs.fdct_cb[i] < -0.1)) begin
		compare_cb_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.fdct_cb[i], rhs.fdct_cb[i]);
	end
end

endfunction : compare_cb_func

//
function bit c_fdct_transaction::compare_cr_func (c_fdct_transaction rhs);

compare_cr_func = 1;
foreach(this.fdct_cr[i]) begin
	if((this.fdct_cr[i] - rhs.fdct_cr[i] > 0.1) || (this.fdct_cr[i] - rhs.fdct_cr[i] < -0.1)) begin
		compare_cr_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.fdct_cr[i], rhs.fdct_cr[i]);
	end
end

endfunction : compare_cr_func


`endif