`timescale 1ns / 1ps
`include "define.sv"

module STAGE_CONTROLLER(
    input reset_n,
    input clk,
    output logic pc_wren,
    output logic wb_if_wren,
    output logic if_id_wren,
    output logic id_ex_wren,
    output logic ex_mem_wren,
    output logic mem_wb_wren,
    output logic ram_wren,
    output logic reg_wren,
    output logic stage_reset_n
);

reg [3:0] stage;
logic [3:0] _stage;
assign _stage = stage;

always_ff @(posedge clk) begin
    if(!reset_n) begin
        stage <= `STAGE_INIT;
    end
    else begin
        case (_stage)
            `STAGE_INIT:begin
                stage <= `STAGE_IF;
            end
            `STAGE_IF:begin
                stage <= `STAGE_IF_ID;
            end
            `STAGE_IF_ID:begin
                stage <= `STAGE_ID;
            end
            `STAGE_ID:begin
                stage <= `STAGE_ID_EX;
            end
            `STAGE_ID_EX: begin
                stage <= `STAGE_EX_MEM;
            end
            `STAGE_EX_MEM: begin
                stage <= `STAGE_MEM;
            end
            `STAGE_MEM: begin
                stage <= `STAGE_MEM_WB;
            end
            `STAGE_MEM_WB: begin
                stage <= `STAGE_WB;
            end
            `STAGE_WB: begin
                stage <= `STAGE_WB_IF;
            end
            `STAGE_WB_IF: begin
                stage <= `STAGE_IF;
            end
        endcase
    end
end

always @(_stage) begin
    case(_stage)
        `STAGE_INIT:begin
            pc_wren <= 0;
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 0;
        end
        `STAGE_IF:begin
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_IF_ID:begin
            wb_if_wren <= 0;
            if_id_wren <= 1;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_ID:begin
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_ID_EX:begin
            pc_wren <= 0;
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 1;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_EX_MEM:begin
            pc_wren <= 0;
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 1;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_MEM:begin
            pc_wren <= 0;
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 1;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_MEM_WB:begin
            pc_wren <= 0;
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 1;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        `STAGE_WB:begin
            pc_wren <= 0;
            wb_if_wren <= 0;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 1;
            stage_reset_n <= 1;
        end
        `STAGE_WB_IF:begin
            pc_wren <= 0;
            wb_if_wren <= 1;
            if_id_wren <= 0;
            id_ex_wren <= 0;
            ex_mem_wren <= 0;
            mem_wb_wren <= 0;
            ram_wren <= 0;
            reg_wren <= 0;
            stage_reset_n <= 1;
        end
        default:begin
        end
    endcase
end


endmodule
