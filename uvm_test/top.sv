module top;

`include "uvm_macros.svh"
import	uvm_pkg::*;
import pkg_uvm_test::*;

if_dut	bfm ();
m_dut	top_dut (bfm);

initial begin
	uvm_config_db #(virtual if_dut)::set(null, "*", "bfm", bfm);
	run_test("c_random_test");
end // initial

endmodule // top