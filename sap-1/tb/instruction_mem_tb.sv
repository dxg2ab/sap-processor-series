module instruction_mem_tb;

logic clk;
logic rst;
logic load;
logic [7:0] bus;
logic [7:0] data;

int num_fails = 0;
logic [7:0] expected = 8'h00;

// generate DUT
instruction_mem instruction_mem_dut(.i_clk(clk),
                                    .i_rst(rst),
                                    .i_load(load),
                                    .i_bus(bus),
                                    .o_data(data));


task automatic check_result(input logic i_rst,
                            input logic i_load,
                            input logic [7:0] i_bus);
        @(negedge clk);

        rst = i_rst;
        load = i_load;
        bus = i_bus;

        // define expected output
        if (i_rst) begin
            expected = 8'b0;
        end
        else if (i_load) begin
            expected = i_bus;
        end

        // update on positive edge
        @(posedge clk);
        #1;

        if (expected === data) begin
            $display("[PASS] RST=%0d LOAD=%0d BUS=0x%02h OUT=0x%02h",
                    rst, load, bus, data);
        end
        else begin
            $display("[FAIL] RST=%0d LOAD=%0d BUS=0x%02h EXP=0x%02h GOT=0x%02h",
                    rst, load, bus, expected, data);
                    num_fails+=1;
        end

    

endtask

// generate artifical clock signal
initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
end

// perform tests
initial begin
    // TEST-CASE-1:RESET CHECK RST = 1 LOAD = 0
    check_result(1'b1,1'b0,8'h00); 

    // TEST-CASE-2:LOAD CHECK WITH MINIMUM VALUE RST = 0 LOAD = 1
    check_result(1'b0,1'b1,8'h00);

    // TEST-CASE-3:LOAD CHECK WITH A NORMAL DATA RST = 0 LOAD = 1
    check_result(1'b0,1'b1,8'hA5);

    // TEST-CASE-4:LOAD CHECK WITH MAXIMUM RST = 0 LOAD = 1
    check_result(1'b0,1'b1,8'hFF);

    // TEST-CASE-5:HOLD CHECK RST = 0 LOAD = 0
    check_result(1'b0,1'b0,8'h3C); 

    // TEST-CASE-6:PRIORITY CHECK RST = 1 LOAD = 1
    check_result(1'b1,1'b1,8'hA5); 
    
    $display("Test Failed = %0d", num_fails);
    $finish;

end

endmodule