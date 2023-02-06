`timescale 1ns / 1ps
`include "define.v"

module ROM (
    input clk,
    input reset_n,
    input [`ROM_ADDRESS_BITWIDTH - 1:0] address,
    output reg [31:0] data
);

reg [`ROM_ADDRESS_BITWIDTH - 3:0] _address;
(* ram_style = "BLOCK" *) reg [31:0] _rom [`ROM_SIZE / 4 - 1:0];

initial $readmemb("program.dat", _rom);

always @(posedge clk) begin
    if(!reset_n) begin
        _address <= 0;
    end
    else begin
        _address <= address[`ROM_ADDRESS_BITWIDTH - 1 : 2];
    end
end

wire [31:0] _data;
assign _data = _rom[_address];

always @* begin
    data <= _data;
end

endmodule