module adder_tb;

logic in_sub;
logic [7:0] in_a_reg;
logic [7:0] in_b_reg;
logic [7:0] out_result;

int num_fails = 0;

//DUT init
adder adder_dut(.i_sub(in_sub),
                .i_a(in_a_reg),
                .i_b(in_b_reg),
                .o_result(out_result));

task automatic check_result(input logic sub,
                             input logic [7:0] a,
                             input logic [7:0] b);

    logic [7:0] expected; //variable to store expected value

    begin
        in_sub = sub;
        in_a_reg = a;
        in_b_reg = b;
        #10;

        expected = sub ? (a - b) : (a + b);

        if (expected === out_result) begin
            $display("[PASS] %s A=%0d B=%0d OUT=%0d",
                     sub ? "SUB" : "ADD",
                     a, b, out_result);
        end
        else begin
            $display("[FAIL] %s A=%0d B=%0d EXP=%0d GOT=%0d",
                     sub ? "SUB" : "ADD",
                     a, b, expected, out_result);
            num_fails++;
        end

    end

    
endtask


initial begin

    $display("=== Addition Tests ===");

    check_result(0, 8'd0,   8'd0); // TEST-CASE-1: 0 + 0
    check_result(0, 8'd255, 8'd0); // TEST-CASE-2: 255 + 0
    check_result(0, 8'd255, 8'd1); // TEST-CASE-3: 255 + 1 (OVERFLOW)
    check_result(0, 8'd128, 8'd128); // TEST-CASE-4: 128 + 128 (OVERFLOW)
    check_result(0, $urandom_range(255,0), $urandom_range(255,0)); // TEST-CASE-5: RANDOM

    $display("=== Subtraction Tests ===");

    check_result(1, 8'd0,   8'd0); // TEST-CASE-6: 0 - 0
    check_result(1, 8'd255, 8'd0); // TEST-CASE-7: 255 - 0
    check_result(1, 8'd0,   8'd1); // TEST-CASE-8: 0 - 1 (UNDERFLOW)
    check_result(1, 8'd0,   8'd255); // TEST-CASE-8: 0 - 255 (UNDERFLOW)
    check_result(1, $urandom_range(255,0), $urandom_range(255,0)); // TEST-CASE-10: RANDOM

    $display("Tests Failed: %0d", num_fails);

    $finish;



end








endmodule