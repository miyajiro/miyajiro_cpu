`default_nettype none

module UART_RX #(CLK_PER_HALF_BIT = 5208) (
   input wire         rxd, // status of connection
   input wire         clk,
   input wire         reset_n,
   output logic [7:0] rdata,
   output logic       rdata_ready,
   output logic       ferr
);
   localparam e_clk_bit = CLK_PER_HALF_BIT * 2 - 1;
   localparam e_clk_half_bit = CLK_PER_HALF_BIT - 1;
   localparam e_clk_stop_bit = (CLK_PER_HALF_BIT * 2 * 9) / 10 - 1;

   logic [3:0]                  status;
   logic [31:0]                 counter;
   logic                        next; // signal from counter
   logic                        fin_stop_bit; // signal from counter
   logic                        rst_ctr;
   logic rst_flags;
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
         if (~rst_ctr && counter == e_clk_half_bit) begin
            next <= 1'b1;
         end else begin
            next <= 1'b0;
         end
         if (~rst_ctr && counter == e_clk_half_bit) begin
            fin_stop_bit <= 1'b1;
         end else begin
            fin_stop_bit <= 1'b0;
         end
      end
   end

   always_ff @(posedge clk) begin
      rdata_ready <= 1'b0;
      if (~reset_n) begin
         status <= s_idle;
         rst_ctr <= 1'b0;
         ferr <= 1'b0;
         rdata <= 8'b0;
      end else begin
         rst_ctr <= 1'b0;
         if (status == s_idle) begin
            if (~rxd) begin
               status <= s_start_bit;
               rst_ctr <= 1'b1;
               ferr <= 1'b0;
               rdata <= 8'b0;
            end
         end else if (status == s_stop_bit) begin
            if (fin_stop_bit) begin
               status <= s_idle;
               rdata_ready <= 1'b1;
               if (~rxd) begin
                  ferr <= 1'b1;
               end
               else begin
                  ferr <= 1'b0;
               end
            end
         end else if (next) begin
            if (status == s_start_bit) begin
               status <= status + 1'b1;
            end
            else if (status == s_bit_7) begin
               rdata[status - 2] <= rxd;
               status <= status + 1'b1;
            end else begin
               rdata[status - 2] <= rxd;
               status <= status + 1'b1;
            end
         end
      end
   end
endmodule
`default_nettype wire
