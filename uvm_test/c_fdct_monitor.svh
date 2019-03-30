`ifndef C_FDCT_MONITOR
`define C_FDCT_MONITOR

class c_fdct_monitor extends uvm_monitor;


virtual 	if_dut 	bfm;
uvm_analysis_port	#(c_fdct_transaction)	fdct_port;

`uvm_component_utils (c_fdct_monitor)


function new(string name = "c_fdct_monitor", uvm_component parent);
	super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : c_fdct_monitor



//////////////////////////////////////////////////////////////////////////////////////////

function void c_fdct_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
	fdct_port = new("fdct_port", this);
endfunction : build_phase

//
task c_fdct_monitor::run_phase(uvm_phase phase);
c_fdct_transaction item;
bit[5:0] counter;

item = new();
counter = 0;

	forever begin
		@(posedge bfm.clk_0 iff bfm.start_encoder == 1) begin
			item.fdct_y[counter] =  $bitstoshortreal(bfm.dct_2D_Y_float);
			item.fdct_cb[counter] = $bitstoshortreal(bfm.dct_2D_Cb_float);
			item.fdct_cr[counter] = $bitstoshortreal(bfm.dct_2D_Cr_float);

			// $display("\n========fdct h1");
			// foreach(item.fdct_y[i]) begin
			// 	$write("%F, ", item.fdct_y[i]);
			// end

			counter++;
			if(counter == 0) begin
				fdct_port.write(item);

				// $display("\n========fdct h2");
				// foreach(item.fdct_y[i]) begin
				// 	$write("%F, ", item.fdct_y[i]);
				// end
			end
		end
	end
endtask : run_phase

`endif