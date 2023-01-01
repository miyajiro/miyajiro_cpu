module testbench_miyajiro_cpu ();
// CLK
reg reset_n;
reg clk;

MIYAJIRO_CPU miyajiro_cpu(
    .reset_n(reset_n)
    .clk(clk),
);

initial begin
    reset_n <= 1'b1;
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
    RST <= 1'b0;
    wait_posedge_clk(100);
    $finish;
end


endmodule