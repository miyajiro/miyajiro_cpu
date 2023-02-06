`timescale 1ns / 1ps
`include "define.sv"

module ROM (
    input logic clk,
    input logic reset_n,
    input logic [`ROM_ADDRESS_BITWIDTH - 1:0] address,
    output logic [31:0] data
);

logic [`ROM_ADDRESS_BITWIDTH - 3:0] _address;
(* ram_style = "BLOCK" *) reg [31:0] _rom [`ROM_SIZE / 4 - 1:0];

initial $readmemb("program.dat", _rom);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        _address <= 0;
    end
    else begin
        _address <= address[`ROM_ADDRESS_BITWIDTH - 1 : 2];
    end
end

always_comb begin
    data <= _rom[_address];
end

endmodule