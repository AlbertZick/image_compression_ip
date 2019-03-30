`ifndef C_BASIC_ITEM
`define C_BASIC_ITEM

typedef enum {LOW_FREQ, MEDIUM_FREQ, HIGH_FREQ, RANDOM} test_area;

class c_basic_item extends uvm_sequence_item;

rand	byte	unsigned 	red_value[64];
rand	byte	unsigned 	blue_value[64];
rand	byte	unsigned 	green_value[64];
rand	test_area			test_kind;

`uvm_object_utils(c_basic_item)

// function new ();
// 	foreach(red_value[i]) begin
// 		red_value[i] = 0;
// 		blue_value[i] = 0;
// 		green_value[i] = 0;
// 	end
// endfunction : new 

function new ();
	foreach(red_value[i]) begin
		red_value[i] = 1;
		blue_value[i] = 1;
		green_value[i] = 1;
	end
	red_value[36] = 63;
endfunction : new 

endclass : c_basic_item

`endif