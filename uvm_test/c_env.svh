`ifndef C_ENV
`define C_ENV

class c_env extends uvm_env;

c_stimulus_agent	stimulus_agent;

c_reference_model	reference_model;
c_scoreboard		scoreboard;
c_result_monitor	result_monitor;
c_rounding_result_monitor	rounding_result_monitor;

c_transformation_monitor 	transformation_monitor;
c_fdct_monitor				fdct_monitor;
c_quantization_monitor 		quantization_monitor;

`uvm_component_utils(c_env)

function new (string name = "c_env", uvm_component parent);
	super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	stimulus_agent 			= c_stimulus_agent::type_id::create("stimulus_agent", this);
	scoreboard 				= c_scoreboard::type_id::create("scoreboard", this);
	reference_model 		= c_reference_model::type_id::create("reference_model",this);
	result_monitor 			= c_result_monitor::type_id::create("result_monitor",this);
	rounding_result_monitor = c_rounding_result_monitor::type_id::create("rounding_result_monitor", this);

	transformation_monitor 	= c_transformation_monitor::type_id::create("transformation_monitor", this);
	fdct_monitor 			= c_fdct_monitor::type_id::create("fdct_monitor", this);
	quantization_monitor 	= c_quantization_monitor::type_id::create("quantization_monitor", this);

endfunction : build_phase

function void connect_phase(uvm_phase phase);
	stimulus_agent.stimulus_port.connect(reference_model.analysis_export);
	
	reference_model.y_reference_port.connect(scoreboard.reference_port_0);
	reference_model.cb_reference_port.connect(scoreboard.reference_port_1);
	reference_model.cr_reference_port.connect(scoreboard.reference_port_2);

	result_monitor.y_result_port.connect(scoreboard.result_port_3);
	result_monitor.cb_result_port.connect(scoreboard.result_port_4);
	result_monitor.cr_result_port.connect(scoreboard.result_port_5);

	rounding_result_monitor.rounding_result_port.connect(reference_model.result_rounding_port);

	transformation_monitor.transformation_port.connect(reference_model.transformation_port);
	fdct_monitor.fdct_port.connect(reference_model.fdct_port);

	transformation_monitor.transformation_port.connect(scoreboard.rl_transformation_port);
	fdct_monitor.fdct_port.connect(scoreboard.rl_fdct_port);
	quantization_monitor.quantization_port.connect(scoreboard.rl_quantization_port);

	reference_model.prdct_transformation_port.connect(scoreboard.prdct_transformation_port);
	reference_model.prdct_fdct_port.connect(scoreboard.prdct_fdct_port);
	reference_model.prdct_quantization_port.connect(scoreboard.prdct_quantization_port);

endfunction : connect_phase

endclass : c_env

`endif