`timescale 1ns / 1ps
`include "define.sv"

module STDIN_MEMORY (
    input logic clk,
    input logic reset_n,
    input logic write_enable,
    input logic write_data,
    input logic read_enable,
    output logic [7:0] read_data,
    output logic read_ready
);

logic [`STDIN_MEMORY_ADDRESS_BITWIDTH - 1:0] read_address;
logic [`STDIN_MEMORY_ADDRESS_BITWIDTH - 1:0] write_address;
(* ram_style = "BLOCK" *) reg [7:0] _stdin_memory [`STDIN_MEMORY_SIZE - 1:0];

initial $readmemb("stdin.dat", _stdin_memory);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        read_address <= 0;
        write_address <= 0;
        read_data <= 0;
        read_ready <= 0;
    end
    else begin
        if(write_enable) begin
            _stdin_memory[write_address] <= write_data;
            write_address <= write_address + 1;
        end
        if(read_enable) begin
            if(read_address < write_address) begin
                read_data <= _stdin_memory[read_address];
                read_ready <= 1;
                read_address <= read_address + 1;
            end
        end
        if(read_ready) begin
            read_ready <= 0;
        end
    end
end

endmodule