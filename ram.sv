`timescale 1ns / 1ps
`include "define.sv"

module RAM(
    input logic clk,
    input logic write_enable,
    input logic [`RAM_ADDRESS_BITWIDTH - 1 : 0] address,
    input logic [31:0] write_data,
    output logic[31:0] data
);

logic [`RAM_ADDRESS_BITWIDTH - 3:0] _address;
reg [31:0] _ram [`RAM_SIZE / 4 - 1:0];

// initial $readmemb("empty.dat", _ram);

always_ff @(posedge clk) begin
    _address <= address[`RAM_ADDRESS_BITWIDTH - 1 : 2];
    if(write_enable) begin
        _ram[address] <= write_data;
    end
end

always_comb begin
    data <= _ram[_address];
end
endmodule
