`ifndef C_QUANTIZATION_MONITOR
`define C_QUANTIZATION_MONITOR

class c_quantization_monitor extends uvm_monitor;

virtual 	if_dut 	bfm;
uvm_analysis_port	#(c_quantization_transaction)	quantization_port;

`uvm_component_utils (c_quantization_monitor)

function new(string name = "c_quantization_monitor", uvm_component parent);
	super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : c_quantization_monitor

///////////////////////////////////////////////////////////////////////////////

function void c_quantization_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
	quantization_port = new("quantization_port", this);
endfunction : build_phase

//
task c_quantization_monitor::run_phase(uvm_phase phase);
c_quantization_transaction 	item;
bit[5:0] 					counter;
item = new();
counter = 0;

	forever begin
		@(posedge bfm.clk_0 iff bfm.start_encoder == 1) begin
			item.quantized_y[counter] 	= int' (bfm.rounded_Y_int);
			item.quantized_cb[counter] 	= int' (bfm.rounded_Cb_int);
			item.quantized_cr[counter] 	= int' (bfm.rounded_Cr_int);
			counter++;
			if(counter == 0) begin
				quantization_port.write(item);
				// $displayh("==qun moni\n%p",item.quantized_y);
			end
		end
	end
endtask : run_phase


`endif