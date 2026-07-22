module memory_tb;

logic clk;
logic rst;
logic load;
logic [7:0] bus;
logic [7:0] out;

int num_fails = 0;

logic [3:0] expected_mar = 0; // mock up mar
logic [7:0] expected_mem[15:0]; // mock up register for testing purposes
logic [7:0] expected;

// generate DUT
memory memory_dut(.i_clk(clk),
                  .i_rst(rst),
                  .i_load(load),
                  .i_bus(bus),
                  .o_data(out));

task automatic check_result(input logic i_rst, // reset signal
                            input logic i_load, // load signal
                            input logic [7:0] i_bus); // bus input


    @(negedge clk);

    rst = i_rst;
    load = i_load;
    bus = i_bus;

    @(posedge clk);
    #1;

    //check logic
    if (i_rst) begin
        expected_mar = 0; // reset the mar
    end
    else if (i_load) begin
        expected_mar = i_bus[3:0]; // load the addr from bus
    end

    expected = expected_mem[expected_mar];

    if (out === expected) begin
    $display("[PASS] RST=%0d LOAD=%0d ADDR=%0d DATA=0x%02h",
         rst,
         load,
         expected_mar,
         out);
    end
    else begin
        $display("[FAIL] RST=%0d LOAD=%0d ADDR=%0d EXP=0x%02h GOT=0x%02h",
                rst,
                load,
                expected_mar,
                expected,
                out);

        num_fails++;
    end
    
endtask

// generate clk signal
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

// read the memory contents for comparasion
initial begin
    $readmemh("program.bin", expected_mem);
end

// perform tests
initial begin

    // TEST-CASE-1: RESET MAR RST = 1, LOAD = 0
    check_result(1'b1,1'b0,8'h00);

    // TEST-CASE-2: LOAD MAR ADR 0 RST = 0, LOAD = 1
    check_result(1'b0,1'b1,8'h00);

    // TEST-CASE-3: LOAD MAR ADR 1 RST = 0, LOAD = 1
    check_result(1'b0,1'b1,8'h01);

    // TEST-CASE-4: LOAD MAR ADR 7 RST = 0, LOAD = 1
    check_result(1'b0,1'b1,8'h07);

    // TEST-CASE-5: LOAD MAR ADR 15 RST = 0, LOAD = 1
    check_result(1'b0,1'b1,8'h0F);

    // TEST-CASE-6: HOLD RST = 0, LOAD = 0
    check_result(1'b0,1'b0,8'h03);

    // TEST-CASE-7: RST PRIORITY RST = 0, LOAD = 0
    check_result(1'b1,1'b1,8'h0F);

    $display("Tests Failed = %0d",num_fails);
    $finish;

end

endmodule