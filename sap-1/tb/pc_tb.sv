module pc_tb;

logic clk;
logic rst;
logic inc;
logic [7:0] adr;

logic [7:0] expected = 8'h00; //initialize with zero
int num_fails = 0;

// generate dut
pc pc_dut(.i_clk(clk),
          .i_rst(rst),
          .i_inc(inc),
          .o_adr(adr));

//generate clock signal
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

task automatic check_result(input logic i_rst,
                            input logic i_inc);

    @(negedge clk); // assign on negative edge

    rst = i_rst;
    inc = i_inc;

    @(posedge clk); // update on positive edge
    #1;

    if (i_rst) begin
        expected = 8'h00;
    end
    else if (i_inc) begin
        expected = expected + 1;
    end

    if (expected === adr) begin
        $display("[PASS] RST=%0d INC=%0d ADR=0x%02h",
                    rst, inc, adr);
    end
    else begin
        $display("[FAIL] RST=%0d INC=%0d OUT=0x%02h EXP=0x%02h",
                    rst, inc, adr, expected);
                    num_fails+=1;
    end
    
endtask 

//perform tests
initial begin

    // TEST-CASE-1: RESET FUNCTIONALITY CHECK RST = 1 INC = 0
    check_result(1'b1,1'b0);

    // TEST-CASE-2: SINGLE INCREMENT CHECK CHECK RST = 0 INC = 1
    check_result(1'b0,1'b1);

    // TEST-CASE-3: CONSECUTIVE INCREMENTS CHECK RST = 0 INC = 1
    check_result(1'b0,1'b1);

    // TEST-CASE-4: HOLD VALUE CHECK CHECK RST = 0 INC = 0
    check_result(1'b0,1'b0);

    // TEST-CASE-5: RESET PRIORITY CHECK RST = 1 INC = 1
    check_result(1'b1,1'b1);

    // TEST-CASE-6: COUNTER OVERFLOW CHECK RST = 0 INC = 1

    // count until 255
    repeat(255) begin 

        rst = 1'b0;
        inc = 1'b1;
        @(posedge clk);
        #1;

        expected = expected + 1; // update expected value 

    end

    check_result(1'b0,1'b1);

    $display("Tests Failed = %0d",num_fails);
    $finish;
end

endmodule