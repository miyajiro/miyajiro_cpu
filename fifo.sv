`timescale 1ns / 1ps
`include "define.sv"
module FIFO(
    input logic reset_n,
    input logic clk,
    input logic read_enable,
    input logic write_enable,
    input logic [7:0] write_data,
    output logic [7:0] read_data,
    output logic read_ready,
    output logic write_ready
);

logic [`FIFO_CAPACITY_BITWIDTH:0] read_address;
logic [`FIFO_CAPACITY_BITWIDTH:0] write_address;
logic [`FIFO_CAPACITY_BITWIDTH:0] address_difference;
logic fifo_full;
logic fifo_empty;

(* ram_style = "BLOCK" *) reg [7:0] memory_array [0:`FIFO_CAPACITY_BYTE - 1];

always_ff @(posedge clk) begin
    if (~reset_n) begin
        read_address <= 0;
    end
    else if (read_enable) begin
        read_address <= read_address + 1;
    end
end

always_ff @(posedge clk) begin
    if (~reset_n) begin
        write_address <= 0;
    end
    else if (write_enable) begin
        write_address <= write_address + 1;
    end
end

always_comb begin
    fifo_empty <= (read_address == write_address);
    fifo_full <= (read_address[`FIFO_CAPACITY_BITWIDTH - 1:0] == write_address[`FIFO_CAPACITY_BITWIDTH - 1:0]) & (read_address[`FIFO_CAPACITY_BITWIDTH] != write_address[`FIFO_CAPACITY_BITWIDTH]);
end

always_comb begin
    read_ready <= ~fifo_empty;
    write_ready <= ~fifo_full;
end

always_ff @(posedge clk) begin
    if (write_enable) begin
        memory_array[write_address[`FIFO_CAPACITY_BITWIDTH - 1:0]] <= write_data;
    end
end

always_ff @(posedge clk) begin
    read_data <= memory_array[read_address[`FIFO_CAPACITY_BITWIDTH - 1:0]];
end
endmodule