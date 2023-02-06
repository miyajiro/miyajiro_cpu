`timescale 1ns / 1ps
`include "define.sv"
module MIYAJIRO_CPU(
    input logic reset_n,
    input logic clk
);

// STAGE_CONTROLLER
logic stage_controller_stage_reset_n;
logic stage_controller_wb_if_wren;
logic stage_controller_if_id_wren;
logic stage_controller_id_ex_wren;
logic stage_controller_ex_mem_wren;
logic stage_controller_mem_wb_wren;
logic stage_controller_ram_wren;
logic stage_controller_reg_wren;
logic stage_controller_pc_wren;

STAGE_CONTROLLER stage_controller(
    .reset_n(reset_n),
    .clk(clk),
    .pc_wren(stage_controller_pc_wren),
    .wb_if_wren(stage_controller_wb_if_wren),
    .if_id_wren(stage_controller_if_id_wren),
    .id_ex_wren(stage_controller_id_ex_wren),
    .ex_mem_wren(stage_controller_ex_mem_wren),
    .mem_wb_wren(stage_controller_mem_wb_wren),
    .ram_wren(stage_controller_ram_wren),
    .reg_wren(stage_controller_reg_wren),
    .stage_reset_n(stage_controller_stage_reset_n)
);

// WB -> IF
logic [31:0] wb_next_pc_data;
logic [31:0] if_pc_data;
WB_IF_PIPELINE_REGISTER wb_if_pipeline_register(
    .reset_n(stage_controller_stage_reset_n),
    .clk(clk),
    .wren(stage_controller_wb_if_wren),
    .in_next_pc_data(wb_next_pc_data),
    .next_pc_data(if_pc_data)
);

