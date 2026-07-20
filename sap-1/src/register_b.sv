module register_b(
    input logic i_clk, // clock signal
    input logic i_rst, // reset signal
    input logic i_load, // load signal
    input logic [7:0] i_bus, // data from bus
    output logic [7:0] o_data // data out
);
    logic [7:0] register_b;

    always_ff @(posedge i_clk) begin
        
        if (i_rst) begin
            register_b <= 8'b0;
        end
        else if (i_load) begin
            register_b <= i_bus;
        end

    end

    assign o_data <= register_b;

endmodule