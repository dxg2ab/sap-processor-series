`include "../inc/sap_1_defs.svh"

module controller (
    input logic i_clk,
    input logic i_rst,
    input opcodes_t i_opcode,
    output logic [11:0] o_control
);

    stages_t stage_reg; // register to store current stage
    control_t control_reg; // control register

    // stage change logic
    always_ff @(posedge i_rst or posedge i_clk) begin
        if (i_rst) begin
            stage_reg <= STAGE_0; // go to first stage (RST)
        end
        else if (stage_reg == STAGE_5) begin
            stage_reg <= STAGE_0; // go to first stage (COMPLETE)
        end
        else begin
            stage_reg <= stage_reg + 1; // go to next stage
        end
    end

    // stage logic 
        
    always_comb begin
        control_reg = 12'b0; //init control register with default values

        unique case (stage_reg)
            /**************************************
            ********Common Stage Operations********
            **************************************/
            
            STAGE_0: begin
                control_reg[PC_EN] = 1; // enable bus mode
                control_reg[MAR_LOAD] = 1; // load the value to memory
            end

            STAGE_1: begin
                control_reg[PC_INC] = 1; // increment PC
            end

            STAGE_2: begin
                control_reg[MAR_EN] = 1; // load the pointed memory to bus
                control_reg[IR_LOAD] = 1; // load the IR
            end

            /******************************************
            ***Instruction Specific stage Operations***
            ******************************************/

            STAGE_3: begin
                unique case(i_opcode)
                    LDA: begin
                        control_reg[IR_EN] = 1; // put operand to bus
                        control_reg[MAR_LOAD] = 1; //mload the operand to memory
                    end

                    ADD: begin
                        control_reg[IR_EN] = 1; // put operand to bus
                        control_reg[MAR_LOAD] = 1; // load the operand to memory
                    end

                    SUB: begin
                        control_reg[IR_EN] = 1; // put operand to bus
                        control_reg[MAR_LOAD] = 1; // load the operand to memory
                    end

                    HLT: begin
                        control_reg[HLT_EN] = 1; // halt the clock
                    end

                    default: begin
                        control_reg = 0;
                    end
                endcase
            end

            STAGE_4: begin
                unique case(i_opcode)
                    LDA: begin
                        control_reg[MAR_EN] = 1; // put data in memory to bus
                        control_reg[A_LOAD] = 1; // load the data on bus to A
                    end

                    ADD: begin
                        control_reg[MAR_EN] = 1; // put data in memory to bus
                        control_reg[B_LOAD] = 1; // load the data on bus to B
                    end

                    SUB: begin
                        control_reg[MAR_EN] = 1; // put data in memory to bus
                        control_reg[B_LOAD] = 1; // load the data on bus to B
                    end

                    default: begin
                        control_reg = 0;
                    end
                endcase
            end

            STAGE_5: begin
                unique case(i_opcode)
                    ADD: begin
                        control_reg[ADDER_EN] = 1; // put the data on adder to bus
                        control_reg[A_LOAD] = 1; // load the data to A
                    end

                    SUB: begin
                        control_reg[ADDER_SUB] = 1; // enable subtraction
                        control_reg[ADDER_EN] = 1; // put the data on adder to bus
                        control_reg[A_LOAD] = 1; // load the data to A
                    end

                    default: begin
                        control_reg = 0;
                    end
                endcase
            end
        endcase
    end

    assign o_control = control_reg;

endmodule