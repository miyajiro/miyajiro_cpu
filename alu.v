`timescale 1ns / 1ps
`include "define.v"

module ALU (
    input [4:0] operator,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] result,
    output reg result_is_zero
);

always @(*) begin
    case(operator)
        `ALU_OPERATOR_ADD: begin
            result <= operand1 + operand2;
        end
        `ALU_OPERATOR_SUB: begin
            result <= operand1 - operand2;
        end
        `ALU_OPERATOR_XOR: begin
            result <= operand1 ^ operand2;
        end
        `ALU_OPERATOR_OR: begin
            result <= operand1 | operand2;
        end
        `ALU_OPERATOR_SLL: begin
            result <= operand1 << operand2;
        end
        `ALU_OPERATOR_SRL: begin
            result <= operand1 >> operand2;
        end
        `ALU_OPERATOR_SRA: begin
            result <= $signed(operand1) >>> operand2;
        end
        `ALU_OPERATOR_SLT: begin
            result <= $signed(operand1) < $signed(operand2) ? 32'b1 : 32'b0;
        end
        `ALU_OPERATOR_SLTU: begin
            result <= operand1 < operand2 ? 32'b1 : 32'b0;
        end
        `ALU_OPERATOR_MUL: begin
            result <= ($signed(operand1) * $signed(operand2))[31:0];
        end
        `ALU_OPERATOR_MULH: begin
            result <= ($signed(operand1) * $signed(operand2))[63:32];
        end
        `ALU_OPERATOR_MULU: begin
            result <= (operand1 * operand2)[31:0];
        end
        `ALU_OPERATOR_MULHU: begin
            result <= (operand1 * operand2)[63:32];
        end
        `ALU_OPERATOR_DIV: begin
            result <= $signed(operand1) / $signed(operand2);
        end
        `ALU_OPERATOR_DIVU: begin
            result <= operand1 / operand2;
        end
        `ALU_OPERATOR_REM: begin
            result <= $signed(operand1) % $signed(operand2);
        end
        `ALU_OPERATOR_REMU: begin
            result <= operand1 % operand2;
        end
        default: begin
            result <= 4'bx;
        end
    endcase
    result_is_zero <= (result == 32'h0) ? `ALU_RESULT_IS_ZERO : `ALU_RESULT_IS_NOT_ZERO;
end

endmodule