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
    output logic [2:0] next_pc_src,
    output logic [1:0] reg_write_data_src,
    output logic reg_write_enable,
    output logic ram_read,
    output logic ram_write_enable,
    output logic stdin_read_enable,
    output logic stdout_write_enable
);
logic instruction_31;
logic [6:0] instruction_31_25;
logic [11:0] instruction_31_20;
logic [19:0] instruction_31_12;
logic [5:0] instruction_30_25;
logic [9:0] instruction_30_21;
logic [4:0] instruction_24_20;
logic instruction_20;
logic [4:0] instruction_19_15;
logic [7:0] instruction_19_12;
logic [2:0] instruction_14_12;
logic [3:0] instruction_11_8;
logic [4:0] instruction_11_7;
logic instruction_7;
logic [6:0] instruction_6_0;

assign instruction_31 = instruction[31];
assign instruction_31_25 = instruction[31:25];
assign instruction_31_20 = instruction[31:20];
assign instruction_31_12 = instruction[31:12];
assign instruction_30_25 = instruction[30:25];
assign instruction_30_21 = instruction[30:21];
assign instruction_24_20 = instruction[24:20];
assign instruction_20 = instruction[20];
assign instruction_19_15 = instruction[19:15];
assign instruction_19_12 = instruction[19:12];
assign instruction_14_12 = instruction[14:12];
assign instruction_11_8 = instruction[11:8];
assign instruction_11_7 = instruction[11:7];
assign instruction_7 = instruction[7];
assign instruction_6_0 = instruction[6:0];

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
    opcode <= instruction_6_0;
    funct3 <= instruction_14_12;
    funct7 <= instruction_31_25;
    rs1_address <= instruction_19_15;
    rs2_address <= instruction_24_20;
    rd_address <= instruction_11_7;
    imm_i <= {instruction_31 ? 20'hfffff : 20'h0, instruction_31_20};
    imm_i_unsigned <= {20'b0, instruction_31_20};
    imm_s <= {instruction_31 ? 20'hfffff : 20'h0, instruction_31_25, instruction_11_7};
    imm_b <= {instruction_31 ? 19'h7ffff : 19'h0, instruction_31, instruction_7, instruction_30_25, instruction_11_8, 1'b0};
    imm_u <= {instruction_31 ? 12'hfff : 12'h0, instruction_31_12};
    imm_j <= {instruction_31 ? 11'h7ff : 11'h0, instruction_31, instruction_19_12, instruction_20, instruction_30_21, 1'b0};
end

always_comb begin
    case(opcode)
        `OPCODE_R_BASE_INTEGER_REG: begin
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_RS2;
            alu_pc_operand1_src <= 0;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            case(funct3)
                `FUNCT3_ADD_SUB_MUL: begin
                    case(funct7)
                        `FUNCT7_ADD: begin
                            alu_rd_operator <= `ALU_OPERATOR_ADD;
                        end
                        `FUNCT7_SUB: begin
                            alu_rd_operator <= `ALU_OPERATOR_SUB;
                        end
                        `FUNCT7_MUL: begin
                            alu_rd_operator <= `ALU_OPERATOR_MUL;
                        end
                    endcase
                end
                `FUNCT3_XOR_DIV: begin
                    case(funct7)
                        `FUNCT7_XOR: begin
                            alu_rd_operator <= `ALU_OPERATOR_XOR;
                        end
                        `FUNCT7_DIV: begin
                            alu_rd_operator <= `ALU_OPERATOR_DIV;
                        end
                    endcase
                end
                `FUNCT3_OR_REM: begin
                    case(funct7)
                        `FUNCT7_OR: begin
                            alu_rd_operator <= `ALU_OPERATOR_OR;
                        end
                        `FUNCT7_REM: begin
                            alu_rd_operator <= `ALU_OPERATOR_REM;
                        end
                    endcase
                end
                `FUNCT3_AND_REMU: begin
                    case(funct7)
                        `FUNCT7_AND: begin
                            alu_rd_operator <= `ALU_OPERATOR_AND;
                        end
                        `FUNCT7_REMU: begin
                            alu_rd_operator <= `ALU_OPERATOR_REMU;
                        end
                    endcase
                end
                `FUNCT3_SLL_MULH: begin
                    case(funct7)
                        `FUNCT7_SLL: begin
                            alu_rd_operator <= `ALU_OPERATOR_SLL;
                        end
                        `FUNCT7_MULH: begin
                            alu_rd_operator <= `ALU_OPERATOR_MULH;
                        end
                    endcase
                end
                `FUNCT3_SRL_SRA_DIVU: begin
                    case(funct7)
                        `FUNCT7_SRL: begin
                            alu_rd_operator <= `ALU_OPERATOR_SRL;
                        end
                        `FUNCT7_SRA: begin
                            alu_rd_operator <= `ALU_OPERATOR_SRA;
                        end
                        `FUNCT7_DIVU: begin
                            alu_rd_operator <= `ALU_OPERATOR_DIVU;
                        end
                    endcase
                end
                `FUNCT3_SLT_MULU: begin
                    case(funct7)
                        `FUNCT7_SLT: begin
                            alu_rd_operator <= `ALU_OPERATOR_SLT;
                        end
                        `FUNCT7_MULU: begin
                            alu_rd_operator <= `ALU_OPERATOR_MULU;
                        end
                    endcase
                end
                `FUNCT3_SLTU_MULHU: begin
                    case(funct7)
                        `FUNCT7_SLTU: begin
                            alu_rd_operator <= `ALU_OPERATOR_SLTU;
                        end
                        `FUNCT7_MULHU: begin
                            alu_rd_operator <= `ALU_OPERATOR_MULHU;
                        end
                    endcase
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
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
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
            ram_read <= 1;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
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
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_ENABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
        end
        `OPCODE_B_BASE_BRANCH: begin
            imm <= imm_b;

            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_RS1;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_RS2;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_PC;
            reg_write_data_src <= 0;
            reg_write_enable <= `REG_WRITE_DISABLE;
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
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
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_2;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_PC;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
        end
        `OPCODE_I_BASE_JALR: begin
            imm <= imm_i;

            alu_rd_operator <= `ALU_OPERATOR_ADD;
            alu_rd_operand1_src <= `ALU_RD_OPERAND1_SRC_PC;
            alu_rd_operand2_src <= `ALU_RD_OPERAND2_SRC_2;
            alu_pc_operand1_src <= `ALU_PC_OPERAND1_SRC_RS1;
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_BRANCH;
            reg_write_data_src <= `REG_WRITE_DATA_SRC_ALU;
            reg_write_enable <= `REG_WRITE_ENABLE;
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
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
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
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
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
        end
        `OPCODE_R_STDIN_STDOUT: begin
            next_pc_src <= `NEXT_PC_SRC_ALWAYS_NOT_BRANCH;
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            case (funct3)
                `FUNCT3_STDIN: begin
                    reg_write_data_src <= `REG_WRITE_DATA_SRC_STDIN;
                    reg_write_enable <= `REG_WRITE_ENABLE;
                    stdin_read_enable <= 1;
                    stdout_write_enable <= 0;
                end
                `FUNCT3_STDOUT: begin
                    reg_write_enable <= `REG_WRITE_DISABLE;
                    stdin_read_enable <= 0;
                    stdout_write_enable <= 1;
                end
            endcase
        end
        `OPCODE_I_FINISH: begin
            next_pc_src <= `NEXT_PC_SRC_FINISH;
            ram_read <= 0;
            ram_write_enable <= `RAM_WRITE_DISABLE;
            reg_write_enable <= `REG_WRITE_DISABLE;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
        end
    endcase
end

endmodule
