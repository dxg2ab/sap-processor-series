module memory (
    input logic i_clk, // clk
    input logic i_rst, // reset signal
    input logic i_load, // load signal
    input logic [7:0] i_bus, // bus input
    output logic [7:0] o_data // instruction out
);
    logic [3:0] mar; // pointer to memory adress 
    logic [7:0] ram [0:15]; // 16 x 8 cell memory

    initial begin
        $readmemh("program.bin", ram); // read the program
    end

    always_ff @(posedge i_clk) begin
        if (i_rst) begin
            mar <= 3'b0; // if reset set the ram pointer to first adress
        end
        else if (i_load) begin
            mar <= i_bus[3:0]; // if an adress is loaded point that adress
        end
    end

    assign o_data = ram[mar];
    
endmodule