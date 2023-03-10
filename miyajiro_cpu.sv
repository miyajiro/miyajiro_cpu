`timescale 1ns / 1ps
`include "define.sv"
`include "alu.sv"
`include "decoder.sv"
`include "ex_mem_pipeline_register.sv"
`include "fifo.sv"
`include "id_ex_pipeline_register.sv"
`include "if_id_pipeline_register.sv"
`include "mem_wb_pipeline_register.sv"
`include "wb_if_pipeline_register.sv"
`include "program_memory.sv"
`include "ram.sv"
`include "register_file.sv"
`include "state_controller.sv"
`include "uart_controller.sv"

module MIYAJIRO_CPU(
    input logic reset_n,
    input logic clk,
    input logic cpu_uart_rxd,
    output logic cpu_uart_txd
);

// STATE_CONTROLLER

// stall
logic stall;
always_comb begin
    stall <= mem_ram_read_stall | stdin_read_stall | stdout_write_stall;
end

STATE_CONTROLLER state_controller(
    .reset_n(reset_n),
    .clk(clk),
    .stall(stall),
    .transmit_0x99_finished(uart_controller_transmit_0x99_finished),
    .receive_program_data_size_finished(uart_controller_receive_program_data_size_finished),
    .receive_program_data_finished(uart_controller_receive_program_data_finished),
    .transmit_0xAA_finished(uart_controller_transmit_0xAA_finished),

    .transmit_0x99(state_controller_transmit_0x99),
    .receive_program_data_size(state_controller_receive_program_data_size),
    .receive_program_data(state_controller_receive_program_data),
    .transmit_0xAA(state_controller_transmit_0xAA),
    .receive_stdin_data(state_controller_receive_stdin_data),
    .transmit_stdout_data(state_controller_transmit_stdout_data),
    .wb_if_write_enable(state_controller_wb_if_write_enable),
    .if_id_write_enable(state_controller_if_id_write_enable),
    .id_ex_write_enable(state_controller_id_ex_write_enable),
    .ex_mem_write_enable(state_controller_ex_mem_write_enable),
    .mem_wb_write_enable(state_controller_mem_wb_write_enable),
    .ram_read(state_controller_ram_read),
    .ram_write_enable(state_controller_ram_write_enable),
    .reg_write_enable(state_controller_reg_write_enable),
    .stdin_read_enable(state_controller_stdin_read_enable),
    .stdout_write_enable(state_controller_stdout_write_enable),
    .pipeline_register_reset_n(state_controller_pipeline_register_reset_n)
);

// UART CONTROLLER
logic stdin_memory_stdin_memory_write_ready;
logic stdout_memory_stdin_memory_read_ready;
logic [7:0] stdout_memory_stdout_memory_read_data;

logic [`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0] uart_controller_program_memory_write_address;
logic uart_controller_program_memory_write_enable;
logic [31:0] uart_controller_program_memory_write_data;
logic uart_controller_stdin_memory_write_enable;
logic [7:0] uart_controller_stdin_memory_write_data;
logic uart_controller_stdout_memory_read_enable;
UART_CONTROLLER uart_controller(
    .reset_n(reset_n),
    .clk(clk),
    .cpu_uart_rxd(cpu_uart_rxd),
    .transmit_0x99(state_controller_transmit_0x99),
    .receive_program_data_size(state_controller_receive_program_data_size),
    .receive_program_data(state_controller_receive_program_data),
    .transmit_0xAA(state_controller_transmit_0xAA),
    .receive_stdin_data(state_controller_receive_stdin_data),
    .transmit_stdout_data(state_controller_transmit_stdout_data),
    .stdin_memory_write_ready(stdin_memory_stdin_memory_write_ready),
    .stdout_memory_read_ready(stdout_memory_stdout_memory_read_ready),
    .stdout_memory_read_data(stdout_memory_stdout_memory_read_data),

    .cpu_uart_txd(cpu_uart_txd),
    .transmit_0x99_finished(uart_controller_transmit_0x99_finished),
    .receive_program_data_size_finished(uart_controller_receive_program_data_size_finished),
    .receive_program_data_finished(uart_controller_receive_program_data_finished),
    .transmit_0xAA_finished(uart_controller_transmit_0xAA_finished),
    .program_memory_write_address(uart_controller_program_memory_write_address),
    .program_memory_write_enable(uart_controller_program_memory_write_enable),
    .program_memory_write_data(uart_controller_program_memory_write_data),
    .stdin_memory_write_enable(uart_controller_stdin_memory_write_enable),
    .stdin_memory_write_data(uart_controller_stdin_memory_write_data),
    .stdout_memory_read_enable(uart_controller_stdout_memory_read_enable)
);

