import shared_pkg::*;
interface FIFO_if (clk);
	logic [FIFO_WIDTH-1:0] data_in;
	input clk;
	bit rst_n, wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow,underflow;
	bit full, empty, almostfull, almostempty;
modport TEST (output data_in, rst_n, wr_en, rd_en, input clk, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
modport DUT (input data_in, rst_n, wr_en, rd_en, clk, output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
modport MONITOR (input clk, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);

endinterface : FIFO_if