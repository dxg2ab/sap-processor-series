`ifndef SAP_1_DEFS_SVH
`define SAP_1_DEFS_SVH

// define control register pin names
typedef enum logic [3:0] { 
    ADDER_EN = 4'd0, // load adder result to bus
    ADDER_SUB = 4'd1, // switch to sub mode
    B_LOAD = 4'd2, // load reg b 
    A_EN = 4'd3, // load bus with reg a 
    A_LOAD = 4'd4, // load reg a 
    IR_EN = 4'd5, // load bus with instruction reg
    IR_LOAD = 4'd6, // load instruction reg
    MAR_EN = 4'd7, // load bus with ram
    MAR_LOAD = 4'd8, // point to a specific adress on ram
    PC_EN = 4'd9, // load bus with pc
    PC_INC = 4'd10, // increment pc
    HLT_EN = 4'd11 // halt execution
} control_t;

// define opcodes
typedef enum logic [3:0] {  
    LDA = 4'd0,
    ADD = 4'd1,
    SUB = 4'd2,
    HLT = 4'd4
} opcodes_t;
    
// define execution stages
typedef enum logic [2:0] { 
    STAGE_0 = 3'd0,
    STAGE_1 = 3'd1,
    STAGE_2 = 3'd2,
    STAGE_3 = 3'd3,
    STAGE_4 = 3'd4,
    STAGE_5 = 3'd5
} stages_t;

`endif 