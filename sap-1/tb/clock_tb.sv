module clock_tb;

logic in_clk;
logic in_hlt;
logic out_clk;

//DUT generation
clock clock_dut(.i_clk(in_clk),
                .i_hlt(in_hlt),
                .o_clk(out_clk));

initial begin
    $dumpfile("clock.vcd");
    $dumpvars(0, clock_tb);

    //TEST-CASE-1: HLT = 0, CLK = 0
    in_hlt = 1'b0;
    in_clk = 1'b0;
    #10;

    if(out_clk == in_clk) begin
        $display("[PASSED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end
    else begin
        $display("[FAILED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end

    //TEST-CASE-2 HLT = 0, CLK = 1
    in_clk = 1'b1;
    #10;

    if(out_clk == in_clk) begin
        $display("[PASSED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end
    else begin
        $display("[FAILED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end

    //TEST-CASE-3: HLT = 1, CLK = 1
    in_hlt = 1'b1;
    #10;

    if(out_clk == 1'b0) begin
        $display("[PASSED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end
    else begin
        $display("[FAILED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end

    //TEST-CASE-4: HLT = 1, CLK = 0
    in_clk = 1'b0;
    #10;

    if(out_clk == 1'b0) begin
        $display("[PASSED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end
    else begin
        $display("[FAILED]: in_clk = %b, in_hlt = %b, out_clk = %b",in_clk,in_hlt,out_clk);
    end

    #10;
    $finish;

end
endmodule