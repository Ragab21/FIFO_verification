package FIFO_Transaction_pkg;
  import shared_pkg::*;
	class FIFO_transaction;

    rand bit rst_n;
    randc bit wr_en;
    randc bit rd_en;
    randc logic [15:0] data_in;
    logic [15:0] data_out;
    bit wr_ack;
    bit overflow;
    bit full, empty, almostfull, almostempty, underflow;

    int RD_EN_ON_DIST;
    int WR_EN_ON_DIST;

    function new(int rd_dist = 30, int wr_dist = 70);
      this.RD_EN_ON_DIST = rd_dist;
      this.WR_EN_ON_DIST = wr_dist;
    endfunction

    constraint reset_assertion {
      rst_n dist {1'b1 :/ 99, 1'b0 :/ 1};
    }

    constraint write_enable_distribution {
      wr_en dist {1'b1 :/ WR_EN_ON_DIST, 1'b0 :/ (100 - WR_EN_ON_DIST)};
    }

    constraint read_enable_distribution {
      rd_en dist {1'b1 :/ RD_EN_ON_DIST, 1'b0 :/ (100 - RD_EN_ON_DIST)};
    }
  endclass
  
endpackage