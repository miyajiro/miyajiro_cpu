`timescale 1ns / 1ps
module testbench_miyajiro_cpu ();
// CLK
logic reset_n;
logic clk;

MIYAJIRO_CPU miyajiro_cpu(
    .reset_n(reset_n),
    .clk(clk)
);

initial begin
    reset_n <= 1'b0;
    clk <= 1'b0;
end

always #5 begin
    clk <= ~clk;
end

task wait_posedge_clk;
    input   n;
    integer n;

    begin
        for(n=n; n>0; n=n-1) begin
            @(posedge clk)
                ;
        end
    end
endtask

initial begin
    wait_posedge_clk(2);
    reset_n <= 1'b1;
    wait_posedge_clk(1000);
    $finish;
end


endmodule