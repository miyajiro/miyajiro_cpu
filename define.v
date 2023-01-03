`timescale 1ns / 1ps
// RAM
`define RAM_SIZE 8192
`define RAM_ADDRESS_BITWIDTH 13

// ROM
`define ROM_SIZE 1024
`define ROM_ADDRESS_BITWIDTH 10

// STAGE CONTROLLER
`define STAGE_INIT      3'h0
`define STAGE_IF        3'h1
`define STAGE_IF_WAIT   3'h2
`define STAGE_ID        3'h3
`define STAGE_EX        3'h4
`define STAGE_MEM       3'h5
`define STAGE_MEM_WAIT  3'h6
`define STAGE_WB        3'h7

// CONTROL
`define ALU_RD_OPERAND1_SRC_RS1         2'h0
`define ALU_RD_OPERAND1_SRC_IMM         2'h1
`define ALU_RD_OPERAND1_SRC_PC          2'h2

`define ALU_RD_OPERAND2_SRC_RS2         3'h0
`define ALU_RD_OPERAND2_SRC_IMM         3'h1
`define ALU_RD_OPERAND2_SRC_4           3'h2
`define ALU_RD_OPERAND2_SRC_12          3'h3
`define ALU_RD_OPERAND2_SRC_UPPER_IMM   3'h4

`define ALU_PC_OPERAND1_SRC_PC  1'b0
`define ALU_PC_OPERAND1_SRC_RS1 1'b1

`define NEXT_PC_SRC_ALWAYS_NOT_BRANCH                   2'h0
`define NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO        2'h1
`define NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO    2'h2
`define NEXT_PC_SRC_ALWAYS_BRANCH                       2'h3

`define REG_WRITE_ENABLE        1'b1
`define REG_WRITE_DISABLE       1'b0

`define RAM_WRITE_ENABLE        1'b1
`define RAM_WRITE_DISABLE       1'b0

`define REG_WRITE_DATA_SRC_ALU  1'b0
`define REG_WRITE_DATA_SRC_RAM  1'b1

`define ALU_RD_RESULT_IS_ZERO      1'b1
`define ALU_RD_RESULT_IS_NOT_ZERO  1'b0

// OPCODE
`define OPCODE_R_BASE_INTEGER_REG   7'b0110011
`define OPCODE_I_BASE_INTEGER_IMM   7'b0010011
`define OPCODE_I_BASE_LOAD          7'b0000011
`define OPCODE_S_BASE_STORE         7'b0100011
`define OPCODE_B_BASE_BRANCH        7'b1100011
`define OPCODE_J_BASE_JAL           7'b1101111
`define OPCODE_I_BASE_JALR          7'b1100111
`define OPCODE_U_BASE_LUI           7'b0110111
`define OPCODE_U_BASE_AUIPC         7'b0010111
`define OPCODE_R_FLOAT_ARITHMETIC   7'b0111011
`define OPCODE_I_FLOAT_LOAD         7'b0001011
`define OPCODE_S_FLOAT_STORE        7'b0101011

// FUNCT3
`define FUNCT3_ADD_SUB      3'h0
`define FUNCT3_XOR          3'h4
`define FUNCT3_OR           3'h6
`define FUNCT3_AND          3'h7
`define FUNCT3_SLL          3'h1
`define FUNCT3_SRL_SRA      3'h5
`define FUNCT3_SLT          3'h2
`define FUNCT3_SLTU         3'h3

`define FUNCT3_ADDI         3'h0
`define FUNCT3_XORI         3'h4
`define FUNCT3_ORI          3'h6
`define FUNCT3_ANDI         3'h7
`define FUNCT3_SLLI         3'h1
`define FUNCT3_SRLI_SRAI    3'h5
`define FUNCT3_SLTI         3'h2
`define FUNCT3_SLTIU        3'h3

`define FUNCT3_LW           3'h2

