vlib work
vlog -f src_files.list  +cover
vsim -voptargs=+acc FIFO_top -cover
add wave -position insertpoint sim:/FIFO_top/V_if/*
add wave -position insertpoint  \
sim:/shared_pkg::iteration
coverage save FIFO_TOP.ucdb -onexit -du work.FIFO_top
run -all