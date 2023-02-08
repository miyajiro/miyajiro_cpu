`timescale 1ns / 1ps
`include "define.sv"

module PROGRAM_MEMORY (
    input logic clk,
    input logic reset_n,
    input logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] read_address,
    input logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] write_address,
    input logic [31:0] write_data,
    input logic write_enable,
    output logic [31:0] read_data
);

logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 3:0] inner_read_address;
logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 3:0] inner_write_address;
assign inner_read_address = read_address[`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:2];
assign inner_write_address = write_address[`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:2];

(* ram_style = "BLOCK" *) reg [31:0] inner_program_memory [`PROGRAM_MEMORY_SIZE_BYTE / 4 - 1:0];

// initial $readmemb("program.dat", _program_memory);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        read_data <= 0;
    end else if (write_enable) begin
        inner_program_memory[inner_write_address] <= write_data;
    end
end

always_comb begin
    read_data <= inner_program_memory[inner_read_address];
end

endmodule