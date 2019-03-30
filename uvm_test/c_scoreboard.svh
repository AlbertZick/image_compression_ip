`ifndef C_SCOREBOARD
`define C_SCOREBOARD


`uvm_analysis_imp_decl (_port_0)
`uvm_analysis_imp_decl (_port_1)
`uvm_analysis_imp_decl (_port_2)

`uvm_analysis_imp_decl (_port_3)
`uvm_analysis_imp_decl (_port_4)
`uvm_analysis_imp_decl (_port_5)

`uvm_analysis_imp_decl (_encoded_y)

`uvm_analysis_imp_decl (_rl_transformation_port)
`uvm_analysis_imp_decl (_prdct_transformation_port)

`uvm_analysis_imp_decl (_rl_fdct_port)
`uvm_analysis_imp_decl (_prdct_fdct_port)

`uvm_analysis_imp_decl (_rl_quantization_port)
`uvm_analysis_imp_decl (_prdct_quantization_port)


class c_scoreboard extends uvm_component;
`uvm_component_utils(c_scoreboard)


uvm_analysis_imp_port_0 #(c_y_result_transaction, c_scoreboard) 	reference_port_0;
uvm_analysis_imp_port_1 #(c_cb_result_transaction, c_scoreboard) 	reference_port_1;
uvm_analysis_imp_port_2 #(c_cr_result_transaction, c_scoreboard) 	reference_port_2;

uvm_analysis_imp_port_3 #(c_y_result_transaction, c_scoreboard) 	result_port_3;
uvm_analysis_imp_port_4 #(c_cb_result_transaction, c_scoreboard) 	result_port_4;
uvm_analysis_imp_port_5 #(c_cr_result_transaction, c_scoreboard) 	result_port_5;

uvm_analysis_imp_rl_transformation_port		#(c_transformation_transaction, c_scoreboard)	rl_transformation_port;
uvm_analysis_imp_prdct_transformation_port	#(c_transformation_transaction, c_scoreboard)	prdct_transformation_port;
uvm_analysis_imp_rl_fdct_port				#(c_fdct_transaction, c_scoreboard)				rl_fdct_port;
uvm_analysis_imp_prdct_fdct_port			#(c_fdct_transaction, c_scoreboard)				prdct_fdct_port;
uvm_analysis_imp_rl_quantization_port		#(c_quantization_transaction, c_scoreboard)		rl_quantization_port;
uvm_analysis_imp_prdct_quantization_port	#(c_quantization_transaction, c_scoreboard)		prdct_quantization_port;


longint		y_counter, cb_counter, cr_counter;

c_y_result_transaction			rl_encoded_y_component[$], prdct_encoded_y_component[$];
c_cb_result_transaction			rl_encoded_cb_component[$], prdct_encoded_cb_component[$];
c_cr_result_transaction			rl_encoded_cr_component[$], prdct_encoded_cr_component[$];

c_transformation_transaction	rl_transformation[$], prdct_transformation[$];
c_fdct_transaction				rl_fdct[$], prdct_fdct[$];
c_quantization_transaction		rl_quantization[$], prdct_quantization[$];


//
extern function new(string name="c_scoreboard", uvm_component parent);

//
extern function void build_phase(uvm_phase phase);

// those functions are responsible for recieving encoding data predicted by reference_model.
extern function void write_port_0 (input c_y_result_transaction t);
extern function void write_port_1 (input c_cb_result_transaction t);
extern function void write_port_2 (input c_cr_result_transaction t);

// those functions are responsible for recieving real data encoded by dut.
extern function void write_port_3 (input c_y_result_transaction t);
extern function void write_port_4 (input c_cb_result_transaction t);
extern function void write_port_5 (input c_cr_result_transaction t);

// those functions are use for checking data encoded.
extern function void check_y_component_encoded();
extern function void check_cb_component_encoded();
extern function void check_cr_component_encoded();

extern task check_quantization();
extern task check_fdct();
extern task check_transformation();

extern function void write_rl_transformation_port(input c_transformation_transaction t);

extern function void write_prdct_transformation_port(input c_transformation_transaction t);

extern function void write_prdct_fdct_port (input c_fdct_transaction t);

extern function void write_rl_fdct_port (input c_fdct_transaction t);

extern function void write_prdct_quantization_port (input c_quantization_transaction t);

extern function void write_rl_quantization_port (input c_quantization_transaction t);

extern task run_phase(uvm_phase phase);

endclass : c_scoreboard

/////////////////////////////////////////////////////////////////////////////////////////
function c_scoreboard::new(string name = "c_scoreboard", uvm_component parent);
	super.new(name, parent);
	y_counter = 0; cb_counter = 0; cr_counter = 0;

endfunction : new