// STDIN_MEMORY
logic [7:0] stdin_memory_read_data;
logic stdin_memory_read_ready;
FIFO #(
    .FIFO_BRAM_ADDRESS_SIZE(`STDIN_MEMORY_FIFO_BRAM_ADDRESS_SIZE),
    .FIFO_BRAM_ADDRESS_BITWIDTH(`STDIN_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH)
) stdin_memory(
    .reset_n(reset_n),
    .clk(clk),
    .read_enable(combined_stdin_read_enable),
    .write_enable(uart_controller_stdin_memory_write_enable),
    .write_data(uart_controller_stdin_memory_write_data),

    .read_data(stdin_memory_read_data),
    .read_ready(stdin_memory_read_ready),
    .write_ready(stdin_memory_stdin_memory_write_ready)
);

// STDOUT_MEMORY
logic [31:0] mem_rs1_data;
logic stdout_memory_stdout_memory_write_ready;
logic combined_stdout_write_enable;

FIFO #(
    .FIFO_BRAM_ADDRESS_SIZE(`STDOUT_MEMORY_FIFO_BRAM_ADDRESS_SIZE),
    .FIFO_BRAM_ADDRESS_BITWIDTH(`STDOUT_MEMORY_FIFO_BRAM_ADDRESS_BITWIDTH)
) stdout_memory(
    .reset_n(reset_n),
    .clk(clk),
    .read_enable(uart_controller_stdout_memory_read_enable),
    .write_enable(combined_stdout_write_enable),
    .write_data(mem_rs1_data[7:0]),

    .read_data(stdout_memory_stdout_memory_read_data),
    .read_ready(stdout_memory_stdout_memory_read_ready),
    .write_ready(stdout_memory_stdout_memory_write_ready)
);

// WB -> IF
logic [31:0] wb_next_pc_data;
logic [31:0] if_pc_data;
WB_IF_PIPELINE_REGISTER wb_if_pipeline_register(
    .reset_n(state_controller_pipeline_register_reset_n),
    .clk(clk),
    .write_enable(state_controller_wb_if_write_enable),
    .in_next_pc_data(wb_next_pc_data),
    .next_pc_data(if_pc_data)
);

