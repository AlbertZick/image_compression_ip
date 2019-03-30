`ifndef C_RANDOM_ITEM_LIBS
`define C_RANDOM_ITEM_LIBS

//
constraint c_random_item::random_test_kind {
	test_kind dist {LOW_FREQ := 1, MEDIUM_FREQ := 1, HIGH_FREQ := 1, RANDOM := 1};
}

//
constraint c_random_item::random_value {
	f_random_value();
}

//
constraint c_random_item::solve_order {
	solve test_kind before red_value;
}

function automatic int c_random_item::f_random_value();
	case(test_kind)
		LOW_FREQ:	begin
			foreach(red_value[i]) begin
				if(i % 8 < 4) begin
					red_value[i] = $urandom_range(0, 127);
					blue_value[i] = $urandom_range(0, 127);
					green_value[i] = $urandom_range(0, 127);
				end
				else begin
					red_value[i] = $urandom_range(128, 255);
					blue_value[i] = $urandom_range(128, 255);
					green_value[i] = $urandom_range(128, 255);
				end
			end
		end
		MEDIUM_FREQ: begin
			foreach(red_value[i]) begin
				if(i % 4 < 2) begin
					red_value[i] = $urandom_range(0, 64);
					blue_value[i] = $urandom_range(0, 64);
					green_value[i] = $urandom_range(0, 64);
				end
				else begin
					red_value[i] = $urandom_range(191, 255);
					blue_value[i] = $urandom_range(191, 255);
					green_value[i] = $urandom_range(191, 255);
				end
			end
		end
		HIGH_FREQ: begin
			foreach(red_value[i]) begin
				if(i % 2 == 0) begin
					red_value[i] = $urandom_range(0, 32);
					blue_value[i] = $urandom_range(0, 32);
					green_value[i] = $urandom_range(0, 32);
				end
				else begin
					red_value[i] = $urandom_range(223, 255);
					blue_value[i] = $urandom_range(223, 255);
					green_value[i] = $urandom_range(223, 255);
				end
			end
		end
		RANDOM: begin
			foreach(red_value[i]) begin
				red_value[i] = $urandom_range(0, 255);
				blue_value[i] = $urandom_range(0, 255);
				green_value[i] = $urandom_range(0, 255);
			end
		end
	endcase
	return 1;
endfunction


`endif