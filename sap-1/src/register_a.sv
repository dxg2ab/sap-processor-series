module register_a (
    input logic i_clk, // clock signal
    input logic i_rst, // reset flag
    input logic i_load, // load flag
    input logic [7:0] i_bus, // data from bus
    output logic [7:0] o_data // data out
);
    logic [7:0] register_a;

    always_ff @(posedge i_clk) begin
        
        if (i_rst) begin
            register_a <= 8'b0;
        end
        else if (i_load) begin
            register_a <= i_bus;
        end

    end

    assign o_data = register_a;
    
endmodule