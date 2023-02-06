`timescale 1ns / 1ps
module WB_IF_PIPELINE_REGISTER(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_next_pc_data,
    output reg [31:0] next_pc_data
);

always @(posedge clk) begin
    if(!reset_n) begin
        next_pc_data <= 0;
    end
    else if(wren) begin
        next_pc_data <= in_next_pc_data;
    end
end
endmodule