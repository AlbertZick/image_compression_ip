`ifndef PKG_UVM_TEST
`define PKG_UVM_TEST

package pkg_uvm_test ;


`include "uvm_macros.svh"
import uvm_pkg::*;

typedef class c_basic_item;
typedef class c_random_item;
typedef class c_scoreboard;
typedef class c_sequence;

// `include "if_dut.sv"

`include "c_basic_item.svh"
`include "c_random_item.svh"
`include "c_random_item_lib.svh"
`include "c_result_transaction.svh"
`include "c_rounding_transaction.svh"
`include "c_transformation_transaction.svh"
`include "c_fdct_transaction.svh"
`include "c_quantization_transaction.svh"

`include "c_driver.svh"
`include "c_sequencer.svh"

`include "c_stimulus_monitor.svh"
`include "c_result_monitor.svh"
`include "c_rounding_monitor.svh"
`include "c_transformation_monitor.svh"
`include "c_fdct_monitor.svh"
`include "c_quantization_monitor.svh"

`include "c_reference_model.svh"

`include "c_stimulus_agent.svh"

`include "c_scoreboard.svh"

`include "c_env.svh"

`include "c_sequence.svh"
`include "c_base_test.svh"
`include "c_random_test.svh"

endpackage : pkg_uvm_test

`endif