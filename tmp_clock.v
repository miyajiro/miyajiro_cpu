`timescale 1ns / 1ps

module TMP_CLOCK (
    input clk,
    input reset_n,
    input cpu_uart_rxd,
    output cpu_uart_txd
);

reg [4:0] count;

always @(posedge clk) begin
    if (~reset_n) begin
        count <= 0;
    end
    count <= count + 1;
end


MIYAJIRO_CPU_WRAPPER miyajiro_cpu_wrapper(
    .reset_n(reset_n),
    .clk(count[4]),
    .cpu_uart_rxd(cpu_uart_rxd),
    .cpu_uart_txd(cpu_uart_txd)
);

endmodule