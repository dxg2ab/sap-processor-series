module top(
    input wire i_clk
);
    reg [7:0] bus; //8 bit bus

    always @(*) begin


    end

    /******************
    ****CLOCK INIT*****
    ******************/
    wire hlt;
    wire clk_out
    clock clock(
        .i_hlt(hlt),
        .i_clk(i_clk),
        .o_clk(clk_out)
    );

    /******************
    ******PC INIT******
    ******************/
    wire rst_pc;
    wire pc_inc;
    wire [7:0] pc_adr;
    pc pc(
        .i_clk(i_clk),
        .i_rst(rst_pc),
        .i_inc(pc_inc),
        .o_adr(pc_adr)
    );

    /******************
    ****MEMORY INIT****
    ******************/

    /******************************
    ****INSTRUCTION MEMORY INIT****
    ******************************/
    wire rst_inst_mem;
    wire load_inst_mem;
    wire [7:0] inst_mem_bus_in;
    reg [7:0] inst_mem_out
    instruction_mem instruction_mem(
        .i_clk(i_clk),
        .i_rst(rst_inst_mem),
        .i_load(load_inst_mem),
        .i_bus(inst_mem_bus_in),
        .o_data(inst_mem_out)
    );

    /**********************
    ****REGISTER A INIT****
    **********************/
    wire reg_a_rst;
    wire reg_a_load;
    wire [7:0] reg_a_bus_in;
    wire [7:0] reg_a_out;
    register_a register_a(
        .i_clk(i_clk),
        .i_rst(reg_a_rst),
        .i_load(reg_a_load),
        .i_bus(reg_a_bus_in)
        .o_data(reg_a_out)
    );

    /**********************
    ****REGISTER B INIT****
    **********************/
    wire reg_b_rst;
    wire reg_b_load;
    wire [7:0] reg_b_bus_in;
    wire [7:0] reg_b_out;
    register_b register_b(
        .i_clk(i_clk),
        .i_rst(reg_b_rst),
        .i_load(reg_b_load),
        .i_bus(reg_b_bus_in)
        .o_data(reg_b_out)
    );

    /**********************
    ****CONTROLLER INIT****
    **********************/
    





endmodule