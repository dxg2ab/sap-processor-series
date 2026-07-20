module register_b_tb;

logic clk;
logic rst;
logic load;
logic [7:0] bus;
logic [7:0] data;

logic [7:0] expected;

int num_fails = 0;

// generate DUT
register_a register_a_dut(.i_clk(clk),
                          .i_rst(rst),
                          .i_load(load),
                          .i_bus(bus),
                          .o_data(data));

// generate clock signal
initial begin
    clk = 0;
    forever #10 clk = ~clk;
end

task automatic check_result(input logic rst_i,
                            input logic load_i,
                            input logic [7:0] bus_i);
    
    @(negedge clk);
    rst = rst_i;
    load = load_i;
    bus = bus_i;

    @(posedge clk);
    #1;

    if (rst_i) begin
        expected = 8'h00;
    end
    else if (load_i) begin
        expected = bus_i;
    end

    if (data === expected) begin
        $display("[PASS] RST=%0d LOAD=%0d OUT=0x%02h BUS=0x%02h",
                    rst, load, data, bus);
    end
    else begin
        $display("[FAIL] RST=%0d LOAD=%0d BUS=0x%02h EXP=0x%02h GOT=0x%02h",
                    rst, load, bus, expected, data);
                    num_fails+=1;
    end

endtask

initial begin

    // TEST-CASE-1: RESET FUNCTIONALITY, RST = 1 LOAD = 0
    check_result(1'b1,1'b0,8'h55);

    // TEST-CASE-2: MIN VALUE, RST = 0 LOAD = 1
    check_result(1'b0,1'b1,8'h00);

    // TEST-CASE-3: LOAD FUNCTIONALITY, RST = 0 LOAD = 1
    check_result(1'b0,1'b1,8'hC3);

    // TEST-CASE-4: MAX VALUE, RST = 0 LOAD = 1
    check_result(1'b0,1'b1,8'hFF);

    // TEST-CASE-5: HOLD VALUE, = 0 LOAD = 0
    check_result(1'b0,1'b0,8'h55);

    // TEST-CASE-6: RESET PRIORITY, RST = 1 LOAD = 1
    check_result(1'b1,1'b1,8'h38);

    $display("Failed Tests = %0d",num_fails);
    $finish;

end

endmodule