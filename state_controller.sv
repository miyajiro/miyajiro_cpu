`timescale 1ns / 1ps
`include "define.sv"

module STATE_CONTROLLER(
    input logic reset_n,
    input logic clk,
    input logic stall,
    input logic transmit_0x99_finished,
    input logic receive_program_data_size_finished,
    input logic receive_program_data_finished,
    input logic transmit_0xAA_finished,
    output logic transmit_0x99,
    output logic receive_program_data_size,
    output logic receive_program_data,
    output logic transmit_0xAA,
    output logic receive_stdin_data,
    output logic transmit_stdout_data,
    output logic wb_if_write_enable,
    output logic if_id_write_enable,
    output logic id_ex_write_enable,
    output logic ex_mem_write_enable,
    output logic mem_wb_write_enable,
    output logic ram_read,
    output logic ram_write_enable,
    output logic reg_write_enable,
    output logic stdin_read_enable,
    output logic stdout_write_enable,
    output logic pipeline_register_reset_n
);

logic [4:0] state;

always_ff @(posedge clk) begin
    if(!reset_n) begin
        state <= `STATE_INIT;
    end
    else if(!stall) begin
        case (state)
            `STATE_INIT: begin
                state <= `STATE_TRANSMIT_0x99;
            end
            `STATE_TRANSMIT_0x99: begin
                if (transmit_0x99_finished) begin
                    state <= `STATE_RECEIVE_PROGRAM_DATA_SIZE;
                end
            end
            `STATE_RECEIVE_PROGRAM_DATA_SIZE: begin
                if (receive_program_data_size_finished) begin
                    state <= `STATE_RECEIVE_PROGRAM_DATA;
                end
            end
            `STATE_RECEIVE_PROGRAM_DATA: begin
                if (receive_program_data_finished) begin
                    state <= `STATE_TRANSMIT_0xAA;
                end
            end
            `STATE_TRANSMIT_0xAA: begin
                if (transmit_0xAA_finished) begin
                    state <= `STATE_IF;
                end
            end
            `STATE_IF: begin
                state <= `STATE_IF_ID;
            end
            `STATE_IF_ID: begin
                state <= `STATE_ID;
            end
            `STATE_ID: begin
                state <= `STATE_ID_EX;
            end
            `STATE_ID_EX: begin
                state <= `STATE_EX_MEM;
            end
            `STATE_EX_MEM: begin
                state <= `STATE_MEM;
            end
            `STATE_MEM: begin
                state <= `STATE_MEM_WB;
            end
            `STATE_MEM_WB: begin
                state <= `STATE_WB;
            end
            `STATE_WB: begin
                state <= `STATE_WB_IF;
            end
            `STATE_WB_IF: begin
                state <= `STATE_IF;
            end
        endcase
    end
end

always_comb begin
    case(state)
        `STATE_INIT: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 0;
            transmit_stdout_data <= 0;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 0;
        end
        `STATE_TRANSMIT_0x99: begin
            transmit_0x99 <= 1;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 0;
            transmit_stdout_data <= 0;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 0;
        end
        `STATE_RECEIVE_PROGRAM_DATA_SIZE: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 1;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 0;
            transmit_stdout_data <= 0;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 0;
        end
        `STATE_RECEIVE_PROGRAM_DATA: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 1;
            transmit_0xAA <= 0;
            receive_stdin_data <= 0;
            transmit_stdout_data <= 0;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 0;
        end
        `STATE_TRANSMIT_0xAA: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 1;
            receive_stdin_data <= 0;
            transmit_stdout_data <= 0;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 0;
        end
        `STATE_IF: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_IF_ID: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 1;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_ID: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_ID_EX: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 1;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_EX_MEM: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 1;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_MEM: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 1;
            ram_write_enable <= 1;
            reg_write_enable <= 0;
            stdin_read_enable <= 1;
            stdout_write_enable <= 1;
            pipeline_register_reset_n <= 1;
        end
        `STATE_MEM_WB: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 1;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_WB: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 0;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 1;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_WB_IF: begin
            transmit_0x99 <= 0;
            receive_program_data_size <= 0;
            receive_program_data <= 0;
            transmit_0xAA <= 0;
            receive_stdin_data <= 1;
            transmit_stdout_data <= 1;
            wb_if_write_enable <= 1;
            if_id_write_enable <= 0;
            id_ex_write_enable <= 0;
            ex_mem_write_enable <= 0;
            mem_wb_write_enable <= 0;
            ram_read <= 0;
            ram_write_enable <= 0;
            reg_write_enable <= 0;
            stdin_read_enable <= 0;
            stdout_write_enable <= 0;
            pipeline_register_reset_n <= 1;
        end
    endcase
end


endmodule
