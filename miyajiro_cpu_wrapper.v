`include "miyajiro_cpu.sv"

module MIYAJIRO_CPU_WRAPPER (
    input reset_n,
    input clk,
    input cpu_uart_rxd,
    output wire cpu_uart_txd
)

MIYAJIRO_CPU miyajiro_cpu(
    .reset_n(reset_n),
    .clk(reset_n),
    .cpu_uart_rxd(cpu_uart_rxd),
    .cpu_uart_txd(cpu_uart_txd)
)

endmodule