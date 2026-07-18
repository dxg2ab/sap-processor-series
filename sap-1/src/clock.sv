module clock (
    input logic i_clk, //clock signal
    input logic i_hlt, //HLT signal
    output logic o_clk //clock signal
);

    assign o_clk = i_hlt ? 1'b0 : i_clk;
    
endmodule