`define FUNCT3_SW           3'h2

`define FUNCT3_BEQ          3'h0
`define FUNCT3_BNE          3'h1
`define FUNCT3_BLT          3'h4
`define FUNCT3_BGE          3'h5
`define FUNCT3_BLTU         3'h6
`define FUNCT3_BGEU         3'h7

`define FUNCT3_JALR         3'h0

`define FUNCT3_MUL          3'h0
`define FUNCT3_MULH         3'h1
`define FUNCT3_MULSU        3'h2
`define FUNCT3_MULU         3'h3
`define FUNCT3_DIV          3'h4
`define FUNCT3_DIVU         3'h5
`define FUNCT3_REM          3'h6
`define FUNCT3_REMU         3'h7

// FUNCT7
`define FUNCT7_ADD              7'h00
`define FUNCT7_SUB              7'h20
`define FUNCT7_XOR              7'h00
`define FUNCT7_OR               7'h00
`define FUNCT7_AND              7'h00
`define FUNCT7_SLL              7'h00
`define FUNCT7_SRL              7'h00
`define FUNCT7_SRA              7'h20
`define FUNCT7_SLT              7'h00
`define FUNCT7_SLTU             7'h00

`define FUNCT7_IMM_5_11_SLLI    7'h00
`define FUNCT7_IMM_5_11_SRLI    7'h00
`define FUNCT7_IMM_5_11_SRAI    7'h20

`define FUNCT7_MUL              7'h01
`define FUNCT7_MULH             7'h01
`define FUNCT7_MULSU            7'h01
`define FUNCT7_MULU             7'h01
`define FUNCT7_DIV              7'h01
`define FUNCT7_DIVU             7'h01
`define FUNCT7_REM              7'h01
`define FUNCT7_REMU             7'h01

// ALU_OPERATOR
`define ALU_OPERATOR_ADD      4'h0
`define ALU_OPERATOR_SUB      4'h1
`define ALU_OPERATOR_XOR      4'h2
`define ALU_OPERATOR_OR       4'h3
`define ALU_OPERATOR_AND      4'h4
`define ALU_OPERATOR_SLL      4'h5
`define ALU_OPERATOR_SRL      4'h6
`define ALU_OPERATOR_SRA      4'h7
`define ALU_OPERATOR_SLT      4'h8
`define ALU_OPERATOR_SLTU     4'h9

// ALU_RESULT
`define ALU_RESULT_IS_NOT_ZERO  2'h0
`define ALU_RESULT_IS_ZERO      2'h1

// REG_NUM
`define ZERO_REG_NUM    5'h00
`define RA_REG_NUM      5'h01
`define SP_REG_NUM      5'h02
`define GP_REG_NUM      5'h03
`define TP_REG_NUM      5'h04
`define T0_REG_NUM      5'h05
`define T1_REG_NUM      5'h06
`define T2_REG_NUM      5'h07
`define S0_FP_REG_NUM   5'h08
`define S1_REG_NUM      5'h09
`define A0_REG_NUM      5'h0A
`define A1_REG_NUM      5'h0B
`define A2_REG_NUM      5'h0C
`define A3_REG_NUM      5'h0D
`define A4_REG_NUM      5'h0E
`define A5_REG_NUM      5'h0F
`define A6_REG_NUM      5'h10
`define A7_REG_NUM      5'h11
`define S2_REG_NUM      5'h12
`define S3_REG_NUM      5'h13
`define S4_REG_NUM      5'h14
`define S5_REG_NUM      5'h15
`define S6_REG_NUM      5'h16
`define S7_REG_NUM      5'h17
`define S8_REG_NUM      5'h18
`define S9_REG_NUM      5'h19
`define S10_REG_NUM     5'h1A
`define S11_REG_NUM     5'h1B
`define T3_REG_NUM      5'h1C
`define T4_REG_NUM      5'h1D
`define T5_REG_NUM      5'h1E
`define T6_REG_NUM      5'h1F
