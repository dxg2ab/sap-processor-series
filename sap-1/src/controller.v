module controller (
    input wire i_clk,
    input wire i_rst,
    input wire [3:0] i_opcode
    output wire [11:0] o_status
);
    //define control signals
    localparam SIG_ADDER_EN = 0;
    localparam SIG_ADDER_EN = 1;
    localparam SIG_B_LOAD = 2;
    localparam SIG_A_EN = 3;
    localparam SIG_A_LOAD = 4;
    localparam SIG_IR_EN = 5;
    localparam SIG_IR_LOAD = 6;
    localparam SIG_MEM_EN = 7;
    localparam SIG_MEM_LOAD = 8;
    localparam SIG_PC_EN = 9;
    localparam SIG_PC_INC = 10;
    localparam SIG_HLT = 11;

    //define opcodes
    localparam OP_LDA = 4'b0000;
    localparam OP_ADD = 4'b0001;
    localparam OP_SUB = 4'b0010;
    localparam OP_HLT = 4'b1111;

endmodule