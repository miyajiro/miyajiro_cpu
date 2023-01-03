`timescale 1ns / 1ps
module MEM_WB_PIPELINE_REGISTER(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_ram_data,
    input [31:0] in_alu_rd_result,
    input [4:0] in_rd_address,
    input in_reg_write_data_src,
    input in_reg_wren,
    input [31:0] in_next_pc_data,
    output reg [31:0] ram_data,
    output reg [31:0] alu_rd_result,
    output reg [4:0] rd_address,
    output reg reg_write_data_src,
    output reg reg_wren,
    output reg [31:0] next_pc_data
);

always @(posedge clk) begin
    if(!reset_n) begin
        ram_data <= 0;
        alu_rd_result <= 0;
        rd_address <= 0;
        reg_write_data_src <= 0;
        reg_wren <= 0;
        next_pc_data <= 0;
    end
    else if(wren) begin
        ram_data <= in_ram_data;
        alu_rd_result <= in_alu_rd_result;
        rd_address <= in_rd_address;
        reg_write_data_src <= in_reg_write_data_src;
        reg_wren <= in_reg_wren;
        next_pc_data <= in_next_pc_data;
    end
end
endmodule