`ifndef C_BASE_TEST
`define C_BASE_TEST

virtual class c_base_test extends uvm_test;

c_env	env;
// c_sequencer	sequencer;

function new (string name="c_base_test", uvm_component parent);
	super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	env = c_env::type_id::create("env", this);
endfunction : build_phase

// function void end_of_elaboration_phase(uvm_phase phase);
//     sequencer = env.sequencer ;
// endfunction : end_of_elaboration_phase


endclass : c_base_test

`endif