module clock (
    input wire i_clk, //clock signal
    input wire i_hlt, //HLT signal
    output wire o_clk //clock signal
);

    assign o_clk = hlt ? 1'b0 : i_clk; //if HLT is not set return current clock
    
endmodule