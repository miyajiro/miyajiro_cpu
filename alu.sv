`timescale 1ns / 1ps
`include "define.sv"

module ALU (
    input logic [4:0] operator,
    input logic [31:0] operand1,
    input logic [31:0] operand2,
    output logic [31:0] result,
    output logic result_is_zero
);

logic [63:0] signed_mul_result;
logic [63:0] unsigned_mul_result;
always_comb begin
    signed_mul_result = ($signed(operand1) * $signed(operand2));
    unsigned_mul_result = (operand1 * operand2);
end

logic [31:0] upper_signed_mul_result;
logic [31:0] lower_signed_mul_result;
logic [31:0] upper_unsigned_mul_result;
logic [31:0] lower_unsigned_mul_result;

assign upper_signed_mul_result = signed_mul_result[63:32];
assign lower_signed_mul_result = signed_mul_result[31:0];
assign upper_unsigned_mul_result = unsigned_mul_result[63:32];
assign lower_unsigned_mul_result = unsigned_mul_result[31:0];

always_comb begin
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
            result <= lower_signed_mul_result;
        end
        `ALU_OPERATOR_MULH: begin
            result <= upper_signed_mul_result;
        end
        `ALU_OPERATOR_MULU: begin
            result <= lower_unsigned_mul_result;
        end
        `ALU_OPERATOR_MULHU: begin
            result <= upper_unsigned_mul_result;
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
end

always_comb begin
    result_is_zero <= (result == 32'h0) ? `ALU_RESULT_IS_ZERO : `ALU_RESULT_IS_NOT_ZERO;
end

endmodule