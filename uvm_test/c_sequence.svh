`ifndef C_SEQUENCE
`define C_SEQUENCE

class c_sequence extends uvm_sequence #(c_random_item);

c_random_item item;

`uvm_object_utils(c_sequence)

function new(string name="c_sequence");
	super.new(name);
endfunction : new

task body();
int num_sequence;
if (!$value$plusargs("num_sequence=%0d", num_sequence))
	num_sequence = 10;			// the number of sequences will be 10 by default
	repeat(num_sequence) begin
		item = c_random_item::type_id::create("item");
		start_item(item);
			// if(item.randomize());
			// else 
			// 	$display("Randomization failed"); 
		finish_item(item);
	end
endtask : body

endclass : c_sequence

`endif

