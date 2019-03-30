`ifndef C_TRANSFORMATION_MONITOR
`define C_TRANSFORMATION_MONITOR

class c_transformation_monitor extends uvm_monitor;

virtual 	if_dut bfm;
uvm_analysis_port	#(c_transformation_transaction)	transformation_port;

`uvm_component_utils (c_transformation_monitor)

function new(string name = "c_transformation_monitor", uvm_component parent);
	super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : c_transformation_monitor

////////////////////////////////////////////////////////////////////////////////////////////

function void c_transformation_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
	transformation_port = new("transformation_port", this);
endfunction : build_phase

//
task c_transformation_monitor::run_phase(uvm_phase phase);
c_transformation_transaction 	item;
bit[5:0]						counter;

item = new ();
counter = 0;

forever begin
	@(posedge bfm.clk_0) begin
		if(bfm.dct_2_D_rst == 0) begin
			item.transformed_y[counter] 	= int' (bfm.Y_int);
			item.transformed_cb[counter] 	= int' (bfm.Cb_int);
			item.transformed_cr[counter] 	= int' (bfm.Cr_int);
			if(counter == 63) begin
				transformation_port.write(item);
				// $display("transport the transaction to the RM\n%p\n%p\n%p",item.transformed_y, 
				// 															item.transformed_cb,
				// 															item.transformed_cr);
			end
			counter++;
		end
		
	end
end
endtask : run_phase

`endif