`ifndef C_ROUNDING_RESULT_MONITOR
`define C_ROUNDING_RESULT_MONITOR

class c_rounding_result_monitor extends uvm_monitor;

virtual 	if_dut 	bfm;
uvm_analysis_port	#(c_rounding_transaction)	rounding_result_port;

`uvm_component_utils (c_rounding_result_monitor)

function new(string name = "c_rounding_result_monitor", uvm_component parent);
	super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : c_rounding_result_monitor



//////////////////////////////////////////////////////////////////////////////////////////

function void c_rounding_result_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
	rounding_result_port = new("rounding_result_monitor", this);
endfunction : build_phase

//
task c_rounding_result_monitor::run_phase(uvm_phase phase);
c_rounding_transaction item;
item = new();

	forever begin
		@(posedge bfm.clk_0 iff bfm.start_encoder == 1) begin
			item.y_rounding 	= int' (bfm.rounded_Y_int);
			item.cb_rounding 	= int' (bfm.rounded_Cb_int);
			item.cr_rounding 	= int' (bfm.rounded_Cr_int);

			rounding_result_port.write(item);
		end
	end
endtask : run_phase





`endif