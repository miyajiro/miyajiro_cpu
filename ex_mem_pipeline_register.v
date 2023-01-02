module EX_MEM_PIPELINE_REGISTER(
    input reset_n,
    input clk,
    input wren,
    input [31:0] in_pc_data,
    input [4:0] in_rd_address,
    input [31:0] in_alu_rd_result,
    input in_alu_rd_result_is_zero,
    input [31:0] in_alu_pc_result,
    input [1:0] in_next_pc_src,
    input in_reg_write_data_src,
    input in_reg_wren,
    input in_ram_wren,
    output reg [31:0] pc_data,
    output reg [4:0] rd_address,
    output reg [31:0] alu_rd_result,
    output reg alu_rd_result_is_zero,
    output reg [31:0] alu_pc_result,
    output reg [1:0] next_pc_src,
    output reg reg_write_data_src,
    output reg reg_wren,
    output reg ram_wren
);

always @(posedge clk) begin
    if(!reset_n) begin
        pc_data <= 0;
        rd_address <= 0;
        alu_rd_result <= 0;
        alu_rd_result_is_zero <= 0;
        alu_pc_result <= 0;
        next_pc_src <= 0;
        reg_write_data_src <= 0;
        reg_wren <= 0;
        ram_wren <= 0;
    end
    else if(wren) begin
        pc_data <= in_pc_data;
        rd_address <= in_rd_address;
        alu_rd_result <= in_alu_rd_result;
        alu_rd_result_is_zero <= in_alu_rd_result_is_zero;
        alu_pc_result <= in_alu_pc_result;
        next_pc_src <= in_next_pc_src;
        reg_write_data_src <= in_reg_write_data_src;
        reg_wren <= in_reg_wren;
        ram_wren <= in_ram_wren;
    end
end

endmodule