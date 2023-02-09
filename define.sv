`timescale 1ns / 1ps
// CLK PAR
// `define CLK_PER_HALF_BIT 5208 // 100 MHz,   9600 baud
`define CLK_PER_HALF_BIT 434  // 100 MHz, 115200 baud

// RAM
// `define RAM_ADDRESS_BITWIDTH 17 // 本番
// `define RAM_SIZE 131072 // 本番
`define RAM_ADDRESS_BITWIDTH 10 // test
`define RAM_SIZE 1024 // test

// PROGRAM_MEMORY
// `define PROGRAM_MEMORY_ADDRESS_BITWIDTH 17 // 本番
// `define PROGRAM_MEMORY_SIZE_BYTE 131072 // 本番
`define PROGRAM_MEMORY_ADDRESS_BITWIDTH 10 // test
`define PROGRAM_MEMORY_SIZE_BYTE 1024 // test

// STDIN_MEMORY
// `define STDIN_MEMORY_FIFO_BRAM_ADDRESS_SIZE 2048　// 本番
// `define STDIN_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH 11 // 本番
`define STDIN_MEMORY_FIFO_BRAM_ADDRESS_SIZE 1024 // test
`define STDIN_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH 10 // test

// STDOUT_MEMORY
// `define STDOUT_MEMORY_FIFO_BRAM_ADDRESS_SIZE 131072 // 本番
// `define STDOUT_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH 17 // 本番
// `define STDOUT_MEMORY_FIFO_BRAM_ADDRESS_SIZE 1024 // test
// `define STDOUT_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH 10 // test
`define STDOUT_MEMORY_FIFO_BRAM_ADDRESS_SIZE 16 // stall test
`define STDOUT_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH 4 // stall test

// STATE CONTROLLER
`define STATE_INIT                      4'h0
`define STATE_TRANSMIT_0x99             4'h1
`define STATE_RECEIVE_PROGRAM_DATA_SIZE 4'h2
`define STATE_RECEIVE_PROGRAM_DATA      4'h3
`define STATE_TRANSMIT_0xAA             4'h4
`define STATE_IF                        4'h5
`define STATE_IF_ID                     4'h6
`define STATE_ID                        4'h7
`define STATE_ID_EX                     4'h8
`define STATE_EX_MEM                    4'h9
`define STATE_MEM                       4'hA
`define STATE_MEM_WB                    4'hB
`define STATE_WB                        4'hC
`define STATE_WB_IF                     4'hD

// CONTROL
`define ALU_RD_OPERAND1_SRC_RS1         2'h0
`define ALU_RD_OPERAND1_SRC_IMM         2'h1
`define ALU_RD_OPERAND1_SRC_PC          2'h2

`define ALU_RD_OPERAND2_SRC_RS2         3'h0
`define ALU_RD_OPERAND2_SRC_IMM         3'h1
`define ALU_RD_OPERAND2_SRC_2           3'h2
`define ALU_RD_OPERAND2_SRC_12          3'h3
`define ALU_RD_OPERAND2_SRC_UPPER_IMM   3'h4

`define ALU_PC_OPERAND1_SRC_PC  1'b0
`define ALU_PC_OPERAND1_SRC_RS1 1'b1

`define NEXT_PC_SRC_FINISH                              3'h0
`define NEXT_PC_SRC_ALWAYS_NOT_BRANCH                   3'h1
`define NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO        3'h2
`define NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO    3'h3
`define NEXT_PC_SRC_ALWAYS_BRANCH                       3'h4

`define REG_WRITE_ENABLE        1'b1
`define REG_WRITE_DISABLE       1'b0

`define RAM_WRITE_ENABLE        1'b1
`define RAM_WRITE_DISABLE       1'b0

`define REG_WRITE_DATA_SRC_ALU      2'b0
`define REG_WRITE_DATA_SRC_RAM      2'b1
`define REG_WRITE_DATA_SRC_STDIN    2'h2

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
`define OPCODE_R_STDIN_STDOUT       7'b1111111
`define OPCODE_I_FINISH             7'b0000000

// FUNCT3
`define FUNCT3_ADD_SUB_MUL       3'h0
`define FUNCT3_XOR_DIV           3'h4
`define FUNCT3_OR_REM            3'h6
`define FUNCT3_AND_REMU          3'h7
`define FUNCT3_SLL_MULH          3'h1
`define FUNCT3_SRL_SRA_DIVU      3'h5
`define FUNCT3_SLT_MULU          3'h2
`define FUNCT3_SLTU_MULHU        3'h3

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

`define FUNCT3_STDIN        3'h0
`define FUNCT3_STDOUT       3'h1

`define FUNCT3_FINISH       3'h0

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
`define FUNCT7_MULU             7'h01
`define FUNCT7_MULHU            7'h01
`define FUNCT7_DIV              7'h01
`define FUNCT7_DIVU             7'h01
`define FUNCT7_REM              7'h01
`define FUNCT7_REMU             7'h01

`define FUNCT7_STDIN            7'h0
`define FUNCT7_STDOUT           7'h0

// ALU_OPERATOR
`define ALU_OPERATOR_ADD      5'h0
`define ALU_OPERATOR_SUB      5'h1
`define ALU_OPERATOR_XOR      5'h2
`define ALU_OPERATOR_OR       5'h3
`define ALU_OPERATOR_AND      5'h4
`define ALU_OPERATOR_SLL      5'h5
`define ALU_OPERATOR_SRL      5'h6
`define ALU_OPERATOR_SRA      5'h7
`define ALU_OPERATOR_SLT      5'h8
`define ALU_OPERATOR_SLTU     5'h9
`define ALU_OPERATOR_MUL      5'h10
`define ALU_OPERATOR_MULH     5'h11
`define ALU_OPERATOR_MULU     5'h12
`define ALU_OPERATOR_MULHU    5'h13
`define ALU_OPERATOR_DIV      5'h14
`define ALU_OPERATOR_DIVU     5'h15
`define ALU_OPERATOR_REM      5'h16
`define ALU_OPERATOR_REMU     5'h17

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
