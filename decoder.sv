`timescale 1ns / 1ps
`include "define.sv"

module DECODER(
    input logic [31:0] instruction,
    output logic [4:0] rs1_address,
    output logic [4:0] rs2_address,
    output logic [31:0] imm,
    output logic [4:0] rd_address,
    output logic [4:0] alu_rd_operator,
    output logic [1:0] alu_rd_operand1_src,
    output logic [2:0] alu_rd_operand2_src,
    output logic alu_pc_operand1_src,
    output logic [1:0] next_pc_src,
    output logic [1:0] reg_write_data_src,
    output logic reg_write_enable,
    output logic ram_write_enable
);

logic [6:0] opcode;
logic [2:0] funct3;
logic [6:0] funct7;
logic [31:0] imm_i;
logic [31:0] imm_i_unsigned;
logic [31:0] imm_s;
logic [31:0] imm_b;
logic [31:0] imm_u;
logic [31:0] imm_j;

always_comb begin
    opcode <= instruction[6:0];
    funct3 <= instruction[14:12];
    funct7 <= instruction[31:25];
    imm_i <= {instruction[31] == 1 ? 20'hfffff : 20'h0, instruction[31:20]};
    imm_i_unsigned <= {20'b0, instruction[31:20]};
    imm_s <= {instruction[31] == 1 ? 20'hfffff : 20'h0, instruction[31:25], instruction[11:7]};
    imm_b <= {instruction[31] == 1 ? 19'h7ffff : 19'h0, instruction[31:31], instruction[7:7], instruction[30:25], instruction[11:8], 1'b0};
    imm_u <= {instruction[31] == 1 ? 11'h7ff : 11'h0, instruction[31:12], 11'b0};
    imm_j <= {instruction[31] == 1 ? 11'h7ff : 11'h0, instruction[31:31], instruction[19:12], instruction[20:20], instruction[30:21], 1'b0};
end

always_comb begin
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
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
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
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            case(funct3)
                `FUNCT3_ADDI: begin
                    imm <= imm_i;
                    alu_rd_operator <= `ALU_OPERATOR_ADD;
                end
                `FUNCT3_XORI: begin
                    imm <= imm_i;
                    alu_rd_operator <= `ALU_OPERATOR_XOR;
                end
                `FUNCT3_ORI: begin
                    imm <= imm_i;
                    alu_rd_operator <= `ALU_OPERATOR_OR;
                end
                `FUNCT3_ANDI: begin
                    imm <= imm_i;
                    alu_rd_operator <= `ALU_OPERATOR_AND;
                end
                `FUNCT3_SLLI: begin
                    imm <= imm_i_unsigned;
                    alu_rd_operator <= `ALU_OPERATOR_SLL;
                end
                `FUNCT3_SRLI_SRAI: begin
                    imm <= imm_i_unsigned;
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
                    imm <= imm_i;
                    alu_rd_operator <= `ALU_OPERATOR_SLT;
                end
                `FUNCT3_SLTIU: begin
                    imm <= imm_i_unsigned;
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
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_S_BASE_STORE: begin
            imm <= imm_s;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= 0;
            reg_write_enable <= `REG_WRITE_DISABLE;
            ram_write_enable <= `RAM_WRITE_ENABLE;
        end
        `OPCODE_B_BASE_BRANCH: begin
            imm <= imm_b;

            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_RS2;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_PC;
            reg_write_data_src <= 0;
            reg_write_enable <= `REG_WRITE_DISABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
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
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_I_BASE_JALR: begin
            imm <= imm_i;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_PC;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_4;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_RS1;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_U_BASE_LUI: begin
            imm <= imm_u;

            alu_rd_operator <= `ALU_OPERATOR_SLL;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_IMM;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_12;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_U_BASE_AUIPC: begin
            imm <= imm_u;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_PC;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_UPPER_IMM;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_write_enable <= `RAM_WRITE_DISABLE;
        end
        `OPCODE_R_STDIN_STDOUT: begin
            case (funct3)
                `FUNCT3_STDIN: begin
                    next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
                    reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
                    reg_write_enable <= `REG_WRITE_ENABLE;
                    ram_write_enable <= `RAM_WRITE_DISABLE;
                end
                `FUNCT3_STDOUT: begin
                    next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
                    reg_write_enable <= `REG_WRITE_DISABLE;
                    ram_write_enable <= `RAM_WRITE_DISABLE;
                end
            endcase
        end
    endcase
end

endmodule
