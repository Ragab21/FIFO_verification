
package FIFO_coverage_pkg;
  import FIFO_Transaction_pkg::*;
  class FIFO_coverage;
    FIFO_transaction F_cvg_txn;

    covergroup fifo_cg;
      cp_we_en:coverpoint F_cvg_txn.wr_en;
      cp_rd_en:coverpoint F_cvg_txn.rd_en;
      cp_wr_ack_signal: coverpoint F_cvg_txn.wr_ack;
      cp_overflow_signal: coverpoint F_cvg_txn.overflow;
      cp_full_signal: coverpoint F_cvg_txn.full;
      cp_empty_signal: coverpoint F_cvg_txn.empty;
      cp_almostfull_signal: coverpoint F_cvg_txn.almostfull;
      cp_almostempty_signal: coverpoint F_cvg_txn.almostempty;
      cp_underflow_signal: coverpoint F_cvg_txn.underflow;

      wr_en_cross_rd_en: cross cp_we_en, cp_rd_en;

      wr_en_cross_wr_ack: cross cp_we_en, cp_wr_ack_signal {
            illegal_bins illegal_wr_ack_on_no_wr = binsof(cp_we_en) intersect{0} && binsof(cp_wr_ack_signal) intersect{1};}
      wr_en_cross_overflow: cross cp_we_en, cp_overflow_signal {
            illegal_bins illegal_overflow_on_no_wr = binsof(cp_we_en) intersect{0} && binsof(cp_overflow_signal) intersect{1};
            }
      wr_en_cross_full: cross cp_we_en, cp_full_signal;
      wr_en_cross_empty: cross cp_we_en, cp_empty_signal;
      wr_en_cross_almostfull: cross cp_we_en, cp_almostfull_signal;
      wr_en_cross_almostempty: cross cp_we_en, cp_almostempty_signal;
      wr_en_cross_underflow: cross cp_we_en, cp_underflow_signal;

      rd_en_cross_wr_ack: cross cp_rd_en, cp_wr_ack_signal;
      rd_en_cross_overflow: cross cp_rd_en, cp_overflow_signal {
            illegal_bins illegal_overflow_on_rd = binsof(cp_rd_en) intersect{1} && binsof(cp_overflow_signal) intersect{1};
            }
      rd_en_cross_full: cross cp_rd_en, cp_full_signal {
            illegal_bins illegal_full_on_rd = binsof(cp_rd_en) intersect{1} && binsof(cp_full_signal) intersect{1};
            }
      rd_en_cross_empty: cross cp_rd_en, cp_empty_signal;
      rd_en_cross_almostfull: cross cp_rd_en, cp_almostfull_signal;
      rd_en_cross_almostempty: cross cp_rd_en, cp_almostempty_signal;
      rd_en_cross_underflow: cross cp_rd_en, cp_underflow_signal {
            illegal_bins illegal_underflow_on_rd = binsof(cp_rd_en) intersect{0} && binsof(cp_underflow_signal) intersect{1};
            }
     
    endgroup

    function new();
      this.fifo_cg = new();
    endfunction

    function void sample_data(FIFO_transaction F_txn);
      F_cvg_txn = F_txn;
      fifo_cg.sample();
    endfunction

  endclass

endpackage
