module pc (
    input wire i_clk, //clock signal
    input wire i_rst, //reset flag
    input wire i_inc, //increase flag
    output [7:0] o_adr //current adress
);
    reg [3:0] pc //4 bit register to store instructions

    always @(posedge i_clk) begin

        if (i_rst) begin
            pc <= 4'b0;
        end
        else if (i_inc) begin
            pc <= pc +1;
        end

    end

    assign o_adr = pc;
    
endmodule