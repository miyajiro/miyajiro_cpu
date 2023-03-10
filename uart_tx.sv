`default_nettype none
`include "define.sv"

module UART_TX (
   input wire       clk,
   input wire       reset_n,
   input wire [7:0] sdata,
   input wire       tx_start,
   output logic     tx_busy,
   output logic     txd
);

localparam e_clk_bit = `CLK_PER_HALF_BIT * 2 - 1;
localparam e_clk_stop_bit = (`CLK_PER_HALF_BIT * 2 * 9) / 10 - 1;

logic [7:0]                  txbuf;
logic [3:0]                  status;
logic [31:0]                 counter;
logic                        next;
logic                        fin_stop_bit;
logic                        rst_ctr;

localparam s_idle = 4'd0;
localparam s_start_bit = 4'd1;
localparam s_bit_0 = 4'd2;
localparam s_bit_1 = 4'd3;
localparam s_bit_2 = 4'd4;
localparam s_bit_3 = 4'd5;
localparam s_bit_4 = 4'd6;
localparam s_bit_5 = 4'd7;
localparam s_bit_6 = 4'd8;
localparam s_bit_7 = 4'd9;
localparam s_stop_bit = 4'd10;

// generate event signal
always_ff @(posedge clk) begin
   if (~reset_n) begin
      counter <= 32'b0;
      next <= 1'b0;
      fin_stop_bit <= 1'b0;
   end else begin
      if (counter == e_clk_bit || rst_ctr) begin
         counter <= 32'b0;
      end else begin
         counter <= counter + 32'd1;
      end
      if (~rst_ctr && counter == e_clk_bit) begin
         next <= 1'b1;
      end else begin
         next <= 1'b0;
      end
      if (~rst_ctr && counter == e_clk_stop_bit) begin
         fin_stop_bit <= 1'b1;
      end else begin
         fin_stop_bit <= 1'b0;
      end
   end
end

always_ff @(posedge clk) begin
   if (~reset_n) begin
      txbuf <= 8'b0;
      status <= s_idle;
      rst_ctr <= 1'b0;
      txd <= 1'b1;
      tx_busy <= 1'b0;
   end else begin
      rst_ctr <= 1'b0;

      if (status == s_idle) begin
         if (tx_start) begin
            txbuf <= sdata;
            status <= s_start_bit;
            rst_ctr <= 1'b1;
            txd <= 1'b0;
            tx_busy <= 1'b1;
         end
      end else if (status == s_stop_bit) begin
         if (fin_stop_bit) begin
            txd <= 1'b1;
            status <= s_idle;
            tx_busy <= 1'b0;
         end
      end else if (next) begin
         if (status == s_bit_7) begin
            txd <= 1'b1;
            status <= s_stop_bit;
         end else begin
            txd <= txbuf[0];
            txbuf <= txbuf >> 1;
            status <= status + 1'b1;
         end
      end
   end
end

endmodule
`default_nettype wire
