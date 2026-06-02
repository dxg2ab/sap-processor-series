module instruction_mem (
    input wire i_clk, //clock input
    input wire i_rst, //reset input
    input wire i_load, //load input
    input wire [7:0] i_bus,
    output wire [7:0] o_data 
);
    reg [7:0] instruction_reg;

    always @(posedge i_clk) begin

        if (i_rst) begin
            instruction_reg <= 8'b0;
        end
        else if (i_load) begin
            instruction_reg <= i_bus;
        end

    end

    assign o_data = instruction_reg;

endmodule