`timescale 1ns / 1ps

module server(
);

localparam program_data_size_byte = 96;
localparam stdin_data_size_byte = 128;
localparam result_memory_size_byte = 128;

logic clk;
logic reset_n;
logic server_uart_rxd;
logic [7:0] server_uart_rx_rdata;
logic server_uart_rx_rdata_ready;
logic server_uart_rx_ferr;

UART_RX server_uart_rx(
    .rxd(server_uart_rxd),
    .clk(clk),
    .reset_n(reset_n),
    .rdata(server_uart_rx_rdata),
    .rdata_ready(server_uart_rx_rdata_ready),
    .ferr(server_uart_rx_ferr)
);

logic [7:0] sdata;
logic tx_start;
logic server_uart_tx_tx_busy;
logic server_uart_txd;

UART_TX server_uart_tx(
    .clk(clk),
    .reset_n(reset_n),
    .sdata(sdata),
    .tx_start(tx_start),
    .tx_busy(server_uart_tx_tx_busy),
    .txd(server_uart_txd)
);

always begin
    clk <= 0;
    # 5;
    clk <= 1;
    # 5;
end

logic [2:0] program_data_size_section;
logic [7:0] program_data [program_data_size_byte - 1:0];
logic [16:0] program_data_index;
logic [7:0] stdin_data [stdin_data_size_byte:0];
logic [16:0] stdin_data_index;

initial begin
    $readmemb("program.dat", program_data);
    $readmemb("stdin.dat", stdin_data);
    reset_n <= 0;
    # 20;
    reset_n <= 1;
    # 500000000;
    $finish();
end

logic [7:0] result_memory [result_memory_size_byte:0];
logic [16:0] result_memory_index;
logic [2:0] state;
logic busy_wait;
localparam state_wait_0x99 = 3'h0;
localparam state_program_size_send = 3'h1;
localparam state_program_data_send = 3'h2;
localparam state_wait_0xAA = 3'h2;
localparam state_stdin_data_send = 3'h3;
localparam state_wait_ppm  = 3'h4;

always_ff @(posedge clk) begin
    if (~reset_n) begin
        tx_start <= 0;
        program_data_index <= 0;
        stdin_data_index <= 0;
        result_memory_index <= 0;
        state <= state_wait_0x99;
        busy_wait <= 0;
    end
    if (tx_start) begin
        tx_start <= 0;
    end

    case (state)
        state_wait_0x99: begin
            if (server_uart_rx_rdata_ready && server_uart_rx_rdata == 8'h99) begin
                state <= state_program_data_send;
            end
        end
        state_program_size_send: begin
            if (~server_uart_tx_tx_busy && ~busy_wait) begin
                if(program_data_size_section < 4) begin
                    sdata <= program_data_size_byte[program_data_size_section * 4 + 3:program_data_size_section * 4];
                    tx_start <= 1;
                    program_data_size_section <= program_data_size_section + 1;
                    busy_wait <= 1;
                end
                else begin
                    state <= state_stdin_data_send;
                end
            end
            if (busy_wait) begin
                busy_wait <= 0;
            end
        end
        state_program_data_send: begin
            if (~server_uart_tx_tx_busy && ~busy_wait) begin
                if (program_data_index < program_data_size_byte) begin
                    sdata <= program_data[program_data_index];
                    tx_start <= 1;
                    program_data_index <= program_data_index + 1;
                    busy_wait <= 1;
                end
                else begin
                    state <= state_wait_0xAA;
                end
            end
            if (busy_wait) begin
                busy_wait <= 0;
            end
        end
        state_wait_0xAA: begin
            if (server_uart_rx_rdata_ready && server_uart_rx_rdata == 8'hAA) begin
                state <= state_stdin_data_send;
            end
        end
        state_stdin_data_send: begin
            if (~server_uart_tx_tx_busy && ~busy_wait) begin
                if (stdin_data_index < stdin_data_size_byte) begin
                    sdata <= stdin_data[stdin_data_index];
                    tx_start <= 1;
                    stdin_data_index <= stdin_data_index + 1;
                    busy_wait <= 1;
                end
                else begin
                    state <= state_wait_ppm;
                end
            end
            if (busy_wait) begin
                busy_wait <= 0;
            end
            if (server_uart_rx_rdata_ready) begin
                result_memory[result_memory_index] <= server_uart_rx_rdata;
                result_memory_index <= result_memory_index + 1;
            end
        end
        state_wait_ppm: begin
            if (server_uart_rx_rdata_ready) begin
                result_memory[result_memory_index] <= server_uart_rx_rdata;
                result_memory_index <= result_memory_index + 1;
            end
        end
    endcase
end

MIYAJIRO_CPU miyajiro_cpu(
    .reset_n(reset_n),
    .clk(clk),
    .cpu_uart_rxd(server_uart_txd),
    .cpu_uart_txd(server_uart_rxd),
);
endmodule