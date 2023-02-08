`timescale 1ns / 1ps
`include "define.sv"
`include "uart_tx.sv"
`include "uart_rx.sv"
module UART_CONTROLLER(
    input logic reset_n,
    input logic clk,
    input logic cpu_uart_rxd,
    input logic transmit_0x99,
    input logic receive_program_data_size,
    input logic receive_program_data,
    input logic transmit_0xAA,
    input logic receive_stdin_data,
    input logic transmit_stdout_data,
    input logic stdin_memory_write_ready,
    input logic stdout_memory_read_ready,
    input logic [7:0] stdout_memory_read_data,
    output logic cpu_uart_txd,
    output logic transmit_0x99_finished,
    output logic receive_program_data_size_finished,
    output logic receive_program_data_finished,
    output logic transmit_0xAA_finished,
    output logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] program_memory_write_address,
    output logic program_memory_write_enable,
    output logic [31:0] program_memory_write_data,
    output logic stdin_memory_write_enable,
    output logic [7:0] stdin_memory_write_data,
    output logic stdout_memory_read_enable
);

logic [31:0] program_data_size_byte;
logic [31:0] received_program_data_size_byte;
logic [23:0] received_program_data_flagment;
logic [1:0] receiving_data_section;
logic [7:0] uart_transmit_data;
logic uart_transmit_start;

logic [7:0] uart_rx_rdata;
logic uart_rx_rdata_ready;
logic uart_rx_ferr;
logic uart_tx_tx_busy;

logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] next_program_memory_write_address;

// uart_rx周り
always_ff @(posedge clk) begin
    if(~reset_n) begin
        program_data_size_byte <= 0;
        received_program_data_size_byte <= 0;
        received_program_data_flagment <= 0;
        receiving_data_section <= 0;
        receive_program_data_size_finished <= 0;
        receive_program_data_finished <= 0;
        program_memory_write_address <= 0;
        next_program_memory_write_address <= 0;
        program_memory_write_enable <= 0;
        program_memory_write_data <= 0;
        stdin_memory_write_enable <= 0;
        stdin_memory_write_data <= 0;
    end else if(uart_rx_rdata_ready) begin
        if(receive_program_data_size) begin
            program_data_size_byte <= program_data_size_byte | (uart_rx_rdata << (receiving_data_section * 8));
            receiving_data_section <= receiving_data_section + 1;

            if(receiving_data_section == 3) begin
                receive_program_data_size_finished <= 1;
            end
        end
        if(receive_program_data) begin
            if(receiving_data_section == 3) begin
                program_memory_write_enable <= 1;
                program_memory_write_data <= {uart_rx_rdata, received_program_data_flagment};
                program_memory_write_address <= next_program_memory_write_address;
                next_program_memory_write_address <= next_program_memory_write_address + 4;
                received_program_data_flagment <= 0;
            end else begin
                received_program_data_flagment <= received_program_data_flagment | (uart_rx_rdata << (receiving_data_section * 8));
            end
            receiving_data_section <= receiving_data_section + 1;
            received_program_data_size_byte <= received_program_data_size_byte + 1;

            if(received_program_data_size_byte + 1 == program_data_size_byte) begin
                receive_program_data_finished <= 1;
            end
        end
        if(receive_stdin_data) begin
            // stdin_memory_write_readyは常に1である前提
            stdin_memory_write_data <= uart_rx_rdata;
            stdin_memory_write_enable <= 1;
        end
    end

    if(program_memory_write_enable) begin
        program_memory_write_enable <= 0;
    end

    if(stdin_memory_write_enable) begin
        stdin_memory_write_enable <= 0;
    end
end

// uart_tx周り
always_ff @(posedge clk) begin
    if(~reset_n) begin
        uart_transmit_data <= 0;
        transmit_0x99_finished <= 0;
        transmit_0xAA_finished <= 0;
        stdout_memory_read_enable <= 0;
        uart_transmit_start <= 0;
    end else if(~uart_tx_tx_busy) begin
        if (transmit_0x99) begin
            uart_transmit_data <= 8'h99;
            uart_transmit_start <= 1;
            transmit_0x99_finished <= 1;
        end
        if (transmit_0xAA) begin
            uart_transmit_data <= 8'hAA;
            uart_transmit_start <= 1;
            transmit_0xAA_finished <= 1;
        end
        if (transmit_stdout_data & stdout_memory_read_ready) begin
            uart_transmit_data <= stdout_memory_read_data;
            stdout_memory_read_enable <= 1;
            uart_transmit_start <= 1;
        end
    end
    if(stdout_memory_read_enable) begin
        stdout_memory_read_enable <= 0;
    end
    if(uart_transmit_start) begin
        uart_transmit_start <= 0;
    end
end

UART_RX uart_rx(
    .rxd(cpu_uart_rxd), // in
    .clk(clk), // in
    .reset_n(reset_n), // in
    .rdata(uart_rx_rdata), // out
    .rdata_ready(uart_rx_rdata_ready), // out
    .ferr(uart_rx_ferr) // out
);

UART_TX uart_tx(
    .clk(clk), // in
    .reset_n(reset_n), // in
    .sdata(uart_transmit_data), // in
    .tx_start(uart_transmit_start), // in
    .tx_busy(uart_tx_tx_busy), // out
    .txd(cpu_uart_txd) // out
);


endmodule