// IF
logic [31:0] if_program_memory_data;
PROGRAM_MEMORY program_memory(
    .clk(clk),
    .reset_n(reset_n),
    .read_address(if_pc_data[`PROGRAM_MEMORY_ADDRESS_BITWIDTH - 1:0]),
    .write_address(uart_controller_program_memory_write_address),
    .write_data(uart_controller_program_memory_write_data),
    .write_enable(uart_controller_program_memory_write_enable),
    .read_data(if_program_memory_data)
);

// IF -> ID
logic [31:0] id_instruction_data;
logic [31:0] id_pc_data;
IF_ID_PIPELINE_REGISTER if_id_pipeline_register(
    .reset_n(state_controller_pipeline_register_reset_n),
    .clk(clk),
    .write_enable(state_controller_if_id_write_enable),
    .in_instruction(if_program_memory_data),
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
logic [2:0] id_next_pc_src;
logic [1:0] id_reg_write_data_src;
logic id_reg_write_enable;
logic id_ram_read;
logic id_ram_write_enable;
logic id_stdin_read_enable;
logic id_stdout_write_enable;

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
    .reg_write_enable(id_reg_write_enable),
    .ram_read(id_ram_read),
    .ram_write_enable(id_ram_write_enable),
    .stdin_read_enable(id_stdin_read_enable),
    .stdout_write_enable(id_stdout_write_enable)
);

logic [31:0] id_rs1_data;
logic [31:0] id_rs2_data;

logic wb_reg_combined_write_enable;
logic [4:0] wb_rd_address;
logic [31:0] wb_reg_write_data;

REGISTER_FILE regfile(
    .reset_n(reset_n),
    .clk(clk),
    .reg_write_enable(wb_reg_combined_write_enable),
    .read_address1(id_rs1_address),
    .read_address2(id_rs2_address),
    .write_address(wb_rd_address), // WB?????????????????????.
    .write_data(wb_reg_write_data), // WB?????????????????????.
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
logic [2:0] ex_next_pc_src;
logic [1:0] ex_reg_write_data_src;
logic ex_reg_write_enable;
logic ex_ram_read;
logic ex_ram_write_enable;
logic ex_stdin_read_enable;
logic ex_stdout_write_enable;

ID_EX_PIPELINE_REGISTER id_ex_pipeline_register(
    .reset_n(state_controller_pipeline_register_reset_n),
    .clk(clk),
    .write_enable(state_controller_id_ex_write_enable),
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
    .in_reg_write_enable(id_reg_write_enable),
    .in_ram_read(id_ram_read),
    .in_ram_write_enable(id_ram_write_enable),
    .in_stdin_read_enable(id_stdin_read_enable),
    .in_stdout_write_enable(id_stdout_write_enable),
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
    .reg_write_enable(ex_reg_write_enable),
    .ram_read(ex_ram_read),
    .ram_write_enable(ex_ram_write_enable),
    .stdin_read_enable(ex_stdin_read_enable),
    .stdout_write_enable(ex_stdout_write_enable)
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
always_comb begin
    case(ex_alu_rd_operand2_src)
        `ALU_RD_OPERAND2_SRC_RS2: begin
            ex_alu_rd_operand2 <= ex_rs2_data;
        end
        `ALU_RD_OPERAND2_SRC_IMM: begin
            ex_alu_rd_operand2 <= ex_imm;
        end
        `ALU_RD_OPERAND2_SRC_2: begin
            ex_alu_rd_operand2 <= 2;
        end
        `ALU_RD_OPERAND2_SRC_12: begin
            ex_alu_rd_operand2 <= 12;
        end
        `ALU_RD_OPERAND2_SRC_UPPER_IMM: begin
            ex_alu_rd_operand2 <= (ex_imm << 12);
        end
        default: begin
            ex_alu_rd_operand2 <= 0;
        end
    endcase
end

logic [31:0] ex_alu_pc_operand1;
always_comb begin
    case(ex_alu_pc_operand1_src)
        `ALU_PC_OPERAND1_SRC_PC: begin
            ex_alu_pc_operand1 <= ex_pc_data;
        end
        `ALU_PC_OPERAND1_SRC_RS1: begin
            ex_alu_pc_operand1 <= ex_rs1_data;
        end
        default: begin
            ex_alu_pc_operand1 <= 0;
        end
    endcase
end

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
logic [2:0] mem_next_pc_src;
logic [1:0] mem_reg_write_data_src;
logic mem_reg_write_enable;
logic mem_ram_read;
logic mem_ram_write_enable;
logic mem_stdin_read_enable;
logic mem_stdout_write_enable;

EX_MEM_PIPELINE_REGISTER ex_mem_pipeline_register(
    .reset_n(state_controller_pipeline_register_reset_n),
    .clk(clk),
    .write_enable(state_controller_ex_mem_write_enable),
    .in_pc_data(ex_pc_data),
    .in_rs1_data(ex_rs1_data),
    .in_rs2_data(ex_rs2_data),
    .in_rd_address(ex_rd_address),
    .in_alu_rd_result(ex_alu_rd_result),
    .in_alu_rd_result_is_zero(ex_alu_rd_result_is_zero),
    .in_alu_pc_result(ex_alu_pc_result),
    .in_next_pc_src(ex_next_pc_src),
    .in_reg_write_data_src(ex_reg_write_data_src),
    .in_reg_write_enable(ex_reg_write_enable),
    .in_ram_read(ex_ram_read),
    .in_ram_write_enable(ex_ram_write_enable),
    .in_stdin_read_enable(ex_stdin_read_enable),
    .in_stdout_write_enable(ex_stdout_write_enable),
    .pc_data(mem_pc_data),
    .rs1_data(mem_rs1_data),
    .rs2_data(mem_rs2_data),
    .rd_address(mem_rd_address),
    .alu_rd_result(mem_alu_rd_result),
    .alu_rd_result_is_zero(mem_alu_rd_result_is_zero),
    .alu_pc_result(mem_alu_pc_result),
    .next_pc_src(mem_next_pc_src),
    .reg_write_data_src(mem_reg_write_data_src),
    .reg_write_enable(mem_reg_write_enable),
    .ram_read(mem_ram_read),
    .ram_write_enable(mem_ram_write_enable),
    .stdin_read_enable(mem_stdin_read_enable),
    .stdout_write_enable(mem_stdout_write_enable)
);

// MEM
logic [`RAM_ADDRESS_BITWIDTH - 1:0] ram_addr;
assign ram_addr = mem_alu_rd_result[`RAM_ADDRESS_BITWIDTH - 1:0];

logic [31:0] mem_pc_data_plus_2;
always_comb begin
    mem_pc_data_plus_2 = mem_pc_data + 2;
end

logic [31:0] mem_next_pc_data;
always_comb begin
    case(mem_next_pc_src)
        `NEXT_PC_SRC_FINISH: begin
            mem_next_pc_data <= mem_next_pc_data;
        end
        `NEXT_PC_SRC_ALWAYS_NOT_BRANCH: begin
            mem_next_pc_data <= mem_pc_data_plus_2;
        end
        `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_ZERO: begin
            mem_next_pc_data <= mem_alu_rd_result_is_zero == `ALU_RD_RESULT_IS_ZERO
                ? mem_alu_pc_result
                : mem_pc_data_plus_2;
        end
        `NEXT_PC_SRC_BRANCH_ON_ALU_PC_RESULT_NOT_ZERO: begin
            mem_next_pc_data <= mem_alu_rd_result_is_zero == `ALU_RD_RESULT_IS_NOT_ZERO
                ? mem_alu_pc_result
                : mem_pc_data_plus_2;
        end
        `NEXT_PC_SRC_ALWAYS_BRANCH: begin
            mem_next_pc_data <= mem_alu_pc_result;
        end
    endcase
end

logic [31:0] mem_ram_data;
logic mem_ram_read_ready;
logic mem_ram_combined_write_enable;
RAM ram(
    .clk(clk),
    .read_address(ram_addr[`RAM_ADDRESS_BITWIDTH - 1:0]),
    .write_address(ram_addr[`RAM_ADDRESS_BITWIDTH - 1:0]),
    .write_data(mem_rs2_data),
    .write_enable(mem_ram_combined_write_enable),
    .read_data(mem_ram_data),
    .read_ready(mem_ram_read_ready)
);

// ram access
always_comb begin
    mem_ram_combined_write_enable <= (state_controller_ram_write_enable & (mem_ram_write_enable == `RAM_WRITE_ENABLE));
end

// ram read stall
logic mem_ram_read_stall;
always_comb begin
    if(state_controller_ram_read & mem_ram_read) begin
        mem_ram_read_stall <= ~mem_ram_read_ready;
    end else begin
        mem_ram_read_stall <= 0;
    end
end

// stdin read access
logic combined_stdin_read_enable;
always_comb begin
    combined_stdin_read_enable <= state_controller_stdin_read_enable & mem_stdin_read_enable & stdin_memory_read_ready;
end

// stdin read stall
logic stdin_read_stall;
always_comb begin
    if(state_controller_stdin_read_enable & mem_stdin_read_enable) begin
        stdin_read_stall <= ~stdin_memory_read_ready;
    end else begin
        stdin_read_stall <= 0;
    end
end

// stdout write access
always_comb begin
    combined_stdout_write_enable <= state_controller_stdout_write_enable & mem_stdout_write_enable & stdout_memory_stdout_memory_write_ready;
end

// stdout write stall
logic stdout_write_stall;
always_comb begin
    if(state_controller_stdout_write_enable & mem_stdout_write_enable) begin
        stdout_write_stall <= ~stdout_memory_stdout_memory_write_ready;
    end else begin
        stdout_write_stall <= 0;
    end
end

// MEM -> WB
logic [31:0] wb_ram_data;
logic [31:0] wb_alu_rd_result;
logic [1:0] wb_reg_write_data_src;
logic wb_reg_write_enable;
MEM_WB_PIPELINE_REGISTER mem_wb_pipeline_register(
    .reset_n(state_controller_pipeline_register_reset_n),
    .clk(clk),
    .write_enable(state_controller_mem_wb_write_enable),
    .in_ram_data(mem_ram_data),
    .in_alu_rd_result(mem_alu_rd_result),
    .in_rd_address(mem_rd_address),
    .in_reg_write_data_src(mem_reg_write_data_src),
    .in_reg_write_enable(mem_reg_write_enable),
    .in_next_pc_data(mem_next_pc_data),
    .ram_data(wb_ram_data),
    .alu_rd_result(wb_alu_rd_result),
    .rd_address(wb_rd_address),
    .reg_write_data_src(wb_reg_write_data_src),
    .reg_write_enable(wb_reg_write_enable),
    .next_pc_data(wb_next_pc_data)
);

// WB
always_comb begin
    wb_reg_combined_write_enable <= (state_controller_reg_write_enable & (wb_reg_write_enable == `REG_WRITE_ENABLE));
end

always_comb begin
    wb_reg_write_data <=
        wb_reg_write_data_src == `REG_WRITE_DATA_SRC_ALU
            ? wb_alu_rd_result :
        wb_reg_write_data_src == `REG_WRITE_DATA_SRC_RAM
            ? wb_ram_data :
        0;
end

endmodule
