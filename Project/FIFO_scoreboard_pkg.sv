package FIFO_scoreboard_pkg;
  import FIFO_Transaction_pkg::*;
  import shared_pkg::*;
	class FIFO_scoreboard;
		logic [FIFO_WIDTH-1:0] data_out_ref;
		bit full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref;
    static logic [FIFO_WIDTH-1:0] fifo_queue[$];
    static int count_ref=0; 

		function void check_data(FIFO_transaction F_txn);
      iteration++;
			reference_model(F_txn);

			if (F_txn.data_out !== data_out_ref) begin
				error_count++;
				$display("*******************ERROR: Mismatch detected in FIFO transaction in iteration number=%0d.",iteration);
			end else begin
				correct_count++;
			end
      $display("Expected: data_out_ref=%0d, full_ref=%0b, empty_ref=%0b, almostfull_ref=%0b, almostempty_ref=%0b, overflow_ref=%0b, underflow_ref=%0b, wr_ack_ref=%0b;",
          data_out_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, overflow_ref, underflow_ref, wr_ack_ref);

        $display("Got: data_out=%0d, full=%0b, empty=%0b, almostfull=%0b, almostempty=%0b, overflow=%0b, underflow=%0b, wr_ack=%0b",
          F_txn.data_out, F_txn.full, F_txn.empty, F_txn.almostfull, F_txn.almostempty, F_txn.overflow, F_txn.underflow, F_txn.wr_ack);

        $display("queue size=%0d",fifo_queue.size());

        for (int i = 0; i < fifo_queue.size(); i++) begin
            $display("Element at index %0d: %0d", i, fifo_queue[i]);
        end
		endfunction

		function void reference_model(FIFO_transaction F_txn);
        wr_ack_ref = 0;
        overflow_ref = 0;
        underflow_ref = 0;
        if (!F_txn.rst_n) begin
          fifo_queue.delete();
          count_ref = 0;
          //data_out_ref = F_txn.data_out;
        wr_ack_ref = 0;
        overflow_ref = 0;
        underflow_ref = 0;
        end
        else begin
          case ({F_txn.wr_en,F_txn.rd_en})
            2'b10: begin
              if(fifo_queue.size() < FIFO_DEPTH) begin
                fifo_queue.push_back(F_txn.data_in);
                wr_ack_ref = 1;
                overflow_ref = 0;
              end
              else
                overflow_ref = 1;
            end
            2'b01 : begin
              if(fifo_queue.size() > 0) begin
                data_out_ref = fifo_queue.pop_front();
                underflow_ref = 0;
              end
              else
                underflow_ref = 1;
            end
            2'b00 : begin
              //data_out_ref = F_txn.data_out;
            end
            2'b11 : begin
              if(fifo_queue.size() < FIFO_DEPTH && fifo_queue.size() > 0) begin
                fifo_queue.push_back(F_txn.data_in);
                wr_ack_ref = 1;
                data_out_ref = fifo_queue.pop_front();
              end
              else if(fifo_queue.size() == FIFO_DEPTH) begin
                data_out_ref = fifo_queue.pop_front();
              end
              else if(fifo_queue.size() == 0) begin
                fifo_queue.push_back(F_txn.data_in);
                wr_ack_ref = 1;
              end
            end
          endcase
        end
          full_ref = (fifo_queue.size() == FIFO_DEPTH);
          almostfull_ref = (fifo_queue.size() == FIFO_DEPTH - 1);
          empty_ref = (fifo_queue.size() == 0);
          almostempty_ref = (fifo_queue.size() == 1);
    endfunction
	endclass
endpackage