module clock (
    input i_hlt,
    input i_clk,
    output o_clk
);
    assign o_clk = hlt ? 1'b0 : i_clk; 
endmodule