`timescale 1ns / 1ps
module REGISTER (
    input logic reset_n,
    input logic clk,
    input logic write,
    input logic [31:0] in_data,
    output logic [31:0] data
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        data <= 32'b0;
    end
    else begin
        if(write) begin
            data <= in_data;
        end
    end
end
endmodule