`timescale 1ns / 1ps
module MEM_WB_PIPELINE_REGISTER(
    input logic reset_n,
    input logic clk,
    input logic wr_en,
    input logic [31:0] in_ram_data,
    input logic [31:0] in_alu_rd_result,
    input logic [4:0] in_rd_address,
    input logic in_reg_write_data_src,
    input logic in_reg_wr_en,
    input logic [31:0] in_next_pc_data,
    output logic [31:0] ram_data,
    output logic [31:0] alu_rd_result,
    output logic [4:0] rd_address,
    output logic reg_write_data_src,
    output logic reg_wr_en,
    output logic [31:0] next_pc_data
);

always_ff @(posedge clk) begin
    if(!reset_n) begin
        ram_data <= 0;
        alu_rd_result <= 0;
        rd_address <= 0;
        reg_write_data_src <= 0;
        reg_wr_en <= 0;
        next_pc_data <= 0;
    end
    else if(wr_en) begin
        ram_data <= in_ram_data;
        alu_rd_result <= in_alu_rd_result;
        rd_address <= in_rd_address;
        reg_write_data_src <= in_reg_write_data_src;
        reg_wr_en <= in_reg_wr_en;
        next_pc_data <= in_next_pc_data;
    end
end
endmodule