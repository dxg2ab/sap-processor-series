module clock (
    input wire i_hlt, //HLT signal
    input wire i_clk, //clock signal
    output wire o_clk //clock signal
);

    assign o_clk = hlt ? 1'b0 : i_clk; //if HLT is not set return current clock
    
endmodule