module memory (
    input wire i_clk,
    input wire i_rst,
    input wire i_load,
    input wire [7:0] i_bus,
    output wire [7:0] o_data
);
    reg [3:0] mar; //pointer to memory adress
    reg [7:0] ram [0:15]; //16 cell memory

    initial begin
        $readmemh("program.bin", ram);
    end

    always @(posedge i_clk) begin
        if (i_rst) begin
            mar <= 3'b0;
        end
        else if (i_load) begin
            mar <= i_bus[3:0];
        end
    end

    assign o_data = ram[mar];
    
endmodule