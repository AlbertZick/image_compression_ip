`ifndef C_RANDOM_ITEM 
`define C_RANDOM_ITEM

class c_random_item extends c_basic_item;

`uvm_object_utils (c_random_item)
// 	`uvm_field_int ()
// `uvm_component_utils_end

constraint random_test_kind;
constraint random_value;
constraint solve_order;

// function new(int seed = 0);
// 	super.new(seed);
// endfunction : new

extern function int f_random_value;


endclass

// `include "c_random_item_lib.svh"

`endif
