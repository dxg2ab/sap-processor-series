module clock_tb;

logic in_clk;
logic in_hlt;
logic out_clk;

int num_fails = 0; // var to count failing cases 

//DUT generation
clock clock_dut(.i_clk(in_clk),
                .i_hlt(in_hlt),
                .o_clk(out_clk));


task automatic check_result(input logic clk_in,
                            input logic hlt_in);

    logic expected; 

    begin
        in_clk = clk_in;
        in_hlt = hlt_in;
        #10;

        expected = hlt_in ? 1'b0 : clk_in;

        if (expected === out_clk) begin
            $display("[PASS] HLT = %0d, CLK_IN = %0d, OUT = %0d",
                    hlt_in, clk_in, out_clk);
        end
        else begin
            $display("[FAIL] HLT = %0d, CLK_IN = %0d, OUT = %0d, EXPECTED = %0d",
                    hlt_in, clk_in, out_clk, expected);
                    num_fails+=1;
        end
    end


endtask

initial begin

    check_result(0,0); // TEST-CASE-1: CLK = 0 HLT = 0
    check_result(0,1); // TEST-CASE-4: CLK = 0 HLT = 1
    check_result(1,0); // TEST-CASE-2: CLK = 1 HLT = 0
    check_result(1,1); // TEST-CASE-3: CLK = 1 HLT = 1


    $display("Test Failed = %0d", num_fails);
    $finish;

end
endmodule