// IF
logic [31:0] if_rom_data;
ROM rom(
    .clk(clk),
    .reset_n(reset_n),
    .address(if_pc_data[`ROM_ADDRESS_BITWIDTH - 1:0]),
    .data(if_rom_data)
);

// IF -> ID
logic [31:0] id_instruction_data;
logic [31:0] id_pc_data;
IF_ID_PIPELINE_REGISTER if_id_pipeline_register(
    .reset_n(stage_controller_stage_reset_n),
    .clk(clk),
    .wren(stage_controller_if_id_wren),
    .in_instruction(if_rom_data),
    .in_pc_data(if_pc_data),
    .instruction(id_instruction_data),
    .pc_data(id_pc_data)
);

// ID
logic [4:0] id_rs1_address;
logic [4:0] id_rs2_address;
logic [31:0] id_imm;
logic [4:0] id_rd_address;
logic [4:0] id_alu_rd_operator;
logic [1:0] id_alu_rd_operand1_src;
logic [2:0] id_alu_rd_operand2_src;
logic id_alu_pc_operand1_src;
logic [1:0] id_next_pc_src;
logic id_reg_write_data_src;
logic id_reg_wren;
logic id_ram_wren;

DECODER decoder(
    .instruction(id_instruction_data),
    .rs1_address(id_rs1_address),
    .rs2_address(id_rs2_address),
    .imm(id_imm),
    .rd_address(id_rd_address),
    .alu_rd_operator(id_alu_rd_operator),
    .alu_rd_operand1_src(id_alu_rd_operand1_src),
    .alu_rd_operand2_src(id_alu_rd_operand2_src),
    .alu_pc_operand1_src(id_alu_pc_operand1_src),
    .next_pc_src(id_next_pc_src),
    .reg_write_data_src(id_reg_write_data_src),
    .reg_wren(id_reg_wren),
    .ram_wren(id_ram_wren)
);

logic [31:0] id_rs1_data;
logic [31:0] id_rs2_data;

logic wb_reg_combined_wren;
logic [4:0] wb_rd_address;
logic [31:0] wb_reg_write_data;

REGISTER_FILE regfile(
    .reset_n(reset_n),
    .clk(clk),
    .reg_wren(wb_reg_combined_wren),
    .read_address1(id_rs1_address),
    .read_address2(id_rs2_address),
    .write_address(wb_rd_address), // WBステージで設定.
    .write_data(wb_reg_write_data), // WBステージで設定.
    .read_data1(id_rs1_data),
    .read_data2(id_rs2_data)
);

// ID -> EX
logic [31:0] ex_pc_data;
logic [31:0] ex_rs1_data;
logic [31:0] ex_rs2_data;
logic [31:0] ex_imm;
logic [4:0] ex_rd_address;
logic [4:0] ex_alu_rd_operator;
logic [1:0] ex_alu_rd_operand1_src;
logic [2:0] ex_alu_rd_operand2_src;
logic ex_alu_pc_operand1_src;
logic [1:0] ex_next_pc_src;
logic ex_reg_write_data_src;
logic ex_reg_wren;
logic ex_ram_wren;

ID_EX_PIPELINE_REGISTER id_ex_pipeline_register(
    .reset_n(stage_controller_stage_reset_n),
    .clk(clk),
    .wren(stage_controller_id_ex_wren),
    .in_pc_data(id_pc_data),
    .in_rs1_data(id_rs1_data),
    .in_rs2_data(id_rs2_data),
    .in_imm(id_imm),
    .in_rd_address(id_rd_address),
    .in_alu_rd_operator(id_alu_rd_operator),
    .in_alu_rd_operand1_src(id_alu_rd_operand1_src),
    .in_alu_rd_operand2_src(id_alu_rd_operand2_src),
    .in_alu_pc_operand1_src(id_alu_pc_operand1_src),
    .in_next_pc_src(id_next_pc_src),
    .in_reg_write_data_src(id_reg_write_data_src),
    .in_reg_wren(id_reg_wren),
    .in_ram_wren(id_ram_wren),
    .pc_data(ex_pc_data),
    .rs1_data(ex_rs1_data),
    .rs2_data(ex_rs2_data),
    .imm(ex_imm),
    .rd_address(ex_rd_address),
    .alu_rd_operator(ex_alu_rd_operator),
    .alu_rd_operand1_src(ex_alu_rd_operand1_src),
    .alu_rd_operand2_src(ex_alu_rd_operand2_src),
    .alu_pc_operand1_src(ex_alu_pc_operand1_src),
    .next_pc_src(ex_next_pc_src),
    .reg_write_data_src(ex_reg_write_data_src),
    .reg_wren(ex_reg_wren),
    .ram_wren(ex_ram_wren)
);

// EX
logic [31:0] ex_alu_rd_operand1;
always_comb begin
    case(ex_alu_rd_operand1_src)
        `ALU_RD_OPERAND1_SRC_RS1: begin
            ex_alu_rd_operand1 <= ex_rs1_data;
        end
        `ALU_RD_OPERAND1_SRC_IMM: begin
            ex_alu_rd_operand1 <= ex_imm;
        end
        `ALU_RD_OPERAND1_SRC_PC: begin
            ex_alu_rd_operand1 <= ex_pc_data;
        end
        default: begin
            ex_alu_rd_operand1 <= 0;
        end
    endcase
end


logic [31:0] ex_alu_rd_operand2;
assign ex_alu_rd_operand2 =
    ex_alu_rd_operand2_src == `ALU_RD_OPERAND2_SRC_RS2
        ? ex_rs2_data :
    ex_alu_rd_operand2_src == `ALU_RD_OPERAND2_SRC_IMM
        ? ex_imm :
    ex_alu_rd_operand2_src == `ALU_RD_OPERAND2_SRC_4
        ? 4 :
    ex_alu_rd_operand2_src == `ALU_RD_OPERAND2_SRC_12
        ? 12 :
    ex_alu_rd_operand2_src == `ALU_RD_OPERAND2_SRC_UPPER_IMM
        ? (ex_imm << 12)
    : 0;

logic [31:0] ex_alu_pc_operand1;
assign ex_alu_pc_operand1 =
    ex_alu_pc_operand1_src == `ALU_PC_OPERAND1_SRC_PC
        ? ex_pc_data :
    ex_alu_pc_operand1_src == `ALU_PC_OPERAND1_SRC_RS1
        ? ex_rs1_data
    : 0;

logic [31:0] ex_alu_rd_result;
logic ex_alu_rd_result_is_zero;
ALU alu_rd(
    .operator(ex_alu_rd_operator),
    .operand1(ex_alu_rd_operand1),
    .operand2(ex_alu_rd_operand2),
    .result(ex_alu_rd_result),
    .result_is_zero(ex_alu_rd_result_is_zero)
);

logic [31:0] ex_alu_pc_result;
ALU alu_pc(
    .operator(`ALU_OPERATOR_ADD),
    .operand1(ex_alu_pc_operand1),
    .operand2(ex_imm),
    .result(ex_alu_pc_result)
);

// EX -> MEM
logic [31:0] mem_pc_data;
logic [31:0] mem_rs2_data;
logic [4:0] mem_rd_address;
logic [31:0] mem_alu_rd_result;
logic mem_alu_rd_result_is_zero;
logic [31:0] mem_alu_pc_result;
logic [1:0] mem_next_pc_src;
logic mem_reg_write_data_src;
logic mem_reg_wren;
logic mem_ram_wren;

EX_MEM_PIPELINE_REGISTER ex_mem_pipeline_register(
    .reset_n(stage_controller_stage_reset_n),
    .clk(clk),
    .wren(stage_controller_ex_mem_wren),
    .in_pc_data(ex_pc_data),
    .in_rs2_data(ex_rs2_data),
    .in_rd_address(ex_rd_address),
    .in_alu_rd_result(ex_alu_rd_result),
    .in_alu_rd_result_is_zero(ex_alu_rd_result_is_zero),
    .in_alu_pc_result(ex_alu_pc_result),
    .in_next_pc_src(ex_next_pc_src),
    .in_reg_write_data_src(ex_reg_write_data_src),
    .in_reg_wren(ex_reg_wren),
    .in_ram_wren(ex_ram_wren),
    .pc_data(mem_pc_data),
    .rs2_data(mem_rs2_data),
    .rd_address(mem_rd_address),
    .alu_rd_result(mem_alu_rd_result),
    .alu_rd_result_is_zero(mem_alu_rd_result_is_zero),
    .alu_pc_result(mem_alu_pc_result),
    .next_pc_src(mem_next_pc_src),
    .reg_write_data_src(mem_reg_write_data_src),
    .reg_wren(mem_reg_wren),
    .ram_wren(mem_ram_wren)
);

// MEM
logic [`RAM_ADDRESS_BITWIDTH - 1:0] ram_addr;
always_comb begin
    ram_addr <= mem_alu_rd_result[`RAM_ADDRESS_BITWIDTH - 1:0];
end

logic [31:0] mem_pc_data_plus_4;
assign mem_pc_data_plus_4 = mem_pc_data + 4;
logic [31:0] mem_next_pc_data;
always_comb begin
    case(mem_next_pc_src)
        `NEXT_PC_SRC_ALWAYS_NOT_BRANCH: begin
            mem_next_pc_data <= mem_pc_data_plus_4;
        end
        `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO: begin
            mem_next_pc_data <= mem_alu_rd_result_is_zero == `ALU_RD_RESULT_IS_ZERO
                ? mem_alu_pc_result
                : mem_pc_data_plus_4;
        end
        `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO: begin
            mem_next_pc_data <= mem_alu_rd_result_is_zero == `ALU_RD_RESULT_IS_NOT_ZERO
                ? mem_alu_pc_result
                : mem_pc_data_plus_4;
        end
        `NEXT_PC_SRC_ALWAYS_BRANCH: begin
            mem_next_pc_data <= mem_alu_pc_result;
        end
    endcase
end

logic [31:0] ram_data;
logic ram_combined_wren;
assign ram_combined_wren = (stage_controller_ram_wren & (mem_ram_wren == `RAM_WRITE_ENABLE));
RAM ram(
    .clk(clk),
    .address(ram_addr[`RAM_ADDRESS_BITWIDTH - 1:0]),
    .data(ram_data),
    .write_data(mem_rs2_data),
    .wren(ram_combined_wren)
);