//
function void c_scoreboard::build_phase(uvm_phase phase);
	reference_port_0 = new ("reference_port_0", this);
	reference_port_1 = new ("reference_port_1", this);
	reference_port_2 = new ("reference_port_2", this);
	result_port_3 	= new ("result_port_3", this);
	result_port_4 	= new ("result_port_4", this);
	result_port_5 	= new ("result_port_5", this);

	rl_transformation_port 		= new ("rl_transformation_port", this);
	prdct_transformation_port 	= new ("prdct_transformation_port", this);
	rl_fdct_port 				= new ("rl_fdct_port", this);
	prdct_fdct_port 			= new ("prdct_fdct_port", this);
	rl_quantization_port 		= new ("rl_quantization_port", this);
	prdct_quantization_port 	= new ("prdct_quantization_port", this);

endfunction : build_phase

//
task c_scoreboard::run_phase(uvm_phase phase);

	fork
		forever begin
			#20;
			check_transformation();
		end
		forever begin
			#20;
			check_fdct();
		end
		forever begin
			#20;
			check_quantization();
		end
		forever begin
			#20;
			check_y_component_encoded();
		end
		forever begin
			#20;
			check_cb_component_encoded();
		end
		forever begin
			#20;
			check_cr_component_encoded();
		end
	join_none

endtask : run_phase

//recieving the y component data encoded prophetically and storing them in the encoded_y_prdt queue
function void c_scoreboard::write_port_0 (input c_y_result_transaction t);
	c_y_result_transaction	temp;
	$cast(temp, t.clone());
	prdct_encoded_y_component.push_back(temp);
endfunction : write_port_0

//recieving the cb component data encoded prophetically and storing them in the encoded_cb_prdt queue
function void c_scoreboard::write_port_1 (input c_cb_result_transaction t);
	c_cb_result_transaction	temp;
	$cast(temp, t.clone());
	prdct_encoded_cb_component.push_back(temp);
endfunction : write_port_1

//recieving the cr component data encoded prophetically and storing them in the encoded_cr_prdt queue
function void c_scoreboard::write_port_2 (input c_cr_result_transaction t);
	c_cr_result_transaction	temp;
	$cast(temp, t.clone());
	prdct_encoded_cr_component.push_back(temp);
endfunction : write_port_2

//recieving the real y component data encoded and comparing
function void c_scoreboard::write_port_3 (input c_y_result_transaction t);
	c_y_result_transaction	temp;
	$cast(temp, t.clone());
	rl_encoded_y_component.push_back(temp);

endfunction : write_port_3

//like function above but this is for cb component
function void c_scoreboard::write_port_4 (input c_cb_result_transaction t);
	c_cb_result_transaction	temp;
	$cast(temp, t.clone());
	rl_encoded_cb_component.push_back(temp);

endfunction : write_port_4

//like function above but this is for cr component
function void c_scoreboard::write_port_5 (input c_cr_result_transaction t);
	c_cr_result_transaction	temp;
	$cast(temp, t.clone());
	rl_encoded_cr_component.push_back(temp);

endfunction : write_port_5

//
function void c_scoreboard::write_rl_transformation_port(input c_transformation_transaction t);
	c_transformation_transaction temp;
	$cast(temp, t.clone());
	rl_transformation.push_back(temp);
endfunction : write_rl_transformation_port

//
function void c_scoreboard::write_prdct_transformation_port(input c_transformation_transaction t);
	c_transformation_transaction temp;
	$cast(temp, t.clone());
	prdct_transformation.push_back(temp);

endfunction : write_prdct_transformation_port

//
function void c_scoreboard::write_prdct_fdct_port (input c_fdct_transaction t);
	c_fdct_transaction temp;
	$cast(temp, t.clone());
	prdct_fdct.push_back(temp);
endfunction : write_prdct_fdct_port

//
function void c_scoreboard::write_rl_fdct_port (input c_fdct_transaction t);
	c_fdct_transaction temp;
	$cast(temp, t.clone());
	rl_fdct.push_back(temp);
endfunction : write_rl_fdct_port

function void c_scoreboard::write_prdct_quantization_port (input c_quantization_transaction t);
	c_quantization_transaction	temp;
	$cast(temp, t.clone());
	prdct_quantization.push_back(temp);
endfunction

//
function void c_scoreboard::write_rl_quantization_port (input c_quantization_transaction t);
c_quantization_transaction	temp;
$cast(temp, t.clone());
rl_quantization.push_back(temp);

endfunction

//////////////////////////////////////////////////////////////////////////////////
task c_scoreboard::check_transformation();
if((prdct_transformation.size() != 0) && (rl_transformation.size() != 0)) begin
	c_transformation_transaction rl, prdct;

	rl 		= rl_transformation.pop_front();
	prdct 	= prdct_transformation.pop_front();

	if(rl.compare_y_func(prdct)) begin
			`uvm_info("Report", "transform y rightly", UVM_LOW);
	end else begin
			`uvm_error("Error", "transform y wrongly");
		end
	if(rl.compare_cb_func(prdct)) begin
			`uvm_info("Report", "transform cb rightly", UVM_LOW);
	end else begin
			`uvm_error("Error", "transform cb wrongly");
		end
	if(rl.compare_cr_func(prdct)) begin
			`uvm_info("Report", "transform cr rightly", UVM_LOW);
	end else begin
			`uvm_error("Error", "transform cr wrongly");
	end

