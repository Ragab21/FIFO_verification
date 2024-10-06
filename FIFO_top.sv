module FIFO_top ();
	bit clk;
	always #1 clk = ~clk;
	FIFO_if V_if(clk);
	FIFO DUT(V_if);
	FIFO_tb tb(V_if);
	monitor_fifo mon(V_if);
endmodule