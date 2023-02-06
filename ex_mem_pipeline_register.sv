`timescale 1ns / 1ps
module EX_MEM_PIPELINE_REGISTER(
    input logic reset_n,
    input logic clk,
    input logic wren,
    input logic [31:0] in_pc_data,
    input logic [31:0] in_rs2_data,
    input logic [4:0] in_rd_address,
    input logic [31:0] in_alu_rd_result,
    input logic in_alu_rd_result_is_zero,
    input logic [31:0] in_alu_pc_result,
    input logic [1:0] in_next_pc_src,
    input logic in_reg_write_data_src,
    input logic in_reg_wren,
    input logic in_ram_wren,
    output logic [31:0] pc_data,
    output logic [31:0] rs2_data,
    output logic [4:0] rd_address,
    output logic [31:0] alu_rd_result,
    output logic alu_rd_result_is_zero,
    output logic [31:0] alu_pc_result,
    output logic [1:0] next_pc_src,
    output logic reg_write_data_src,
    output logic reg_wren,
    output logic ram_wren
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        pc_data <= 0;
        rd_address <= 0;
        rs2_data <= 0;
        alu_rd_result <= 0;
        alu_rd_result_is_zero <= 0;
        alu_pc_result <= 0;
        next_pc_src <= 0;
        reg_write_data_src <= 0;
        reg_wren <= 0;
        ram_wren <= 0;
    end
    else if(wren) begin
        pc_data <= in_pc_data;
        rd_address <= in_rd_address;
        rs2_data <= in_rs2_data;
        alu_rd_result <= in_alu_rd_result;
        alu_rd_result_is_zero <= in_alu_rd_result_is_zero;
        alu_pc_result <= in_alu_pc_result;
        next_pc_src <= in_next_pc_src;
        reg_write_data_src <= in_reg_write_data_src;
        reg_wren <= in_reg_wren;
        ram_wren <= in_ram_wren;
    end
end

endmodule