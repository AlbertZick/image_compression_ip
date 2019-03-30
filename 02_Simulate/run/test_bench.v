`timescale 1ps/1ps
module test_bench ();
integer f_R, f_G, f_B, f_trans_r_Y, f_unquantized_Y, f_quantized_Y, f_dct_2D_Y;
integer	f_trans_r_Cb;
integer	f_trans_r_Cr;
real	temp_Y_0, temp_Y_1, temp_Y_2, temp_Y_3, temp_Y_4;
real    temp_Cb_0, temp_Cb_1, temp_Cb_2, temp_Cb_3, temp_Cb_4;
real    temp_Cr_0, temp_Cr_1, temp_Cr_2, temp_Cr_3, temp_Cr_4;
//----- declare wires and modules here -----

wire	[7:0]	R_out, G_out, B_out;
wire	[31:0]	trans_r_Y, unquantized_Y, quantized_Y, dct_2D_Y;
wire	[31:0]	trans_r_Cb, unquantized_Cb, quantized_Cb, dct_2D_Cb;
wire	[31:0]	trans_r_Cr, unquantized_Cr, quantized_Cr, dct_2D_Cr;


reg			clk, rst;
image_compression_ip	m	(R_out, G_out, B_out, rst, clk);


assign trans_r_Y[31:0] 		= m.r_dct_2D_Y_float[31:0];
assign unquantized_Y[31:0] 	= m.unquantized_Y[31:0];
assign quantized_Y[31:0] 	= m.rounded_Y_float[31:0];
assign dct_2D_Y[31:0] 		= m.dct_2D_Y_float[31:0];

assign trans_r_Cb[31:0] 	= m.r_dct_2D_Cb_float[31:0];

assign trans_r_Cr[31:0] 	= m.r_dct_2D_Cr_float[31:0];

always @(*) begin
	temp_Y_0 <= $bitstoreal({trans_r_Y[31]	 	, {trans_r_Y[30:23] 	+ 11'd896}	, trans_r_Y[22:0]		, 29'b0});
	temp_Y_1 <= $bitstoreal({unquantized_Y[31]	, {unquantized_Y[30:23] + 11'd896}	, unquantized_Y[22:0]	, 29'b0});
	temp_Y_2 <= $bitstoreal({quantized_Y[31]	, {quantized_Y[30:23] 	+ 11'd896}	, quantized_Y[22:0]		, 29'b0});
	temp_Y_3 <= $bitstoreal({dct_2D_Y[31]		, {dct_2D_Y[30:23] 		+ 11'd896}	, dct_2D_Y[22:0]		, 29'b0});

	temp_Cb_0 <= $bitstoreal({trans_r_Cb[31]	, {trans_r_Cb[30:23] 	+ 11'd896}	, trans_r_Cb[22:0]		, 29'b0});

	temp_Cr_0 <= $bitstoreal({trans_r_Cr[31]	, {trans_r_Cr[30:23] 	+ 11'd896}	, trans_r_Cr[22:0]		, 29'b0});

end


//----------------------------------------//

always begin
clk = 1'b0; #1;
clk  = 1'b1; #1;
end

//----- to put output to monitor
/*initial begin
	$monitor("==========\n","********** INPUT **********\n", "rst: %b", rst,"\n","********** OUTPUT **********\n", "dct_2D_Y_float: %b", dct_2D_Y_float,"\n", "dct_2D_Cb_float: %b", dct_2D_Cb_float,"\n", "dct_2D_Cr_float: %b", dct_2D_Cr_float,"\n");

end*/


always @(posedge clk) begin
	$fwrite(f_R,"%d\n",R_out);
	$fwrite(f_G,"%d\n",G_out);
	$fwrite(f_B,"%d\n",B_out);
	$fwrite(f_trans_r_Y,	"%f\n"		, temp_Y_0);
	$fwrite(f_unquantized_Y,"%f\n"		, temp_Y_1);
	$fwrite(f_quantized_Y,	"%f\n"  	, temp_Y_2);
	$fwrite(f_dct_2D_Y,		"%f\n"		, temp_Y_3);

	$fwrite(f_trans_r_Cb,	"%f\n"		, temp_Cb_0);
	// $fwrite(f_unquantized_Cb,"%f\n"		, temp_Y_1);
	// $fwrite(f_quantized_Cb,	"%f\n"  	, temp_Y_2);
	// $fwrite(f_dct_2D_Cb,		"%f\n"	, temp_Y_3);

	$fwrite(f_trans_r_Cr,	"%f\n"		, temp_Cr_0);
	// $fwrite(f_unquantized_Y,"%f\n"		, temp_Y_1);
	// $fwrite(f_quantized_Y,	"%f\n"  	, temp_Y_2);
	// $fwrite(f_dct_2D_Y,		"%f\n"		, temp_Y_3);

end


initial begin
//$vcdplusfile("test.vpd");
//$vcdpluson;

f_R = $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/result_R.txt","w");
f_G = $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/result_G.txt","w");
f_B = $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/result_B.txt","w");
f_trans_r_Y 	= $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/trans_r_Y.txt","w");
f_trans_r_Cb 	= $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/trans_r_Cb.txt","w");
f_trans_r_Cr	= $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/trans_r_Cr.txt","w");

f_unquantized_Y = $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/unquantized_Y.txt","w");
f_quantized_Y 	= $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/quantized_Y.txt","w");
f_dct_2D_Y		= $fopen("/mnt/hgfs/A/Truong/project_term_172/05_Sim_Log/dct_2D_Y.txt","w");


rst = 1'b1;
#2; rst = 1'b0;

#109000;
$finish;
end
endmodule