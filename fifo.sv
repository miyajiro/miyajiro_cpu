`timescale 1ns / 1ps
`include "define.sv"
module FIFO #(
    parameter FIFO_BRAM_ADDRESS_SIZE = 1024,
    parameter FIFO_BRAM_ADDRESS_BITWIDTH = 10,
    parameter FIFO_BRAM_DATA_BITWIDTH = 8
) (
    input logic reset_n,
    input logic clk,
    input logic read_enable,
    input logic write_enable,
    input logic [FIFO_BRAM_DATA_BITWIDTH - 1:0] write_data,
    output logic [FIFO_BRAM_DATA_BITWIDTH - 1:0] read_data,
    output logic read_ready,
    output logic write_ready
);

logic [FIFO_BRAM_ADDRESS_BITWIDTH:0] read_position;
logic [FIFO_BRAM_ADDRESS_BITWIDTH:0] write_position;
logic fifo_full;
logic fifo_empty;

(* ram_style = "BLOCK" *) reg [FIFO_BRAM_DATA_BITWIDTH - 1:0] memory_array [0:FIFO_BRAM_ADDRESS_SIZE - 1];

always_ff @(posedge clk) begin
    if (~reset_n) begin
        read_position <= 0;
    end
    else if (read_enable) begin
        read_position <= read_position + 1;
    end
end

always_ff @(posedge clk) begin
    if (~reset_n) begin
        write_position <= 0;
    end
    else if (write_enable) begin
        write_position <= write_position + 1;
    end
end

logic [FIFO_BRAM_ADDRESS_BITWIDTH - 1:0] read_address;
logic read_position_prefix;
logic [FIFO_BRAM_ADDRESS_BITWIDTH - 1:0] write_address;
logic write_position_prefix;

assign read_address = read_position[FIFO_BRAM_ADDRESS_BITWIDTH - 1:0];
assign read_position_prefix = read_position[FIFO_BRAM_ADDRESS_BITWIDTH];

assign write_address = write_position[FIFO_BRAM_ADDRESS_BITWIDTH - 1:0];
assign write_position_prefix = read_position[FIFO_BRAM_ADDRESS_BITWIDTH];

always_comb begin
    fifo_empty <= (read_address == write_address) & (read_position_prefix == write_position_prefix);
    fifo_full <= (read_address == write_address) & (read_position_prefix != write_position_prefix);
end

always_comb begin
    read_ready <= ~fifo_empty;
    write_ready <= ~fifo_full;
end

always_ff @(posedge clk) begin
    if (write_enable) begin
        memory_array[write_address] <= write_data;
    end
end

always_ff @(posedge clk) begin
    read_data <= memory_array[read_address];
end
endmodule