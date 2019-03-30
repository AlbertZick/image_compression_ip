`ifndef C_RANDOM_TEST
`define C_RANDOM_TEST

class c_random_test extends c_base_test;
`uvm_component_utils(c_random_test)

function new (string name="c_random_test", uvm_component parent);
	super.new(name, parent);
endfunction : new

task run_phase(uvm_phase phase);
	c_sequence	my_sequence;

	my_sequence = new ("my_sequence");
	phase.raise_objection(this);
	my_sequence.start(env.stimulus_agent.sequencer);
	// phase.drop_objection(this);

endtask : run_phase

endclass : c_random_test

`endif
/////////////////////////////////////////////////////////////////
