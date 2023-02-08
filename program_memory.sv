`timescale 1ns / 1ps
`include "define.sv"

module PROGRAM_MEMORY (
    input logic clk,
    input logic reset_n,
    input logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] read_address,
    output logic [31:0] read_data
);

logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 3:0] _read_address;
(* ram_style = "BLOCK" *) reg [31:0] _program_memory [`PROGRAM_MEMORY_SIZE_BYTE / 4 - 1:0];

// initial $readmemb("program.dat", _program_memory);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        _read_address <= 0;
    end
    else begin
        _read_address <= read_address[`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1 : 2];
    end
end

always_comb begin
    read_data <= _program_memory[_read_address];
end

endmodule