`timescale 1ns / 1ps
module IF_ID_PIPELINE_REGISTER (
    input logic reset_n,
    input logic clk,
    input logic wren,
    input logic [31:0] in_instruction,
    input logic [31:0] in_pc_data,
    output logic[31:0] instruction,
    output logic[31:0] pc_data
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        instruction <= 0;
        pc_data <= 0;
    end
    else if(wren) begin
        instruction <= in_instruction;
        pc_data <= in_pc_data;
    end
end

endmodule