`timescale 1ns / 1ps
`include "define.v"

module RAM(
    input clk,
    input wren,
    input [`RAM_ADDRESS_BITWIDTH - 1 : 0] address,
    input [31:0] write_data,
    output [31:0] data
);

reg [`RAM_ADDRESS_BITWIDTH - 3:0] _address;
reg [31:0] _ram [`RAM_SIZE / 4 - 1:0];

always @(posedge clk) begin
    _address <= address[`RAM_ADDRESS_BITWIDTH - 1 : 2];
    if(wren) begin
        _ram[address] <= write_data;
    end
end

assign data = _ram[_address];

endmodule
