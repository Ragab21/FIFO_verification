import FIFO_Transaction_pkg::*;
import FIFO_scoreboard_pkg::*;
import FIFO_coverage_pkg::*;
import shared_pkg::*;
module monitor_fifo(FIFO_if.MONITOR V_if);
  FIFO_transaction fifo_txn;
  FIFO_coverage fifo_cov;
  FIFO_scoreboard fifo_sb;
  initial begin
    fifo_txn = new();
    fifo_cov = new();
    fifo_sb = new();
    forever begin
      @(negedge V_if.clk);
      fifo_txn.rst_n     = V_if.rst_n;
      fifo_txn.data_in     = V_if.data_in;
      fifo_txn.wr_en       = V_if.wr_en;
      fifo_txn.rd_en       = V_if.rd_en;
      fifo_txn.data_out    = V_if.data_out;
      fifo_txn.wr_ack      = V_if.wr_ack;
      fifo_txn.full        = V_if.full;
      fifo_txn.empty       = V_if.empty;
      fifo_txn.almostfull  = V_if.almostfull;
      fifo_txn.almostempty = V_if.almostempty;
      fifo_txn.overflow    = V_if.overflow;
      fifo_txn.underflow   = V_if.underflow;

      fork
        begin
          fifo_cov.sample_data(fifo_txn);
        end

        begin
          fifo_sb.check_data(fifo_txn);
        end
      join

      if (test_finished) begin
        $display("Simulation finished!");
        $display("Correct transactions: %0d",correct_count);
        $display("Errors found: %0d",error_count);
        $stop;
        $finish;
      end
    end
  end

endmodule
