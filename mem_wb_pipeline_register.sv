`timescale 1ns / 1ps
module MEM_WB_PIPELINE_REGISTER(
    input logic reset_n,
    input logic clk,
    input logic write_enable,
    input logic [31:0] in_ram_data,
    input logic [31:0] in_alu_rd_result,
    input logic [4:0] in_rd_address,
    input logic [1:0] in_reg_write_data_src,
    input logic in_reg_write_enable,
    input logic [31:0] in_next_pc_data,
    output logic [31:0] ram_data,
    output logic [31:0] alu_rd_result,
    output logic [4:0] rd_address,
    output logic [1:0] reg_write_data_src,
    output logic reg_write_enable,
    output logic [31:0] next_pc_data
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        ram_data <= 0;
        alu_rd_result <= 0;
        rd_address <= 0;
        reg_write_data_src <= 0;
        reg_write_enable <= 0;
        next_pc_data <= 0;
    end
    else if(write_enable) begin
        ram_data <= in_ram_data;
        alu_rd_result <= in_alu_rd_result;
        rd_address <= in_rd_address;
        reg_write_data_src <= in_reg_write_data_src;
        reg_write_enable <= in_reg_write_enable;
        next_pc_data <= in_next_pc_data;
    end
end
endmodule