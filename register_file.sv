`timescale 1ns / 1ps
module REGISTER_FILE (
    input logic reset_n,
    input logic clk,
    input logic reg_wren,
    input logic [4:0] read_address1,
    input logic [4:0] read_address2,
    input logic [4:0] write_address,
    input logic [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

logic [31:0] _write_sel;

logic [31:0] _r_data[31:0];

logic [31:0] _r0_data;
logic [31:0] _r1_data;
logic [31:0] _r2_data;
logic [31:0] _r3_data;
logic [31:0] _r4_data;
logic [31:0] _r5_data;
logic [31:0] _r6_data;
logic [31:0] _r7_data;
logic [31:0] _r8_data;
logic [31:0] _r9_data;
logic [31:0] _r10_data;
logic [31:0] _r11_data;
logic [31:0] _r12_data;
logic [31:0] _r13_data;
logic [31:0] _r14_data;
logic [31:0] _r15_data;
logic [31:0] _r16_data;
logic [31:0] _r17_data;
logic [31:0] _r18_data;
logic [31:0] _r19_data;
logic [31:0] _r20_data;
logic [31:0] _r21_data;
logic [31:0] _r22_data;
logic [31:0] _r23_data;
logic [31:0] _r24_data;
logic [31:0] _r25_data;
logic [31:0] _r26_data;
logic [31:0] _r27_data;
logic [31:0] _r28_data;
logic [31:0] _r29_data;
logic [31:0] _r30_data;
logic [31:0] _r31_data;

logic [1023:0] regs;
assign regs = {
    _r31_data,
    _r30_data,
    _r29_data,
    _r28_data,
    _r27_data,
    _r26_data,
    _r25_data,
    _r24_data,
    _r23_data,
    _r22_data,
    _r21_data,
    _r20_data,
    _r19_data,
    _r18_data,
    _r17_data,
    _r16_data,
    _r15_data,
    _r14_data,
    _r13_data,
    _r12_data,
    _r11_data,
    _r10_data,
    _r9_data,
    _r8_data,
    _r7_data,
    _r6_data,
    _r5_data,
    _r4_data,
    _r3_data,
    _r2_data,
    _r1_data,
    _r0_data
};

assign _write_sel = (reg_wren == 1) ? (32'b1 << write_address) : (32'b0);
assign read_data1 = mux_reg(read_address1, regs);
assign read_data2 = mux_reg(read_address2, regs);

REGISTER r0(reset_n, clk, _write_sel[0], 32'h0, _r0_data);        // zero
REGISTER r1(reset_n, clk, _write_sel[1], write_data, _r1_data);       // ra
REGISTER r2(reset_n, clk, _write_sel[2], write_data, _r2_data);       // sp
REGISTER r3(reset_n, clk, _write_sel[3], write_data, _r3_data);       // hp
REGISTER r4(reset_n, clk, _write_sel[4], write_data, _r4_data);       // rc
REGISTER r5(reset_n, clk, _write_sel[5], write_data, _r5_data);       // t0
REGISTER r6(reset_n, clk, _write_sel[6], write_data, _r6_data);       // t1
REGISTER r7(reset_n, clk, _write_sel[7], write_data, _r7_data);       // t2
REGISTER r8(reset_n, clk, _write_sel[8], write_data, _r8_data);       // s0 / fp
REGISTER r9(reset_n, clk, _write_sel[9], write_data, _r9_data);       // s1
REGISTER r10(reset_n, clk, _write_sel[10], write_data, _r10_data);    // a0
REGISTER r11(reset_n, clk, _write_sel[11], write_data, _r11_data);    // a1
REGISTER r12(reset_n, clk, _write_sel[12], write_data, _r12_data);    // a2
REGISTER r13(reset_n, clk, _write_sel[13], write_data, _r13_data);    // a3
REGISTER r14(reset_n, clk, _write_sel[14], write_data, _r14_data);    // a4
REGISTER r15(reset_n, clk, _write_sel[15], write_data, _r15_data);    // a5
REGISTER r16(reset_n, clk, _write_sel[16], write_data, _r16_data);    // a6
REGISTER r17(reset_n, clk, _write_sel[17], write_data, _r17_data);    // a7
REGISTER r18(reset_n, clk, _write_sel[18], write_data, _r18_data);    // s2
REGISTER r19(reset_n, clk, _write_sel[19], write_data, _r19_data);    // s3
REGISTER r20(reset_n, clk, _write_sel[20], write_data, _r20_data);    // s4
REGISTER r21(reset_n, clk, _write_sel[21], write_data, _r21_data);    // s5
REGISTER r22(reset_n, clk, _write_sel[22], write_data, _r22_data);    // s6
REGISTER r23(reset_n, clk, _write_sel[23], write_data, _r23_data);    // s7
REGISTER r24(reset_n, clk, _write_sel[24], write_data, _r24_data);    // s8
REGISTER r25(reset_n, clk, _write_sel[25], write_data, _r25_data);    // s9
REGISTER r26(reset_n, clk, _write_sel[26], write_data, _r26_data);    // s10
REGISTER r27(reset_n, clk, _write_sel[27], write_data, _r27_data);    // s11
REGISTER r28(reset_n, clk, _write_sel[28], write_data, _r28_data);    // t3
REGISTER r29(reset_n, clk, _write_sel[29], write_data, _r29_data);    // t4
REGISTER r30(reset_n, clk, _write_sel[30], write_data, _r30_data);    // t5
REGISTER r31(reset_n, clk, _write_sel[31], write_data, _r31_data);    // t6

function [31:0] mux_reg;
    input logic [4:0] sel;
    input logic [1023:0] regs;

    begin
        case(sel)
            0: mux_reg = regs[(32*1)-1:32*0];
            1: mux_reg = regs[(32*2)-1:32*1];
            2: mux_reg = regs[(32*3)-1:32*2];
            3: mux_reg = regs[(32*4)-1:32*3];
            4: mux_reg = regs[(32*5)-1:32*4];
            5: mux_reg = regs[(32*6)-1:32*5];
            6: mux_reg = regs[(32*7)-1:32*6];
            7: mux_reg = regs[(32*8)-1:32*7];
            8: mux_reg = regs[(32*9)-1:32*8];
            9: mux_reg = regs[(32*10)-1:32*9];
            10: mux_reg = regs[(32*11)-1:32*10];
            11: mux_reg = regs[(32*12)-1:32*11];
            12: mux_reg = regs[(32*13)-1:32*12];
            13: mux_reg = regs[(32*14)-1:32*13];
            14: mux_reg = regs[(32*15)-1:32*14];
            15: mux_reg = regs[(32*16)-1:32*15];
            16: mux_reg = regs[(32*17)-1:32*16];
            17: mux_reg = regs[(32*18)-1:32*17];
            18: mux_reg = regs[(32*19)-1:32*18];
            19: mux_reg = regs[(32*20)-1:32*19];
            20: mux_reg = regs[(32*21)-1:32*20];
            21: mux_reg = regs[(32*22)-1:32*21];
            22: mux_reg = regs[(32*23)-1:32*22];
            23: mux_reg = regs[(32*24)-1:32*23];
            24: mux_reg = regs[(32*25)-1:32*24];
            25: mux_reg = regs[(32*26)-1:32*25];
            26: mux_reg = regs[(32*27)-1:32*26];
            27: mux_reg = regs[(32*28)-1:32*27];
            28: mux_reg = regs[(32*29)-1:32*28];
            29: mux_reg = regs[(32*30)-1:32*29];
            30: mux_reg = regs[(32*31)-1:32*30];
            31: mux_reg = regs[(32*32)-1:32*31];
        endcase
    end
endfunction

logic [31:0] debug_zero, debug_ra, debug_sp, debug_hp, debug_rc, debug_t0, debug_t1, debug_t2, debug_s0_fp, debug_s1, debug_a0, debug_a1, debug_a2, debug_a3, debug_a4, debug_a5, debug_a6, debug_a7, debug_s2, debug_s3, debug_s4, debug_s5, debug_s6, debug_s7, debug_s8, debug_s9, debug_s10, debug_s11, debug_t3, debug_t4, debug_t5, debug_t6;

assign debug_zero = _r0_data;
assign debug_ra = _r1_data;
assign debug_sp = _r2_data;
assign debug_hp = _r3_data;
assign debug_rc = _r4_data;
assign debug_t0 = _r5_data;
assign debug_t1 = _r6_data;
assign debug_t2 = _r7_data;
assign debug_s0_fp = _r8_data;
assign debug_s1 = _r9_data;
assign debug_a0 = _r10_data;
assign debug_a1 = _r11_data;
assign debug_a2 = _r12_data;
assign debug_a3 = _r13_data;
assign debug_a4 = _r14_data;
assign debug_a5 = _r15_data;
assign debug_a6 = _r16_data;
assign debug_a7 = _r17_data;
assign debug_s2 = _r18_data;
assign debug_s3 = _r19_data;
assign debug_s4 = _r20_data;
assign debug_s5 = _r21_data;
assign debug_s6 = _r22_data;
assign debug_s7 = _r23_data;
assign debug_s8 = _r24_data;
assign debug_s9 = _r25_data;
assign debug_s10 = _r26_data;
assign debug_s11 = _r27_data;
assign debug_t3 = _r28_data;
assign debug_t4 = _r29_data;
assign debug_t5 = _r30_data;
assign debug_t6 = _r31_data;

endmodule