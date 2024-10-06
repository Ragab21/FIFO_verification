import shared_pkg::*;
import FIFO_Transaction_pkg::*;
module FIFO_tb(FIFO_if.TEST V_if);

  FIFO_transaction trans = new();
int i = 0;
  initial begin
    V_if.rst_n = 1;
    @(negedge V_if.clk); #0;
    V_if.rst_n = 0;
    @(negedge V_if.clk); #0;
    V_if.rst_n = 1;
    @(negedge V_if.clk); #0;
    V_if.wr_en = 1;
    V_if.data_in = 6;
    V_if.rd_en = 1;
    @(negedge V_if.clk); #0;
    V_if.rd_en = 0;
    for(int i = 0;i<10;i++)begin
      V_if.wr_en = 1;
      V_if.data_in = i;
      @(negedge V_if.clk); #0;
    end
    V_if.wr_en = 0;
    @(negedge V_if.clk); #0;
    V_if.wr_en = 1;
    V_if.rd_en = 1;
    @(negedge V_if.clk); #0;
    for(int i = 10;i<22;i++)begin
      V_if.rd_en = 1;
      V_if.data_in = i;
      @(negedge V_if.clk); #0;
    end
    V_if.wr_en = 0;
    V_if.rd_en = 0;
    @(negedge V_if.clk); #0;
    V_if.wr_en = 1;
    V_if.rd_en = 1;
    @(negedge V_if.clk); #0;
    for(int i = 0;i<32768;i++) begin
    assert(trans.randomize());
        V_if.rst_n  = trans.rst_n;
        V_if.wr_en = trans.wr_en;
        V_if.rd_en     = trans.rd_en;
        V_if.data_in = trans.data_in;
        @(negedge V_if.clk); #0;
    end
    test_finished = 1;
  end
endmodule