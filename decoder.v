`timescale 1ns / 1ps
`include "define.v"

module DECODER(
    input [31:0] instruction,
    output reg [4:0] rs1_address,
    output reg [4:0] rs2_address,
    output reg [31:0] imm,
    output reg [4:0] rd_address,
    output reg [3:0] alu_rd_operator,
    output reg [1:0] alu_rd_operand1_src,
    output reg [2:0] alu_rd_operand2_src,
    output reg alu_pc_operand1_src,
    output reg [1:0] next_pc_src,
    output reg reg_write_data_src,
    output reg reg_wren,
    output reg ram_wren
);

wire [6:0] opcode;
assign opcode = instruction[6:0];
wire [2:0] funct3;
assign funct3 = instruction[14:12];
wire [6:0] funct7;
assign funct7 = instruction[31:25];

wire [31:0] imm_i;
assign imm_i = {20'b0, instruction[31:20]};
wire [31:0] imm_s;
assign imm_s = {20'b0, instruction[31:25], instruction[11:7]};
wire [31:0] imm_b;
assign imm_b = {19'b0, imm[31:31], imm[7:7], imm[30:25], imm[11:8], 1'b0};
wire [31:0] imm_u;
assign imm_u = {11'b0, instruction[31:12], 11'b0};
wire [31:0] imm_j;
assign imm_j = {11'b0, instruction[31:31], instruction[19:12], instruction[20:20], instruction[30:21], 1'b0};

always @* begin
    rs1_address <= instruction[19:15];
    rs2_address <= instruction[24:20];
    rd_address <= instruction[11:7];

    case(opcode)
        `OPCODE_R_BASE_INTEGER_REG: begin
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_RS2;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
            case(funct3)
                `FUNCT3_ADD_SUB: begin
                    case(funct7)
                        `FUNCT7_ADD: begin
                            alu_rd_operator <= `ALU_OPERATOR_ADD;
                        end
                        `FUNCT7_SUB: begin
                            alu_rd_operator <= `ALU_OPERATOR_SUB;
                        end
                    endcase
                end
                `FUNCT3_XOR: begin
                    alu_rd_operator <= `ALU_OPERATOR_XOR;
                end
                `FUNCT3_OR: begin
                    alu_rd_operator <= `ALU_OPERATOR_OR;
                end
                `FUNCT3_AND: begin
                    alu_rd_operator <= `ALU_OPERATOR_AND;
                end
                `FUNCT3_SLL: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLL;
                end
                `FUNCT3_SRL_SRA: begin
                    case(funct7)
                        `FUNCT7_SRL: begin
                            alu_rd_operator <= `ALU_OPERATOR_SRL;
                        end
                        `FUNCT7_SRA: begin
                            alu_rd_operator <= `ALU_OPERATOR_SRA;
                        end
                    endcase
                end
                `FUNCT3_SLT: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLT;
                end
                `FUNCT3_SLTU: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLTU;
                end
            endcase
        end
        `OPCODE_I_BASE_INTEGER_IMM: begin
            imm <= imm_i;

            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
            case(funct3)
                `FUNCT3_ADDI: begin
                    alu_rd_operator <= `ALU_OPERATOR_ADD;
                end
                `FUNCT3_XORI: begin
                    alu_rd_operator <= `ALU_OPERATOR_XOR;
                end
                `FUNCT3_ORI: begin
                    alu_rd_operator <= `ALU_OPERATOR_OR;
                end
                `FUNCT3_ANDI: begin
                    alu_rd_operator <= `ALU_OPERATOR_AND;
                end
                `FUNCT3_SLLI: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLL;
                end
                `FUNCT3_SRLI_SRAI: begin
                    case(funct7)
                        `FUNCT7_IMM_5_11_SRLI: begin
                            alu_rd_operator <= `ALU_OPERATOR_SRL;
                        end
                        `FUNCT7_IMM_5_11_SRAI: begin
                            alu_rd_operator <= `ALU_OPERATOR_SRA;
                        end
                    endcase
                end
                `FUNCT3_SLTI: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLT;
                end
                `FUNCT3_SLTIU: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLTU;
                end
            endcase
        end
        `OPCODE_I_BASE_LOAD: begin
            imm <= imm_i;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_RAM;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_S_BASE_STORE: begin
            imm <= imm_s;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= 0;
            reg_wren <= `REG_WRITE_DISABLE;
            ram_wren <= `RAM_WRITE_ENABLE;
        end
        `OPCODE_B_BASE_BRANCH: begin
            imm <= imm_b;

            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_RS2;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_PC;
            reg_write_data_src <= 0;
            reg_wren <= `REG_WRITE_DISABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
            case(funct3)
                `FUNCT3_BEQ: begin
                    alu_rd_operator <= `ALU_OPERATOR_SUB;
                    next_pc_src <= `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO;
                end
                `FUNCT3_BNE: begin
                    alu_rd_operator <= `ALU_OPERATOR_SUB;
                    next_pc_src <= `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO;
                end
                `FUNCT3_BLT: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLT;
                    next_pc_src <= `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO;
                end
                `FUNCT3_BGE: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLT;
                    next_pc_src <= `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO;
                end
                `FUNCT3_BLTU: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLTU;
                    next_pc_src <= `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO;
                end
                `FUNCT3_BGEU: begin
                    alu_rd_operator <= `ALU_OPERATOR_SLTU;
                    next_pc_src <= `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO;
                end
            endcase
        end
        `OPCODE_J_BASE_JAL: begin
            imm <= imm_j;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_PC;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_4;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_PC;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_I_BASE_JALR: begin
            imm <= imm_i;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_PC;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_4;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_RS1;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_U_BASE_LUI: begin
            imm <= imm_u;

            alu_rd_operator <= `ALU_OPERATOR_SLL;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_IMM;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_12;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_U_BASE_AUIPC: begin
            imm <= imm_u;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_PC;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_UPPER_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_wren <= `REG_WRITE_ENABLE;
            ram_wren <= `RAM_WRITE_DISABLE;
        end
    endcase
end

endmodule
