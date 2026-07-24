`include "../inc/sap_1_defs.svh"

module top(
    input logic ext_clk, // external clock to cpu
    input logic ext_rst // external reset signal
);

    /******************
    ****CLOCK INIT*****
    ******************/

    logic hlt_sig; // hlt signal from controller reg
    logic clk_cpu; // clk pulse that will be provided to cpu

    clock u_clock(
        .i_hlt(hlt_sig),
        .i_clk(ext_clk),
        .o_clk(clk_cpu)
    );

    /******************
    ****ADDER INIT*****
    ******************/

    logic add_en_sig; // signal to load adder result to bus
    logic sub_sig; // mode select signal from controller
    logic [7:0] adder_out; // register to store adder result

    adder u_adder(
        .i_sub(sub_sig),
        .i_a(reg_a_out),
        .i_b(reg_b_out),
        .o_result(adder_out)
    );

    /******************
    ******PC INIT******
    ******************/

    logic pc_en_sig; // signal to load pc to bus
    logic pc_inc_sig; // pc inc signal from controller 
    logic [7:0] pc_adr;

    pc u_pc(
        .i_clk(clk_cpu),
        .i_rst(ext_rst),
        .i_inc(pc_inc_sig),
        .o_adr(pc_adr)
    );

    /******************
    ****MEMORY INIT****
    ******************/

    logic mem_en_sig; // signal to load memory to bus
    logic load_mem_sig; // load signal from controller
    logic [7:0] memory_out;

    memory u_memory(
        .i_clk(clk_cpu),
        .i_rst(ext_rst),
        .i_load(load_mem_sig),
        .i_bus(bus),
        .o_data(memory_out)
        );

    /******************************
    ****INSTRUCTION MEMORY INIT****
    ******************************/

    logic ir_en_sig; // load bus with instruction sig
    logic ir_load_sig; // load inst mem sig from controller
    logic [7:0] ir_out;

    instruction_mem u_instruction_mem(
        .i_clk(clk_cpu),
        .i_rst(ext_rst),
        .i_load(ir_load_sig),
        .i_bus(bus),
        .o_data(ir_out)
    );

    /**********************
    ****REGISTER A INIT****
    **********************/

    logic a_en_sig; // signal to load a to bus
    logic reg_a_load_sig; // load reg a signal from controller
    logic [7:0] reg_a_out; // reg a output

    register_a u_register_a(
        .i_clk(clk_cpu),
        .i_rst(ext_rst),
        .i_load(reg_a_load_sig),
        .i_bus(bus),
        .o_data(reg_a_out)
    );

    /**********************
    ****REGISTER B INIT****
    **********************/

    logic reg_b_load_sig; // load reg signal from controller
    logic [7:0] reg_b_out; // reg b output

    register_b u_register_b(
        .i_clk(clk_cpu),
        .i_rst(ext_rst),
        .i_load(reg_b_load_sig), 
        .i_bus(bus),
        .o_data(reg_b_out)
    );

    /**********************
    ****CONTROLLER INIT****
    **********************/

    // extract opcode and operand
    logic [3:0] opcode;
    logic [3:0] operand;
    assign opcode = ir_out[7:4];
    assign operand = ir_out[3:0];

    logic [11:0] control_reg_out; // control reg output

    controller u_controller(
        .i_clk(clk_cpu),
        .i_rst(ext_rst),
        .i_opcode(opcode),
        .o_control(control_reg_out)
    );

    /******************
    *****BUS LOGIC*****
    ******************/

    logic [7:0] bus; // 8 bit bus

    // controller signal mapping
    assign add_en_sig        = control_reg_out[ADDER_EN];
    assign sub_sig           = control_reg_out[ADDER_SUB];
    assign reg_b_load_sig    = control_reg_out[B_LOAD];
    assign a_en_sig          = control_reg_out[A_EN];
    assign reg_a_load_sig    = control_reg_out[A_LOAD];
    assign ir_en_sig         = control_reg_out[IR_EN];
    assign ir_load_sig       = control_reg_out[IR_LOAD];
    assign mem_en_sig        = control_reg_out[MAR_EN];
    assign load_mem_sig      = control_reg_out[MAR_LOAD];
    assign pc_en_sig         = control_reg_out[PC_EN];
    assign pc_inc_sig        = control_reg_out[PC_INC];
    assign hlt_sig           = control_reg_out[HLT_EN];
    
    // bus MUX
    always_comb begin

        bus = 8'h00;

        unique if (pc_en_sig) begin
            bus = pc_adr;
        end
        else if (mem_en_sig) begin
            bus = memory_out;
        end
        else if (ir_en_sig) begin
            bus = {4'b0000,operand};
        end
        else if (a_en_sig) begin
            bus = reg_a_out;
        end
        else if (add_en_sig) begin
            bus = adder_out;
        end

    end

endmodule