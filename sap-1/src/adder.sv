module adder (
    input logic i_sub, // flag to choose between addition and subtraction
    input logic [7:0] i_a, // data from a register
    input logic [7:0] i_b, // data from b register
    output logic [7:0] o_result // output of the desired operation
);

    //continiously caclulate the desired operation
    assign o_result = i_sub ? i_a - i_b : i_a + i_b;
    
endmodule