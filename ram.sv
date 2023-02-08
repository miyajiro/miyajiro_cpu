`timescale 1ns / 1ps
`include "define.sv"

module RAM(
    input logic clk,
    input logic [`RAM_ADDRESS_BITWIDTH - 1:0] read_address,
    input logic [`RAM_ADDRESS_BITWIDTH - 1:0] write_address,
    input logic write_enable,
    input logic [31:0] write_data,
    output logic[31:0] read_data,
    output logic read_ready
);

logic [`RAM_ADDRESS_BITWIDTH - 2:0] inner_read_address;
logic [`RAM_ADDRESS_BITWIDTH - 2:0] inner_write_address;
assign inner_read_address = read_address[`RAM_ADDRESS_BITWIDTH - 1:1];
assign inner_write_address = write_address[`RAM_ADDRESS_BITWIDTH - 1:1];

reg [31:0] inner_ram [`RAM_SIZE / 2 - 1:0];

// initial $readmemb("empty.dat", _ram);

always_ff @(posedge clk) begin
    if(write_enable) begin
        inner_ram[inner_write_address] <= write_data;
    end
end

always_comb begin
    read_data <= inner_ram[inner_read_address];
    read_ready <= 1;
end
endmodule