end
endtask : check_transformation

//
task c_scoreboard::check_quantization();
	if ((rl_quantization.size() != 0) && (prdct_quantization.size() != 0)) begin
		automatic c_quantization_transaction rl, prdct;

		prdct 	= prdct_quantization.pop_front();
		rl		= rl_quantization.pop_front();

		if(rl.compare_y_func(prdct)) begin
			`uvm_info("Report", "quantize y rightly", UVM_LOW);
		end else begin
			`uvm_error("Error", "quantize y wrongly");
		end
		if(rl.compare_cb_func(prdct)) begin
			`uvm_info("Report", "quantize cb rightly", UVM_LOW);
		end else begin
			`uvm_error("Error", "quantize cb wrongly");
		end
		if(rl.compare_cr_func(prdct)) begin
			`uvm_info("Report", "quantize cr rightly", UVM_LOW);
		end else begin
			`uvm_error("Error", "quantize cr wrongly");
		end
	end
endtask : check_quantization

//
task c_scoreboard::check_fdct();
if((prdct_fdct.size() != 0) && (rl_fdct.size() != 0)) begin
	automatic c_fdct_transaction 	prdct, rl;
	
	prdct 	= prdct_fdct.pop_front();
	rl		= rl_fdct.pop_front();

	if(rl.compare_y_func(prdct)) begin
		`uvm_info("Report", "fdct for y rightly", UVM_LOW);
	end else begin
		`uvm_error("Error", "fdct for y wrongly");
	end

	if(rl.compare_cb_func(prdct)) begin
		`uvm_info("Report", "fdct for cb rightly", UVM_LOW);
	end else begin
		`uvm_error("Error", "fdct for cb wrongly");
	end

	if(rl.compare_cr_func(prdct)) begin
		`uvm_info("Report", "fdct for cr rightly", UVM_LOW);
	end else begin
		`uvm_error("Error", "fdct for cr wrongly");
	end
end
endtask : check_fdct

//
function automatic void c_scoreboard::check_cr_component_encoded();
	if(rl_encoded_cr_component.size() != 0 && prdct_encoded_cr_component.size() != 0) begin
		automatic c_cr_result_transaction	prct, rl;

		rl = rl_encoded_cr_component.pop_front();
		prct = prdct_encoded_cr_component.pop_front();

		if(rl.compare_func(prct)) begin
			`uvm_info("Report", "Right :), cr component encoding", UVM_LOW);
			// $display("element: %d\npredicted : %h\nreal: %h", cr_counter, prct, rl);
		end
		else begin
			`uvm_error("Error", "Fail :(, cr component encoding");
			$display("element: %d\npredicted : %h\nreal: %h", cr_counter, prct, rl);
		end
		cr_counter++;
	end

endfunction : check_cr_component_encoded

//
function void c_scoreboard::check_cb_component_encoded();
	if(rl_encoded_cb_component.size() != 0 && prdct_encoded_cb_component.size() != 0) begin
		automatic c_cb_result_transaction prct, rl;

		rl 		= rl_encoded_cb_component.pop_front();
		prct 	= prdct_encoded_cb_component.pop_front();

		if(rl.compare_func(prct)) begin
			`uvm_info("Report", "Right :), cb component encoding", UVM_LOW);
			// $display("element: %d\npredicted : %h\nreal: %h", cb_counter, prct, rl);
		end
		else begin
			`uvm_error("Error", "Fail :(, cb component encoding");
			$display("element: %d\npredicted : %h\nreal: %h", cb_counter, prct, rl);
		end
		cb_counter++;
	end
endfunction : check_cb_component_encoded

//
function void c_scoreboard::check_y_component_encoded();
	if(rl_encoded_y_component.size() != 0 && prdct_encoded_y_component.size() != 0) begin
		automatic c_y_result_transaction	prct, rl;

		rl 		= rl_encoded_y_component.pop_front();
		prct 	= prdct_encoded_y_component.pop_front();

		if(rl.compare_func(prct)) begin
			`uvm_info("Report", "Right :), y component encoding", UVM_LOW);
			// $display("element: %d\npredicted : %h\nreal: %h", y_counter, prct, rl);
		end
		else begin
			`uvm_error("Error", "Fail :(, y component encoding");
			$display("element: %d\npredicted : %h\nreal: %h", y_counter, prct, rl);
		end
		y_counter++;
	end
endfunction : check_y_component_encoded




`endif