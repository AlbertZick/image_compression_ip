`ifndef C_STIMULUS_MONITOR
`define C_STIMULUS_MONITOR

class c_stimulus_monitor extends uvm_monitor;

virtual if_dut bfm;
uvm_analysis_port	#(c_basic_item)	stimulus_port;

`uvm_component_utils (c_stimulus_monitor)

function new(string name = "c_stimulus_monitor", uvm_component parent);
	super.new(name, parent);
endfunction

extern function void build_phase(uvm_phase phase);
extern virtual task run_phase(uvm_phase phase);

endclass : c_stimulus_monitor


//////////////////////////////////////////////////////////////////////////////////////////

function void c_stimulus_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual if_dut) :: get(this, "", "bfm", bfm))
		`uvm_fatal("Cannot connect if_dut", {"virtual interface should be set for: ", 
			get_full_name(), ".bfm"});
	stimulus_port = new("stimulus_port", this);
endfunction : build_phase

task c_stimulus_monitor::run_phase(uvm_phase phase);
c_basic_item item;
bit[5:0] 	count;
int			ending_counter;
event		ending;

item = new();
count = 0;
ending_counter = 0;

fork
	forever begin
		@(negedge  bfm.clk_0) begin
			if(bfm.clock_0.rst == 0) begin
				item.red_value[count] 	= bfm.R_in;
				item.green_value[count] = bfm.G_in;
				item.blue_value[count] 	= bfm.B_in;

				//--------------------------------------------------
				//checking the end of process
				if(count != 0) begin
					if(item.red_value[count-1] 	!= bfm.R_in || 
					item.green_value[count-1] != bfm.G_in || 
					item.blue_value[count-1] != bfm.B_in) begin
						-> ending;
					end
				end
				//--------------------------------------------------
				
				//carrying the item to the Scoreboard
				count++;
				if(count == 0) begin
					stimulus_port.write(item);
				end
			end
		end
	end

	//--------------------------------------------------
	// if the input ports do not have alternative values, 
	// the test will end in 65 follwing clocks.
	forever begin
		@(ending) begin
			ending_counter = 0;
		end
	end
	forever begin
		@(negedge  bfm.clk_0) begin
			ending_counter++;
			if(ending_counter == 65) begin
				phase.drop_objection(this);
			end
		end
	end
join_none
endtask : run_phase

`endif