`timescale 1ns / 1ps
module PC(
    input logic reset_n,
    input logic clk,
    input logic wren,
    input logic [31:0] next_pc_data,
    output logic [31:0] pc_data
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        pc_data <= 0;
    end
    else if(wren) begin
        pc_data <= next_pc_data;
    end
end

endmodule
