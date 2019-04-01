module my_rom(
input wire clk,
input wire ce_rom,

input wire [15:0] pc_final,
output reg [19:0] rom_dout
    );

reg [19:0] memory [0:255];
initial $readmemb("rom.bin",memory);

always@(posedge clk) begin
    if(ce_rom) begin
        rom_dout<=#12 memory[pc_final];
    end else begin
        rom_dout <= #8 15'd0;
    end
end

endmodule