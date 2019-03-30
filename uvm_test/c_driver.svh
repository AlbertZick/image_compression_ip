`ifndef C_DRIVER
`define C_DRIVER


class c_driver extends uvm_driver #(c_random_item);

virtual if_dut	bfm;
c_random_item	item;

`uvm_component_utils (c_driver)

function new(string name = "c_driver", uvm_component parent);
	super.new(name, parent);
endfunction : new

extern task drive_item(input c_random_item item);

extern function void build_phase(uvm_phase phase);

extern task run_phase(uvm_phase phase);

endclass : c_driver



///////////////////////////////////////////////////////////////////
task c_driver::drive_item(input c_random_item item);
int count = 0;
repeat(64) begin
	@(posedge bfm.clk_0 iff bfm.rst == 0) begin
		// if(~bfm.rst) begin
		bfm.R_in = item.red_value[count];
		bfm.B_in = item.blue_value[count];
		bfm.G_in = item.green_value[count];
		count++;
		bfm.done_driving = 1;
		//
		// $display("******driver******\n %d %x %x %x", count, bfm.R_in, bfm.G_in, bfm.B_in);
		//
		// end
	end
end
endtask : drive_item

//
function void c_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
endfunction : build_phase

//
task c_driver::run_phase(uvm_phase phase);
	forever begin
		seq_item_port.get_next_item(item);
		drive_item(item);
		seq_item_port.item_done();
	end
endtask : run_phase


`endif