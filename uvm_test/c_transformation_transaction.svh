`ifndef C_TRANSFORMATION_TRANSACTION
`define C_TRANSFORMATION_TRANSACTION

class c_transformation_transaction extends uvm_transaction;

int		transformed_y[64], transformed_cb[64], transformed_cr[64] ;

`uvm_object_utils(c_transformation_transaction)

extern function void do_copy(uvm_object rhs);
extern function bit compare_y_func(c_transformation_transaction rhs);
extern function bit compare_cb_func(c_transformation_transaction rhs);
extern function bit compare_cr_func(c_transformation_transaction rhs);

endclass : c_transformation_transaction

/////////////////////////////////////////////////////////////////////////////
function void c_transformation_transaction::do_copy(uvm_object rhs);
	c_transformation_transaction rhs_;
	if(!$cast(rhs_,rhs)) begin
		uvm_report_error("do_copy:", "Cast failed");
		return;
	end
	super.do_copy(rhs);

	foreach(this.transformed_y[i]) begin
		this.transformed_y[i] = rhs_.transformed_y[i];
		this.transformed_cb[i] = rhs_.transformed_cb[i];
		this.transformed_cr[i] = rhs_.transformed_cr[i];
	end

endfunction : do_copy

//
function bit c_transformation_transaction::compare_y_func(c_transformation_transaction rhs);

compare_y_func = 1;
foreach(this.transformed_y[i]) begin
	if((this.transformed_y[i] - rhs.transformed_y[i] > 1) || (this.transformed_y[i] - rhs.transformed_y[i] < -1)) begin
		compare_y_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.transformed_y[i], rhs.transformed_y[i]);
	end
end

endfunction : compare_y_func

//
function bit c_transformation_transaction::compare_cb_func(c_transformation_transaction rhs);

compare_cb_func = 1;
foreach(this.transformed_cb[i]) begin
	if((this.transformed_cb[i] - rhs.transformed_cb[i] > 1) || (this.transformed_cb[i] - rhs.transformed_cb[i] < -1)) begin
		compare_cb_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.transformed_cb[i], rhs.transformed_cb[i]);
	end
end

endfunction : compare_cb_func

//
function bit c_transformation_transaction::compare_cr_func(c_transformation_transaction rhs);

compare_cr_func = 1;
foreach(this.transformed_cr[i]) begin
	if((this.transformed_cr[i] - rhs.transformed_cr[i] > 1) || (this.transformed_cr[i] - rhs.transformed_cr[i] < -1)) begin
		compare_cr_func &=0;
		$display("element: %h\nthis: %h\nrhs: %h", i, this.transformed_cr[i], rhs.transformed_cr[i]);
	end
end

endfunction : compare_cr_func


`endif