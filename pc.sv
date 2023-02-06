`timescale 1ns / 1ps
module PC(
    input reset_n,
    input clk,
    input wren,
    input [31:0] next_pc_data,
    output logic [31:0] pc_data
);

reg [31:0] _pc_data;

assign pc_data = _pc_data;

always_ff @(posedge clk) begin
    if(!reset_n) begin
        _pc_data <= 0;
    end
    else if(wren) begin
        _pc_data <= next_pc_data;
    end
end

endmodule
