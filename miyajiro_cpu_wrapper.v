`timescale 1ns / 1ps

module MIYAJIRO_CPU_WRAPPER (
    input clk,
    input reset_n,
    input cpu_uart_rxd,
    output cpu_uart_txd
);

MIYAJIRO_CPU miyajiro_cpu(
    .reset_n(reset_n),
    .clk(reset_n),
    .cpu_uart_rxd(cpu_uart_rxd),
    .cpu_uart_txd(cpu_uart_txd)
);

endmodule