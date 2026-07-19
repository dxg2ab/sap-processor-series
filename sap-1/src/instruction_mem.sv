module instruction_mem (
    input logic i_clk, // clock input
    input logic i_rst, // reset input
    input logic i_load, // load input
    input logic [7:0] i_bus, // input from the bus
    output logic [7:0] o_data 
);
    logic [7:0] instruction_reg;

    always_ff @( posedge i_clk ) begin
        
        if (i_rst) begin
            instruction_reg <= 8'b0;
        end
        else if (i_load) begin
            instruction_reg <= i_bus;
        end

    end

    assign o_data = instruction_reg;

endmodule