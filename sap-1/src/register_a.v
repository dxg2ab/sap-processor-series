module register_a (
    input wire i_clk, //clock signal
    input wire i_rst, //reset flag
    input wire i_load, //load flag
    input wire [7:0] i_bus, //data from bus
    output wire [7:0] o_data //data out
);
    reg [7:0] register_a;

    always @(posedge i_clk) begin
        
        if (i_rst) begin
            register_a <= 8'b0;
        end
        else if (i_load) begin
            register_a <= i_bus;
        end

    end

    assign o_data = register_a;
    
endmodule