// MEM -> WB
logic [31:0] wb_ram_data;
logic [31:0] wb_alu_rd_result;
logic wb_reg_write_data_src;
logic wb_reg_wren;
MEM_WB_PIPELINE_REGISTER mem_wb_pipeline_register(
    .reset_n(stage_controller_stage_reset_n),
    .clk(clk),
    .wren(stage_controller_mem_wb_wren),
    .in_ram_data(ram_data),
    .in_alu_rd_result(mem_alu_rd_result),
    .in_rd_address(mem_rd_address),
    .in_reg_write_data_src(mem_reg_write_data_src),
    .in_reg_wren(mem_reg_wren),
    .in_next_pc_data(mem_next_pc_data),
    .ram_data(wb_ram_data),
    .alu_rd_result(wb_alu_rd_result),
    .rd_address(wb_rd_address),
    .reg_write_data_src(wb_reg_write_data_src),
    .reg_wren(wb_reg_wren),
    .next_pc_data(wb_next_pc_data)
);

// WB
assign wb_reg_combined_wren = (stage_controller_reg_wren & (wb_reg_wren == `REG_WRITE_ENABLE));

always_comb begin
    wb_reg_write_data <=
        wb_reg_write_data_src == `REG_WRITE_DATA_SRC_ALU
            ? wb_alu_rd_result :
        wb_reg_write_data_src == `REG_WRITE_DATA_SRC_RAM
            ? wb_ram_data :
        0;
end

endmodule
