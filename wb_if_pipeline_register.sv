`timescale 1ns / 1ps
module WB_IF_PIPELINE_REGISTER(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_next_pc_data,
    output logic [31:0] next_pc_data
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        next_pc_data <= 0;
    end
    else if(wren) begin
        next_pc_data <= in_next_pc_data;
    end
end
endmodule