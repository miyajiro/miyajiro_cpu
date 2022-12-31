module IF_ID_PIPELINE_REGISTER (
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_instruction,
    input [31:0] in_pc_data,
    output reg[31:0] instruction,
    output reg[31:0] pc_data
);

always @(posedge clk) begin
    if(!reset_n) begin
        instruction <= 0;
        pc_data <= 0;
    end
    else if(wren) begin
        instruction <= in_instruction;
        pc_data <= in_pc_data;
    end
end

endmodule