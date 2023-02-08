`timescale 1ns / 1ps
`include "define.sv"

module PROGRAM_MEMORY (
    input logic clk,
    input logic reset_n,
    input logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] address,
    output logic [31:0] data
);

logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 3:0] _address;
(* ram_style = "BLOCK" *) reg [31:0] _program_memory [`PROGRAM_MEMORY_SIZE / 4 - 1:0];

// initial $readmemb("program.dat", _program_memory);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        _address <= 0;
    end
    else begin
        _address <= address[`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1 : 2];
    end
end

always_comb begin
    data <= _program_memory[_address];
end

endmodule