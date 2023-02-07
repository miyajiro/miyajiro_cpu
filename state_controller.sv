`timescale 1ns / 1ps
`include "define.sv"

module STATE_CONTROLLER(
    input logic reset_n,
    input logic clk,
    input logic stall,
    input logic program_data_size_fetch_finished,
    input logic program_data_fetch_finished,
    output logic transmit_0x99,
    output logic program_data_size_wr_en,
    output logic program_memory_wr_en,
    output logic transmit_0xAA,
    output logic stdin_memory_wr_en,
    output logic wb_if_wr_en,
    output logic if_id_wr_en,
    output logic id_ex_wr_en,
    output logic ex_mem_wr_en,
    output logic mem_wb_wr_en,
    output logic ram_wr_en,
    output logic reg_wr_en,
    output logic pipeline_register_reset_n
);

logic [4:0] state;

always_ff @(posedge clk) begin
    if(!reset_n) begin
        state <= `STATE_INIT;
    end
    else begin
        case (state)
            `STATE_INIT:begin
                state <= `STATE_IF;
            end
            `STATE_IF:begin
                state <= `STATE_IF_ID;
            end
            `STATE_IF_ID:begin
                state <= `STATE_ID;
            end
            `STATE_ID:begin
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
        `STATE_INIT:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 0;
        end
        `STATE_IF:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_IF_ID:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 1;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_ID:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_ID_EX:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 1;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_EX_MEM:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 1;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_MEM:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 1;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_MEM_WB:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 1;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        `STATE_WB:begin
            wb_if_wr_en <= 0;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 1;
            pipeline_register_reset_n <= 1;
        end
        `STATE_WB_IF:begin
            wb_if_wr_en <= 1;
            if_id_wr_en <= 0;
            id_ex_wr_en <= 0;
            ex_mem_wr_en <= 0;
            mem_wb_wr_en <= 0;
            ram_wr_en <= 0;
            reg_wr_en <= 0;
            pipeline_register_reset_n <= 1;
        end
        default:begin
        end
    endcase
end


endmodule
