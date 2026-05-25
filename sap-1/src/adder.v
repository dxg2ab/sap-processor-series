module adder (
    input i_sub, //flag to choose between addition and subtraction
    input wire [7:0] i_a, //data from a register
    input wire [7:0] i_b, //data from b register
    output wire [7:0] o_result
);

    //continiously caclulate the sum
    assign o_result = i_sub ? i_a - i_b : i_a + i_b;
    
endmodule