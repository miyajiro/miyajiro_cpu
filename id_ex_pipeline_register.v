module ID_EX_PIPELINE_REGISTER (
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_pc_data,
    input [31:0] in_rs1_data,
    input [31:0] in_rs2_data,
    input [31:0] in_imm,
    input [4:0] in_rd_address,
    input [3:0] in_alu_rd_operator,
    input [1:0] in_alu_rd_operand1_src,
    input [2:0] in_alu_rd_operand2_src,
    input in_alu_pc_operand1_src,
    input in_next_pc_src,
    input in_reg_write_data_src,
    input in_reg_wren,
    input in_ram_wren,
    output reg [31:0] pc_data,
    output reg [31:0] rs1_data,
    output reg [31:0] rs2_data,
    output reg [31:0] imm,
    output reg [4:0] rd_address,
    output reg [3:0] alu_rd_operator,
    output reg [1:0] alu_rd_operand1_src,
    output reg [2:0] alu_rd_operand2_src,
    output reg alu_pc_operand1_src,
    output reg next_pc_src,
    output reg reg_write_data_src,
    output reg reg_wren,
    output reg ram_wren
);

always @(posedge clk) begin
    if(!reset_n) begin
        pc_data <= 0;
        rs1_data <= 0;
        rs2_data <= 0;
        imm <= 0;
        rd_address <= 0;
        alu_rd_operator <= 0;
        alu_rd_operand1_src <= 0;
        alu_rd_operand2_src <= 0;
        alu_pc_operand1_src <= 0;
        next_pc_src <= 0;
        reg_write_data_src <= 0;
        reg_wren <= 0;
        ram_wren <= 0;
    end
    else if(wren) begin
        pc_data <= in_pc_data;
        rs1_data <= in_rs1_data;
        rs2_data <= in_rs2_data;
        imm <= in_imm;
        rd_address <= in_rd_address;
        alu_rd_operator <= in_alu_rd_operator;
        alu_rd_operand1_src <= in_alu_rd_operand1_src;
        alu_rd_operand2_src <= in_alu_rd_operand2_src;
        alu_pc_operand1_src <= in_alu_pc_operand1_src;
        next_pc_src <= in_next_pc_src;
        reg_write_data_src <= in_reg_write_data_src;
        reg_wren <= in_reg_wren;
        ram_wren <= in_ram_wren;
    end
end

endmodule