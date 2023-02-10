`timescale 1ns / 1ps

module TMP_CLOCK (
    input CLK100MHZ,
    input CPU_RESETN,
    input UART_TXD_IN,
    output UART_RXD_OUT
);

reg [4:0] count;
reg [4:0] mod;

always @(posedge CLK100MHZ) begin
    if (~reset_n) begin
        count <= 0;
        mode <= 20;
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