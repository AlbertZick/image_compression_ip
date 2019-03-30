`ifndef C_STIMULUS_AGENT
`define C_STIMULUS_AGENT

class c_stimulus_agent extends uvm_component;

virtual if_dut		bfm;
c_driver			driver;
c_stimulus_monitor	stimulus_monitor;
c_sequencer			sequencer;
// c_coverage			coverage;

uvm_analysis_port #(c_basic_item) stimulus_port;

`uvm_component_utils(c_stimulus_agent)

//
function new (string name="stimulus_agent", uvm_component parent);
	super.new(name, parent);
endfunction : new

//
extern function void build_phase(uvm_phase phase);

//
function void connect_phase(uvm_phase phase);
	driver.seq_item_port.connect(sequencer.seq_item_export);
	stimulus_monitor.stimulus_port.connect(this.stimulus_port);
endfunction : connect_phase


endclass : c_stimulus_agent

`endif

////////////////////////////////////////////////////////////
function void c_stimulus_agent::build_phase(uvm_phase phase);

	if(!uvm_config_db #(virtual if_dut)::get(this, "", "bfm", bfm))
		`uvm_fatal("My fatal","AGENT could not get the interface");

	driver = c_driver::type_id::create("driver", this);
	stimulus_monitor = c_stimulus_monitor::type_id::create("stimulus_monitor", this);
	sequencer = c_sequencer::type_id::create("sequencer", this);
	// coverage = 
	stimulus_port = new ("stimulus_port", this);

endfunction : build_phase