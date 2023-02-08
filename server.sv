`timescale 1ns / 1ps
`include "miyajiro_cpu.sv"

module server(
);

localparam PROGRAM_DATA_SIZE_BYTE = 128;
localparam STDIN_DATA_SIZE_BYTE = 32;
localparam RESULT_MEMORY_SIZE_BYTE = 128;
localparam STATE_WAIT_0x99 = 3'h0;
localparam STATE_PROGRAM_DATA_SIZE_SEND = 3'h1;
localparam STATE_PROGRAM_DATA_SEND = 3'h2;
localparam STATE_WAIT_0xAA = 3'h3;
localparam STATE_STDIN_DATA_SEND = 3'h4;
localparam STATE_WAIT_PPM  = 3'h5;

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

logic [31:0] program_data_size_byte;
logic [2:0] program_data_size_section;
logic [31:0] transmitting_program_data;
logic [2:0] transmitting_program_data_section;
logic [31:0] program_data [PROGRAM_DATA_SIZE_BYTE / 4 - 1:0];
logic [16:0] program_data_index;
logic [7:0] stdin_data [STDIN_DATA_SIZE_BYTE - 1:0];
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

logic [7:0] result_memory [RESULT_MEMORY_SIZE_BYTE:0];
logic [16:0] result_memory_index;
logic [2:0] state;
logic busy_wait;

always_ff @(posedge clk) begin
    if (~reset_n) begin
        tx_start <= 0;
        program_data_size_byte <= PROGRAM_DATA_SIZE_BYTE;
        program_data_size_section <= 0;
        transmitting_program_data <= program_data[0];
        transmitting_program_data_section <= 0;
        program_data_index <= 0;
        stdin_data_index <= 0;
        result_memory_index <= 0;
        state <= STATE_WAIT_0x99;
        busy_wait <= 0;
    end
    if (tx_start) begin
        tx_start <= 0;
    end

    case (state)
        STATE_WAIT_0x99: begin
            if (server_uart_rx_rdata_ready && server_uart_rx_rdata == 8'h99) begin
                state <= STATE_PROGRAM_DATA_SIZE_SEND;
            end
        end
        STATE_PROGRAM_DATA_SIZE_SEND: begin
            if (~server_uart_tx_tx_busy && ~busy_wait) begin
                if(program_data_size_section < 4) begin
                    sdata <= program_data_size_byte[7:0];
                    program_data_size_byte <= (program_data_size_byte >> 8);
                    tx_start <= 1;
                    program_data_size_section <= program_data_size_section + 1;
                    busy_wait <= 1;
                end
                else begin
                    state <= STATE_PROGRAM_DATA_SEND;
                end
            end
            if (busy_wait) begin
                busy_wait <= 0;
            end
        end
        STATE_PROGRAM_DATA_SEND: begin
            if (~server_uart_tx_tx_busy && ~busy_wait) begin
                if (program_data_index < PROGRAM_DATA_SIZE_BYTE) begin
                    sdata <= transmitting_program_data[7:0];
                    transmitting_program_data <= (transmitting_program_data >> 8);
                    tx_start <= 1;
                    busy_wait <= 1;
                    if(transmitting_program_data_section == 3) begin
                        program_data_index <= program_data_index + 1;
                        transmitting_program_data_section <= 0;
                        if(program_data_index + 1 < PROGRAM_DATA_SIZE_BYTE / 4) begin
                            transmitting_program_data <= program_data[program_data_index + 1];
                        end
                    end else begin
                        transmitting_program_data_section <= transmitting_program_data_section + 1;
                    end
                end
                else begin
                    state <= STATE_WAIT_0xAA;
                end
            end
            if (busy_wait) begin
                busy_wait <= 0;
            end
        end
        STATE_WAIT_0xAA: begin
            if (server_uart_rx_rdata_ready && server_uart_rx_rdata == 8'hAA) begin
                state <= STATE_STDIN_DATA_SEND;
            end
        end
        STATE_STDIN_DATA_SEND: begin
            if (~server_uart_tx_tx_busy && ~busy_wait) begin
                if (stdin_data_index < STDIN_DATA_SIZE_BYTE) begin
                    sdata <= stdin_data[stdin_data_index];
                    tx_start <= 1;
                    stdin_data_index <= stdin_data_index + 1;
                    busy_wait <= 1;
                end
                else begin
                    state <= STATE_WAIT_PPM;
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
        STATE_WAIT_PPM: begin
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
    .cpu_uart_txd(server_uart_rxd)
);
endmodule