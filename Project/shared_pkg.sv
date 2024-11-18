package shared_pkg;
	parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
	bit test_finished = 0;
	int error_count = 0;
	int correct_count = 0;
	int iteration = 0;
endpackage : shared_pkg