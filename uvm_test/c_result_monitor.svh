`ifndef C_RESULT_MONITOR
`define C_RESULT_MONITOR

class c_result_monitor extends uvm_monitor;

virtual if_dut bfm;
uvm_analysis_port	#(c_y_result_transaction)	y_result_port;
uvm_analysis_port	#(c_cb_result_transaction)	cb_result_port;
uvm_analysis_port	#(c_cr_result_transaction)	cr_result_port;

`uvm_component_utils (c_result_monitor)

function new(string name = "c_result_monitor", uvm_component parent);
	super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : c_result_monitor


//////////////////////////////////////////////////////////////////////////////////////////

function void c_result_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
	y_result_port = new("y_result_port", this);
	cb_result_port = new("cb_result_port", this);
	cr_result_port = new("cr_result_port", this);
endfunction : build_phase

task c_result_monitor::run_phase(uvm_phase phase);
c_y_result_transaction y_item;
c_cb_result_transaction cb_item;
c_cr_result_transaction cr_item;
y_item = new();
cb_item = new();
cr_item = new();
// fork
	forever begin
		@(posedge bfm.clk_1) begin
			fork
				begin
					if(bfm.sync_y == 1) begin
						y_item.encoded_y = bfm.encoded_y;
						y_item.encoded_y_bits = bfm.encoded_y_bits;
						y_result_port.write(y_item);
					end
				end
				begin
					if(bfm.sync_cb == 1) begin
						cb_item.encoded_cb = bfm.encoded_cb;
						cb_item.encoded_cb_bits = bfm.encoded_cb_bits;
						cb_result_port.write(cb_item);
					end
				end
				begin
					if(bfm.sync_cr == 1) begin
						cr_item.encoded_cr = bfm.encoded_cr;
						cr_item.encoded_cr_bits = bfm.encoded_cr_bits;
						cr_result_port.write(cr_item);
					end
				end
			join_none
		end
	end
// join_none
endtask : run_phase


`endif