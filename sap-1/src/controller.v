module controller (
    input wire i_clk,
    input wire i_rst,
    input wire [3:0] i_opcode,
    output wire [11:0] o_control
);
    //define control signals
    localparam SIG_ADDER_EN = 0;
    localparam SIG_ADDER_SUB = 1;
    localparam SIG_B_LOAD = 2;
    localparam SIG_A_EN = 3;
    localparam SIG_A_LOAD = 4;
    localparam SIG_IR_EN = 5;
    localparam SIG_IR_LOAD = 6;
    localparam SIG_MAR_EN = 7;
    localparam SIG_MAR_LOAD = 8;
    localparam SIG_PC_EN = 9;
    localparam SIG_PC_INC = 10;
    localparam SIG_HLT = 11;

    //define opcodes
    localparam OP_LDA = 4'b0000;
    localparam OP_ADD = 4'b0001;
    localparam OP_SUB = 4'b0010;
    localparam OP_HLT = 4'b1111;
    
    //define states
    localparam STAGE_0 = 0;
    localparam STAGE_1 = 1;
    localparam STAGE_2 = 2;
    localparam STAGE_3 = 3;
    localparam STAGE_4 = 4;
    localparam STAGE_5 = 5;

    reg [3:0] stage_reg; //register to store current stage
    reg [11:0] control_reg; //control register

    always @(posedge i_rst or posedge i_clk) begin
        if (i_rst) begin
            stage_reg <= STAGE_0; //if reset signal is given go to STAGE_0
        end
        else if (stage_reg == STAGE_5) begin
            stage_reg <= STAGE_0; //if at STAGE_5 go back to STAGE_0
        end
        else begin
            stage_reg <= stage_reg + 1; //increment the stage
        end
    end

    //stage logic
    always @(*) begin
        control_reg = 12'b0; //init control register with default values

        case (stage_reg)
            /****************************************
            common stage operations
            ****************************************/
            
            STAGE_0: begin
                control_reg[SIG_PC_EN] = 1; //enable bus mode
                control_reg[SIG_MAR_LOAD] = 1; //load the value to memory
            end

            STAGE_1: begin
                control_reg[SIG_PC_INC] = 1; //increment PC
            end

            STAGE_2: begin
                control_reg[SIG_MAR_EN] = 1; //load the data on memory to bus
                control_reg[SIG_IR_LOAD] = 1; //load the IR
            end

            /****************************************
            instruction specific stage operations
            ****************************************/
            STAGE_3: begin
                case(i_opcode)
                    OP_LDA: begin
                        control_reg[SIG_IR_EN] = 1; //put operand to bus
                        control_reg[SIG_MAR_LOAD] = 1; //load the operand to memory
                    end

                    OP_ADD: begin
                        control_reg[SIG_IR_EN] = 1; //put operand to bus
                        control_reg[SIG_MAR_LOAD] = 1; //load the operand to memory
                    end

                    OP_SUB: begin
                        control_reg[SIG_IR_EN] = 1; //put operand to bus
                        control_reg[SIG_MAR_LOAD] = 1; //load the operand to memory
                    end

                    OP_HLT: begin
                        control_reg[SIG_HLT] = 1; //halt the clock
                    end
                endcase
            end

            STAGE_4: begin
                case(i_opcode)
                    OP_LDA: begin
                        control_reg[SIG_MAR_EN] = 1; //put data in memory to bus
                        control_reg[SIG_A_LOAD] = 1; //load the data on bus to A
                    end

                    OP_ADD: begin
                        control_reg[SIG_MAR_EN] = 1; //put data in memory to bus
                        control_reg[SIG_B_LOAD] = 1; //load the data on bus to B
                    end

                    OP_SUB: begin
                        control_reg[SIG_MAR_EN] = 1; //put data in memory to bus
                        control_reg[SIG_B_LOAD] = 1; //load the data on bus to B
                    end
                endcase
            end

            STAGE_5: begin
                case(i_opcode)
                OP_ADD: begin
                    control_reg[SIG_ADDER_EN] = 1; //put the data on adder to bus
                    control_reg[SIG_A_LOAD] = 1; //load the data to A
                end

                OP_SUB: begin
                    control_reg[SIG_ADDER_SUB] = 1; //enable subtraction
                    control_reg[SIG_ADDER_EN] = 1; //put the data on adder to bus
                    control_reg[SIG_A_LOAD] = 1; //load the data to A
                end
                endcase
            end
        endcase
    end

    assign o_control = control_reg;

endmodule