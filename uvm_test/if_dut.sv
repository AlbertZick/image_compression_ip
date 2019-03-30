interface if_dut ();
parameter setup_time = 2;
parameter hold_time = 1;

// parameter p_clk_0 = 40;
// parameter p_clk_1 = 10;


bit clk_0, clk_1;

//dut inputs
logic[7:0]	R_in, G_in, B_in;
logic		rst;

//outputs of dut
logic[25:0]		encoded_y, encoded_cb, encoded_cr ;
logic[4:0]		encoded_y_bits, encoded_cb_bits, encoded_cr_bits ;
logic			sync_y, sync_cb, sync_cr;

//for transformation monitor
logic signed [8:0]	Y_int, Cb_int, Cr_int;
logic				dct_2_D_rst;

//for fdct monitor
bit[31:0]			dct_2D_Y_float, dct_2D_Cb_float ,dct_2D_Cr_float;


//wires in Rounding block
logic	[31:0]			quantized_Y, quantized_Cb, quantized_Cr;
logic	signed [10:0]	rounded_Y_int, rounded_Cb_int, rounded_Cr_int;

logic			start_encoder;


bit 			done_driving;

bit	[7:0]		counter;
bit 			start_rounding;


clocking clock_0 @ (posedge clk_0);
default input #setup_time output #hold_time;

input	rst;

endclocking


modport if_small_ip (clocking clock_0,
					output encoded_y, encoded_cb, encoded_cr, 
					encoded_y_bits, encoded_cb_bits, encoded_cr_bits,
					sync_y, sync_cb, sync_cr,
					R_in, G_in, B_in,
					clk_0, clk_1, rst
					);


initial begin
	clk_0 = 0;
	clk_1 = 1;
	fork
		forever begin
			#60; clk_0++; 
		end
		forever begin
			#10; clk_1++;
		end
		begin
			rst = 1;
			#120;
			rst = 0;
		end
		forever begin
			@(posedge clk_0 iff (rst == 0)) begin
				counter++;
			end
			if(counter == 8'd84) start_rounding = 1;
		end
	join_none
end





endinterface



//84 clock moi lay rounding


