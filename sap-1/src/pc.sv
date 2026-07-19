module pc (
    input logic i_clk, //clock signal
    input logic i_rst, //reset flag
    input logic i_inc, //increase flag
    output logic [7:0] o_adr //current adress
);
    logic [3:0] pc; //4 bit register to store instructions

    always_ff @(posedge i_clk) begin

        if (i_rst) begin
            pc <= 4'b0;
        end
        else if (i_inc) begin
            pc <= pc +1;
        end

    end

    assign o_adr = pc;
    
endmodule