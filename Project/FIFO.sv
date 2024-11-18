////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
module FIFO(FIFO_if.DUT V_if);

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge V_if.clk or negedge V_if.rst_n) begin
	if (!V_if.rst_n) begin
		wr_ptr <= 0;
		//reset is not complete
		V_if.wr_ack <=0;
		V_if.overflow <= 0;
	end
	else if (V_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= V_if.data_in;
		V_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		V_if.wr_ack <= 0; 
		if (V_if.full & V_if.wr_en)
			V_if.overflow <= 1;
		else
			V_if.overflow <= 0;
	end
end

always @(posedge V_if.clk or negedge V_if.rst_n) begin
	if (!V_if.rst_n) begin
		rd_ptr <= 0;
		//underflow reset
		V_if.underflow <= 0;
	end
	else if (V_if.rd_en && count != 0) begin
		V_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	//handling the underflow signal
	else begin
		if (V_if.empty & V_if.rd_en)
			V_if.underflow <= 1;
		else
			V_if.underflow <= 0;
	end
end

always @(posedge V_if.clk or negedge V_if.rst_n) begin
	if (!V_if.rst_n) begin
		count <= 0;
	end
	else begin
		case ({V_if.wr_en,V_if.rd_en})
			2'b00 : begin 
				V_if.data_out <= V_if.data_out;
			end
			2'b01 : begin
				if(!V_if.empty)
					count <= count - 1;
			end
			2'b10 : begin
				if(!V_if.full)
					count <= count + 1;
			end
			2'b11 : begin
				if(V_if.full)
					count <= count - 1;
				else if(V_if.empty)
					count <= count + 1;
				else
					count <= count;
			end
		endcase
		// if	( ({V_if.wr_en, V_if.rd_en} == 2'b10) && !V_if.full) 
		// 	count <= count + 1;
		// else if ( ({V_if.wr_en, V_if.rd_en} == 2'b01) && !V_if.empty)
		// 	count <= count - 1;
	end
end

assign V_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign V_if.empty = (count == 0)? 1 : 0;
// assign V_if.underflow = (count == 0 && V_if.rd_en)? 1 : 0;
assign V_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign V_if.almostempty = (count == 1)? 1 : 0;


always_comb begin
    if(!V_if.rst_n)
        a_reset: assert final(V_if.full == 0 && V_if.empty == 1 && V_if.almostfull == 0 && V_if.almostempty == 0 &&
        							 V_if.overflow == 0 && V_if.underflow == 0 && count == 0 && V_if.wr_ack == 0);
end

property reset_reg;
	@(posedge V_if.clk) (V_if.rst_n == 0) |=> ( V_if.overflow == 0 && V_if.underflow == 0 && count == 0 && V_if.wr_ack == 0);
endproperty

property full_prop;
	@(posedge V_if.clk) disable iff(!V_if.rst_n) (count == FIFO_DEPTH) |-> (V_if.full == 1); 
endproperty

property almostfull_prop;
	@(posedge V_if.clk) disable iff(!V_if.rst_n) (count == FIFO_DEPTH-1) |-> (V_if.almostfull == 1); 
endproperty

property empty_prop;
	@(posedge V_if.clk) (count == 0) |-> (V_if.empty == 1); 
endproperty

property almostempty_prop;
	@(posedge V_if.clk) disable iff(!V_if.rst_n) (count == 1) |-> (V_if.almostempty == 1); 
endproperty

property overflow_prop;
	@(posedge V_if.clk) disable iff(!V_if.rst_n) ((count == FIFO_DEPTH) && V_if.wr_en == 1) |=> (V_if.overflow == 1);
endproperty

property underflow_prop;
	@(posedge V_if.clk) disable iff(!V_if.rst_n) ((count == 0) && V_if.rd_en == 1) |=> (V_if.underflow == 1);
endproperty

property wr_ack_prop;
	@(posedge V_if.clk) disable iff(!V_if.rst_n) (V_if.wr_en && (count < FIFO_DEPTH)) |=> (V_if.wr_ack== 1);
endproperty


assert property(reset_reg); cover property(reset_reg);
assert property(full_prop); cover property(full_prop);
assert property(almostfull_prop); cover property(almostfull_prop);
assert property(empty_prop); cover property(empty_prop);
assert property(almostempty_prop); cover property(almostempty_prop);
assert property(overflow_prop); cover property(overflow_prop);
assert property(underflow_prop); cover property(underflow_prop);
assert property(wr_ack_prop); cover property(wr_ack_prop);
 

endmodule