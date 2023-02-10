module MIYAJIRO_CPU_WRAPPER (
    input logic reset_n,
    input logic clk,
    input logic cpu_uart_rxd,
    output logic cpu_uart_txd
);

MIYAJIRO_CPU miyajiro_cpu(
    .reset_n(reset_n),
    .clk(reset_n),
    .cpu_uart_rxd(cpu_uart_rxd),
    .cpu_uart_txd(cpu_uart_txd)
);

endmodule