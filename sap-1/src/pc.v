module pc (
    input i_clk,
    input i_rst, //reset flag
    input i_inc, //increase flag
    output [7:0] o_adr
);
    reg [3:0] pc //16 adresses

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